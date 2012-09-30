Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:47115 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407Ab2I3Qrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2012 12:47:46 -0400
Date: Sun, 30 Sep 2012 19:47:40 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix FC masking in BIP AAD generation
Message-ID: <20120930164740.GA16910@w1.fi> (sfid-20120930_184837_329663_6CAB434E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bits used in the mask were off-by-one and ended up masking PwrMgt,
MoreData, Protected fields instead of Retry, PwrMgt, MoreData. Fix this
and to mask the correct fields. While doing so, convert the code to mask
the full FC using IEEE80211_FCTL_* defines similarly to how CCMP AAD is
built.

Since BIP is used only with broadcast/multicast management frames, the
Retry field is always 0 in these frames. The Protected field is also
zero to maintain backwards compatibility. As such, the incorrect mask
here does not really cause any problems for valid frames. In theory, an
invalid BIP frame with Retry or Protected field set to 1 could be
rejected because of BIP validation. However, no such frame should show
up with standard compliant implementations, so this does not cause
problems in normal BIP use.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 net/mac80211/wpa.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

This incorrect mask value was reported to me through private email and I
have not received permission to add a Reported-by: tag, so I can only
credit the anonymous reporter here. Thanks!


diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index bdb53ab..e58bf3f 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -545,14 +545,19 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 
 static void bip_aad(struct sk_buff *skb, u8 *aad)
 {
+	__le16 mask_fc;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+
 	/* BIP AAD: FC(masked) || A1 || A2 || A3 */
 
 	/* FC type/subtype */
-	aad[0] = skb->data[0];
 	/* Mask FC Retry, PwrMgt, MoreData flags to zero */
-	aad[1] = skb->data[1] & ~(BIT(4) | BIT(5) | BIT(6));
+	mask_fc = hdr->frame_control;
+	mask_fc &= ~cpu_to_le16(IEEE80211_FCTL_RETRY | IEEE80211_FCTL_PM |
+				IEEE80211_FCTL_MOREDATA);
+	put_unaligned(mask_fc, (__le16 *) &aad[0]);
 	/* A1 || A2 || A3 */
-	memcpy(aad + 2, skb->data + 4, 3 * ETH_ALEN);
+	memcpy(aad + 2, &hdr->addr1, 3 * ETH_ALEN);
 }
 
 
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
