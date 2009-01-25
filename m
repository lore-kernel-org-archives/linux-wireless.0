Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from flock1.newmail.ru ([82.204.219.207]:59233 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750872AbZAYTzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 14:55:13 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [PATCH] orinoco: checkpatch cleanup
Date: Sun, 25 Jan 2009 22:54:26 +0300
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1442854.bUW4ViArWM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200901252254.32137.arvidjaar@mail.ru> (sfid-20090125_205535_658867_59D1A796)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1442854.bUW4ViArWM
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Subject: [PATCH] orinoco: checkpatch cleanup
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

=46ix errors and obvious warnings reported by checkpatch in all files
except orinoco.c. Orinoco.c is part of different patch series of Dave.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

This fixes all errors. Remaining warnings are:

  - one typedef struct. This needs separate patch.

  - one typedef enum. I am not convinced this needs changing

  - long lines where it is not obvious that fixing them improves
    anything.

 drivers/net/wireless/orinoco/airport.c        |   35 +++++----
 drivers/net/wireless/orinoco/hermes.c         |  102=20
++++++++++++++-----------
 drivers/net/wireless/orinoco/hermes.h         |   35 +++++----
 drivers/net/wireless/orinoco/orinoco.h        |   17 ++--
 drivers/net/wireless/orinoco/orinoco_cs.c     |   31 ++++----
 drivers/net/wireless/orinoco/orinoco_nortel.c |    7 +-
 drivers/net/wireless/orinoco/orinoco_pci.c    |    5 +
 drivers/net/wireless/orinoco/orinoco_pci.h    |   10 +-
 drivers/net/wireless/orinoco/orinoco_plx.c    |    3 -
 drivers/net/wireless/orinoco/orinoco_tmd.c    |    2=20
 drivers/net/wireless/orinoco/spectrum_cs.c    |   15 ++--
 11 files changed, 143 insertions(+), 119 deletions(-)


diff --git a/drivers/net/wireless/orinoco/airport.c=20
b/drivers/net/wireless/orinoco/airport.c
index 28f1cae..5582dca 100644
=2D-- a/drivers/net/wireless/orinoco/airport.c
+++ b/drivers/net/wireless/orinoco/airport.c
@@ -4,9 +4,9 @@
  * card.
  *
  * Copyright notice & release notes in file orinoco.c
=2D *=20
+ *
  * Note specific to airport stub:
=2D *=20
+ *
  *  0.05 : first version of the new split driver
  *  0.06 : fix possible hang on powerup, add sleep support
  */
@@ -60,7 +60,8 @@ airport_suspend(struct macio_dev *mdev, pm_message_t=20
state)
 	orinoco_unlock(priv, &flags);
=20
 	disable_irq(dev->irq);
=2D	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE, macio_get_of_node(mdev), 0,=
=20
0);
+	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE,
+			  macio_get_of_node(mdev), 0, 0);
=20
 	return 0;
 }
@@ -75,7 +76,8 @@ airport_resume(struct macio_dev *mdev)
=20
 	printk(KERN_DEBUG "%s: Airport waking up\n", dev->name);
=20
=2D	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE, macio_get_of_node(mdev), 0,=
=20
1);
+	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE,
+			  macio_get_of_node(mdev), 0, 1);
 	msleep(200);
=20
 	enable_irq(dev->irq);
@@ -93,7 +95,7 @@ airport_resume(struct macio_dev *mdev)
=20
 	priv->hw_unavailable--;
=20
=2D	if (priv->open && (! priv->hw_unavailable)) {
+	if (priv->open && (!priv->hw_unavailable)) {
 		err =3D __orinoco_up(dev);
 		if (err)
 			printk(KERN_ERR "%s: Error %d restarting card on PBOOK_WAKE\n",
@@ -127,7 +129,8 @@ airport_detach(struct macio_dev *mdev)
=20
 	macio_release_resource(mdev, 0);
=20
=2D	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE, macio_get_of_node(mdev), 0,=
=20
0);
+	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE,
+			  macio_get_of_node(mdev), 0, 0);
 	ssleep(1);
=20
 	macio_set_drvdata(mdev, NULL);
@@ -153,9 +156,11 @@ static int airport_hard_reset(struct orinoco_private=20
*priv)
 	 * off. */
 	disable_irq(dev->irq);
=20
=2D	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE, macio_get_of_node(card-
>mdev), 0, 0);
+	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE,
+			  macio_get_of_node(card->mdev), 0, 0);
 	ssleep(1);
=2D	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE, macio_get_of_node(card-
>mdev), 0, 1);
+	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE,
+			  macio_get_of_node(card->mdev), 0, 1);
 	ssleep(1);
=20
 	enable_irq(dev->irq);
@@ -182,7 +187,7 @@ airport_attach(struct macio_dev *mdev, const struct=20
of_device_id *match)
 	/* Allocate space for private device-specific data */
 	dev =3D alloc_orinocodev(sizeof(*card), &mdev->ofdev.dev,
 			       airport_hard_reset, NULL);
=2D	if (! dev) {
+	if (!dev) {
 		printk(KERN_ERR PFX "Cannot allocate network device\n");
 		return -ENODEV;
 	}
@@ -214,9 +219,10 @@ airport_attach(struct macio_dev *mdev, const struct=20
of_device_id *match)
 	}
=20
 	hermes_struct_init(hw, card->vaddr, HERMES_16BIT_REGSPACING);
=2D	=09
+
 	/* Power up card */
=2D	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE, macio_get_of_node(mdev), 0,=
=20
1);
+	pmac_call_feature(PMAC_FTR_AIRPORT_ENABLE,
+			  macio_get_of_node(mdev), 0, 1);
 	ssleep(1);
=20
 	/* Reset it before we get the interrupt */
@@ -248,7 +254,7 @@ MODULE_AUTHOR("Benjamin Herrenschmidt=20
<benh@kernel.crashing.org>");
 MODULE_DESCRIPTION("Driver for the Apple Airport wireless card.");
 MODULE_LICENSE("Dual MPL/GPL");
=20
=2Dstatic struct of_device_id airport_match[] =3D=20
+static struct of_device_id airport_match[] =3D
 {
 	{
 	.name 		=3D "radio",
@@ -256,10 +262,9 @@ static struct of_device_id airport_match[] =3D
 	{},
 };
=20
=2DMODULE_DEVICE_TABLE (of, airport_match);
+MODULE_DEVICE_TABLE(of, airport_match);
=20
=2Dstatic struct macio_driver airport_driver =3D=20
=2D{
+static struct macio_driver airport_driver =3D {
 	.name 		=3D DRIVER_NAME,
 	.match_table	=3D airport_match,
 	.probe		=3D airport_attach,
diff --git a/drivers/net/wireless/orinoco/hermes.c=20
b/drivers/net/wireless/orinoco/hermes.c
index bfa3753..f48358f 100644
=2D-- a/drivers/net/wireless/orinoco/hermes.c
+++ b/drivers/net/wireless/orinoco/hermes.c
@@ -15,7 +15,7 @@
  *
  * Copyright (C) 2000, David Gibson, Linuxcare Australia.
  * (C) Copyright David Gibson, IBM Corp. 2001-2003.
=2D *=20
+ *
  * The contents of this file are subject to the Mozilla Public License
  * Version 1.1 (the "License"); you may not use this file except in
  * compliance with the License. You may obtain a copy of the License
@@ -45,7 +45,8 @@
=20
 #include "hermes.h"
=20
=2DMODULE_DESCRIPTION("Low-level driver helper for Lucent Hermes chipset an=
d=20
Prism II HFA384x wireless MAC controller");
+MODULE_DESCRIPTION("Low-level driver helper for Lucent Hermes chipset"
+		   " and Prism II HFA384x wireless MAC controller");
 MODULE_AUTHOR("Pavel Roskin <proski@gnu.org>"
 	" & David Gibson <hermes@gibson.dropbear.id.au>");
 MODULE_LICENSE("Dual MPL/GPL");
@@ -61,13 +62,13 @@ MODULE_LICENSE("Dual MPL/GPL");
  */
=20
 #define DMSG(stuff...) do {printk(KERN_DEBUG "hermes @ %p: " , hw->iobase)=
;=20
\
=2D			printk(stuff);} while (0)
+			printk(stuff); } while (0)
=20
 #undef HERMES_DEBUG
 #ifdef HERMES_DEBUG
 #include <stdarg.h>
=20
=2D#define DEBUG(lvl, stuff...) if ( (lvl) <=3D HERMES_DEBUG) DMSG(stuff)
+#define DEBUG(lvl, stuff...) if ((lvl) <=3D HERMES_DEBUG) DMSG(stuff)
=20
 #else /* ! HERMES_DEBUG */
=20
@@ -95,20 +96,19 @@ static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16=
=20
param0,
=20
 	/* First wait for the command register to unbusy */
 	reg =3D hermes_read_regn(hw, CMD);
=2D	while ( (reg & HERMES_CMD_BUSY) && k ) {
+	while ((reg & HERMES_CMD_BUSY) && k) {
 		k--;
 		udelay(1);
 		reg =3D hermes_read_regn(hw, CMD);
 	}
=2D	if (reg & HERMES_CMD_BUSY) {
+	if (reg & HERMES_CMD_BUSY)
 		return -EBUSY;
=2D	}
=20
 	hermes_write_regn(hw, PARAM2, param2);
 	hermes_write_regn(hw, PARAM1, param1);
 	hermes_write_regn(hw, PARAM0, param0);
 	hermes_write_regn(hw, CMD, cmd);
=2D=09
+
 	return 0;
 }
=20
@@ -191,23 +191,23 @@ int hermes_init(hermes_t *hw)
 	hermes_write_regn(hw, EVACK, 0xffff);
=20
 	/* Normally it's a "can't happen" for the command register to
=2D           be busy when we go to issue a command because we are
=2D           serializing all commands.  However we want to have some
=2D           chance of resetting the card even if it gets into a stupid
=2D           state, so we actually wait to see if the command register
=2D           will unbusy itself here. */
+	   be busy when we go to issue a command because we are
+	   serializing all commands.  However we want to have some
+	   chance of resetting the card even if it gets into a stupid
+	   state, so we actually wait to see if the command register
+	   will unbusy itself here. */
 	k =3D CMD_BUSY_TIMEOUT;
 	reg =3D hermes_read_regn(hw, CMD);
 	while (k && (reg & HERMES_CMD_BUSY)) {
=2D		if (reg =3D=3D 0xffff) /* Special case - the card has probably been=20
removed,
=2D				      so don't wait for the timeout */
+		if (reg =3D=3D 0xffff) /* Special case - the card has probably been
+				      removed, so don't wait for the timeout */
 			return -ENODEV;
=20
 		k--;
 		udelay(1);
 		reg =3D hermes_read_regn(hw, CMD);
 	}
=2D=09
+
 	/* No need to explicitly handle the timeout - if we've timed
 	   out hermes_issue_cmd() will probably return -EBUSY below */
=20
@@ -228,7 +228,10 @@ EXPORT_SYMBOL(hermes_init);
 /* Issue a command to the chip, and (busy!) wait for it to
  * complete.
  *
=2D * Returns: < 0 on internal error, 0 on success, > 0 on error returned b=
y=20
the firmware
+ * Returns:
+ *     < 0 on internal error
+ *       0 on success
+ *     > 0 on error returned by the firmware
  *
  * Callable from any context, but locking is your problem. */
 int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
@@ -241,13 +244,13 @@ int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16=20
parm0,
=20
 	err =3D hermes_issue_cmd(hw, cmd, parm0, 0, 0);
 	if (err) {
=2D		if (! hermes_present(hw)) {
+		if (!hermes_present(hw)) {
 			if (net_ratelimit())
 				printk(KERN_WARNING "hermes @ %p: "
 				       "Card removed while issuing command "
 				       "0x%04x.\n", hw->iobase, cmd);
 			err =3D -ENODEV;
=2D		} else=20
+		} else
 			if (net_ratelimit())
 				printk(KERN_ERR "hermes @ %p: "
 				       "Error %d issuing command 0x%04x.\n",
@@ -257,21 +260,21 @@ int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16=20
parm0,
=20
 	reg =3D hermes_read_regn(hw, EVSTAT);
 	k =3D CMD_COMPL_TIMEOUT;
=2D	while ( (! (reg & HERMES_EV_CMD)) && k) {
+	while ((!(reg & HERMES_EV_CMD)) && k) {
 		k--;
 		udelay(10);
 		reg =3D hermes_read_regn(hw, EVSTAT);
 	}
=20
=2D	if (! hermes_present(hw)) {
+	if (!hermes_present(hw)) {
 		printk(KERN_WARNING "hermes @ %p: Card removed "
 		       "while waiting for command 0x%04x completion.\n",
 		       hw->iobase, cmd);
 		err =3D -ENODEV;
 		goto out;
 	}
=2D	=09
=2D	if (! (reg & HERMES_EV_CMD)) {
+
+	if (!(reg & HERMES_EV_CMD)) {
 		printk(KERN_ERR "hermes @ %p: Timeout waiting for "
 		       "command 0x%04x completion.\n", hw->iobase, cmd);
 		err =3D -ETIMEDOUT;
@@ -301,31 +304,30 @@ int hermes_allocate(hermes_t *hw, u16 size, u16 *fid)
 	int err =3D 0;
 	int k;
 	u16 reg;
=2D=09
=2D	if ( (size < HERMES_ALLOC_LEN_MIN) || (size > HERMES_ALLOC_LEN_MAX) )
+
+	if ((size < HERMES_ALLOC_LEN_MIN) || (size > HERMES_ALLOC_LEN_MAX))
 		return -EINVAL;
=20
 	err =3D hermes_docmd_wait(hw, HERMES_CMD_ALLOC, size, NULL);
=2D	if (err) {
+	if (err)
 		return err;
=2D	}
=20
 	reg =3D hermes_read_regn(hw, EVSTAT);
 	k =3D ALLOC_COMPL_TIMEOUT;
=2D	while ( (! (reg & HERMES_EV_ALLOC)) && k) {
+	while ((!(reg & HERMES_EV_ALLOC)) && k) {
 		k--;
 		udelay(10);
 		reg =3D hermes_read_regn(hw, EVSTAT);
 	}
=2D=09
=2D	if (! hermes_present(hw)) {
+
+	if (!hermes_present(hw)) {
 		printk(KERN_WARNING "hermes @ %p: "
 		       "Card removed waiting for frame allocation.\n",
 		       hw->iobase);
 		return -ENODEV;
 	}
=2D	=09
=2D	if (! (reg & HERMES_EV_ALLOC)) {
+
+	if (!(reg & HERMES_EV_ALLOC)) {
 		printk(KERN_ERR "hermes @ %p: "
 		       "Timeout waiting for frame allocation\n",
 		       hw->iobase);
@@ -334,14 +336,17 @@ int hermes_allocate(hermes_t *hw, u16 size, u16 *fid)
=20
 	*fid =3D hermes_read_regn(hw, ALLOCFID);
 	hermes_write_regn(hw, EVACK, HERMES_EV_ALLOC);
=2D=09
+
 	return 0;
 }
 EXPORT_SYMBOL(hermes_allocate);
=20
 /* Set up a BAP to read a particular chunk of data from card's internal=20
buffer.
  *
=2D * Returns: < 0 on internal failure (errno), 0 on success, >0 on error
+ * Returns:
+ *     < 0 on internal failure (errno)
+ *       0 on success
+ *     > 0 on error
  * from firmware
  *
  * Callable from any context */
@@ -353,7 +358,7 @@ static int hermes_bap_seek(hermes_t *hw, int bap, u16=20
id, u16 offset)
 	u16 reg;
=20
 	/* Paranoia.. */
=2D	if ( (offset > HERMES_BAP_OFFSET_MAX) || (offset % 2) )
+	if ((offset > HERMES_BAP_OFFSET_MAX) || (offset % 2))
 		return -EINVAL;
=20
 	k =3D HERMES_BAP_BUSY_TIMEOUT;
@@ -374,7 +379,7 @@ static int hermes_bap_seek(hermes_t *hw, int bap, u16=20
id, u16 offset)
 	/* Wait for the BAP to be ready */
 	k =3D HERMES_BAP_BUSY_TIMEOUT;
 	reg =3D hermes_read_reg(hw, oreg);
=2D	while ( (reg & (HERMES_OFFSET_BUSY | HERMES_OFFSET_ERR)) && k) {
+	while ((reg & (HERMES_OFFSET_BUSY | HERMES_OFFSET_ERR)) && k) {
 		k--;
 		udelay(1);
 		reg =3D hermes_read_reg(hw, oreg);
@@ -386,9 +391,8 @@ static int hermes_bap_seek(hermes_t *hw, int bap, u16=20
id, u16 offset)
 		       (reg & HERMES_OFFSET_BUSY) ? "timeout" : "error",
 		       reg, id, offset);
=20
=2D		if (reg & HERMES_OFFSET_BUSY) {
+		if (reg & HERMES_OFFSET_BUSY)
 			return -ETIMEDOUT;
=2D		}
=20
 		return -EIO;		/* error or wrong offset */
 	}
@@ -400,7 +404,10 @@ static int hermes_bap_seek(hermes_t *hw, int bap, u16=
=20
id, u16 offset)
  * BAP. Synchronization/serialization is the caller's problem.  len
  * must be even.
  *
=2D * Returns: < 0 on internal failure (errno), 0 on success, > 0 on error=
=20
from firmware
+ * Returns:
+ *     < 0 on internal failure (errno)
+ *       0 on success
+ *     > 0 on error from firmware
  */
 int hermes_bap_pread(hermes_t *hw, int bap, void *buf, int len,
 		     u16 id, u16 offset)
@@ -408,7 +415,7 @@ int hermes_bap_pread(hermes_t *hw, int bap, void *buf,=
=20
int len,
 	int dreg =3D bap ? HERMES_DATA1 : HERMES_DATA0;
 	int err =3D 0;
=20
=2D	if ( (len < 0) || (len % 2) )
+	if ((len < 0) || (len % 2))
 		return -EINVAL;
=20
 	err =3D hermes_bap_seek(hw, bap, id, offset);
@@ -426,7 +433,10 @@ EXPORT_SYMBOL(hermes_bap_pread);
 /* Write a block of data to the chip's buffer, via the
  * BAP. Synchronization/serialization is the caller's problem.
  *
=2D * Returns: < 0 on internal failure (errno), 0 on success, > 0 on error=
=20
from firmware
+ * Returns:
+ *     < 0 on internal failure (errno)
+ *       0 on success
+ *     > 0 on error from firmware
  */
 int hermes_bap_pwrite(hermes_t *hw, int bap, const void *buf, int len,
 		      u16 id, u16 offset)
@@ -440,11 +450,11 @@ int hermes_bap_pwrite(hermes_t *hw, int bap, const=20
void *buf, int len,
 	err =3D hermes_bap_seek(hw, bap, id, offset);
 	if (err)
 		goto out;
=2D=09
+
 	/* Actually do the transfer */
 	hermes_write_bytes(hw, dreg, buf, len);
=20
=2D out:=09
+ out:
 	return err;
 }
 EXPORT_SYMBOL(hermes_bap_pwrite);
@@ -465,7 +475,7 @@ int hermes_read_ltv(hermes_t *hw, int bap, u16 rid,=20
unsigned bufsize,
 	u16 rlength, rtype;
 	unsigned nwords;
=20
=2D	if ( (bufsize < 0) || (bufsize % 2) )
+	if ((bufsize < 0) || (bufsize % 2))
 		return -EINVAL;
=20
 	err =3D hermes_docmd_wait(hw, HERMES_CMD_ACCESS, rid, NULL);
@@ -478,7 +488,7 @@ int hermes_read_ltv(hermes_t *hw, int bap, u16 rid,=20
unsigned bufsize,
=20
 	rlength =3D hermes_read_reg(hw, dreg);
=20
=2D	if (! rlength)
+	if (!rlength)
 		return -ENODATA;
=20
 	rtype =3D hermes_read_reg(hw, dreg);
@@ -503,7 +513,7 @@ int hermes_read_ltv(hermes_t *hw, int bap, u16 rid,=20
unsigned bufsize,
 }
 EXPORT_SYMBOL(hermes_read_ltv);
=20
=2Dint hermes_write_ltv(hermes_t *hw, int bap, u16 rid,=20
+int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
 		     u16 length, const void *value)
 {
 	int dreg =3D bap ? HERMES_DATA1 : HERMES_DATA0;
diff --git a/drivers/net/wireless/orinoco/hermes.h=20
b/drivers/net/wireless/orinoco/hermes.h
index 8b13c8f..c78c442 100644
=2D-- a/drivers/net/wireless/orinoco/hermes.h
+++ b/drivers/net/wireless/orinoco/hermes.h
@@ -15,7 +15,8 @@
  * Copyright (C) 2000, David Gibson, Linuxcare Australia.
  * (C) Copyright David Gibson, IBM Corp. 2001-2003.
  *
=2D * Portions taken from hfa384x.h, Copyright (C) 1999 AbsoluteValue Syste=
ms,=20
Inc. All Rights Reserved.
+ * Portions taken from hfa384x.h.
+ * Copyright (C) 1999 AbsoluteValue Systems, Inc. All Rights Reserved.
  *
  * This file distributed under the GPL, version 2.
  */
@@ -31,7 +32,7 @@
 */
=20
 #include <linux/if_ether.h>
=2D#include <asm/io.h>
+#include <linux/io.h>
=20
 /*
  * Limits and constants
@@ -203,7 +204,7 @@ struct hermes_tx_descriptor {
 	__le32 sw_support;
 	u8 retry_count;
 	u8 tx_rate;
=2D	__le16 tx_control;=09
+	__le16 tx_control;
 } __attribute__ ((packed));
=20
 #define HERMES_TXSTAT_RETRYERR		(0x0001)
@@ -298,7 +299,7 @@ struct symbol_scan_apinfo {
 	/* bits: 0-ess, 1-ibss, 4-privacy [wep] */
 	__le16 essid_len;	/* ESSID length */
 	u8 essid[32];		/* ESSID of the network */
=2D    	__le16 rates[5];	/* Bit rate supported */
+	__le16 rates[5];	/* Bit rate supported */
 	__le16 basic_rates;	/* Basic rates bitmask */
 	u8 unknown2[6];		/* Always FF:FF:FF:FF:00:00 */
 	u8 unknown3[8];		/* Always 0, appeared in f/w 3.91-68 */
@@ -344,14 +345,14 @@ struct agere_ext_scan_info {
 	u8	data[316];
 } __attribute__ ((packed));
=20
=2D#define HERMES_LINKSTATUS_NOT_CONNECTED   (0x0000) =20
+#define HERMES_LINKSTATUS_NOT_CONNECTED   (0x0000)
 #define HERMES_LINKSTATUS_CONNECTED       (0x0001)
 #define HERMES_LINKSTATUS_DISCONNECTED    (0x0002)
 #define HERMES_LINKSTATUS_AP_CHANGE       (0x0003)
 #define HERMES_LINKSTATUS_AP_OUT_OF_RANGE (0x0004)
 #define HERMES_LINKSTATUS_AP_IN_RANGE     (0x0005)
 #define HERMES_LINKSTATUS_ASSOC_FAILED    (0x0006)
=2D =20
+
 struct hermes_linkstatus {
 	__le16 linkstatus;         /* Link status */
 } __attribute__ ((packed));
@@ -384,11 +385,12 @@ typedef struct hermes {
=20
 /* Register access convenience macros */
 #define hermes_read_reg(hw, off) \
=2D	(ioread16((hw)->iobase + ( (off) << (hw)->reg_spacing )))
+	(ioread16((hw)->iobase + ((off) << (hw)->reg_spacing)))
 #define hermes_write_reg(hw, off, val) \
 	(iowrite16((val), (hw)->iobase + ((off) << (hw)->reg_spacing)))
 #define hermes_read_regn(hw, name) hermes_read_reg((hw), HERMES_##name)
=2D#define hermes_write_regn(hw, name, val) hermes_write_reg((hw),=20
HERMES_##name, (val))
+#define hermes_write_regn(hw, name, val) \
+	hermes_write_reg((hw), HERMES_##name, (val))
=20
 /* Function prototypes */
 void hermes_struct_init(hermes_t *hw, void __iomem *address, int=20
reg_spacing);
@@ -430,7 +432,7 @@ static inline int hermes_enable_port(hermes_t *hw, int=
=20
port)
=20
 static inline int hermes_disable_port(hermes_t *hw, int port)
 {
=2D	return hermes_docmd_wait(hw, HERMES_CMD_DISABLE | (port << 8),=20
+	return hermes_docmd_wait(hw, HERMES_CMD_DISABLE | (port << 8),
 				 0, NULL);
 }
=20
@@ -441,11 +443,12 @@ static inline int hermes_inquire(hermes_t *hw, u16=20
rid)
 	return hermes_docmd_wait(hw, HERMES_CMD_INQUIRE, rid, NULL);
 }
=20
=2D#define HERMES_BYTES_TO_RECLEN(n) ( (((n)+1)/2) + 1 )
=2D#define HERMES_RECLEN_TO_BYTES(n) ( ((n)-1) * 2 )
+#define HERMES_BYTES_TO_RECLEN(n) ((((n)+1)/2) + 1)
+#define HERMES_RECLEN_TO_BYTES(n) (((n)-1) * 2)
=20
 /* Note that for the next two, the count is in 16-bit words, not bytes */
=2Dstatic inline void hermes_read_words(struct hermes *hw, int off, void *b=
uf,=20
unsigned count)
+static inline void hermes_read_words(struct hermes *hw, int off,
+				     void *buf, unsigned count)
 {
 	off =3D off << hw->reg_spacing;
 	ioread16_rep(hw->iobase + off, buf, count);
@@ -460,7 +463,8 @@ static inline void hermes_write_bytes(struct hermes *hw=
,=20
int off,
 		iowrite8(buf[count - 1], hw->iobase + off);
 }
=20
=2Dstatic inline void hermes_clear_words(struct hermes *hw, int off, unsign=
ed=20
count)
+static inline void hermes_clear_words(struct hermes *hw, int off,
+				      unsigned count)
 {
 	unsigned i;
=20
@@ -471,9 +475,10 @@ static inline void hermes_clear_words(struct hermes=20
*hw, int off, unsigned count
 }
=20
 #define HERMES_READ_RECORD(hw, bap, rid, buf) \
=2D	(hermes_read_ltv((hw),(bap),(rid), sizeof(*buf), NULL, (buf)))
+	(hermes_read_ltv((hw), (bap), (rid), sizeof(*buf), NULL, (buf)))
 #define HERMES_WRITE_RECORD(hw, bap, rid, buf) \
=2D	(hermes_write_ltv((hw),(bap),(rid),HERMES_BYTES_TO_RECLEN(sizeof(*buf)),
(buf)))
+	(hermes_write_ltv((hw), (bap), (rid), \
+			  HERMES_BYTES_TO_RECLEN(sizeof(*buf)), (buf)))
=20
 static inline int hermes_read_wordrec(hermes_t *hw, int bap, u16 rid, u16=
=20
*word)
 {
diff --git a/drivers/net/wireless/orinoco/orinoco.h=20
b/drivers/net/wireless/orinoco/orinoco.h
index 00750c8..096f004 100644
=2D-- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -1,5 +1,5 @@
 /* orinoco.h
=2D *=20
+ *
  * Common definitions to all pieces of the various orinoco
  * drivers
  */
@@ -18,9 +18,9 @@
 #include "hermes.h"
=20
 /* To enable debug messages */
=2D//#define ORINOCO_DEBUG		3
+/*#define ORINOCO_DEBUG		3*/
=20
=2D#define WIRELESS_SPY		// enable iwspy support
+#define WIRELESS_SPY		/* enable iwspy support */
=20
 #define MAX_SCAN_LEN		4096
=20
@@ -130,7 +130,7 @@ struct orinoco_private {
 	u16 encode_alg, wep_restrict, tx_key;
 	struct orinoco_key keys[ORINOCO_MAX_KEYS];
 	int bitratemode;
=2D 	char nick[IW_ESSID_MAX_SIZE+1];
+	char nick[IW_ESSID_MAX_SIZE+1];
 	char desired_essid[IW_ESSID_MAX_SIZE+1];
 	char desired_bssid[ETH_ALEN];
 	int bssid_fixed;
@@ -140,7 +140,7 @@ struct orinoco_private {
 	u16 pm_on, pm_mcast, pm_period, pm_timeout;
 	u16 preamble;
 #ifdef WIRELESS_SPY
=2D 	struct iw_spy_data spy_data; /* iwspy support */
+	struct iw_spy_data spy_data; /* iwspy support */
 	struct iw_public_data	wireless_data;
 #endif
=20
@@ -177,7 +177,10 @@ struct orinoco_private {
=20
 #ifdef ORINOCO_DEBUG
 extern int orinoco_debug;
=2D#define DEBUG(n, args...) do { if (orinoco_debug>(n)) printk(KERN_DEBUG=
=20
args); } while(0)
+#define DEBUG(n, args...) do { \
+	if (orinoco_debug > (n)) \
+		printk(KERN_DEBUG args); \
+} while (0)
 #else
 #define DEBUG(n, args...) do { } while (0)
 #endif	/* ORINOCO_DEBUG */
@@ -194,7 +197,7 @@ extern void free_orinocodev(struct net_device *dev);
 extern int __orinoco_up(struct net_device *dev);
 extern int __orinoco_down(struct net_device *dev);
 extern int orinoco_reinit_firmware(struct net_device *dev);
=2Dextern irqreturn_t orinoco_interrupt(int irq, void * dev_id);
+extern irqreturn_t orinoco_interrupt(int irq, void *dev_id);
=20
 /********************************************************************/
 /* Locking and synchronization functions                            */
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c=20
b/drivers/net/wireless/orinoco/orinoco_cs.c
index 0b32215..d194b3e 100644
=2D-- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -6,7 +6,7 @@
  * It should also be usable on various Prism II based cards such as the
  * Linksys, D-Link and Farallon Skyline. It should also work on Symbol
  * cards such as the 3Com AirConnect and Ericsson WLAN.
=2D *=20
+ *
  * Copyright notice & release notes in file orinoco.c
  */
=20
@@ -30,7 +30,8 @@
 /********************************************************************/
=20
 MODULE_AUTHOR("David Gibson <hermes@gibson.dropbear.id.au>");
=2DMODULE_DESCRIPTION("Driver for PCMCIA Lucent Orinoco, Prism II based and=
=20
similar wireless cards");
+MODULE_DESCRIPTION("Driver for PCMCIA Lucent Orinoco,"
+		   " Prism II based and similar wireless cards");
 MODULE_LICENSE("Dual MPL/GPL");
=20
 /* Module parameters */
@@ -53,8 +54,8 @@ struct orinoco_pccard {
=20
 	/* Used to handle hard reset */
 	/* yuck, we need this hack to work around the insanity of the
=2D         * PCMCIA layer */
=2D	unsigned long hard_reset_in_progress;=20
+	 * PCMCIA layer */
+	unsigned long hard_reset_in_progress;
 };
=20
=20
@@ -98,7 +99,7 @@ orinoco_cs_hard_reset(struct orinoco_private *priv)
  * This creates an "instance" of the driver, allocating local data
  * structures for one device.  The device is registered with Card
  * Services.
=2D *=20
+ *
  * The dev_link structure is initialized, but we don't actually
  * configure the card at this point -- we wait until we receive a card
  * insertion event.  */
@@ -111,7 +112,7 @@ orinoco_cs_probe(struct pcmcia_device *link)
=20
 	dev =3D alloc_orinocodev(sizeof(*card), &handle_to_dev(link),
 			       orinoco_cs_hard_reset, NULL);
=2D	if (! dev)
+	if (!dev)
 		return -ENOMEM;
 	priv =3D netdev_priv(dev);
 	card =3D priv->card;
@@ -124,7 +125,7 @@ orinoco_cs_probe(struct pcmcia_device *link)
 	link->irq.Attributes =3D IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
 	link->irq.IRQInfo1 =3D IRQ_LEVEL_ID;
 	link->irq.Handler =3D orinoco_interrupt;
=2D	link->irq.Instance =3D dev;=20
+	link->irq.Instance =3D dev;
=20
 	/* General socket configuration defaults can go here.  In this
 	 * client, we assume very little, and rely on the CIS for
@@ -162,8 +163,10 @@ static void orinoco_cs_detach(struct pcmcia_device=20
*link)
  */
=20
 #define CS_CHECK(fn, ret) do { \
=2D		last_fn =3D (fn); if ((last_ret =3D (ret)) !=3D 0) goto cs_failed; \
=2D	} while (0)
+	last_fn =3D (fn); \
+	if ((last_ret =3D (ret)) !=3D 0) \
+		goto cs_failed; \
+} while (0)
=20
 static int orinoco_cs_config_check(struct pcmcia_device *p_dev,
 				   cistpl_cftable_entry_t *cfg,
@@ -307,8 +310,8 @@ orinoco_cs_config(struct pcmcia_device *link)
 	 * initialized and arranged in a linked list at link->dev_node. */
 	strcpy(card->node.dev_name, dev->name);
 	link->dev_node =3D &card->node; /* link->dev_node being non-NULL is also
=2D                                    used to indicate that the
=2D                                    net_device has been registered */
+				       * used to indicate that the
+				       * net_device has been registered */
=20
 	/* Finally, report what we've done */
 	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s, irq %d, io "
@@ -359,7 +362,7 @@ static int orinoco_cs_suspend(struct pcmcia_device=20
*link)
 	/* This is probably racy, but I can't think of
 	   a better way, short of rewriting the PCMCIA
 	   layer to not suck :-( */
=2D	if (! test_bit(0, &card->hard_reset_in_progress)) {
+	if (!test_bit(0, &card->hard_reset_in_progress)) {
 		spin_lock_irqsave(&priv->lock, flags);
=20
 		err =3D __orinoco_down(dev);
@@ -384,7 +387,7 @@ static int orinoco_cs_resume(struct pcmcia_device *link)
 	int err =3D 0;
 	unsigned long flags;
=20
=2D	if (! test_bit(0, &card->hard_reset_in_progress)) {
+	if (!test_bit(0, &card->hard_reset_in_progress)) {
 		err =3D orinoco_reinit_firmware(dev);
 		if (err) {
 			printk(KERN_ERR "%s: Error %d re-initializing firmware\n",
@@ -397,7 +400,7 @@ static int orinoco_cs_resume(struct pcmcia_device *link)
 		netif_device_attach(dev);
 		priv->hw_unavailable--;
=20
=2D		if (priv->open && ! priv->hw_unavailable) {
+		if (priv->open && !priv->hw_unavailable) {
 			err =3D __orinoco_up(dev);
 			if (err)
 				printk(KERN_ERR "%s: Error %d restarting card\n",
diff --git a/drivers/net/wireless/orinoco/orinoco_nortel.c=20
b/drivers/net/wireless/orinoco/orinoco_nortel.c
index 2fc8659..b017262 100644
=2D-- a/drivers/net/wireless/orinoco/orinoco_nortel.c
+++ b/drivers/net/wireless/orinoco/orinoco_nortel.c
@@ -9,12 +9,12 @@
  *
  * Some of this code is borrowed from orinoco_plx.c
  *	Copyright (C) 2001 Daniel Barlow
=2D * Some of this code is borrowed from orinoco_pci.c=20
+ * Some of this code is borrowed from orinoco_pci.c
  *  Copyright (C) 2001 Jean Tourrilhes
  * Some of this code is "inspired" by linux-wlan-ng-0.1.10, but nothing
  * has been copied from it. linux-wlan-ng-0.1.10 is originally :
  *	Copyright (C) 1999 AbsoluteValue Systems, Inc.  All Rights Reserved.
=2D *=20
+ *
  * The contents of this file are subject to the Mozilla Public License
  * Version 1.1 (the "License"); you may not use this file except in
  * compliance with the License. You may obtain a copy of the License
@@ -103,9 +103,8 @@ static int orinoco_nortel_hw_init(struct=20
orinoco_pci_card *card)
 	iowrite16(0x8, card->bridge_io + 2);
 	for (i =3D 0; i < 30; i++) {
 		mdelay(30);
=2D		if (ioread16(card->bridge_io) & 0x10) {
+		if (ioread16(card->bridge_io) & 0x10)
 			break;
=2D		}
 	}
 	if (i =3D=3D 30) {
 		printk(KERN_ERR PFX "brg1 timed out\n");
diff --git a/drivers/net/wireless/orinoco/orinoco_pci.c=20
b/drivers/net/wireless/orinoco/orinoco_pci.c
index 4ebd638..78cafff 100644
=2D-- a/drivers/net/wireless/orinoco/orinoco_pci.c
+++ b/drivers/net/wireless/orinoco/orinoco_pci.c
@@ -1,5 +1,5 @@
 /* orinoco_pci.c
=2D *=20
+ *
  * Driver for Prism 2.5/3 devices that have a direct PCI interface
  * (i.e. these are not PCMCIA cards in a PCMCIA-to-PCI bridge).
  * The card contains only one PCI region, which contains all the usual
@@ -237,7 +237,8 @@ static char version[] __initdata =3D DRIVER_NAME " "=20
DRIVER_VERSION
 	" (Pavel Roskin <proski@gnu.org>,"
 	" David Gibson <hermes@gibson.dropbear.id.au> &"
 	" Jean Tourrilhes <jt@hpl.hp.com>)";
=2DMODULE_AUTHOR("Pavel Roskin <proski@gnu.org> & David Gibson=20
<hermes@gibson.dropbear.id.au>");
+MODULE_AUTHOR("Pavel Roskin <proski@gnu.org> &"
+	      " David Gibson <hermes@gibson.dropbear.id.au>");
 MODULE_DESCRIPTION("Driver for wireless LAN cards using direct PCI=20
interface");
 MODULE_LICENSE("Dual MPL/GPL");
=20
diff --git a/drivers/net/wireless/orinoco/orinoco_pci.h=20
b/drivers/net/wireless/orinoco/orinoco_pci.h
index f4e5e06..88df3ee 100644
=2D-- a/drivers/net/wireless/orinoco/orinoco_pci.h
+++ b/drivers/net/wireless/orinoco/orinoco_pci.h
@@ -1,5 +1,5 @@
 /* orinoco_pci.h
=2D *=20
+ *
  * Common code for all Orinoco drivers for PCI devices, including
  * both native PCI and PCMCIA-to-PCI bridges.
  *
@@ -37,11 +37,11 @@ static int orinoco_pci_suspend(struct pci_dev *pdev,=20
pm_message_t state)
 	if (err)
 		printk(KERN_WARNING "%s: error %d bringing interface down "
 		       "for suspend\n", dev->name, err);
=2D=09
+
 	netif_device_detach(dev);
=20
 	priv->hw_unavailable++;
=2D=09
+
 	orinoco_unlock(priv, &flags);
=20
 	free_irq(pdev->irq, dev);
@@ -90,13 +90,13 @@ static int orinoco_pci_resume(struct pci_dev *pdev)
=20
 	priv->hw_unavailable--;
=20
=2D	if (priv->open && (! priv->hw_unavailable)) {
+	if (priv->open && (!priv->hw_unavailable)) {
 		err =3D __orinoco_up(dev);
 		if (err)
 			printk(KERN_ERR "%s: Error %d restarting card on resume\n",
 			       dev->name, err);
 	}
=2D=09
+
 	spin_unlock_irqrestore(&priv->lock, flags);
=20
 	return 0;
diff --git a/drivers/net/wireless/orinoco/orinoco_plx.c=20
b/drivers/net/wireless/orinoco/orinoco_plx.c
index ef76185..a2a4471 100644
=2D-- a/drivers/net/wireless/orinoco/orinoco_plx.c
+++ b/drivers/net/wireless/orinoco/orinoco_plx.c
@@ -146,9 +146,8 @@ static int orinoco_plx_hw_init(struct orinoco_pci_card=
=20
*card)
 	};
=20
 	printk(KERN_DEBUG PFX "CIS: ");
=2D	for (i =3D 0; i < 16; i++) {
+	for (i =3D 0; i < 16; i++)
 		printk("%02X:", ioread8(card->attr_io + (i << 1)));
=2D	}
 	printk("\n");
=20
 	/* Verify whether a supported PC card is present */
diff --git a/drivers/net/wireless/orinoco/orinoco_tmd.c=20
b/drivers/net/wireless/orinoco/orinoco_tmd.c
index ede24ec..e77c404 100644
=2D-- a/drivers/net/wireless/orinoco/orinoco_tmd.c
+++ b/drivers/net/wireless/orinoco/orinoco_tmd.c
@@ -1,7 +1,7 @@
 /* orinoco_tmd.c
  *
  * Driver for Prism II devices which would usually be driven by orinoco_cs,
=2D * but are connected to the PCI bus by a TMD7160.=20
+ * but are connected to the PCI bus by a TMD7160.
  *
  * Copyright (C) 2003 Joerg Dorchain <joerg AT dorchain.net>
  * based heavily upon orinoco_plx.c Copyright (C) 2001 Daniel Barlow
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c=20
b/drivers/net/wireless/orinoco/spectrum_cs.c
index b2ca2e3..9aefe19 100644
=2D-- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -133,7 +133,7 @@ spectrum_reset(struct pcmcia_device *link, int idle)
 	udelay(1000);
 	return 0;
=20
=2D      cs_failed:
+cs_failed:
 	cs_error(link, last_fn, last_ret);
 	return -ENODEV;
 }
@@ -171,7 +171,7 @@ spectrum_cs_stop_firmware(struct orinoco_private *priv,=
=20
int idle)
  * This creates an "instance" of the driver, allocating local data
  * structures for one device.  The device is registered with Card
  * Services.
=2D *=20
+ *
  * The dev_link structure is initialized, but we don't actually
  * configure the card at this point -- we wait until we receive a card
  * insertion event.  */
@@ -185,7 +185,7 @@ spectrum_cs_probe(struct pcmcia_device *link)
 	dev =3D alloc_orinocodev(sizeof(*card), &handle_to_dev(link),
 			       spectrum_cs_hard_reset,
 			       spectrum_cs_stop_firmware);
=2D	if (! dev)
+	if (!dev)
 		return -ENOMEM;
 	priv =3D netdev_priv(dev);
 	card =3D priv->card;
@@ -198,7 +198,7 @@ spectrum_cs_probe(struct pcmcia_device *link)
 	link->irq.Attributes =3D IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
 	link->irq.IRQInfo1 =3D IRQ_LEVEL_ID;
 	link->irq.Handler =3D orinoco_interrupt;
=2D	link->irq.Instance =3D dev;=20
+	link->irq.Instance =3D dev;
=20
 	/* General socket configuration defaults can go here.  In this
 	 * client, we assume very little, and rely on the CIS for
@@ -367,9 +367,8 @@ spectrum_cs_config(struct pcmcia_device *link)
 	card->node.major =3D card->node.minor =3D 0;
=20
 	/* Reset card */
=2D	if (spectrum_cs_hard_reset(priv) !=3D 0) {
+	if (spectrum_cs_hard_reset(priv) !=3D 0)
 		goto failed;
=2D	}
=20
 	SET_NETDEV_DEV(dev, &handle_to_dev(link));
 	/* Tell the stack we exist */
@@ -382,8 +381,8 @@ spectrum_cs_config(struct pcmcia_device *link)
 	 * initialized and arranged in a linked list at link->dev_node. */
 	strcpy(card->node.dev_name, dev->name);
 	link->dev_node =3D &card->node; /* link->dev_node being non-NULL is also
=2D                                    used to indicate that the
=2D                                    net_device has been registered */
+				       * used to indicate that the
+				       * net_device has been registered */
=20
 	/* Finally, report what we've done */
 	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s, irq %d, io "


--nextPart1442854.bUW4ViArWM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl8w3cACgkQR6LMutpd94xRoQCdGIDDcQum8u0LgdNq6iIIyMzq
kgcAniuuAtkf/3WFEJCzdbQbOEqOET6g
=xFlF
-----END PGP SIGNATURE-----

--nextPart1442854.bUW4ViArWM--
