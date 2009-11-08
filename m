Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:57079 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbZKHTZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 14:25:47 -0500
Received: by ewy3 with SMTP id 3so2540013ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 11:25:52 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 8/9] rt2800: add eFuse EEPROM support code to rt2800lib
Date: Sun, 8 Nov 2009 20:25:48 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <200911081940.27534.IvDoorn@gmail.com> <200911081947.53754.bzolnier@gmail.com>
In-Reply-To: <200911081947.53754.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911082025.48707.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > > The purpose of the defines was to keep the EFUSE code out of the driver
> > > > on embedded systems. So either rt2800lib should do the same with ifdefs
> > > > in the rt2800lib.c and rt2800lib.h files, or we don't need the efuse specific
> > > > wrappers in rt2800pci.c.
> > > 
> > > Said wrappers predate all of my rt2800 patches.
> > 
> > Actually the code inside the function was larger, since you removed multiple
> > lines from the function (moved to rt2800lib). But as said above, the wrapper
> > had the code inside the ifdef, while the this patch has the code outside the
> > ifdef, and thus the wrapper has no need.
> > 
> > > I think that they shouldn't have been added in the first place and I'll be
> > > happy to add patch removing them to rt2800 tree (since code savings seem to
> > > be really marginal and not worth the maintenance cost). 
> > 
> > Removing the ifdefs entirely would be fine.
> 
> Like I said before -- this would mean driver's behavior change.  Even though
> WISOC code is currently dead (RALINK_RT288X and RALINK_RT305X are never set)
> I prefer to not "overload" patches with logically different changes.

The code is not really dead. RALINK_RT288X and RALINK_RT305X are platforms which
are currently present in another tree, it is not the job for rt2x00 to set those defines.
I don't know when these platforms will be merged upstream, nor do I know the status of them.

> If you feel strongly about it please fix it in rt2x00 code and rt2800 tree
> will deal with it, or alternatively please send me an incremental patch.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 6f151d0..b33204d 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -80,20 +80,13 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 }
 
-#ifdef CONFIG_RT2800PCI_WISOC
 static void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
 {
 	u32 *base_addr = (u32 *) KSEG1ADDR(0x1F040000); /* XXX for RT3052 */
 
 	memcpy_fromio(rt2x00dev->eeprom, base_addr, EEPROM_SIZE);
 }
-#else
-static inline void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
-{
-}
-#endif /* CONFIG_RT2800PCI_WISOC */
 
-#ifdef CONFIG_RT2800PCI_PCI
 static void rt2800pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
 {
 	struct rt2x00_dev *rt2x00dev = eeprom->data;
@@ -145,30 +138,6 @@ static void rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
 			       EEPROM_SIZE / sizeof(u16));
 }
 
-static int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
-{
-	return rt2800_efuse_detect(rt2x00dev);
-}
-
-static inline void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
-{
-	rt2800_read_eeprom_efuse(rt2x00dev);
-}
-#else
-static inline void rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
-{
-}
-
-static inline int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
-{
-	return 0;
-}
-
-static inline void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
-{
-}
-#endif /* CONFIG_RT2800PCI_PCI */
-
 /*
  * Firmware functions
  */
@@ -1070,8 +1039,8 @@ static int rt2800pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2800pci_read_eeprom_soc(rt2x00dev);
 		break;
 	default:
-		if (rt2800pci_efuse_detect(rt2x00dev))
-			rt2800pci_read_eeprom_efuse(rt2x00dev);
+		if (rt2800_efuse_detect(rt2x00dev))
+			rt2800_read_eeprom_efuse(rt2x00dev);
 		else
 			rt2800pci_read_eeprom_pci(rt2x00dev);
 		break;
