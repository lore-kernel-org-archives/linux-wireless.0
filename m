Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:37548 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbbCOOAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:00:55 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 3/3] wil6210: support AP isolation
Date: Sun, 15 Mar 2015 16:00:20 +0200
Message-Id: <1426428024-4538-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150315_150100_962287_9A4DEBC1)
In-Reply-To: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the AP, configuration may say not to bridge traffic between
wireless clients. This is conveyed from user space (ex: hostapd has
ap_isolate parameter) with NL80211_CMD_SET_BSS, to the driver's
cfg80211 ops method change_bss

Add support for this setting.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 16 ++++++++++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c  |  1 +
 drivers/net/wireless/ath/wil6210/main.c     |  1 +
 drivers/net/wireless/ath/wil6210/txrx.c     |  2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 5 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 4bd708c..5db6a6d 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -917,6 +917,21 @@ static int wil_cfg80211_probe_client(struct wiphy *wiphy,
 	return 0;
 }
 
+static int wil_cfg80211_change_bss(struct wiphy *wiphy,
+				   struct net_device *dev,
+				   struct bss_parameters *params)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+
+	if (params->ap_isolate >= 0) {
+		wil_dbg_misc(wil, "%s(ap_isolate %d => %d)\n", __func__,
+			     wil->ap_isolate, params->ap_isolate);
+		wil->ap_isolate = params->ap_isolate;
+	}
+
+	return 0;
+}
+
 static struct cfg80211_ops wil_cfg80211_ops = {
 	.scan = wil_cfg80211_scan,
 	.connect = wil_cfg80211_connect,
@@ -937,6 +952,7 @@ static struct cfg80211_ops wil_cfg80211_ops = {
 	.stop_ap = wil_cfg80211_stop_ap,
 	.del_station = wil_cfg80211_del_station,
 	.probe_client = wil_cfg80211_probe_client,
+	.change_bss = wil_cfg80211_change_bss,
 };
 
 static void wil_wiphy_init(struct wiphy *wiphy)
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 3830cc2..a42cb89 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1405,6 +1405,7 @@ static const struct dbg_off dbg_wil_off[] = {
 	WIL_FIELD(fw_version,	S_IRUGO,		doff_u32),
 	WIL_FIELD(hw_version,	S_IRUGO,		doff_x32),
 	WIL_FIELD(recovery_count, S_IRUGO,		doff_u32),
+	WIL_FIELD(ap_isolate,	S_IRUGO,		doff_u32),
 	{},
 };
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index db74e81..afff8d3 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -714,6 +714,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 
 	/* init after reset */
 	wil->pending_connect_cid = -1;
+	wil->ap_isolate = 0;
 	reinit_completion(&wil->wmi_ready);
 	reinit_completion(&wil->wmi_call);
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 08d3cac..689081c 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -515,7 +515,7 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 
 	skb_orphan(skb);
 
-	if (wdev->iftype == NL80211_IFTYPE_AP) {
+	if (wdev->iftype == NL80211_IFTYPE_AP && !wil->ap_isolate) {
 		if (mcast) {
 			/* send multicast frames both to higher layers in
 			 * local net stack and back to the wireless medium
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index b6e65c3..c1a71ab 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -542,6 +542,7 @@ struct wil6210_priv {
 	u32 monitor_flags;
 	u32 privacy; /* secure connection? */
 	int sinfo_gen;
+	u32 ap_isolate; /* no intra-BSS communication */
 	/* interrupt moderation */
 	u32 tx_max_burst_duration;
 	u32 tx_interframe_timeout;
-- 
2.1.0

