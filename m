Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:34389 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbdHAWne (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 18:43:34 -0400
Received: by mail-qk0-f179.google.com with SMTP id u139so17725034qka.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Aug 2017 15:43:34 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mike@hellotwist.com
From: Michael Skeffington <mike@astro.ai>
Date: Tue, 1 Aug 2017 18:43:33 -0400
Message-ID: <CAKXXJEw72EYHJpdwoWhudmOmFF=w+u_JG3vrp=-TCfR3zhANZw@mail.gmail.com> (sfid-20170802_004338_719747_6F613DA1)
Subject: [PATCH] rt2x00: Fix MMIC countermeasures.
To: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mac80211 doesnt check MMIC failure until after falling through the
check for whether the packet is decrypted.  Therefore, this driver
never causes MMIC countermeasures to be initiated.

This change may (or may not) be relevant for rt2500usb, rt73usb, and
rt61pci as well but I don't have any of those devices to test with.

Signed-off-by: Michael Skeffington <mike@hellotwist.com>

---

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index ee5276e233fa..ace91a2db756 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -136,10 +136,19 @@ void rt2800mmio_fill_rxdone(struct queue_entry *entry,
                 */
                rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;

-               if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
+               if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS) {
                        rxdesc->flags |= RX_FLAG_DECRYPTED;
-               else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
+        } else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC) {
+                       /*
+                        * In order to check the Michael Mic, the
packet must have
+                        * been decrypted.  Mac80211 doesnt check the
MMIC failure
+                        * flag to initiate MMIC countermeasures if
the decoded flag
+                        * has not been set.
+                        */
+                       rxdesc->flags |= RX_FLAG_DECRYPTED;
+
                        rxdesc->flags |= RX_FLAG_MMIC_ERROR;
+        }
        }

        if (rt2x00_get_field32(word, RXD_W3_MY_BSS))
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 685b8e0cd67d..7e5f397c37f9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -697,11 +697,20 @@ static void rt2800usb_fill_rxdone(struct
queue_entry *entry,
                 * stripped it from the frame. Signal this to mac80211.
                 */
                rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
-
-               if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
+
+               if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS) {
+                       rxdesc->flags |= RX_FLAG_DECRYPTED;
+        } else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC) {
+                       /*
+                        * In order to check the Michael Mic, the
packet must have
+                        * been decrypted.  Mac80211 doesnt check the
MMIC failure
+                        * flag to initiate MMIC countermeasures if
the decoded flag
+                        * has not been set.
+                        */
                        rxdesc->flags |= RX_FLAG_DECRYPTED;
-               else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
+
                        rxdesc->flags |= RX_FLAG_MMIC_ERROR;
+        }
        }

        if (rt2x00_get_field32(word, RXD_W0_MY_BSS))
