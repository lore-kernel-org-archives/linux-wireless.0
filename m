Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34740 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbcF0Jxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 05:53:39 -0400
Received: by mail-pa0-f65.google.com with SMTP id us13so14948113pab.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2016 02:53:39 -0700 (PDT)
From: Chaitanya TK <chaitanya.mgit@gmail.com>
To: linux-wireless@vger.kernel.org,
	Karl Beldan <karl.beldan@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Cc: Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH] mac80211: minstrel: Enable STBC and LDPC for VHT Rates
Date: Mon, 27 Jun 2016 15:23:26 +0530
Message-Id: <1467021206-2702-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20160627_115343_453707_E3F0C168)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaitanya T K <chaitanya.mgit@gmail.com>

If peer support reception of STBC and LDPC, enable them for better
performance.

Signed-off-by: Chaitanya TK <chaitanya.mgit@gmail.com>
---
 include/linux/ieee80211.h          |    1 +
 net/mac80211/rc80211_minstrel_ht.c |   25 +++++++++++++++++--------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b118744..4d01130 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1550,6 +1550,7 @@ struct ieee80211_vht_operation {
 #define IEEE80211_VHT_CAP_RXSTBC_3				0x00000300
 #define IEEE80211_VHT_CAP_RXSTBC_4				0x00000400
 #define IEEE80211_VHT_CAP_RXSTBC_MASK				0x00000700
+#define IEEE80211_VHT_CAP_RXSTBC_SHIFT				8
 #define IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE			0x00000800
 #define IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE			0x00001000
 #define IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT                  13
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 30fbabf..e2fcdea 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1166,13 +1166,14 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	struct minstrel_ht_sta_priv *msp = priv_sta;
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
-	u16 sta_cap = sta->ht_cap.cap;
+	u16 ht_cap = sta->ht_cap.cap;
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
 	int use_vht;
 	int n_supported = 0;
 	int ack_dur;
 	int stbc;
 	int i;
+	bool ldpc;
 
 	/* fall back to the old minstrel for legacy stations */
 	if (!sta->ht_cap.ht_supported)
@@ -1210,16 +1211,24 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	}
 	mi->sample_tries = 4;
 
-	/* TODO tx_flags for vht - ATM the RC API is not fine-grained enough */
 	if (!use_vht) {
-		stbc = (sta_cap & IEEE80211_HT_CAP_RX_STBC) >>
+		stbc = (ht_cap & IEEE80211_HT_CAP_RX_STBC) >>
 			IEEE80211_HT_CAP_RX_STBC_SHIFT;
-		mi->tx_flags |= stbc << IEEE80211_TX_CTL_STBC_SHIFT;
 
-		if (sta_cap & IEEE80211_HT_CAP_LDPC_CODING)
-			mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
+		if (ht_cap & IEEE80211_HT_CAP_LDPC_CODING)
+			ldpc = true;
+	} else {
+		stbc = (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK) >>
+			IEEE80211_VHT_CAP_RXSTBC_SHIFT;
+
+		if (vht_cap->cap & IEEE80211_VHT_CAP_RXLDPC)
+			ldpc = true;
 	}
 
+	mi->tx_flags |= stbc << IEEE80211_TX_CTL_STBC_SHIFT;
+	if (ldpc)
+		mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
+
 	for (i = 0; i < ARRAY_SIZE(mi->groups); i++) {
 		u32 gflags = minstrel_mcs_groups[i].flags;
 		int bw, nss;
@@ -1232,10 +1241,10 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 
 		if (gflags & IEEE80211_TX_RC_SHORT_GI) {
 			if (gflags & IEEE80211_TX_RC_40_MHZ_WIDTH) {
-				if (!(sta_cap & IEEE80211_HT_CAP_SGI_40))
+				if (!(ht_cap & IEEE80211_HT_CAP_SGI_40))
 					continue;
 			} else {
-				if (!(sta_cap & IEEE80211_HT_CAP_SGI_20))
+				if (!(ht_cap & IEEE80211_HT_CAP_SGI_20))
 					continue;
 			}
 		}
-- 
1.7.9.5

