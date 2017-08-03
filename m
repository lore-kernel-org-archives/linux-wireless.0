Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36205 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbdHCPbu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 11:31:50 -0400
Received: by mail-qk0-f178.google.com with SMTP id d136so9663390qkg.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 08:31:50 -0700 (PDT)
From: Michael Skeffingfon <mike@astro.ai>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Michael Skeffington <mike@astro.ai>
Subject: [PATCH v2] rt2x00: Fix MMIC Countermeasures.
Date: Thu,  3 Aug 2017 11:31:21 -0400
Message-Id: <20170803153121.9046-1-mike@astro.ai> (sfid-20170803_173154_440311_91261C2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Skeffington <mike@astro.ai>

Set RX_FLAG_DECRYPTED in case of MMIC failure so that ieee80211_rx_h_decrypt() doesnt drop the frame before getting to ieee80211_rx_h_michael_mic_verify().

Signed-off-by: Michael Skeffington <mike@astro.ai>

---
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c | 13 +++++++++++--
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c  | 15 ++++++++++++---
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index ee5276e233fa..ace91a2db756 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -136,10 +136,19 @@ void rt2800mmio_fill_rxdone(struct queue_entry *entry,
 		 */
 		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
 
-		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
+		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS) {
 			rxdesc->flags |= RX_FLAG_DECRYPTED;
-		else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
+        } else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC) {
+			/*
+			 * In order to check the Michael Mic, the packet must have
+			 * been decrypted.  Mac80211 doesnt check the MMIC failure 
+			 * flag to initiate MMIC countermeasures if the decoded flag
+			 * has not been set.
+			 */
+			rxdesc->flags |= RX_FLAG_DECRYPTED;
+
 			rxdesc->flags |= RX_FLAG_MMIC_ERROR;
+        }
 	}
 
 	if (rt2x00_get_field32(word, RXD_W3_MY_BSS))
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 685b8e0cd67d..7e5f397c37f9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -697,11 +697,20 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 		 * stripped it from the frame. Signal this to mac80211.
 		 */
 		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
-
-		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
+        
+		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS) {
+			rxdesc->flags |= RX_FLAG_DECRYPTED;
+        } else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC) {
+			/*
+			 * In order to check the Michael Mic, the packet must have
+			 * been decrypted.  Mac80211 doesnt check the MMIC failure 
+			 * flag to initiate MMIC countermeasures if the decoded flag
+			 * has not been set.
+			 */
 			rxdesc->flags |= RX_FLAG_DECRYPTED;
-		else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
+
 			rxdesc->flags |= RX_FLAG_MMIC_ERROR;
+        }
 	}
 
 	if (rt2x00_get_field32(word, RXD_W0_MY_BSS))
-- 
2.11.0
