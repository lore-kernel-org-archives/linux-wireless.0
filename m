Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:22541 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab2LKKKh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 05:10:37 -0500
Date: Tue, 11 Dec 2012 12:03:53 +0200
From: Daniel Golle <dgolle@allnet.de>
To: <linux-wireless@vger.kernel.org>
CC: <users@rt2x00.serialmonkey.com>, <juhosg@openwrt.org>,
	<sgruszka@redhat.com>, <helmut.schaa@googlemail.com>,
	<gwingerde@gmail.com>, <john@phrozen.org>
Subject: [PATCH 1/3] rt2x00: allow overriding eeprom through platform_data
Message-ID: <20121211100350.GA7813@earthship.arig> (sfid-20121211_111040_673078_AAD15BD3)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Daniel Golle <dgolle@allnet.de>

 create mode 100644 drivers/net/wireless/rt2x00/rt2x00eeprom.c
 create mode 100644 include/linux/rt2x00_platform.h

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2=
x00/Kconfig
index c7548da..e3b9dab 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -60,6 +60,7 @@ config RT2800PCI
 	select RT2X00_LIB_PCI if PCI
 	select RT2X00_LIB_SOC if RALINK_RT288X || RALINK_RT305X
 	select RT2X00_LIB_FIRMWARE
+	select RT2X00_LIB_EEPROM
 	select RT2X00_LIB_CRYPTO
 	select CRC_CCITT
 	select EEPROM_93CX6
@@ -212,6 +213,9 @@ config RT2X00_LIB_FIRMWARE
 config RT2X00_LIB_CRYPTO
 	boolean
=20
+config RT2X00_LIB_EEPROM
+	boolean
+
 config RT2X00_LIB_LEDS
 	boolean
 	default y if (RT2X00_LIB=3Dy && LEDS_CLASS=3Dy) || (RT2X00_LIB=3Dm && LED=
S_CLASS!=3Dn)
diff --git a/drivers/net/wireless/rt2x00/Makefile b/drivers/net/wireless/rt=
2x00/Makefile
index 349d5b8..7ea55a4 100644
--- a/drivers/net/wireless/rt2x00/Makefile
+++ b/drivers/net/wireless/rt2x00/Makefile
@@ -7,6 +7,7 @@ rt2x00lib-$(CONFIG_RT2X00_LIB_DEBUGFS)	+=3D rt2x00debug.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_CRYPTO)	+=3D rt2x00crypto.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_FIRMWARE)	+=3D rt2x00firmware.o
 rt2x00lib-$(CONFIG_RT2X00_LIB_LEDS)	+=3D rt2x00leds.o
+rt2x00lib-$(CONFIG_RT2X00_LIB_EEPROM)	+=3D rt2x00eeprom.o
=20
 obj-$(CONFIG_RT2X00_LIB)		+=3D rt2x00lib.o
 obj-$(CONFIG_RT2X00_LIB_PCI)		+=3D rt2x00pci.o
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless=
/rt2x00/rt2800pci.c
index 9224d87..cad50cd 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -89,20 +89,10 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2=
x00dev, const u8 token)
 	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 }
=20
-#if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
-static void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
-{
-	void __iomem *base_addr =3D ioremap(0x1F040000, EEPROM_SIZE);
-
-	memcpy_fromio(rt2x00dev->eeprom, base_addr, EEPROM_SIZE);
-
-	iounmap(base_addr);
-}
-#else
-static inline void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
+static void rt2800pci_read_eeprom_file(struct rt2x00_dev *rt2x00dev)
 {
+	memcpy(rt2x00dev->eeprom, rt2x00dev->eeprom_file->data, EEPROM_SIZE);
 }
-#endif /* CONFIG_RALINK_RT288X || CONFIG_RALINK_RT305X */
=20
 #ifdef CONFIG_PCI
 static void rt2800pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
@@ -322,6 +312,20 @@ static int rt2800pci_write_firmware(struct rt2x00_dev =
*rt2x00dev,
 }
=20
 /*
+ * EEPROM file functions.
+ */
+static char *rt2800pci_get_eeprom_file_name(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2x00_platform_data *pdata;
+
+	pdata =3D rt2x00dev->dev->platform_data;
+	if (pdata)
+		return pdata->eeprom_file_name;
+
+	return NULL;
+}
+
+/*
  * Initialization functions.
  */
 static bool rt2800pci_get_entry_state(struct queue_entry *entry)
@@ -972,8 +976,9 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *d=
ev_instance)
  */
 static void rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
 {
-	if (rt2x00_is_soc(rt2x00dev))
-		rt2800pci_read_eeprom_soc(rt2x00dev);
+	if (rt2x00_is_soc(rt2x00dev) ||
+	    test_bit(REQUIRE_EEPROM_FILE, &rt2x00dev->cap_flags))
+		rt2800pci_read_eeprom_file(rt2x00dev);
 	else if (rt2800pci_efuse_detect(rt2x00dev))
 		rt2800pci_read_eeprom_efuse(rt2x00dev);
 	else
@@ -1033,6 +1038,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_op=
s =3D {
 	.get_firmware_name	=3D rt2800pci_get_firmware_name,
 	.check_firmware		=3D rt2800_check_firmware,
 	.load_firmware		=3D rt2800_load_firmware,
+	.get_eeprom_file_name   =3D rt2800pci_get_eeprom_file_name,
 	.initialize		=3D rt2x00pci_initialize,
 	.uninitialize		=3D rt2x00pci_uninitialize,
 	.get_entry_state	=3D rt2800pci_get_entry_state,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt=
2x00/rt2x00.h
index 0751b35..355cff5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -39,6 +39,7 @@
 #include <linux/input-polldev.h>
 #include <linux/kfifo.h>
 #include <linux/hrtimer.h>
+#include <linux/rt2x00_platform.h>
=20
 #include <net/mac80211.h>
=20
@@ -560,6 +561,7 @@ struct rt2x00lib_ops {
 			       const u8 *data, const size_t len);
 	int (*load_firmware) (struct rt2x00_dev *rt2x00dev,
 			      const u8 *data, const size_t len);
+	char *(*get_eeprom_file_name) (struct rt2x00_dev *rt2x00dev);
=20
 	/*
 	 * Device initialization/deinitialization handlers.
@@ -720,6 +722,7 @@ enum rt2x00_capability_flags {
 	REQUIRE_SW_SEQNO,
 	REQUIRE_HT_TX_DESC,
 	REQUIRE_PS_AUTOWAKE,
+	REQUIRE_EEPROM_FILE,
=20
 	/*
 	 * Capabilities
@@ -989,6 +992,11 @@ struct rt2x00_dev {
 	const struct firmware *fw;
=20
 	/*
+	 * EEPROM image.
+	 */
+	const struct firmware *eeprom_file;
+
+	/*
 	 * FIFO for storing tx status reports between isr and tasklet.
 	 */
 	DECLARE_KFIFO_PTR(txstatus_fifo, u32);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless=
/rt2x00/rt2x00dev.c
index 3248b42..d454488 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1207,6 +1207,10 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
=20
 	rt2x00dev->hw->wiphy->flags |=3D WIPHY_FLAG_IBSS_RSN;
=20
+	retval =3D rt2x00lib_load_eeprom_file(rt2x00dev);
+	if (retval)
+		goto exit;
+
 	/*
 	 * Initialize work.
 	 */
@@ -1331,6 +1335,11 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00d=
ev)
 	 */
 	if (rt2x00dev->drv_data)
 		kfree(rt2x00dev->drv_data);
+
+	/*
+	 * Free EEPROM image.
+	 */
+	rt2x00lib_free_eeprom_file(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
=20
diff --git a/drivers/net/wireless/rt2x00/rt2x00eeprom.c b/drivers/net/wirel=
ess/rt2x00/rt2x00eeprom.c
new file mode 100644
index 0000000..d80eff4
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/rt2x00eeprom.c
@@ -0,0 +1,98 @@
+/*
+	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
+	Copyright (C) 2004 - 2009 Gertjan van Wingerde <gwingerde@gmail.com>
+	<http://rt2x00.serialmonkey.com>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*
+	Module: rt2x00lib
+	Abstract: rt2x00 eeprom file loading routines.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "rt2x00.h"
+#include "rt2x00lib.h"
+
+static int rt2x00lib_request_eeprom_file(struct rt2x00_dev *rt2x00dev)
+{
+	const struct firmware *ee;
+	char *ee_name;
+	int retval;
+
+	ee_name =3D rt2x00dev->ops->lib->get_eeprom_file_name(rt2x00dev);
+	if (!ee_name) {
+		ERROR(rt2x00dev,
+		      "Invalid EEPROM filename.\n"
+		      "Please file bug report to %s.\n", DRV_PROJECT);
+		return -EINVAL;
+	}
+
+	INFO(rt2x00dev, "Loading EEPROM data from '%s'.\n", ee_name);
+
+	retval =3D request_firmware(&ee, ee_name, rt2x00dev->dev);
+	if (retval) {
+		ERROR(rt2x00dev, "Failed to request EEPROM.\n");
+		return retval;
+	}
+
+	if (!ee || !ee->size || !ee->data) {
+		ERROR(rt2x00dev, "Failed to read EEPROM file.\n");
+		retval =3D -ENOENT;
+		goto err_exit;
+	}
+
+	if (ee->size !=3D rt2x00dev->ops->eeprom_size) {
+		ERROR(rt2x00dev,
+		      "EEPROM file size is invalid, it should be %d bytes\n",
+		      rt2x00dev->ops->eeprom_size);
+		retval =3D -EINVAL;
+		goto err_release_ee;
+	}
+
+	rt2x00dev->eeprom_file =3D ee;
+	return 0;
+
+err_release_ee:
+	release_firmware(ee);
+err_exit:
+	return retval;
+}
+
+int rt2x00lib_load_eeprom_file(struct rt2x00_dev *rt2x00dev)
+{
+	int retval;
+
+	if (!test_bit(REQUIRE_EEPROM_FILE, &rt2x00dev->cap_flags))
+		return 0;
+
+	if (!rt2x00dev->eeprom_file) {
+		retval =3D rt2x00lib_request_eeprom_file(rt2x00dev);
+		if (retval)
+			return retval;
+	}
+
+	return 0;
+}
+
+void rt2x00lib_free_eeprom_file(struct rt2x00_dev *rt2x00dev)
+{
+	release_firmware(rt2x00dev->eeprom_file);
+	rt2x00dev->eeprom_file =3D NULL;
+}
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless=
/rt2x00/rt2x00lib.h
index a093598..fc9ad6f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -322,6 +322,22 @@ static inline void rt2x00lib_free_firmware(struct rt2x=
00_dev *rt2x00dev)
 #endif /* CONFIG_RT2X00_LIB_FIRMWARE */
=20
 /*
+ * EEPROM file handlers.
+ */
+#ifdef CONFIG_RT2X00_LIB_EEPROM
+int rt2x00lib_load_eeprom_file(struct rt2x00_dev *rt2x00dev);
+void rt2x00lib_free_eeprom_file(struct rt2x00_dev *rt2x00dev);
+#else
+static inline int rt2x00lib_load_eeprom_file(struct rt2x00_dev *rt2x00dev)
+{
+	return 0;
+}
+static inline void rt2x00lib_free_eeprom_file(struct rt2x00_dev *rt2x00dev)
+{
+}
+#endif /* CONFIG_RT2X00_LIB_EEPROM_FILE */
+
+/*
  * Debugfs handlers.
  */
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless=
/rt2x00/rt2x00pci.c
index a0c8cae..ceadf87 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -254,6 +254,7 @@ exit:
 int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
 {
 	struct ieee80211_hw *hw;
+	struct rt2x00_platform_data *pdata;
 	struct rt2x00_dev *rt2x00dev;
 	int retval;
 	u16 chip;
@@ -297,6 +298,12 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const str=
uct rt2x00_ops *ops)
 	rt2x00dev->irq =3D pci_dev->irq;
 	rt2x00dev->name =3D pci_name(pci_dev);
=20
+	/* if we get passed the name of a eeprom_file_name, then use this in
+	   favour of the eeprom */
+	pdata =3D rt2x00dev->dev->platform_data;
+	if (pdata && pdata->eeprom_file_name)
+		set_bit(REQUIRE_EEPROM_FILE, &rt2x00dev->cap_flags);
+
 	if (pci_is_pcie(pci_dev))
 		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);
 	else
diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.c b/drivers/net/wireless=
/rt2x00/rt2x00soc.c
index 2aa5c38..43dfc8f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00soc.c
+++ b/drivers/net/wireless/rt2x00/rt2x00soc.c
@@ -94,6 +94,7 @@ int rt2x00soc_probe(struct platform_device *pdev, const s=
truct rt2x00_ops *ops)
 	rt2x00dev->hw =3D hw;
 	rt2x00dev->irq =3D platform_get_irq(pdev, 0);
 	rt2x00dev->name =3D pdev->dev.driver->name;
+	set_bit(REQUIRE_EEPROM_FILE, &rt2x00dev->cap_flags);
=20
 	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_SOC);
=20
diff --git a/include/linux/rt2x00_platform.h b/include/linux/rt2x00_platfor=
m.h
new file mode 100644
index 0000000..80effa7
--- /dev/null
+++ b/include/linux/rt2x00_platform.h
@@ -0,0 +1,19 @@
+/*
+ * Platform data definition for the rt2x00 driver
+ *
+ * Copyright (C) 2011 Gabor Juhos <juhosg@openwrt.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ */
+
+#ifndef _RT2X00_PLATFORM_H
+#define _RT2X00_PLATFORM_H
+
+struct rt2x00_platform_data {
+	char *eeprom_file_name;
+};
+
+#endif /* _RT2X00_PLATFORM_H */
--=20
1.8.0.1


--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxwUGAAoJEDy9cKN/1Et01I8QALnk0t1yWpH8YQbCHgQSU2oE
lE/Z8MoPTYa2A52aC3Z3mMm5cEr+1U2+4lA1eiz7tM/LaUA9fCN23mTi2KQ/L+mZ
zcCkcUxuHOgOFjltfd8HcmxW3r06R5SxmlxycNmxjB3DGmnbxfXyBWMke/RlSyLb
jrVyEbem2Vo/wyFtWGlMAQd4W8CRphWe/ddxp39ekuc4S8AKWbkXLYmjRuhmHPfh
rFItONT+FrvYhyRJxFmI7uXvhG/0lOkDlpY+P5fmLETXxCD0qsz+i6E5kjAbrDu1
ffr1z9xjQhmtZ2Gp9/UIrYb+6ygfKg5CHLU0D1qJFRncqwQ6jv+tBe9dMV+qBAH3
iq4MbRhqzKukNGEwnuLazogrHKGNQlnR2nBom+uUALThGdCxOdC2S6n9m8X5NmgQ
BncHH3ygMTV0jfgErvFYEjDJi3lFy3mvQmU2V3ZK9CnUN0K6I5AE132XdYn3XQWI
iZQu59w/LmGv9r4aTLPx/PvnW5fuFxTC6Q3VM6taQa319uML6oxTso03J3kJROXK
rF2xaigbHMVe9dPYjD+Vt1eWQYMR/NIcgse0XITKooPj9t/kqYxxAhTKxzDuzuD5
D8n2AVhRujRWHk7wPO5jgM7PFvozuLZUOnAWHa7DkNYbYSkvScj77x1hTWQmv+Hp
FztrtQ+1JIKzYCl7sSHd
=miGO
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
