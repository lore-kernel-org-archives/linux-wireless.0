Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57392 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752041AbeAQHVo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 02:21:44 -0500
From: tamizhr@codeaurora.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 1/2] cfg80211: Add support to notify station's opmode change to userspace
Date: Wed, 17 Jan 2018 12:48:27 +0530
Message-Id: <1516173508-16528-1-git-send-email-tamizhr@codeaurora.org> (sfid-20180117_082149_186084_D009AE69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <tamizhr@codeaurora.org>

ht/vht action frames will be sent to AP from station to notify
change of its ht/vht opmode(max bandwidth, smps mode or nss) modified
values. Currently these valuse used by driver/firmware for rate control
algorithm. This patch introduces NL80211_CMD_STA_OPMODE_CHANGED
command to notify those modified/current supported values(max bandwidth,
smps mode, max nss) to userspace application. This will be useful for the
application like steering, which closely monitoring station's capability
changes. Since the application has taken these values during station
association.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       | 32 +++++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 12 ++++++++++
 net/wireless/nl80211.c       | 56 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 81174f9..d796160 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3517,6 +3517,20 @@ enum wiphy_vendor_command_flags {
 };
 
 /**
+ * enum wiphy_opmode_info_flag - opmode information flags
+ *
+ * @MAX_BW_CHANGED: Max Bandwidth changed
+ * @SMPS_MODE_CHANGED: SMPS mode changed
+ * @N_SS_CHANGED: max N_SS (number of spatial streams) changed
+ *
+ */
+enum wiphy_opmode_info_flag {
+	MAX_BW_CHANGED		= BIT(0),
+	SMPS_MODE_CHANGED	= BIT(1),
+	N_SS_CHANGED		= BIT(2),
+};
+
+/**
  * struct wiphy_vendor_command - vendor command definition
  * @info: vendor command identifying information, as used in nl80211
  * @flags: flags, see &enum wiphy_vendor_command_flags
@@ -5685,6 +5699,24 @@ void cfg80211_radar_event(struct wiphy *wiphy,
 			  struct cfg80211_chan_def *chandef, gfp_t gfp);
 
 /**
+ * cfg80211_sta_opmode_change_notify - Station's SMPS mode, rx_nss and
+ *	max bandwidth change event
+ * @dev: network device
+ * @mac: MAC address of a station which opmode got modified
+ * @changed: contains value from &enum wiphy_opmode_info_flag
+ * @smps_mode: New SMPS mode of a station
+ * @bw: new max bandwidth value of a station
+ * @rx_nss: new rx_nss value of a station
+ * @gfp: context flags
+ *
+ * This function is called when station's opmode modified via action frame.
+ */
+void cfg80211_sta_opmode_change_notify(struct net_device *dev, const u8 *mac,
+				       enum wiphy_opmode_info_flag changed,
+				       u8 smps_mode, u8 bw, u8 rx_nss,
+				       gfp_t gfp);
+
+/**
  * cfg80211_cac_event - Channel availability check (CAC) event
  * @netdev: network device
  * @chandef: chandef for the current channel
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c587a61..5d69717 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -992,6 +992,11 @@
  *
  * @NL80211_CMD_RELOAD_REGDB: Request that the regdb firmware file is reloaded.
  *
+ * @NL80211_CMD_STA_OPMODE_CHANGED: An event that notify station's
+ *	ht opmode or vht opmode changes. This will use &NL80211_ATTR_SMPS_MODE,
+ *	&NL80211_ATTR_CHANNEL_WIDTH, &NL80211_ATTR_NSS to send the event to
+ *	userspace.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1198,6 +1203,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_RELOAD_REGDB,
 
+	NL80211_CMD_STA_OPMODE_CHANGED,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2153,6 +2160,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_PMKR0_NAME: PMK-R0 Name for offloaded FT.
  * @NL80211_ATTR_PORT_AUTHORIZED: (reserved)
  *
+ * @NL80211_ATTR_NSS: Station's New/updated  RX_NSS value notified using this
+ *	u8 attribute. This is used with %NL80211_CMD_STA_OPMODE_CHANGED.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2579,6 +2589,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_PMKR0_NAME,
 	NL80211_ATTR_PORT_AUTHORIZED,
 
+	NL80211_ATTR_NSS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b48eb6d..330a9ad 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14887,6 +14887,62 @@ void cfg80211_ch_switch_started_notify(struct net_device *dev,
 	nlmsg_free(msg);
 }
 
+void cfg80211_sta_opmode_change_notify(struct net_device *dev, const u8 *mac,
+				       enum wiphy_opmode_info_flag changed,
+				       u8 smps, u8 bw, u8 rx_nss, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	void *hdr;
+
+	if (!mac)
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_STA_OPMODE_CHANGED);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx))
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex))
+		goto nla_put_failure;
+
+	if (mac && nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac))
+		goto nla_put_failure;
+
+	if ((changed & SMPS_MODE_CHANGED) &&
+	    nla_put_u8(msg, NL80211_ATTR_SMPS_MODE, smps))
+		goto nla_put_failure;
+
+	if ((changed & MAX_BW_CHANGED) &&
+	    nla_put_u8(msg, NL80211_ATTR_CHANNEL_WIDTH, bw))
+		goto nla_put_failure;
+
+	if ((changed & N_SS_CHANGED) &&
+	    nla_put_u8(msg, NL80211_ATTR_NSS, rx_nss))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, gfp);
+
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_sta_opmode_change_notify);
+
 void cfg80211_probe_status(struct net_device *dev, const u8 *addr,
 			   u64 cookie, bool acked, gfp_t gfp)
 {
-- 
1.9.1
