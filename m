Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3679 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYLSPx2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 10:53:28 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Benoit PAPILLAULT <benoit.papillault@free.fr>,
	Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: Updated padding stuff for the RX and TX side. TX side has been 100%
Date: Fri, 19 Dec 2008 10:53:17 -0500
Message-Id: <20081219152057.M98456@bobcopeland.com> (sfid-20081219_165332_947537_06648D06)
In-Reply-To: <20081217183527.GA3516@tuxdriver.com>
References: <1229351698-21116-1-git-send-email-benoit.papillault@free.fr> <20081215170613.GA22627@jm.kir.nu> <4946C6D9.1060101@free.fr> <b6c5339f0812160722nab8516cj1ed4e6d397060d9d@mail.gmail.com> <20081217155533.GB12679@tuxdriver.com> <b6c5339f0812170940x58612431ufbe4248711573552@mail.gmail.com> <20081217183527.GA3516@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 17 Dec 2008 13:35:27 -0500, John W. Linville wrote
> > Okay. I think the one you took before, plus my diff should be sufficient.
> > Do you want me to submit a proper patch that just fixes the TX, or should
> > we regroup and combine both up into a single patch on our side?
> 
> Just your new patch will be sufficient I think...?

Ok here you go.  In fact we won't trigger this case very often since
those packets are usually sent by hardware, but anyway we should be
consistent everywhere.  This is on top of 28bd3684fb5.

>From 853eff110f7aefaf150b189ac8a87b77fa9447c5 Mon Sep 17 00:00:00 2001
From: Bob Copeland <me@bobcopeland.com>
Date: Thu, 18 Dec 2008 23:23:05 -0500
Subject: [PATCH] ath5k: correct packet length in tx descriptors

Packet length calculation (which includes frame check sequence)
should take into account whether we add a pad field or not.
Extract the calculation into a helper and use it in both places.

Changes to desc.c
Changes-licensed-under: ISC

Changes to ath5k.h, base.c
Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/ath5k.h |    5 +++++
 drivers/net/wireless/ath5k/base.c  |    8 ++++----
 drivers/net/wireless/ath5k/desc.c  |    4 ++--
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h
b/drivers/net/wireless/ath5k/ath5k.h
index 13df119..183ffc8 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -1350,4 +1350,9 @@ static inline u32 ath5k_hw_bitswap(u32 val, unsigned int
bits)
 	return retval;
 }
 
+static inline int ath5k_pad_size(int hdrlen)
+{
+	return (hdrlen < 24) ? 0 : hdrlen & 3;
+}
+
 #endif
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 9d2c597..40c0155 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1761,8 +1761,8 @@ accept:
 		 * not try to remove padding from short control frames that do
 		 * not have payload. */
 		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-		padsize = hdrlen & 3;
-		if (padsize && hdrlen >= 24) {
+		padsize = ath5k_pad_size(hdrlen);
+		if (padsize) {
 			memmove(skb->data + padsize, skb->data, hdrlen);
 			skb_pull(skb, padsize);
 		}
@@ -2637,8 +2637,8 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * if this is not the case we add the padding after the header
 	 */
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	padsize = hdrlen & 3;
-	if (padsize && hdrlen >= 24) {
+	padsize = ath5k_pad_size(hdrlen);
+	if (padsize) {
 
 		if (skb_headroom(skb) < padsize) {
 			ATH5K_ERR(sc, "tx hdrlen not %%4: %d not enough"
diff --git a/drivers/net/wireless/ath5k/desc.c b/drivers/net/wireless/ath5k/desc.c
index 5e362a7..b40a928 100644
--- a/drivers/net/wireless/ath5k/desc.c
+++ b/drivers/net/wireless/ath5k/desc.c
@@ -71,7 +71,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct
ath5k_desc *desc,
 	/* Verify and set frame length */
 
 	/* remove padding we might have added before */
-	frame_len = pkt_len - (hdr_len & 3) + FCS_LEN;
+	frame_len = pkt_len - ath5k_pad_size(hdr_len) + FCS_LEN;
 
 	if (frame_len & ~AR5K_2W_TX_DESC_CTL0_FRAME_LEN)
 		return -EINVAL;
@@ -202,7 +202,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	/* Verify and set frame length */
 
 	/* remove padding we might have added before */
-	frame_len = pkt_len - (hdr_len & 3) + FCS_LEN;
+	frame_len = pkt_len - ath5k_pad_size(hdr_len) + FCS_LEN;
 
 	if (frame_len & ~AR5K_4W_TX_DESC_CTL0_FRAME_LEN)
 		return -EINVAL;
-- 
1.6.0.4

-- 
Bob Copeland %% www.bobcopeland.com


