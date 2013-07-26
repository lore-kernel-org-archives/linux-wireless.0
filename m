Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:57315 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab3GZSF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 14:05:57 -0400
Received: by mail-we0-f171.google.com with SMTP id q55so2188421wes.30
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jul 2013 11:05:56 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] [PATCH] mac80211: handle VHT radiotap info for tx status
Date: Fri, 26 Jul 2013 19:58:34 +0200
Message-Id: <1374861514-29022-1-git-send-email-karl.beldan@gmail.com> (sfid-20130726_200600_894447_216ED0CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

The radiotap VHT info is 12 bytes (required to be aligned on 2) :
u16 known - IEEE80211_RADIOTAP_VHT_KNOWN_*
u8 flags - IEEE80211_RADIOTAP_VHT_FLAG_*
u8 bandwidth
u8 mcs_nss[4]
u8 coding
u8 group_id
u16 partial_aid

ATM mac80211 can properly handle IEEE80211_RADIOTAP_VHT_KNOWN_GI,
IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH and mcs_nss[0] (i.e single user).

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/status.c | 76 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 63 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 6ad4c14..1a1c7fd 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -235,7 +235,8 @@ static int ieee80211_tx_radiotap_len(struct ieee80211_tx_info *info)
 
 	/* IEEE80211_RADIOTAP_RATE rate */
 	if (info->status.rates[0].idx >= 0 &&
-	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS))
+	    !(info->status.rates[0].flags & (IEEE80211_TX_RC_MCS |
+					     IEEE80211_TX_RC_VHT_MCS)))
 		len += 2;
 
 	/* IEEE80211_RADIOTAP_TX_FLAGS */
@@ -244,16 +245,21 @@ static int ieee80211_tx_radiotap_len(struct ieee80211_tx_info *info)
 	/* IEEE80211_RADIOTAP_DATA_RETRIES */
 	len += 1;
 
-	/* IEEE80211_TX_RC_MCS */
-	if (info->status.rates[0].idx >= 0 &&
-	    info->status.rates[0].flags & IEEE80211_TX_RC_MCS)
-		len += 3;
+	/* IEEE80211_RADIOTAP_MCS
+	 * IEEE80211_RADIOTAP_VHT */
+	if (info->status.rates[0].idx >= 0) {
+		if (info->status.rates[0].flags & IEEE80211_TX_RC_MCS)
+			len += 3;
+		else if (info->status.rates[0].flags & IEEE80211_TX_RC_VHT_MCS)
+			len += ALIGN(len, 2) + 12;
+	}
 
 	return len;
 }
 
 static void
-ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band *sband,
+ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
+				 struct ieee80211_supported_band *sband,
 				 struct sk_buff *skb, int retry_count,
 				 int rtap_len, int shift)
 {
@@ -280,7 +286,8 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band *sband,
 
 	/* IEEE80211_RADIOTAP_RATE */
 	if (info->status.rates[0].idx >= 0 &&
-	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS)) {
+	    !(info->status.rates[0].flags & (IEEE80211_TX_RC_MCS |
+					     IEEE80211_TX_RC_VHT_MCS))) {
 		u16 rate;
 
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
@@ -310,9 +317,12 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band *sband,
 	*pos = retry_count;
 	pos++;
 
-	/* IEEE80211_TX_RC_MCS */
-	if (info->status.rates[0].idx >= 0 &&
-	    info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
+	if (info->status.rates[0].idx < 0)
+		return;
+
+	/* IEEE80211_RADIOTAP_MCS
+	 * IEEE80211_RADIOTAP_VHT */
+	if (info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
 		pos[0] = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
 			 IEEE80211_RADIOTAP_MCS_HAVE_GI |
@@ -325,8 +335,48 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band *sband,
 			pos[1] |= IEEE80211_RADIOTAP_MCS_FMT_GF;
 		pos[2] = info->status.rates[0].idx;
 		pos += 3;
-	}
+	} else if (info->status.rates[0].flags & IEEE80211_TX_RC_VHT_MCS) {
+		u16 known = local->hw.radiotap_vht_details &
+			(IEEE80211_RADIOTAP_VHT_KNOWN_GI |
+			 IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH);
+
+		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_VHT);
+
+		/* required alignment from rthdr */
+		pos = (u8 *)rthdr + ALIGN(pos - (u8 *)rthdr, 2);
 
+		/* u16 known - IEEE80211_RADIOTAP_VHT_KNOWN_* */
+		put_unaligned_le16(known, pos);
+		pos += 2;
+
+		/* u8 flags - IEEE80211_RADIOTAP_VHT_FLAG_* */
+		if (info->status.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
+			*pos |= IEEE80211_RADIOTAP_VHT_FLAG_SGI;
+		pos++;
+
+		/* u8 bandwidth */
+		if (info->status.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			*pos = 1;
+		else if (info->status.rates[0].flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+			*pos = 4;
+		else if (info->status.rates[0].flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
+			*pos = 11;
+		else /* IEEE80211_TX_RC_20_MHZ_WIDTH */
+			*pos = 0;
+		pos++;
+
+		/* u8 mcs_nss[4] */
+		*pos = (ieee80211_rate_get_vht_mcs(&info->status.rates[0]) << 4) |
+			ieee80211_rate_get_vht_nss(&info->status.rates[0]);
+		pos += 4;
+
+		/* u8 coding */
+		pos++;
+		/* u8 group_id */
+		pos++;
+		/* u16 partial_aid */
+		pos += 2;
+	}
 }
 
 static void ieee80211_report_used_skb(struct ieee80211_local *local,
@@ -631,8 +681,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		dev_kfree_skb(skb);
 		return;
 	}
-	ieee80211_add_tx_radiotap_header(sband, skb, retry_count, rtap_len,
-					 shift);
+	ieee80211_add_tx_radiotap_header(local, sband, skb, retry_count,
+					 rtap_len, shift);
 
 	/* XXX: is this sufficient for BPF? */
 	skb_set_mac_header(skb, 0);
-- 
1.8.2

