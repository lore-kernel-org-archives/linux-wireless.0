Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59072 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2DQDFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 23:05:44 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20364.56786.840266.849827@gargle.gargle.HOWL> (sfid-20120417_050618_984536_80FD8354)
Date: Tue, 17 Apr 2012 08:34:50 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix TX fragmentation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Assigning sequence number for frames without taking care
of the fragment field breaks transmission of fragmented frames.
Fix this by assigning the fragment number properly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 834e6bc..23eaa1b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1820,6 +1820,7 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 	struct ath_frame_info *fi = get_frame_info(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ath_buf *bf;
+	int fragno;
 	u16 seqno;
 
 	bf = ath_tx_get_buffer(sc);
@@ -1831,9 +1832,16 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 	ATH_TXBUF_RESET(bf);
 
 	if (tid) {
+		fragno = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG;
 		seqno = tid->seq_next;
 		hdr->seq_ctrl = cpu_to_le16(tid->seq_next << IEEE80211_SEQ_SEQ_SHIFT);
-		INCR(tid->seq_next, IEEE80211_SEQ_MAX);
+
+		if (fragno)
+			hdr->seq_ctrl |= cpu_to_le16(fragno);
+
+		if (!ieee80211_has_morefrags(hdr->frame_control))
+			INCR(tid->seq_next, IEEE80211_SEQ_MAX);
+
 		bf->bf_state.seqno = seqno;
 	}
 
-- 
1.7.10

