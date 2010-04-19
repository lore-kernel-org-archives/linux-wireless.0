Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34487 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0DSHfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 03:35:48 -0400
Received: by wyb39 with SMTP id 39so2304576wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 00:35:46 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 1/5] orinoco: add hermes_ops
Date: Mon, 19 Apr 2010 08:35:18 +0100
Message-Id: <1271662522-29119-2-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1271662522-29119-1-git-send-email-kilroyd@googlemail.com>
References: <1271662522-29119-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pave the way for introducing USB alternative functions.

Force callers to dereference ops instead of providing wrappers.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/airport.c    |    2 +-
 drivers/net/wireless/orinoco/cfg.c        |    2 +-
 drivers/net/wireless/orinoco/fw.c         |    2 +-
 drivers/net/wireless/orinoco/hermes.c     |   52 ++++++++++--------
 drivers/net/wireless/orinoco/hermes.h     |   50 ++++++++++--------
 drivers/net/wireless/orinoco/hermes_dld.c |   34 ++++++------
 drivers/net/wireless/orinoco/hw.c         |   63 +++++++++++-----------
 drivers/net/wireless/orinoco/main.c       |   83 +++++++++++++++--------------
 drivers/net/wireless/orinoco/wext.c       |    6 +-
 9 files changed, 154 insertions(+), 140 deletions(-)

diff --git a/drivers/net/wireless/orinoco/airport.c b/drivers/net/wireless/orinoco/airport.c
index c60df2c..ea23c4f 100644
--- a/drivers/net/wireless/orinoco/airport.c
+++ b/drivers/net/wireless/orinoco/airport.c
@@ -195,7 +195,7 @@ airport_attach(struct macio_dev *mdev, const struct of_device_id *match)
 	ssleep(1);
 
 	/* Reset it before we get the interrupt */
-	hermes_init(hw);
+	hw->ops->init(hw);
 
 	if (request_irq(card->irq, orinoco_interrupt, 0, DRIVER_NAME, priv)) {
 		printk(KERN_ERR PFX "Couldn't get IRQ %d\n", card->irq);
diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index 90dd4d0..81d228d 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -189,7 +189,7 @@ static int orinoco_set_channel(struct wiphy *wiphy,
 	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
 		/* Fast channel change - no commit if successful */
 		hermes_t *hw = &priv->hw;
-		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
+		err = hw->ops->cmd_wait(hw, HERMES_CMD_TEST |
 					    HERMES_TEST_SET_CHANNEL,
 					channel, NULL);
 	}
diff --git a/drivers/net/wireless/orinoco/fw.c b/drivers/net/wireless/orinoco/fw.c
index 5ea0f7c..4c99240 100644
--- a/drivers/net/wireless/orinoco/fw.c
+++ b/drivers/net/wireless/orinoco/fw.c
@@ -260,7 +260,7 @@ symbol_dl_image(struct orinoco_private *priv, const struct fw_info *fw,
 	}
 
 	/* Reset hermes chip and make sure it responds */
-	ret = hermes_init(hw);
+	ret = hw->ops->init(hw);
 
 	/* hermes_reset() should return 0 with the secondary firmware */
 	if (secondary && ret != 0)
diff --git a/drivers/net/wireless/orinoco/hermes.c b/drivers/net/wireless/orinoco/hermes.c
index 1a2fca7..a7df524 100644
--- a/drivers/net/wireless/orinoco/hermes.c
+++ b/drivers/net/wireless/orinoco/hermes.c
@@ -70,6 +70,7 @@
 
 #endif /* ! HERMES_DEBUG */
 
+static const struct hermes_ops hermes_ops_local;
 
 /*
  * Internal functions
@@ -111,9 +112,9 @@ static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16 param0,
  */
 
 /* For doing cmds that wipe the magic constant in SWSUPPORT0 */
-int hermes_doicmd_wait(hermes_t *hw, u16 cmd,
-		       u16 parm0, u16 parm1, u16 parm2,
-		       struct hermes_response *resp)
+static int hermes_doicmd_wait(hermes_t *hw, u16 cmd,
+			      u16 parm0, u16 parm1, u16 parm2,
+			      struct hermes_response *resp)
 {
 	int err = 0;
 	int k;
@@ -163,17 +164,17 @@ int hermes_doicmd_wait(hermes_t *hw, u16 cmd,
 out:
 	return err;
 }
-EXPORT_SYMBOL(hermes_doicmd_wait);
 
 void hermes_struct_init(hermes_t *hw, void __iomem *address, int reg_spacing)
 {
 	hw->iobase = address;
 	hw->reg_spacing = reg_spacing;
 	hw->inten = 0x0;
+	hw->ops = &hermes_ops_local;
 }
 EXPORT_SYMBOL(hermes_struct_init);
 
-int hermes_init(hermes_t *hw)
+static int hermes_init(hermes_t *hw)
 {
 	u16 reg;
 	int err = 0;
@@ -217,7 +218,6 @@ int hermes_init(hermes_t *hw)
 
 	return err;
 }
-EXPORT_SYMBOL(hermes_init);
 
 /* Issue a command to the chip, and (busy!) wait for it to
  * complete.
@@ -228,8 +228,8 @@ EXPORT_SYMBOL(hermes_init);
  *     > 0 on error returned by the firmware
  *
  * Callable from any context, but locking is your problem. */
-int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
-		      struct hermes_response *resp)
+static int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
+			     struct hermes_response *resp)
 {
 	int err;
 	int k;
@@ -291,9 +291,8 @@ int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
  out:
 	return err;
 }
-EXPORT_SYMBOL(hermes_docmd_wait);
 
-int hermes_allocate(hermes_t *hw, u16 size, u16 *fid)
+static int hermes_allocate(hermes_t *hw, u16 size, u16 *fid)
 {
 	int err = 0;
 	int k;
@@ -333,7 +332,6 @@ int hermes_allocate(hermes_t *hw, u16 size, u16 *fid)
 
 	return 0;
 }
-EXPORT_SYMBOL(hermes_allocate);
 
 /* Set up a BAP to read a particular chunk of data from card's internal buffer.
  *
@@ -403,8 +401,8 @@ static int hermes_bap_seek(hermes_t *hw, int bap, u16 id, u16 offset)
  *       0 on success
  *     > 0 on error from firmware
  */
-int hermes_bap_pread(hermes_t *hw, int bap, void *buf, int len,
-		     u16 id, u16 offset)
+static int hermes_bap_pread(hermes_t *hw, int bap, void *buf, int len,
+			    u16 id, u16 offset)
 {
 	int dreg = bap ? HERMES_DATA1 : HERMES_DATA0;
 	int err = 0;
@@ -422,7 +420,6 @@ int hermes_bap_pread(hermes_t *hw, int bap, void *buf, int len,
  out:
 	return err;
 }
-EXPORT_SYMBOL(hermes_bap_pread);
 
 /* Write a block of data to the chip's buffer, via the
  * BAP. Synchronization/serialization is the caller's problem.
@@ -432,8 +429,8 @@ EXPORT_SYMBOL(hermes_bap_pread);
  *       0 on success
  *     > 0 on error from firmware
  */
-int hermes_bap_pwrite(hermes_t *hw, int bap, const void *buf, int len,
-		      u16 id, u16 offset)
+static int hermes_bap_pwrite(hermes_t *hw, int bap, const void *buf, int len,
+			     u16 id, u16 offset)
 {
 	int dreg = bap ? HERMES_DATA1 : HERMES_DATA0;
 	int err = 0;
@@ -451,7 +448,6 @@ int hermes_bap_pwrite(hermes_t *hw, int bap, const void *buf, int len,
  out:
 	return err;
 }
-EXPORT_SYMBOL(hermes_bap_pwrite);
 
 /* Read a Length-Type-Value record from the card.
  *
@@ -461,8 +457,8 @@ EXPORT_SYMBOL(hermes_bap_pwrite);
  * practice.
  *
  * Callable from user or bh context.  */
-int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, unsigned bufsize,
-		    u16 *length, void *buf)
+static int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, unsigned bufsize,
+			   u16 *length, void *buf)
 {
 	int err = 0;
 	int dreg = bap ? HERMES_DATA1 : HERMES_DATA0;
@@ -505,10 +501,9 @@ int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, unsigned bufsize,
 
 	return 0;
 }
-EXPORT_SYMBOL(hermes_read_ltv);
 
-int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
-		     u16 length, const void *value)
+static int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
+			    u16 length, const void *value)
 {
 	int dreg = bap ? HERMES_DATA1 : HERMES_DATA0;
 	int err = 0;
@@ -533,4 +528,15 @@ int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
 
 	return err;
 }
-EXPORT_SYMBOL(hermes_write_ltv);
+
+/* Hermes operations for local buses */
+static const struct hermes_ops hermes_ops_local = {
+	.init = hermes_init,
+	.cmd_wait = hermes_docmd_wait,
+	.init_cmd_wait = hermes_doicmd_wait,
+	.allocate = hermes_allocate,
+	.read_ltv = hermes_read_ltv,
+	.write_ltv = hermes_write_ltv,
+	.bap_pread = hermes_bap_pread,
+	.bap_pwrite = hermes_bap_pwrite
+};
diff --git a/drivers/net/wireless/orinoco/hermes.h b/drivers/net/wireless/orinoco/hermes.h
index 2dddbb5..18b268c 100644
--- a/drivers/net/wireless/orinoco/hermes.h
+++ b/drivers/net/wireless/orinoco/hermes.h
@@ -374,6 +374,27 @@ struct hermes_multicast {
 /* Timeouts */
 #define HERMES_BAP_BUSY_TIMEOUT (10000) /* In iterations of ~1us */
 
+struct hermes;
+
+/* Functions to access hardware */
+struct hermes_ops {
+	int (*init)(struct hermes *hw);
+	int (*cmd_wait)(struct hermes *hw, u16 cmd, u16 parm0,
+			struct hermes_response *resp);
+	int (*init_cmd_wait)(struct hermes *hw, u16 cmd,
+			     u16 parm0, u16 parm1, u16 parm2,
+			     struct hermes_response *resp);
+	int (*allocate)(struct hermes *hw, u16 size, u16 *fid);
+	int (*read_ltv)(struct hermes *hw, int bap, u16 rid, unsigned buflen,
+			u16 *length, void *buf);
+	int (*write_ltv)(struct hermes *hw, int bap, u16 rid,
+			 u16 length, const void *value);
+	int (*bap_pread)(struct hermes *hw, int bap, void *buf, int len,
+			 u16 id, u16 offset);
+	int (*bap_pwrite)(struct hermes *hw, int bap, const void *buf,
+			  int len, u16 id, u16 offset);
+};
+
 /* Basic control structure */
 typedef struct hermes {
 	void __iomem *iobase;
@@ -381,6 +402,7 @@ typedef struct hermes {
 #define HERMES_16BIT_REGSPACING	0
 #define HERMES_32BIT_REGSPACING	1
 	u16 inten; /* Which interrupts should be enabled? */
+	const struct hermes_ops *ops;
 } hermes_t;
 
 /* Register access convenience macros */
@@ -394,22 +416,6 @@ typedef struct hermes {
 
 /* Function prototypes */
 void hermes_struct_init(hermes_t *hw, void __iomem *address, int reg_spacing);
-int hermes_init(hermes_t *hw);
-int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
-		      struct hermes_response *resp);
-int hermes_doicmd_wait(hermes_t *hw, u16 cmd,
-		       u16 parm0, u16 parm1, u16 parm2,
-		       struct hermes_response *resp);
-int hermes_allocate(hermes_t *hw, u16 size, u16 *fid);
-
-int hermes_bap_pread(hermes_t *hw, int bap, void *buf, int len,
-		       u16 id, u16 offset);
-int hermes_bap_pwrite(hermes_t *hw, int bap, const void *buf, int len,
-			u16 id, u16 offset);
-int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, unsigned buflen,
-		    u16 *length, void *buf);
-int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
-		      u16 length, const void *value);
 
 /* Inline functions */
 
@@ -426,13 +432,13 @@ static inline void hermes_set_irqmask(hermes_t *hw, u16 events)
 
 static inline int hermes_enable_port(hermes_t *hw, int port)
 {
-	return hermes_docmd_wait(hw, HERMES_CMD_ENABLE | (port << 8),
+	return hw->ops->cmd_wait(hw, HERMES_CMD_ENABLE | (port << 8),
 				 0, NULL);
 }
 
 static inline int hermes_disable_port(hermes_t *hw, int port)
 {
-	return hermes_docmd_wait(hw, HERMES_CMD_DISABLE | (port << 8),
+	return hw->ops->cmd_wait(hw, HERMES_CMD_DISABLE | (port << 8),
 				 0, NULL);
 }
 
@@ -440,7 +446,7 @@ static inline int hermes_disable_port(hermes_t *hw, int port)
  * information frame in __orinoco_ev_info() */
 static inline int hermes_inquire(hermes_t *hw, u16 rid)
 {
-	return hermes_docmd_wait(hw, HERMES_CMD_INQUIRE, rid, NULL);
+	return hw->ops->cmd_wait(hw, HERMES_CMD_INQUIRE, rid, NULL);
 }
 
 #define HERMES_BYTES_TO_RECLEN(n) ((((n)+1)/2) + 1)
@@ -475,10 +481,10 @@ static inline void hermes_clear_words(struct hermes *hw, int off,
 }
 
 #define HERMES_READ_RECORD(hw, bap, rid, buf) \
-	(hermes_read_ltv((hw), (bap), (rid), sizeof(*buf), NULL, (buf)))
+	(hw->ops->read_ltv((hw), (bap), (rid), sizeof(*buf), NULL, (buf)))
 #define HERMES_WRITE_RECORD(hw, bap, rid, buf) \
-	(hermes_write_ltv((hw), (bap), (rid), \
-			  HERMES_BYTES_TO_RECLEN(sizeof(*buf)), (buf)))
+	(hw->ops->write_ltv((hw), (bap), (rid), \
+			    HERMES_BYTES_TO_RECLEN(sizeof(*buf)), (buf)))
 
 static inline int hermes_read_wordrec(hermes_t *hw, int bap, u16 rid, u16 *word)
 {
diff --git a/drivers/net/wireless/orinoco/hermes_dld.c b/drivers/net/wireless/orinoco/hermes_dld.c
index fb157eb..8f22e20 100644
--- a/drivers/net/wireless/orinoco/hermes_dld.c
+++ b/drivers/net/wireless/orinoco/hermes_dld.c
@@ -293,7 +293,7 @@ int hermes_read_pda(hermes_t *hw,
 		/* PDA of spectrum symbol is in eeprom */
 
 		/* Issue command to read EEPROM */
-		ret = hermes_docmd_wait(hw, HERMES_CMD_READMIF, 0, NULL);
+		ret = hw->ops->cmd_wait(hw, HERMES_CMD_READMIF, 0, NULL);
 		if (ret)
 			return ret;
 	} else {
@@ -408,16 +408,16 @@ int hermesi_program_init(hermes_t *hw, u32 offset)
 	/* Acknowledge any outstanding command */
 	hermes_write_regn(hw, EVACK, 0xFFFF);
 
-	/* Using doicmd_wait rather than docmd_wait */
-	err = hermes_doicmd_wait(hw,
-				 0x0100 | HERMES_CMD_INIT,
-				 0, 0, 0, NULL);
+	/* Using init_cmd_wait rather than cmd_wait */
+	err = hw->ops->init_cmd_wait(hw,
+				     0x0100 | HERMES_CMD_INIT,
+				     0, 0, 0, NULL);
 	if (err)
 		return err;
 
-	err = hermes_doicmd_wait(hw,
-				 0x0000 | HERMES_CMD_INIT,
-				 0, 0, 0, NULL);
+	err = hw->ops->init_cmd_wait(hw,
+				     0x0000 | HERMES_CMD_INIT,
+				     0, 0, 0, NULL);
 	if (err)
 		return err;
 
@@ -428,12 +428,12 @@ int hermesi_program_init(hermes_t *hw, u32 offset)
 		return err;
 
 	pr_debug(PFX "Enabling volatile, EP 0x%08x\n", offset);
-	err = hermes_doicmd_wait(hw,
-				 HERMES_PROGRAM_ENABLE_VOLATILE,
-				 offset & 0xFFFFu,
-				 offset >> 16,
-				 0,
-				 NULL);
+	err = hw->ops->init_cmd_wait(hw,
+				     HERMES_PROGRAM_ENABLE_VOLATILE,
+				     offset & 0xFFFFu,
+				     offset >> 16,
+				     0,
+				     NULL);
 	pr_debug(PFX "PROGRAM_ENABLE returned %d\n", err);
 
 	return err;
@@ -451,7 +451,7 @@ int hermesi_program_end(hermes_t *hw)
 	int rc = 0;
 	int err;
 
-	rc = hermes_docmd_wait(hw, HERMES_PROGRAM_DISABLE, 0, &resp);
+	rc = hw->ops->cmd_wait(hw, HERMES_PROGRAM_DISABLE, 0, &resp);
 
 	pr_debug(PFX "PROGRAM_DISABLE returned %d, "
 		 "r0 0x%04x, r1 0x%04x, r2 0x%04x\n",
@@ -468,8 +468,8 @@ int hermesi_program_end(hermes_t *hw)
 	hermes_write_regn(hw, EVACK, 0xFFFF);
 
 	/* Reinitialise, ignoring return */
-	(void) hermes_doicmd_wait(hw, 0x0000 | HERMES_CMD_INIT,
-				  0, 0, 0, NULL);
+	(void) hw->ops->init_cmd_wait(hw, 0x0000 | HERMES_CMD_INIT,
+				      0, 0, 0, NULL);
 
 	return rc ? rc : err;
 }
diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 24ea4b4..9c86acc 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -177,9 +177,9 @@ int determine_fw_capabilities(struct orinoco_private *priv,
 		/* 3Com MAC : 00:50:DA:* */
 		memset(tmp, 0, sizeof(tmp));
 		/* Get the Symbol firmware version */
-		err = hermes_read_ltv(hw, USER_BAP,
-				      HERMES_RID_SECONDARYVERSION_SYMBOL,
-				      SYMBOL_MAX_VER_LEN, NULL, &tmp);
+		err = hw->ops->read_ltv(hw, USER_BAP,
+					HERMES_RID_SECONDARYVERSION_SYMBOL,
+					SYMBOL_MAX_VER_LEN, NULL, &tmp);
 		if (err) {
 			dev_warn(dev, "Error %d reading Symbol firmware info. "
 				 "Wildly guessing capabilities...\n", err);
@@ -286,8 +286,8 @@ int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr)
 	u16 reclen;
 
 	/* Get the MAC address */
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CNFOWNMACADDR,
-			      ETH_ALEN, NULL, dev_addr);
+	err = hw->ops->read_ltv(hw, USER_BAP, HERMES_RID_CNFOWNMACADDR,
+				ETH_ALEN, NULL, dev_addr);
 	if (err) {
 		dev_warn(dev, "Failed to read MAC address!\n");
 		goto out;
@@ -296,8 +296,8 @@ int orinoco_hw_read_card_settings(struct orinoco_private *priv, u8 *dev_addr)
 	dev_dbg(dev, "MAC address %pM\n", dev_addr);
 
 	/* Get the station name */
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CNFOWNNAME,
-			      sizeof(nickbuf), &reclen, &nickbuf);
+	err = hw->ops->read_ltv(hw, USER_BAP, HERMES_RID_CNFOWNNAME,
+				sizeof(nickbuf), &reclen, &nickbuf);
 	if (err) {
 		dev_err(dev, "failed to read station name\n");
 		goto out;
@@ -413,11 +413,11 @@ int orinoco_hw_allocate_fid(struct orinoco_private *priv)
 	struct hermes *hw = &priv->hw;
 	int err;
 
-	err = hermes_allocate(hw, priv->nicbuf_size, &priv->txfid);
+	err = hw->ops->allocate(hw, priv->nicbuf_size, &priv->txfid);
 	if (err == -EIO && priv->nicbuf_size > TX_NICBUF_SIZE_BUG) {
 		/* Try workaround for old Symbol firmware bug */
 		priv->nicbuf_size = TX_NICBUF_SIZE_BUG;
-		err = hermes_allocate(hw, priv->nicbuf_size, &priv->txfid);
+		err = hw->ops->allocate(hw, priv->nicbuf_size, &priv->txfid);
 
 		dev_warn(dev, "Firmware ALLOC bug detected "
 			 "(old Symbol firmware?). Work around %s\n",
@@ -463,8 +463,9 @@ int orinoco_hw_program_rids(struct orinoco_private *priv)
 	struct hermes_idstring idbuf;
 
 	/* Set the MAC address */
-	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNMACADDR,
-			       HERMES_BYTES_TO_RECLEN(ETH_ALEN), dev->dev_addr);
+	err = hw->ops->write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNMACADDR,
+				 HERMES_BYTES_TO_RECLEN(ETH_ALEN),
+				 dev->dev_addr);
 	if (err) {
 		printk(KERN_ERR "%s: Error %d setting MAC address\n",
 		       dev->name, err);
@@ -527,7 +528,7 @@ int orinoco_hw_program_rids(struct orinoco_private *priv)
 	idbuf.len = cpu_to_le16(strlen(priv->desired_essid));
 	memcpy(&idbuf.val, priv->desired_essid, sizeof(idbuf.val));
 	/* WinXP wants partner to configure OWNSSID even in IBSS mode. (jimc) */
-	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNSSID,
+	err = hw->ops->write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNSSID,
 			HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid)+2),
 			&idbuf);
 	if (err) {
@@ -535,7 +536,7 @@ int orinoco_hw_program_rids(struct orinoco_private *priv)
 		       dev->name, err);
 		return err;
 	}
-	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFDESIREDSSID,
+	err = hw->ops->write_ltv(hw, USER_BAP, HERMES_RID_CNFDESIREDSSID,
 			HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid)+2),
 			&idbuf);
 	if (err) {
@@ -547,9 +548,9 @@ int orinoco_hw_program_rids(struct orinoco_private *priv)
 	/* Set the station name */
 	idbuf.len = cpu_to_le16(strlen(priv->nick));
 	memcpy(&idbuf.val, priv->nick, sizeof(idbuf.val));
-	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNNAME,
-			       HERMES_BYTES_TO_RECLEN(strlen(priv->nick)+2),
-			       &idbuf);
+	err = hw->ops->write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNNAME,
+				 HERMES_BYTES_TO_RECLEN(strlen(priv->nick)+2),
+				 &idbuf);
 	if (err) {
 		printk(KERN_ERR "%s: Error %d setting nickname\n",
 		       dev->name, err);
@@ -664,12 +665,12 @@ int orinoco_hw_program_rids(struct orinoco_private *priv)
 	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
 		/* Enable monitor mode */
 		dev->type = ARPHRD_IEEE80211;
-		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
+		err = hw->ops->cmd_wait(hw, HERMES_CMD_TEST |
 					    HERMES_TEST_MONITOR, 0, NULL);
 	} else {
 		/* Disable monitor mode */
 		dev->type = ARPHRD_ETHER;
-		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
+		err = hw->ops->cmd_wait(hw, HERMES_CMD_TEST |
 					    HERMES_TEST_STOP, 0, NULL);
 	}
 	if (err)
@@ -695,8 +696,8 @@ int orinoco_hw_get_tkip_iv(struct orinoco_private *priv, int key, u8 *tsc)
 	if ((key < 0) || (key >= 4))
 		return -EINVAL;
 
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENT_TKIP_IV,
-			      sizeof(tsc_arr), NULL, &tsc_arr);
+	err = hw->ops->read_ltv(hw, USER_BAP, HERMES_RID_CURRENT_TKIP_IV,
+				sizeof(tsc_arr), NULL, &tsc_arr);
 	if (!err)
 		memcpy(tsc, &tsc_arr[key][0], sizeof(tsc_arr[0]));
 
@@ -875,7 +876,7 @@ int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv)
 				memcpy(key, priv->keys[i].key,
 				       priv->keys[i].key_len);
 
-				err = hermes_write_ltv(hw, USER_BAP,
+				err = hw->ops->write_ltv(hw, USER_BAP,
 						HERMES_RID_CNFDEFAULTKEY0 + i,
 						HERMES_BYTES_TO_RECLEN(keylen),
 						key);
@@ -1092,7 +1093,7 @@ int __orinoco_hw_set_multicast_list(struct orinoco_private *priv,
 			memcpy(mclist.addr[i++], p->dmi_addr, ETH_ALEN);
 		}
 
-		err = hermes_write_ltv(hw, USER_BAP,
+		err = hw->ops->write_ltv(hw, USER_BAP,
 				   HERMES_RID_CNFGROUPADDRESSES,
 				   HERMES_BYTES_TO_RECLEN(mc_count * ETH_ALEN),
 				   &mclist);
@@ -1134,15 +1135,15 @@ int orinoco_hw_get_essid(struct orinoco_private *priv, int *active,
 		rid = (priv->port_type == 3) ? HERMES_RID_CNFOWNSSID :
 			HERMES_RID_CNFDESIREDSSID;
 
-		err = hermes_read_ltv(hw, USER_BAP, rid, sizeof(essidbuf),
-				      NULL, &essidbuf);
+		err = hw->ops->read_ltv(hw, USER_BAP, rid, sizeof(essidbuf),
+					NULL, &essidbuf);
 		if (err)
 			goto fail_unlock;
 	} else {
 		*active = 0;
 
-		err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENTSSID,
-				      sizeof(essidbuf), NULL, &essidbuf);
+		err = hw->ops->read_ltv(hw, USER_BAP, HERMES_RID_CURRENTSSID,
+					sizeof(essidbuf), NULL, &essidbuf);
 		if (err)
 			goto fail_unlock;
 	}
@@ -1213,8 +1214,8 @@ int orinoco_hw_get_bitratelist(struct orinoco_private *priv,
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
 
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_SUPPORTEDDATARATES,
-			      sizeof(list), NULL, &list);
+	err = hw->ops->read_ltv(hw, USER_BAP, HERMES_RID_SUPPORTEDDATARATES,
+				sizeof(list), NULL, &list);
 	orinoco_unlock(priv, &flags);
 
 	if (err)
@@ -1281,7 +1282,7 @@ int orinoco_hw_trigger_scan(struct orinoco_private *priv,
 				idbuf.len = cpu_to_le16(len);
 				memcpy(idbuf.val, ssid->ssid, len);
 
-				err = hermes_write_ltv(hw, USER_BAP,
+				err = hw->ops->write_ltv(hw, USER_BAP,
 					       HERMES_RID_CNFSCANSSID_AGERE,
 					       HERMES_BYTES_TO_RECLEN(len + 2),
 					       &idbuf);
@@ -1345,8 +1346,8 @@ int orinoco_hw_get_current_bssid(struct orinoco_private *priv,
 	hermes_t *hw = &priv->hw;
 	int err;
 
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENTBSSID,
-			      ETH_ALEN, NULL, addr);
+	err = hw->ops->read_ltv(hw, USER_BAP, HERMES_RID_CURRENTBSSID,
+				ETH_ALEN, NULL, addr);
 
 	return err;
 }
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 413e9ab..8c8009c 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -400,8 +400,8 @@ static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 		memset(&desc, 0, sizeof(desc));
 
 		*txcntl = cpu_to_le16(tx_control);
-		err = hermes_bap_pwrite(hw, USER_BAP, &desc, sizeof(desc),
-					txfid, 0);
+		err = hw->ops->bap_pwrite(hw, USER_BAP, &desc, sizeof(desc),
+					  txfid, 0);
 		if (err) {
 			if (net_ratelimit())
 				printk(KERN_ERR "%s: Error %d writing Tx "
@@ -414,8 +414,8 @@ static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 		memset(&desc, 0, sizeof(desc));
 
 		desc.tx_control = cpu_to_le16(tx_control);
-		err = hermes_bap_pwrite(hw, USER_BAP, &desc, sizeof(desc),
-					txfid, 0);
+		err = hw->ops->bap_pwrite(hw, USER_BAP, &desc, sizeof(desc),
+					  txfid, 0);
 		if (err) {
 			if (net_ratelimit())
 				printk(KERN_ERR "%s: Error %d writing Tx "
@@ -458,8 +458,8 @@ static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 		memcpy(eh, &hdr, sizeof(hdr));
 	}
 
-	err = hermes_bap_pwrite(hw, USER_BAP, skb->data, skb->len,
-				txfid, HERMES_802_3_OFFSET);
+	err = hw->ops->bap_pwrite(hw, USER_BAP, skb->data, skb->len,
+				  txfid, HERMES_802_3_OFFSET);
 	if (err) {
 		printk(KERN_ERR "%s: Error %d writing packet to BAP\n",
 		       dev->name, err);
@@ -490,8 +490,8 @@ static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 			    skb->data + ETH_HLEN, skb->len - ETH_HLEN, mic);
 
 		/* Write the MIC */
-		err = hermes_bap_pwrite(hw, USER_BAP, &mic_buf[0], len,
-					txfid, HERMES_802_3_OFFSET + offset);
+		err = hw->ops->bap_pwrite(hw, USER_BAP, &mic_buf[0], len,
+					  txfid, HERMES_802_3_OFFSET + offset);
 		if (err) {
 			printk(KERN_ERR "%s: Error %d writing MIC to BAP\n",
 			       dev->name, err);
@@ -502,7 +502,7 @@ static netdev_tx_t orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Finally, we actually initiate the send */
 	netif_stop_queue(dev);
 
-	err = hermes_docmd_wait(hw, HERMES_CMD_TX | HERMES_CMD_RECL,
+	err = hw->ops->cmd_wait(hw, HERMES_CMD_TX | HERMES_CMD_RECL,
 				txfid, NULL);
 	if (err) {
 		netif_start_queue(dev);
@@ -572,9 +572,9 @@ static void __orinoco_ev_txexc(struct net_device *dev, hermes_t *hw)
 		return; /* Nothing's really happened */
 
 	/* Read part of the frame header - we need status and addr1 */
-	err = hermes_bap_pread(hw, IRQ_BAP, &hdr,
-			       sizeof(struct hermes_txexc_data),
-			       fid, 0);
+	err = hw->ops->bap_pread(hw, IRQ_BAP, &hdr,
+				 sizeof(struct hermes_txexc_data),
+				 fid, 0);
 
 	hermes_write_regn(hw, TXCOMPLFID, DUMMY_FID);
 	stats->tx_errors++;
@@ -764,9 +764,9 @@ static void orinoco_rx_monitor(struct net_device *dev, u16 rxfid,
 
 	/* If any, copy the data from the card to the skb */
 	if (datalen > 0) {
-		err = hermes_bap_pread(hw, IRQ_BAP, skb_put(skb, datalen),
-				       ALIGN(datalen, 2), rxfid,
-				       HERMES_802_2_OFFSET);
+		err = hw->ops->bap_pread(hw, IRQ_BAP, skb_put(skb, datalen),
+					 ALIGN(datalen, 2), rxfid,
+					 HERMES_802_2_OFFSET);
 		if (err) {
 			printk(KERN_ERR "%s: error %d reading monitor frame\n",
 			       dev->name, err);
@@ -814,8 +814,8 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 
 	rxfid = hermes_read_regn(hw, RXFID);
 
-	err = hermes_bap_pread(hw, IRQ_BAP, desc, sizeof(*desc),
-			       rxfid, 0);
+	err = hw->ops->bap_pread(hw, IRQ_BAP, desc, sizeof(*desc),
+				 rxfid, 0);
 	if (err) {
 		printk(KERN_ERR "%s: error %d reading Rx descriptor. "
 		       "Frame dropped.\n", dev->name, err);
@@ -882,9 +882,9 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 	   nothing is removed.  2 is for aligning the IP header.  */
 	skb_reserve(skb, ETH_HLEN + 2);
 
-	err = hermes_bap_pread(hw, IRQ_BAP, skb_put(skb, length),
-			       ALIGN(length, 2), rxfid,
-			       HERMES_802_2_OFFSET);
+	err = hw->ops->bap_pread(hw, IRQ_BAP, skb_put(skb, length),
+				 ALIGN(length, 2), rxfid,
+				 HERMES_802_2_OFFSET);
 	if (err) {
 		printk(KERN_ERR "%s: error %d reading frame. "
 		       "Frame dropped.\n", dev->name, err);
@@ -1145,9 +1145,9 @@ static void orinoco_join_ap(struct work_struct *work)
 		goto out;
 
 	/* Read scan results from the firmware */
-	err = hermes_read_ltv(hw, USER_BAP,
-			      HERMES_RID_SCANRESULTSTABLE,
-			      MAX_SCAN_LEN, &len, buf);
+	err = hw->ops->read_ltv(hw, USER_BAP,
+				HERMES_RID_SCANRESULTSTABLE,
+				MAX_SCAN_LEN, &len, buf);
 	if (err) {
 		printk(KERN_ERR "%s: Cannot read scan results\n",
 		       dev->name);
@@ -1194,8 +1194,8 @@ static void orinoco_send_bssid_wevent(struct orinoco_private *priv)
 	union iwreq_data wrqu;
 	int err;
 
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENTBSSID,
-			      ETH_ALEN, NULL, wrqu.ap_addr.sa_data);
+	err = hw->ops->read_ltv(hw, USER_BAP, HERMES_RID_CURRENTBSSID,
+				ETH_ALEN, NULL, wrqu.ap_addr.sa_data);
 	if (err != 0)
 		return;
 
@@ -1217,8 +1217,8 @@ static void orinoco_send_assocreqie_wevent(struct orinoco_private *priv)
 	if (!priv->has_wpa)
 		return;
 
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENT_ASSOC_REQ_INFO,
-			      sizeof(buf), NULL, &buf);
+	err = hw->ops->read_ltv(hw, USER_BAP, HERMES_RID_CURRENT_ASSOC_REQ_INFO,
+				sizeof(buf), NULL, &buf);
 	if (err != 0)
 		return;
 
@@ -1247,8 +1247,9 @@ static void orinoco_send_assocrespie_wevent(struct orinoco_private *priv)
 	if (!priv->has_wpa)
 		return;
 
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENT_ASSOC_RESP_INFO,
-			      sizeof(buf), NULL, &buf);
+	err = hw->ops->read_ltv(hw, USER_BAP,
+				HERMES_RID_CURRENT_ASSOC_RESP_INFO,
+				sizeof(buf), NULL, &buf);
 	if (err != 0)
 		return;
 
@@ -1371,8 +1372,8 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 	infofid = hermes_read_regn(hw, INFOFID);
 
 	/* Read the info frame header - don't try too hard */
-	err = hermes_bap_pread(hw, IRQ_BAP, &info, sizeof(info),
-			       infofid, 0);
+	err = hw->ops->bap_pread(hw, IRQ_BAP, &info, sizeof(info),
+				 infofid, 0);
 	if (err) {
 		printk(KERN_ERR "%s: error %d reading info frame. "
 		       "Frame dropped.\n", dev->name, err);
@@ -1393,8 +1394,8 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 			len = sizeof(tallies);
 		}
 
-		err = hermes_bap_pread(hw, IRQ_BAP, &tallies, len,
-				       infofid, sizeof(info));
+		err = hw->ops->bap_pread(hw, IRQ_BAP, &tallies, len,
+					 infofid, sizeof(info));
 		if (err)
 			break;
 
@@ -1429,8 +1430,8 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 			break;
 		}
 
-		err = hermes_bap_pread(hw, IRQ_BAP, &linkstatus, len,
-				       infofid, sizeof(info));
+		err = hw->ops->bap_pread(hw, IRQ_BAP, &linkstatus, len,
+					 infofid, sizeof(info));
 		if (err)
 			break;
 		newstatus = le16_to_cpu(linkstatus.linkstatus);
@@ -1494,8 +1495,8 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 		}
 
 		/* Read scan data */
-		err = hermes_bap_pread(hw, IRQ_BAP, (void *) buf, len,
-				       infofid, sizeof(info));
+		err = hw->ops->bap_pread(hw, IRQ_BAP, (void *) buf, len,
+					 infofid, sizeof(info));
 		if (err) {
 			kfree(buf);
 			qabort_scan(priv);
@@ -1547,8 +1548,8 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 			break;
 
 		/* Read scan data */
-		err = hermes_bap_pread(hw, IRQ_BAP, (void *) bss, len,
-				       infofid, sizeof(info));
+		err = hw->ops->bap_pread(hw, IRQ_BAP, (void *) bss, len,
+					 infofid, sizeof(info));
 		if (err)
 			kfree(bss);
 		else
@@ -1647,7 +1648,7 @@ static int orinoco_reinit_firmware(struct orinoco_private *priv)
 	struct hermes *hw = &priv->hw;
 	int err;
 
-	err = hermes_init(hw);
+	err = hw->ops->init(hw);
 	if (priv->do_fw_download && !err) {
 		err = orinoco_download(priv);
 		if (err)
@@ -1984,7 +1985,7 @@ int orinoco_init(struct orinoco_private *priv)
 	priv->nicbuf_size = IEEE80211_MAX_FRAME_LEN + ETH_HLEN;
 
 	/* Initialize the firmware */
-	err = hermes_init(hw);
+	err = hw->ops->init(hw);
 	if (err != 0) {
 		dev_err(dev, "Failed to initialize firmware (err = %d)\n",
 			err);
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index a1006bf..5775124 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -458,7 +458,7 @@ static int orinoco_ioctl_setfreq(struct net_device *dev,
 	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
 		/* Fast channel change - no commit if successful */
 		hermes_t *hw = &priv->hw;
-		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
+		err = hw->ops->cmd_wait(hw, HERMES_CMD_TEST |
 					    HERMES_TEST_SET_CHANNEL,
 					chan, NULL);
 	}
@@ -1273,8 +1273,8 @@ static int orinoco_ioctl_getrid(struct net_device *dev,
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
 
-	err = hermes_read_ltv(hw, USER_BAP, rid, MAX_RID_LEN, &length,
-			      extra);
+	err = hw->ops->read_ltv(hw, USER_BAP, rid, MAX_RID_LEN, &length,
+				extra);
 	if (err)
 		goto out;
 
-- 
1.6.4.4

