Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37265 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaCLJnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 05:43:05 -0400
Received: by mail-qc0-f174.google.com with SMTP id x13so10620235qcv.5
        for <linux-wireless@vger.kernel.org>; Wed, 12 Mar 2014 02:43:04 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Helmut Schaa <helmut.schaa@googlemail.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] ath9k: Fix sequence number assignment for non-data frames
Date: Wed, 12 Mar 2014 10:37:55 +0100
Message-Id: <1394617075-24664-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20140312_104330_692744_990F5A54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit 558ff225de80ac95b132d3a115ddadcd64498b4f (ath9k: fix
ps-poll responses under a-mpdu sessions) non-data frames would have
gotten a sequence number from a TIDs sequence counter instead of
using the global sequence counter.

This can lead to instable connections.

To fix this only select the correct TID if we are processing a
data frame. Furthermore, prevent non-data frames to get a sequence
number from a TID sequence counter by adding a check to
ath_tx_setup_buffer.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index fafacfe..69d04d5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2064,7 +2064,7 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 
 	ATH_TXBUF_RESET(bf);
 
-	if (tid) {
+	if (tid && ieee80211_is_data_present(hdr->frame_control)) {
 		fragno = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG;
 		seqno = tid->seq_next;
 		hdr->seq_ctrl = cpu_to_le16(tid->seq_next << IEEE80211_SEQ_SEQ_SHIFT);
@@ -2187,7 +2187,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		txq->stopped = true;
 	}
 
-	if (txctl->an)
+	if (txctl->an && ieee80211_is_data_present(hdr->frame_control))
 		tid = ath_get_skb_tid(sc, txctl->an, skb);
 
 	if (info->flags & IEEE80211_TX_CTL_PS_RESPONSE) {
-- 
1.8.1.4

