Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbXIPMIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:41 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:40 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 23/24] rt2x00: Add additional bit to MAX_FRAME_UNIT
Date: Sun, 16 Sep 2007 14:19:43 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161419.44941.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Legacy driver indicated that the MAX_FRAME_UNIT register
was 11 bits long. _but_ they do write 12 bits to the register.
Increase the register definition to accept the 12th bit.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.h |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index f24bff3..6721d7d 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -262,7 +262,7 @@ struct hw_pairwise_ta_entry {
  * MAC_CSR6: Maximum frame length register.
  */
 #define MAC_CSR6			0x3018
-#define MAC_CSR6_MAX_FRAME_UNIT		FIELD32(0x000007ff)
+#define MAC_CSR6_MAX_FRAME_UNIT		FIELD32(0x00000fff)
 
 /*
  * MAC_CSR7: Reserved
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 82f4e76..5d63a1a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -174,7 +174,7 @@ struct hw_pairwise_ta_entry {
  * MAC_CSR6: Maximum frame length register.
  */
 #define MAC_CSR6			0x3018
-#define MAC_CSR6_MAX_FRAME_UNIT		FIELD32(0x000007ff)
+#define MAC_CSR6_MAX_FRAME_UNIT		FIELD32(0x00000fff)
 
 /*
  * MAC_CSR7: Reserved
-- 
1.5.3
