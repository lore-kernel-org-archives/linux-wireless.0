Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:17616 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbaB0OVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:39 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 09/16] wil6210: dump_station initial support
Date: Thu, 27 Feb 2014 16:20:48 +0200
Message-ID: <1393510855-17566-10-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_152145_471322_FD951008)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rx stats is not calculated per STA - just give some number

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 82 +++++++++++++++++++++++------
 1 file changed, 66 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index fa713ef..495347b 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -104,27 +104,21 @@ int wil_iftype_nl2wmi(enum nl80211_iftype type)
 	return -EOPNOTSUPP;
 }
 
-static int wil_cfg80211_get_station(struct wiphy *wiphy,
-				    struct net_device *ndev,
-				    u8 *mac, struct station_info *sinfo)
+static int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
+			      struct station_info *sinfo)
 {
-	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
-	int rc;
-
-	int cid = wil_find_cid(wil, mac);
 	struct wmi_notify_req_cmd cmd = {
 		.cid = cid,
 		.interval_usec = 0,
 	};
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_notify_req_done_event evt;
+	} __packed reply;
+	int rc;
 
-	wil_info(wil, "%s(%pM) CID %d\n", __func__, mac, cid);
-	if (cid < 0)
-		return -ENOENT;
-
-	/* WMI_NOTIFY_REQ_DONE_EVENTID handler fills wil->stats.bf_mcs */
-	/* TODO: keep stats per CID */
 	rc = wmi_call(wil, WMI_NOTIFY_REQ_CMDID, &cmd, sizeof(cmd),
-		      WMI_NOTIFY_REQ_DONE_EVENTID, NULL, 0, 20);
+		      WMI_NOTIFY_REQ_DONE_EVENTID, &reply, sizeof(reply), 20);
 	if (rc)
 		return rc;
 
@@ -132,7 +126,7 @@ static int wil_cfg80211_get_station(struct wiphy *wiphy,
 
 	sinfo->filled |= STATION_INFO_TX_BITRATE;
 	sinfo->txrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
-	sinfo->txrate.mcs = wil->stats.bf_mcs;
+	sinfo->txrate.mcs = le16_to_cpu(reply.evt.bf_mcs);
 	sinfo->filled |= STATION_INFO_RX_BITRATE;
 	sinfo->rxrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
 	sinfo->rxrate.mcs = wil->stats.last_mcs_rx;
@@ -142,7 +136,62 @@ static int wil_cfg80211_get_station(struct wiphy *wiphy,
 		sinfo->signal = 12; /* TODO: provide real value */
 	}
 
-	return 0;
+	return rc;
+}
+
+static int wil_cfg80211_get_station(struct wiphy *wiphy,
+				    struct net_device *ndev,
+				    u8 *mac, struct station_info *sinfo)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	int rc;
+
+	int cid = wil_find_cid(wil, mac);
+
+	wil_info(wil, "%s(%pM) CID %d\n", __func__, mac, cid);
+	if (cid < 0)
+		return -ENOENT;
+
+	rc = wil_cid_fill_sinfo(wil, cid, sinfo);
+
+	return rc;
+}
+
+/*
+ * Find @idx-th active STA for station dump.
+ */
+static int wil_find_cid_by_idx(struct wil6210_priv *wil, int idx)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+		if (wil->sta[i].status == wil_sta_unused)
+			continue;
+		if (idx == 0)
+			return i;
+		idx--;
+	}
+
+	return -ENOENT;
+}
+
+static int wil_cfg80211_dump_station(struct wiphy *wiphy,
+				     struct net_device *dev, int idx,
+				     u8 *mac, struct station_info *sinfo)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	int rc;
+	int cid = wil_find_cid_by_idx(wil, idx);
+
+	if (cid < 0)
+		return -ENOENT;
+
+	memcpy(mac, wil->sta[cid].addr, ETH_ALEN);
+	wil_info(wil, "%s(%pM) CID %d\n", __func__, mac, cid);
+
+	rc = wil_cid_fill_sinfo(wil, cid, sinfo);
+
+	return rc;
 }
 
 static int wil_cfg80211_change_iface(struct wiphy *wiphy,
@@ -583,6 +632,7 @@ static struct cfg80211_ops wil_cfg80211_ops = {
 	.disconnect = wil_cfg80211_disconnect,
 	.change_virtual_intf = wil_cfg80211_change_iface,
 	.get_station = wil_cfg80211_get_station,
+	.dump_station = wil_cfg80211_dump_station,
 	.remain_on_channel = wil_remain_on_channel,
 	.cancel_remain_on_channel = wil_cancel_remain_on_channel,
 	.mgmt_tx = wil_cfg80211_mgmt_tx,
-- 
1.8.3.2

