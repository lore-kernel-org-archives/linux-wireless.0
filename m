Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:61092 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbZKNTUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 14:20:51 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 2/2] rt2x00: Fix BUG on rt2800usb when trying to read eFuse EEPROM.
Date: Sat, 14 Nov 2009 20:20:36 +0100
Message-Id: <1258226436-4673-3-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1258226436-4673-2-git-send-email-gwingerde@gmail.com>
References: <1258226436-4673-1-git-send-email-gwingerde@gmail.com>
 <1258226436-4673-2-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current tree hits a BUG_ON in rt2x00_regbusy_read, because the eFuse EEPROM
reading code of rt2800lib uses the function without the csr_mutex locked.

Fix this by locking the csr_mutex for the of the EEPROM reading cycly and
using the _lock variants of the register reading and writing functions.

This also introcudes the register_read_lock function pointer in the
rt2800_ops structure.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   24 ++++++++++++++----------
 drivers/net/wireless/rt2x00/rt2800lib.h |   11 +++++++++++
 drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 4 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c710805..621dac1 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1684,24 +1684,28 @@ static void rt2800_efuse_read(struct rt2x00_dev *rt2x00dev, unsigned int i)
 {
 	u32 reg;
 
-	rt2800_register_read(rt2x00dev, EFUSE_CTRL, &reg);
+	mutex_lock(&rt2x00dev->csr_mutex);
+
+	rt2800_register_read_lock(rt2x00dev, EFUSE_CTRL, &reg);
 	rt2x00_set_field32(&reg, EFUSE_CTRL_ADDRESS_IN, i);
 	rt2x00_set_field32(&reg, EFUSE_CTRL_MODE, 0);
 	rt2x00_set_field32(&reg, EFUSE_CTRL_KICK, 1);
-	rt2800_register_write(rt2x00dev, EFUSE_CTRL, reg);
+	rt2800_register_write_lock(rt2x00dev, EFUSE_CTRL, reg);
 
 	/* Wait until the EEPROM has been loaded */
 	rt2800_regbusy_read(rt2x00dev, EFUSE_CTRL, EFUSE_CTRL_KICK, &reg);
 
 	/* Apparently the data is read from end to start */
-	rt2800_register_read(rt2x00dev, EFUSE_DATA3,
-				(u32 *)&rt2x00dev->eeprom[i]);
-	rt2800_register_read(rt2x00dev, EFUSE_DATA2,
-				(u32 *)&rt2x00dev->eeprom[i + 2]);
-	rt2800_register_read(rt2x00dev, EFUSE_DATA1,
-				(u32 *)&rt2x00dev->eeprom[i + 4]);
-	rt2800_register_read(rt2x00dev, EFUSE_DATA0,
-				(u32 *)&rt2x00dev->eeprom[i + 6]);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA3,
+					(u32 *)&rt2x00dev->eeprom[i]);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA2,
+					(u32 *)&rt2x00dev->eeprom[i + 2]);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA1,
+					(u32 *)&rt2x00dev->eeprom[i + 4]);
+	rt2800_register_read_lock(rt2x00dev, EFUSE_DATA0,
+					(u32 *)&rt2x00dev->eeprom[i + 6]);
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
 void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 7c79011..535ce22 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -23,6 +23,8 @@
 struct rt2800_ops {
 	void (*register_read)(struct rt2x00_dev *rt2x00dev,
 			      const unsigned int offset, u32 *value);
+	void (*register_read_lock)(struct rt2x00_dev *rt2x00dev,
+				   const unsigned int offset, u32 *value);
 	void (*register_write)(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int offset, u32 value);
 	void (*register_write_lock)(struct rt2x00_dev *rt2x00dev,
@@ -49,6 +51,15 @@ static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
 	rt2800ops->register_read(rt2x00dev, offset, value);
 }
 
+static inline void rt2800_register_read_lock(struct rt2x00_dev *rt2x00dev,
+					     const unsigned int offset,
+					     u32 *value)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_read_lock(rt2x00dev, offset, value);
+}
+
 static inline void rt2800_register_write(struct rt2x00_dev *rt2x00dev,
 					 const unsigned int offset,
 					 u32 value)
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 46750f6..bb65ffa 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1058,6 +1058,7 @@ static int rt2800pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 
 static const struct rt2800_ops rt2800pci_rt2800_ops = {
 	.register_read		= rt2x00pci_register_read,
+	.register_read_lock	= rt2x00pci_register_read, /* same for PCI */
 	.register_write		= rt2x00pci_register_write,
 	.register_write_lock	= rt2x00pci_register_write, /* same for PCI */
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index b57999b..b1d6393 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -682,6 +682,7 @@ static int rt2800usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 
 static const struct rt2800_ops rt2800usb_rt2800_ops = {
 	.register_read		= rt2x00usb_register_read,
+	.register_read_lock	= rt2x00usb_register_read_lock,
 	.register_write		= rt2x00usb_register_write,
 	.register_write_lock	= rt2x00usb_register_write_lock,
 
-- 
1.6.5.2

