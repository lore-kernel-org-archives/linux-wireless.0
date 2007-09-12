Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:53170 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760196AbXILVEh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 17:04:37 -0400
Received: by ug-out-1314.google.com with SMTP id z38so303649ugc
        for <linux-wireless@vger.kernel.org>; Wed, 12 Sep 2007 14:04:36 -0700 (PDT)
Message-ID: <46E85591.3090904@gmail.com>
Date: Wed, 12 Sep 2007 22:09:37 +0100
MIME-Version: 1.0
To: orinoco-devel@lists.sourceforge.net,
	orinoco-users@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, proski@gnu.org,
	hermes@gibson.dropbear.id.au
Subject: [PATCH 02/05] orinoco: Agere/Lucent firmware download
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replicate hermes_docmd_wait for commands which clear the MAGIC
number from SWSUPPORT0.

Functionality copied out of hermes_init.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
diff --git a/drivers/net/wireless/hermes.c b/drivers/net/wireless/hermes.c
index d655f3f..1ca8e4b 100644
--- a/drivers/net/wireless/hermes.c
+++ b/drivers/net/wireless/hermes.c
@@ -116,6 +116,60 @@ static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16 param0,
  * Function definitions
  */
 
+/* For doing cmds that wipe the magic constant in SWSUPPORT0 */
+int hermes_doicmd_wait(hermes_t *hw, u16 cmd,
+		       u16 parm0, u16 parm1, u16 parm2,
+		       struct hermes_response *resp)
+{
+	int err = 0;
+	int k;
+	u16 status, reg;
+
+	err = hermes_issue_cmd(hw, cmd, parm0, parm1, parm2);
+	if (err)
+		return err;
+
+	reg = hermes_read_regn(hw, EVSTAT);
+	k = CMD_INIT_TIMEOUT;
+	while ((!(reg & HERMES_EV_CMD)) && k) {
+		k--;
+		udelay(10);
+		reg = hermes_read_regn(hw, EVSTAT);
+	}
+
+	hermes_write_regn(hw, SWSUPPORT0, HERMES_MAGIC);
+
+	if (!hermes_present(hw)) {
+		DEBUG(0, "hermes @ 0x%x: Card removed during reset.\n",
+		       hw->iobase);
+		err = -ENODEV;
+		goto out;
+	}
+
+	if (!(reg & HERMES_EV_CMD)) {
+		printk(KERN_ERR "hermes @ %p: "
+		       "Timeout waiting for card to reset (reg=0x%04x)!\n",
+		       hw->iobase, reg);
+		err = -ETIMEDOUT;
+		goto out;
+	}
+
+	status = hermes_read_regn(hw, STATUS);
+	if (resp) {
+		resp->status = status;
+		resp->resp0 = hermes_read_regn(hw, RESP0);
+		resp->resp1 = hermes_read_regn(hw, RESP1);
+		resp->resp2 = hermes_read_regn(hw, RESP2);
+	}
+
+	hermes_write_regn(hw, EVACK, HERMES_EV_CMD);
+
+	if (status & HERMES_STATUS_RESULT)
+		err = -EIO;
+out:
+	return err;
+}
+
 void hermes_struct_init(hermes_t *hw, void __iomem *address, int reg_spacing)
 {
 	hw->iobase = address;
@@ -125,7 +179,7 @@ void hermes_struct_init(hermes_t *hw, void __iomem *address, int reg_spacing)
 
 int hermes_init(hermes_t *hw)
 {
-	u16 status, reg;
+	u16 reg;
 	int err = 0;
 	int k;
 
@@ -163,43 +217,8 @@ int hermes_init(hermes_t *hw)
 
 	/* We don't use hermes_docmd_wait here, because the reset wipes
 	   the magic constant in SWSUPPORT0 away, and it gets confused */
-	err = hermes_issue_cmd(hw, HERMES_CMD_INIT, 0, 0, 0);
-	if (err)
-		return err;
+	err = hermes_doicmd_wait(hw, HERMES_CMD_INIT, 0, 0, 0, NULL);
 
-	reg = hermes_read_regn(hw, EVSTAT);
-	k = CMD_INIT_TIMEOUT;
-	while ( (! (reg & HERMES_EV_CMD)) && k) {
-		k--;
-		udelay(10);
-		reg = hermes_read_regn(hw, EVSTAT);
-	}
-
-	hermes_write_regn(hw, SWSUPPORT0, HERMES_MAGIC);
-
-	if (! hermes_present(hw)) {
-		DEBUG(0, "hermes @ 0x%x: Card removed during reset.\n",
-		       hw->iobase);
-		err = -ENODEV;
-		goto out;
-	}
-		
-	if (! (reg & HERMES_EV_CMD)) {
-		printk(KERN_ERR "hermes @ %p: " 
-		       "Timeout waiting for card to reset (reg=0x%04x)!\n",
-		       hw->iobase, reg);
-		err = -ETIMEDOUT;
-		goto out;
-	}
-
-	status = hermes_read_regn(hw, STATUS);
-
-	hermes_write_regn(hw, EVACK, HERMES_EV_CMD);
-
-	if (status & HERMES_STATUS_RESULT)
-		err = -EIO;
-
- out:
 	return err;
 }
 
@@ -508,6 +527,7 @@ int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
 EXPORT_SYMBOL(hermes_struct_init);
 EXPORT_SYMBOL(hermes_init);
 EXPORT_SYMBOL(hermes_docmd_wait);
+EXPORT_SYMBOL(hermes_doicmd_wait);
 EXPORT_SYMBOL(hermes_allocate);
 
 EXPORT_SYMBOL(hermes_bap_pread);
diff --git a/drivers/net/wireless/hermes.h b/drivers/net/wireless/hermes.h
index 0d38bf6..148ff80 100644
--- a/drivers/net/wireless/hermes.h
+++ b/drivers/net/wireless/hermes.h
@@ -354,6 +354,9 @@ int hermes_init(hermes_t *hw);
 int hermes_docmd_wait(hermes_t *hw, u16 cmd,
 		      u16 parm0, u16 parm1, u16 parm2,
 		      struct hermes_response *resp);
+int hermes_doicmd_wait(hermes_t *hw, u16 cmd,
+		       u16 parm0, u16 parm1, u16 parm2,
+		       struct hermes_response *resp);
 int hermes_allocate(hermes_t *hw, u16 size, u16 *fid);
 
 int hermes_bap_pread(hermes_t *hw, int bap, void *buf, int len,
