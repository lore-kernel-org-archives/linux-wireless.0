Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbXHSSbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:31:48 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:31:47 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 22/30] rt2x00: Correctly set TXD retry flag
Date: Sun, 19 Aug 2007 20:29:14 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192029.14205.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 0bb0e744139fd77b627cca3faf82897914d6dae9 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 13:25:26 +0200
Subject: [PATCH 22/30] rt2x00: Correctly set TXD retry flag

Check for the IEEE80211_TXCTL_LONG_RETRY_LIMIT flag
to determine the correct RETRY mode.
Only rt2500usb is capable of setting the exact number
of maximum retries. All other chipsets can only set the
LONG or SHORT retry mode.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |    3 ++-
 drivers/net/wireless/rt2500pci.c |    3 ++-
 drivers/net/wireless/rt61pci.c   |    3 ++-
 drivers/net/wireless/rt73usb.c   |    3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index ffd41a6..b851571 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -1153,7 +1153,8 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_RTS,
 			   test_bit(ENTRY_TXD_RTS_FRAME, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
-	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE, 0);
+	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
+			   !!(control->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT));
 	rt2x00_desc_write(txd, 0, word);
 }
 
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index fce91ed..1000525 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -1281,7 +1281,8 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_OWNER, 1);
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
-	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE, 0);
+	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
+			   !!(control->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT));
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index 0e7a528..efa6c25 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -1531,7 +1531,8 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
 			   test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
-	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE, 0);
+	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
+			   !!(control->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT));
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
 	rt2x00_set_field32(&word, TXD_W0_BURST,
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 057e5a0..9e8c049 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -1268,7 +1268,8 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_OFDM,
 			   test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, desc->ifs);
-	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE, 0);
+	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
+			   !!(control->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT));
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
 	rt2x00_set_field32(&word, TXD_W0_BURST2,
-- 
1.5.3.rc5

