Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40453 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab3AHNEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 08:04:52 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv6 5/6] mac80211: check radar interaction with scan and roc
Date: Tue,  8 Jan 2013 14:04:10 +0100
Message-Id: <1357650251-17425-6-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130108_140502_973514_67E3FFDC)
In-Reply-To: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Scanning and remain on channel functionality must be disabled while
doing radar detection/scanning, and vice versa.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/mac80211/cfg.c         |   10 +++++++++-
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/scan.c        |    3 +++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bd300e4..2a5b7a4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1032,6 +1032,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	skb_queue_purge(&sdata->u.ap.ps.bc_buf);
 
 	ieee80211_vif_release_channel(sdata);
+	local->radar_detect_enabled = false;
 
 	return 0;
 }
@@ -2338,7 +2339,9 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	INIT_LIST_HEAD(&roc->dependents);
 
 	/* if there's one pending or we're scanning, queue this one */
-	if (!list_empty(&local->roc_list) || local->scanning)
+	if (!list_empty(&local->roc_list) ||
+	    local->scanning ||
+	    local->radar_detect_enabled)
 		goto out_check_combine;
 
 	/* if not HW assist, just queue & schedule work */
@@ -2599,6 +2602,9 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	if (!local->ops->start_radar_detection)
 		return -EOPNOTSUPP;
 
+	if (!list_empty(&local->roc_list) || local->scanning)
+		return -EBUSY;
+
 	/* whatever, but channel contexts should not complain about that one */
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = local->rx_chains;
@@ -2610,6 +2616,8 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	res = drv_start_radar_detection(local, sdata, chandef);
 	if (res)
 		ieee80211_vif_release_channel(sdata);
+	else
+		local->radar_detect_enabled = true;
 
 	return res;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0fa44a9..ff1c001 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -974,6 +974,9 @@ struct ieee80211_local {
 	/* wowlan is enabled -- don't reconfig on resume */
 	bool wowlan;
 
+	/* DFS/radar detection is enabled */
+	bool radar_detect_enabled;
+
 	/* number of RX chains the hardware has */
 	u8 rx_chains;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 06cbe26..ceaeb32 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -356,6 +356,9 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 static bool ieee80211_can_scan(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata)
 {
+	if (local->radar_detect_enabled)
+		return false;
+
 	if (!list_empty(&local->roc_list))
 		return false;
 
-- 
1.7.10.4

