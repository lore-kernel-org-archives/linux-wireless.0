Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40943 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621AbZKCDH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 22:07:57 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Subject: [RFT 7/9] ath9k: use the right hw on ath_tx_setup_buffer() for HT
Date: Mon,  2 Nov 2009 22:07:59 -0500
Message-Id: <1257217681-27180-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257217681-27180-1-git-send-email-lrodriguez@atheros.com>
References: <1257217681-27180-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using virtual wiphys the base sc->hw was being used, the correct
hw is passed along the caller already so just use that.

Cc: Jouni.Malinen <Jouni.Malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5d0851b..427bd1d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1575,7 +1575,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 
 	bf->bf_frmlen = skb->len + FCS_LEN - (hdrlen & 3);
 
-	if (conf_is_ht(&sc->hw->conf) && !is_pae(skb))
+	if (conf_is_ht(&hw->conf) && !is_pae(skb))
 		bf->bf_state.bf_type |= BUF_HT;
 
 	bf->bf_flags = setup_tx_flags(sc, skb, txctl->txq);
-- 
1.6.5.2.143.g8cc62

