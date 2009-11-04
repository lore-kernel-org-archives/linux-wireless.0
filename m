Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbZKDRfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 12:35:45 -0500
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:35:25 +0100
Message-Id: <20091104173525.28463.40807.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 28/41] rt2x00: fix rt2x00pci_register_multi[read,write]() arguments
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2x00: fix rt2x00pci_register_multi[read,write]() arguments

Change type of 'length' argument from u16 to u32 (all arguments
match rt2x00usb_register_multi[read,write]() ones now).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.h |    8 ++++----
 drivers/net/wireless/rt2x00/rt2x00pci.h |   15 +++++++--------
 2 files changed, 11 insertions(+), 12 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800pci.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -37,10 +37,10 @@ struct rt2800_ops {
 
 	void (*register_multiread)(struct rt2x00_dev *rt2x00dev,
 				   const unsigned int offset,
-				   void *value, const u16 length);
+				   void *value, const u32 length);
 	void (*register_multiwrite)(struct rt2x00_dev *rt2x00dev,
 				    const unsigned int offset,
-				    const void *value, const u16 length);
+				    const void *value, const u32 length);
 
 	int (*regbusy_read)(struct rt2x00_dev *rt2x00dev,
 			    const unsigned int offset,
@@ -76,7 +76,7 @@ static inline void rt2800_register_write
 
 static inline void rt2800_register_multiread(struct rt2x00_dev *rt2x00dev,
 					     const unsigned int offset,
-					     void *value, const u16 length)
+					     void *value, const u32 length)
 {
 	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
 
@@ -86,7 +86,7 @@ static inline void rt2800_register_multi
 static inline void rt2800_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 					      const unsigned int offset,
 					      const void *value,
-					      const u16 length)
+					      const u32 length)
 {
 	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
 
Index: b/drivers/net/wireless/rt2x00/rt2x00pci.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -53,10 +53,9 @@ static inline void rt2x00pci_register_re
 	*value = readl(rt2x00dev->csr.base + offset);
 }
 
-static inline void
-rt2x00pci_register_multiread(struct rt2x00_dev *rt2x00dev,
-			     const unsigned int offset,
-			     void *value, const u16 length)
+static inline void rt2x00pci_register_multiread(struct rt2x00_dev *rt2x00dev,
+						const unsigned int offset,
+						void *value, const u32 length)
 {
 	memcpy_fromio(value, rt2x00dev->csr.base + offset, length);
 }
@@ -68,10 +67,10 @@ static inline void rt2x00pci_register_wr
 	writel(value, rt2x00dev->csr.base + offset);
 }
 
-static inline void
-rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
-			      const unsigned int offset,
-			      const void *value, const u16 length)
+static inline void rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
+						 const unsigned int offset,
+						 const void *value,
+						 const u32 length)
 {
 	memcpy_toio(rt2x00dev->csr.base + offset, value, length);
 }
