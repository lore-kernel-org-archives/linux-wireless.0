Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:41096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbZKDRdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 12:33:53 -0500
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:33:34 +0100
Message-Id: <20091104173334.28463.13649.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/41] rt2800usb: add rt2800_regbusy_read() wrapper
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: add rt2800_regbusy_read() wrapper

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   10 +++++-----
 drivers/net/wireless/rt2x00/rt2800usb.h |    8 ++++++++
 2 files changed, 13 insertions(+), 5 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -58,14 +58,14 @@ MODULE_PARM_DESC(nohwcrypt, "Disable har
  * The _lock versions must be used if you already hold the csr_mutex
  */
 #define WAIT_FOR_BBP(__dev, __reg) \
-	rt2x00usb_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))
+	rt2800_regbusy_read((__dev), BBP_CSR_CFG, BBP_CSR_CFG_BUSY, (__reg))
 #define WAIT_FOR_RFCSR(__dev, __reg) \
-	rt2x00usb_regbusy_read((__dev), RF_CSR_CFG, RF_CSR_CFG_BUSY, (__reg))
+	rt2800_regbusy_read((__dev), RF_CSR_CFG, RF_CSR_CFG_BUSY, (__reg))
 #define WAIT_FOR_RF(__dev, __reg) \
-	rt2x00usb_regbusy_read((__dev), RF_CSR_CFG0, RF_CSR_CFG0_BUSY, (__reg))
+	rt2800_regbusy_read((__dev), RF_CSR_CFG0, RF_CSR_CFG0_BUSY, (__reg))
 #define WAIT_FOR_MCU(__dev, __reg) \
-	rt2x00usb_regbusy_read((__dev), H2M_MAILBOX_CSR, \
-			       H2M_MAILBOX_CSR_OWNER, (__reg))
+	rt2800_regbusy_read((__dev), H2M_MAILBOX_CSR, \
+			    H2M_MAILBOX_CSR_OWNER, (__reg))
 
 static void rt2800usb_bbp_write(struct rt2x00_dev *rt2x00dev,
 				const unsigned int word, const u8 value)
Index: b/drivers/net/wireless/rt2x00/rt2800usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -62,6 +62,14 @@ static inline void rt2x00_register_multi
 	rt2x00usb_register_multiwrite(rt2x00dev, offset, value, length);
 }
 
+static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
+				      const unsigned int offset,
+				      struct rt2x00_field32 field,
+				      u32 *reg)
+{
+	return rt2x00usb_regbusy_read(rt2x00dev, offset, field, reg);
+}
+
 /*
  * RF chip defines.
  *
