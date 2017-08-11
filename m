Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33857 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752985AbdHKNqU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 09:46:20 -0400
Received: by mail-pf0-f196.google.com with SMTP id t86so3539590pfe.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Aug 2017 06:46:19 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 06/11] rsi: handle station disconnection in AP mode
Date: Fri, 11 Aug 2017 19:11:24 +0530
Message-Id: <1502458889-9690-7-git-send-email-amitkarwar@gmail.com> (sfid-20170811_154700_565553_B2CAF76B)
In-Reply-To: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
References: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

When sta_remove of mac80211 is called, driver iterates through
list of existing stations to get the station id. Then peer notify
is prepared and send to firmare.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 57 +++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index cf86162..6eb93ad 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1255,21 +1255,56 @@ static int rsi_mac80211_sta_remove(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	struct ieee80211_bss_conf *bss = &vif->bss_conf;
+	struct rsi_sta *rsta;
+
+	print_hex_dump(KERN_INFO, "Station Remove: ", DUMP_PREFIX_OFFSET,
+		       16, 1, sta->addr, ETH_ALEN, 0);
 
 	mutex_lock(&common->mutex);
 
-	/* Resetting all the fields to default values */
-	common->bitrate_mask[NL80211_BAND_2GHZ] = 0;
-	common->bitrate_mask[NL80211_BAND_5GHZ] = 0;
-	common->min_rate = 0xffff;
-	common->vif_info[0].is_ht = false;
-	common->vif_info[0].sgi = false;
-	common->vif_info[0].seq_start = 0;
-	common->secinfo.ptk_cipher = 0;
-	common->secinfo.gtk_cipher = 0;
+	if (vif->type == NL80211_IFTYPE_AP) {
+		u8 sta_idx, cnt;
 
-	rsi_send_rx_filter_frame(common, 0);
-	
+		/* Send peer notify to device */
+		rsi_dbg(INFO_ZONE, "Indicate bss status to device\n");
+		for (sta_idx = 0; sta_idx < common->max_stations; sta_idx++) {
+			rsta = &common->stations[sta_idx];
+
+			if (!rsta->sta)
+				continue;
+			if (!memcmp(rsta->sta->addr, sta->addr, ETH_ALEN)) {
+				rsi_inform_bss_status(common, AP_OPMODE, 0,
+						      sta->addr, sta->wme,
+						      sta->aid, sta, sta_idx);
+				rsta->sta = NULL;
+				rsta->sta_id = -1;
+				for (cnt = 0; cnt < IEEE80211_NUM_TIDS; cnt++)
+					rsta->start_tx_aggr[cnt] = false;
+				if (common->num_stations > 0)
+					common->num_stations--;
+				break;
+			}
+		}
+		if (sta_idx >= common->max_stations)
+			rsi_dbg(ERR_ZONE, "%s: No station found\n", __func__);
+	}
+
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		/* Resetting all the fields to default values */
+		memcpy((u8 *)bss->bssid, (u8 *)sta->addr, ETH_ALEN);
+		bss->qos = sta->wme;
+		common->bitrate_mask[NL80211_BAND_2GHZ] = 0;
+		common->bitrate_mask[NL80211_BAND_5GHZ] = 0;
+		common->min_rate = 0xffff;
+		common->vif_info[0].is_ht = false;
+		common->vif_info[0].sgi = false;
+		common->vif_info[0].seq_start = 0;
+		common->secinfo.ptk_cipher = 0;
+		common->secinfo.gtk_cipher = 0;
+		if (!common->iface_down)
+			rsi_send_rx_filter_frame(common, 0);
+	}
 	mutex_unlock(&common->mutex);
 	
 	return 0;
-- 
2.7.4
