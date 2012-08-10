Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54929 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944Ab2HJJAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 05:00:25 -0400
Received: by obbuo13 with SMTP id uo13so1950033obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 02:00:25 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Aug 2012 11:00:24 +0200
Message-ID: <CAA2SeNKP1Nkk=1Ef-we33ggJQjmE1G7YcaPjLSxMevQ7zm+TGg@mail.gmail.com> (sfid-20120810_110032_728318_640F3300)
Subject: [PATCH v3] ath9k: fix decrypt_error initialization in ath_rx_tasklet()
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>

ath_rx_tasklet() calls ath9k_rx_skb_preprocess() and ath9k_rx_skb_postprocess()
in a loop over the received frames. The decrypt_error flag is
initialized to false
just outside ath_rx_tasklet() loop. ath9k_rx_accept(), called by
ath9k_rx_skb_preprocess(),
only sets decrypt_error to true and never to false.
Then ath_rx_tasklet() calls ath9k_rx_skb_postprocess() and passes
decrypt_error to it.
So, after a decryption error, in ath9k_rx_skb_postprocess(), we can
have a leftover value
from another processed frame. In that case, the frame will not be marked with
RX_FLAG_DECRYPTED even if it is decrypted correctly.
When using CCMP encryption this issue can lead to connection stuck
because of CCMP
PN corruption and a waste of CPU time since mac80211 tries to decrypt an already
deciphered frame with ieee80211_aes_ccm_decrypt.
Fix the issue initializing decrypt_error flag at the begging of the
ath_rx_tasklet() loop.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: <stable@kernel.org>
---
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1044,7 +1044,6 @@
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_hdr *hdr;
 	int retval;
-	bool decrypt_error = false;
 	struct ath_rx_status rs;
 	enum ath9k_rx_qtype qtype;
 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
@@ -1066,6 +1065,7 @@
 	tsf_lower = tsf & 0xffffffff;

 	do {
+		bool decrypt_error = false;
 		/* If handling rx interrupt and flush is in progress => exit */
 		if (test_bit(SC_OP_RXFLUSH, &sc->sc_flags) && (flush == 0))
 			break;
