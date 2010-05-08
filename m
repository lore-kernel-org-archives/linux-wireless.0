Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:3753 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441Ab0EHVkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 17:40:32 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 2/9] rt2x00: Clean up rt2800usb.h.
Date: Sat,  8 May 2010 23:40:19 +0200
Message-Id: <1273354826-4335-3-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unused RXD_DESC_SIZE define and remove duplicated RXWI definitions
from rt2800.h.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.h |   40 -------------------------------
 1 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.h b/drivers/net/wireless/rt2x00/rt2800usb.h
index d1d8ae9..2bca6a7 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -79,8 +79,6 @@
  */
 #define TXINFO_DESC_SIZE		( 1 * sizeof(__le32) )
 #define RXINFO_DESC_SIZE		( 1 * sizeof(__le32) )
-#define RXWI_DESC_SIZE			( 4 * sizeof(__le32) )
-#define RXD_DESC_SIZE			( 1 * sizeof(__le32) )
 
 /*
  * TX Info structure
@@ -113,44 +111,6 @@
 #define RXINFO_W0_USB_DMA_RX_PKT_LEN	FIELD32(0x0000ffff)
 
 /*
- * RX WI structure
- */
-
-/*
- * Word0
- */
-#define RXWI_W0_WIRELESS_CLI_ID		FIELD32(0x000000ff)
-#define RXWI_W0_KEY_INDEX		FIELD32(0x00000300)
-#define RXWI_W0_BSSID			FIELD32(0x00001c00)
-#define RXWI_W0_UDF			FIELD32(0x0000e000)
-#define RXWI_W0_MPDU_TOTAL_BYTE_COUNT	FIELD32(0x0fff0000)
-#define RXWI_W0_TID			FIELD32(0xf0000000)
-
-/*
- * Word1
- */
-#define RXWI_W1_FRAG			FIELD32(0x0000000f)
-#define RXWI_W1_SEQUENCE		FIELD32(0x0000fff0)
-#define RXWI_W1_MCS			FIELD32(0x007f0000)
-#define RXWI_W1_BW			FIELD32(0x00800000)
-#define RXWI_W1_SHORT_GI		FIELD32(0x01000000)
-#define RXWI_W1_STBC			FIELD32(0x06000000)
-#define RXWI_W1_PHYMODE			FIELD32(0xc0000000)
-
-/*
- * Word2
- */
-#define RXWI_W2_RSSI0			FIELD32(0x000000ff)
-#define RXWI_W2_RSSI1			FIELD32(0x0000ff00)
-#define RXWI_W2_RSSI2			FIELD32(0x00ff0000)
-
-/*
- * Word3
- */
-#define RXWI_W3_SNR0			FIELD32(0x000000ff)
-#define RXWI_W3_SNR1			FIELD32(0x0000ff00)
-
-/*
  * RX descriptor format for RX Ring.
  */
 
-- 
1.7.1

