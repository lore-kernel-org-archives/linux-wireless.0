Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38939 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab2LMN7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 08:59:05 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 5/8] mac80211: check radar interaction with scan and roc
Date: Thu, 13 Dec 2012 14:58:30 +0100
Message-Id: <1355407113-27006-6-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121213_145914_920820_150ECB1B)
In-Reply-To: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Scanning and remain on channel functionality must be disabled while
doing radar detection/scanning, and vice versa.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/mac80211/cfg.c         |   12 ++++++++++--
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/scan.c        |    3 +++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a9de035..9c190c5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1019,6 +1019,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	skb_queue_purge(&sdata->u.ap.ps.bc_buf);
 
 	ieee80211_vif_release_channel(sdata);
+	local->radar_detect_enabled = false;
 
 	return 0;
 }
@@ -2301,7 +2302,9 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	INIT_LIST_HEAD(&roc->dependents);
 
 	/* if there's one pending or we're scanning, queue this one */
-	if (!list_empty(&local->roc_list) || local->scanning)
+	if (!list_empty(&local->roc_list) ||
+	    local->scanning ||
+	    local->radar_detect_enabled)
 		goto out_check_combine;
 
 	/* if not HW assist, just queue & schedule work */
@@ -2562,6 +2565,9 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	if (!local->ops->start_radar_detection)
 		return -EOPNOTSUPP;
 
+	if (!list_empty(&local->roc_list) || local->scanning)
+		return -EBUSY;
+
 	/* whatever, but channel contexts should not complain about that one */
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = sdata->local->rx_chains;
@@ -2572,8 +2578,10 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 		return -EBUSY;
 
 	res = drv_start_radar_detection(local, sdata, chandef->chan);
-	if (!res)
+	if (!res) {
+		local->radar_detect_enabled = true;
 		ieee80211_vif_release_channel(sdata);
+	}
 
 	return res;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 42d0d02..abb2759 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -962,6 +962,9 @@ struct ieee80211_local {
 	/* wowlan is enabled -- don't reconfig on resume */
 	bool wowlan;
 
+	/* DFS/radar detection is enabled */
+	bool radar_detect_enabled;
+
 	/* number of RX chains the hardware has */
 	u8 rx_chains;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8ed83dc..c058749 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -369,6 +369,9 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
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

