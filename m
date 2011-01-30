Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48218 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab1A3MYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:52 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so2118506ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:52 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/21] rt2x00: Fix WPA TKIP Michael MIC failures.
Date: Sun, 30 Jan 2011 13:22:41 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301322.04131.IvDoorn@gmail.com> <201101301322.23247.IvDoorn@gmail.com>
In-Reply-To: <201101301322.23247.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301322.42545.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

As reported and found by Johannes Stezenbach:
rt2800{pci,usb} do not report the Michael MIC in RXed frames, but do check
the Michael MIC in hardware. Therefore we have to report to mac80211 that the
received frame does not include the Michael MIC.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    6 ++++++
 drivers/net/wireless/rt2x00/rt2800usb.c |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 208ea5e..8f4dfc3 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -675,6 +675,12 @@ static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 		 */
 		rxdesc->flags |= RX_FLAG_IV_STRIPPED;
 
+		/*
+		 * The hardware has already checked the Michael Mic and has
+		 * stripped it from the frame. Signal this to mac80211.
+		 */
+		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
+
 		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
 			rxdesc->flags |= RX_FLAG_DECRYPTED;
 		else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 3d2a944..5d91561 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -484,6 +484,12 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 		 */
 		rxdesc->flags |= RX_FLAG_IV_STRIPPED;
 
+		/*
+		 * The hardware has already checked the Michael Mic and has
+		 * stripped it from the frame. Signal this to mac80211.
+		 */
+		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
+
 		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
 			rxdesc->flags |= RX_FLAG_DECRYPTED;
 		else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
-- 
1.7.2.3

