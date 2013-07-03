Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab3GCLeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 07:34:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add per-chain signal information to radiotap
Date: Wed,  3 Jul 2013 13:34:02 +0200
Message-Id: <1372851242-25474-1-git-send-email-johannes@sipsolutions.net> (sfid-20130703_133411_815348_70B87534)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When per-chain signal information is available, don't add
the antenna field once but instead add a radiotap namespace
for each chain containing the chain/antenna number and the
signal strength on that chain.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 69 +++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 23dbcfc..c9f2ca4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -87,11 +87,13 @@ ieee80211_rx_radiotap_space(struct ieee80211_local *local,
 	int len;
 
 	/* always present fields */
-	len = sizeof(struct ieee80211_radiotap_header) + 9;
+	len = sizeof(struct ieee80211_radiotap_header) + 8;
 
-	/* allocate extra bitmap */
+	/* allocate extra bitmaps */
 	if (status->vendor_radiotap_len)
 		len += 4;
+	if (status->chains)
+		len += 4 * hweight8(status->chains);
 
 	if (ieee80211_have_rx_timestamp(status)) {
 		len = ALIGN(len, 8);
@@ -100,6 +102,10 @@ ieee80211_rx_radiotap_space(struct ieee80211_local *local,
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		len += 1;
 
+	/* antenna field, if we don't have per-chain info */
+	if (!status->chains)
+		len += 1;
+
 	/* padding for RX_FLAGS if necessary */
 	len = ALIGN(len, 2);
 
@@ -116,6 +122,11 @@ ieee80211_rx_radiotap_space(struct ieee80211_local *local,
 		len += 12;
 	}
 
+	if (status->chains) {
+		/* antenna and antenna signal fields */
+		len += 2 * hweight8(status->chains);
+	}
+
 	if (status->vendor_radiotap_len) {
 		if (WARN_ON_ONCE(status->vendor_radiotap_align == 0))
 			status->vendor_radiotap_align = 1;
@@ -145,8 +156,11 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_radiotap_header *rthdr;
 	unsigned char *pos;
+	__le32 *it_present;
+	u32 it_present_val;
 	u16 rx_flags = 0;
-	int mpdulen;
+	int mpdulen, chain;
+	unsigned long chains = status->chains;
 
 	mpdulen = skb->len;
 	if (!(has_fcs && (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)))
@@ -154,25 +168,39 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 
 	rthdr = (struct ieee80211_radiotap_header *)skb_push(skb, rtap_len);
 	memset(rthdr, 0, rtap_len);
+	it_present = &rthdr->it_present;
 
 	/* radiotap header, set always present flags */
-	rthdr->it_present =
-		cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
-			    (1 << IEEE80211_RADIOTAP_CHANNEL) |
-			    (1 << IEEE80211_RADIOTAP_ANTENNA) |
-			    (1 << IEEE80211_RADIOTAP_RX_FLAGS));
 	rthdr->it_len = cpu_to_le16(rtap_len + status->vendor_radiotap_len);
+	it_present_val = BIT(IEEE80211_RADIOTAP_FLAGS) |
+			 BIT(IEEE80211_RADIOTAP_CHANNEL) |
+			 BIT(IEEE80211_RADIOTAP_RX_FLAGS);
+
+	if (!status->chains)
+		it_present_val |= BIT(IEEE80211_RADIOTAP_ANTENNA);
 
-	pos = (unsigned char *)(rthdr + 1);
+	for_each_set_bit(chain, &chains, IEEE80211_MAX_CHAINS) {
+		it_present_val |=
+			BIT(IEEE80211_RADIOTAP_EXT) |
+			BIT(IEEE80211_RADIOTAP_RADIOTAP_NAMESPACE);
+		put_unaligned_le32(it_present_val, it_present);
+		it_present++;
+		it_present_val = BIT(IEEE80211_RADIOTAP_ANTENNA) |
+				 BIT(IEEE80211_RADIOTAP_DBM_ANTSIGNAL);
+	}
 
 	if (status->vendor_radiotap_len) {
-		rthdr->it_present |=
-			cpu_to_le32(BIT(IEEE80211_RADIOTAP_VENDOR_NAMESPACE)) |
-			cpu_to_le32(BIT(IEEE80211_RADIOTAP_EXT));
-		put_unaligned_le32(status->vendor_radiotap_bitmap, pos);
-		pos += 4;
+		it_present_val |= BIT(IEEE80211_RADIOTAP_VENDOR_NAMESPACE) |
+				  BIT(IEEE80211_RADIOTAP_EXT);
+		put_unaligned_le32(it_present_val, it_present);
+		it_present++;
+		it_present_val = status->vendor_radiotap_bitmap;
 	}
 
+	put_unaligned_le32(it_present_val, it_present);
+
+	pos = (void *)(it_present + 1);
+
 	/* the order of the following fields is important */
 
 	/* IEEE80211_RADIOTAP_TSFT */
@@ -242,9 +270,11 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 
 	/* IEEE80211_RADIOTAP_LOCK_QUALITY is missing */
 
-	/* IEEE80211_RADIOTAP_ANTENNA */
-	*pos = status->antenna;
-	pos++;
+	if (!status->chains) {
+		/* IEEE80211_RADIOTAP_ANTENNA */
+		*pos = status->antenna;
+		pos++;
+	}
 
 	/* IEEE80211_RADIOTAP_DB_ANTNOISE is not used */
 
@@ -341,6 +371,11 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		pos += 2;
 	}
 
+	for_each_set_bit(chain, &chains, IEEE80211_MAX_CHAINS) {
+		*pos++ = status->chain_signal[chain];
+		*pos++ = chain;
+	}
+
 	if (status->vendor_radiotap_len) {
 		/* ensure 2 byte alignment for the vendor field as required */
 		if ((pos - (u8 *)rthdr) & 1)
-- 
1.8.0

