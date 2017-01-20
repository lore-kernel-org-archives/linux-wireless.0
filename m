Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35076 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751403AbdATIzU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 03:55:20 -0500
Received: by mail-wm0-f65.google.com with SMTP id d140so5091810wmd.2
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2017 00:55:20 -0800 (PST)
Received: from localhost.localdomain ([92.176.165.227])
        by smtp.gmail.com with ESMTPSA id d14sm4619205wmd.19.2017.01.20.00.55.17
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Jan 2017 00:55:18 -0800 (PST)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v3 2/4] cfg80211: Pass new RSSI level in CQM RSSI notification
Date: Fri, 20 Jan 2017 09:55:07 +0100
Message-Id: <20170120085509.13222-2-andrew.zaborowski@intel.com> (sfid-20170120_095524_905062_DC230F17)
In-Reply-To: <20170120085509.13222-1-andrew.zaborowski@intel.com>
References: <20170120085509.13222-1-andrew.zaborowski@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the drivers to pass the RSSI level as a cfg80211_cqm_rssi_notify
parameter and pass this value to userspace in a new nl80211 attribute.
This helps both userspace and also helps in the implementation of the
multiple RSSI thresholds CQM mechanism.

Note for marvell/mwifiex I pass 0 for the RSSI value because the new
RSSI value is not available to the driver at the time of the
cfg80211_cqm_rssi_notify call, but the driver queries the new value
immediately after that, so it is actually available just a moment later
if we wanted to defer caling cfg80211_cqm_rssi_notify until that moment.
Without this, the new cfg80211 code (patch 3) will call .get_station
which will send a duplicate HostCmd_CMD_RSSI_INFO command to the hardware.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_event.c |  4 ++--
 drivers/net/wireless/rndis_wlan.c                |  2 +-
 include/net/cfg80211.h                           |  3 ++-
 include/uapi/linux/nl80211.h                     |  3 +++
 net/mac80211/mlme.c                              |  2 +-
 net/wireless/nl80211.c                           |  9 +++++++--
 net/wireless/trace.h                             | 11 +++++++----
 7 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 9df0c4d..5cc3aa7 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -824,7 +824,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 	case EVENT_RSSI_LOW:
 		cfg80211_cqm_rssi_notify(priv->netdev,
 					 NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
-					 GFP_KERNEL);
+					 0, GFP_KERNEL);
 		mwifiex_send_cmd(priv, HostCmd_CMD_RSSI_INFO,
 				 HostCmd_ACT_GEN_GET, 0, NULL, false);
 		priv->subsc_evt_rssi_state = RSSI_LOW_RECVD;
@@ -839,7 +839,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 	case EVENT_RSSI_HIGH:
 		cfg80211_cqm_rssi_notify(priv->netdev,
 					 NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
-					 GFP_KERNEL);
+					 0, GFP_KERNEL);
 		mwifiex_send_cmd(priv, HostCmd_CMD_RSSI_INFO,
 				 HostCmd_ACT_GEN_GET, 0, NULL, false);
 		priv->subsc_evt_rssi_state = RSSI_HIGH_RECVD;
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 603c904..785334f 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -3187,7 +3187,7 @@ static void rndis_do_cqm(struct usbnet *usbdev, s32 rssi)
 		return;
 
 	priv->last_cqm_event_rssi = rssi;
-	cfg80211_cqm_rssi_notify(usbdev->net, event, GFP_KERNEL);
+	cfg80211_cqm_rssi_notify(usbdev->net, event, rssi, GFP_KERNEL);
 }
 
 #define DEVICE_POLLER_JIFFIES (HZ)
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 57383a1..9adff4e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5303,6 +5303,7 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
  * cfg80211_cqm_rssi_notify - connection quality monitoring rssi event
  * @dev: network device
  * @rssi_event: the triggered RSSI event
+ * @rssi_level: new RSSI level value or 0 if not available
  * @gfp: context flags
  *
  * This function is called when a configured connection quality monitoring
@@ -5310,7 +5311,7 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
  */
 void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      enum nl80211_cqm_rssi_threshold_event rssi_event,
-			      gfp_t gfp);
+			      s32 rssi_level, gfp_t gfp);
 
 /**
  * cfg80211_cqm_pktloss_notify - notify userspace about packetloss to peer
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 455ed9b..5cd7a81 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3918,6 +3918,8 @@ enum nl80211_ps_state {
  *	%NL80211_CMD_NOTIFY_CQM. Set to 0 to turn off TX error reporting.
  * @NL80211_ATTR_CQM_BEACON_LOSS_EVENT: flag attribute that's set in a beacon
  *	loss event
+ * @NL80211_ATTR_CQM_RSSI_LEVEL: the RSSI value in dBm that triggered the
+ *	RSSI threshold event.
  * @__NL80211_ATTR_CQM_AFTER_LAST: internal
  * @NL80211_ATTR_CQM_MAX: highest key attribute
  */
@@ -3931,6 +3933,7 @@ enum nl80211_attr_cqm {
 	NL80211_ATTR_CQM_TXE_PKTS,
 	NL80211_ATTR_CQM_TXE_INTVL,
 	NL80211_ATTR_CQM_BEACON_LOSS_EVENT,
+	NL80211_ATTR_CQM_RSSI_LEVEL,
 
 	/* keep last */
 	__NL80211_ATTR_CQM_AFTER_LAST,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a40b90b..0cfa215 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5052,7 +5052,7 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 
 	trace_api_cqm_rssi_notify(sdata, rssi_event, rssi_level);
 
-	cfg80211_cqm_rssi_notify(sdata->dev, rssi_event, gfp);
+	cfg80211_cqm_rssi_notify(sdata->dev, rssi_event, rssi_level, gfp);
 }
 EXPORT_SYMBOL(ieee80211_cqm_rssi_notify);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cc05d36..7749687 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9386,6 +9386,7 @@ nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX + 1] = {
 	[NL80211_ATTR_CQM_TXE_RATE] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_TXE_PKTS] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_TXE_INTVL] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_RSSI_LEVEL] = { .type = NLA_S32 },
 };
 
 static int nl80211_set_cqm_txe(struct genl_info *info,
@@ -13873,11 +13874,11 @@ static void cfg80211_send_cqm(struct sk_buff *msg, gfp_t gfp)
 
 void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      enum nl80211_cqm_rssi_threshold_event rssi_event,
-			      gfp_t gfp)
+			      s32 rssi_level, gfp_t gfp)
 {
 	struct sk_buff *msg;
 
-	trace_cfg80211_cqm_rssi_notify(dev, rssi_event);
+	trace_cfg80211_cqm_rssi_notify(dev, rssi_event, rssi_level);
 
 	if (WARN_ON(rssi_event != NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW &&
 		    rssi_event != NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH))
@@ -13891,6 +13892,10 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			rssi_event))
 		goto nla_put_failure;
 
+	if (rssi_level && nla_put_s32(msg, NL80211_ATTR_CQM_RSSI_LEVEL,
+				      rssi_level))
+		goto nla_put_failure;
+
 	cfg80211_send_cqm(msg, gfp);
 
 	return;
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index ea1b47e..2419c39 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2490,18 +2490,21 @@ TRACE_EVENT(cfg80211_mgmt_tx_status,
 
 TRACE_EVENT(cfg80211_cqm_rssi_notify,
 	TP_PROTO(struct net_device *netdev,
-		 enum nl80211_cqm_rssi_threshold_event rssi_event),
-	TP_ARGS(netdev, rssi_event),
+		 enum nl80211_cqm_rssi_threshold_event rssi_event,
+		 s32 rssi_level),
+	TP_ARGS(netdev, rssi_event, rssi_level),
 	TP_STRUCT__entry(
 		NETDEV_ENTRY
 		__field(enum nl80211_cqm_rssi_threshold_event, rssi_event)
+		__field(s32, rssi_level)
 	),
 	TP_fast_assign(
 		NETDEV_ASSIGN;
 		__entry->rssi_event = rssi_event;
+		__entry->rssi_level = rssi_level;
 	),
-	TP_printk(NETDEV_PR_FMT ", rssi event: %d",
-		  NETDEV_PR_ARG, __entry->rssi_event)
+	TP_printk(NETDEV_PR_FMT ", rssi event: %d, level: %d",
+		  NETDEV_PR_ARG, __entry->rssi_event, __entry->rssi_level)
 );
 
 TRACE_EVENT(cfg80211_reg_can_beacon,
-- 
2.9.3
