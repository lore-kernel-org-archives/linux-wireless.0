Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:8775 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYHBKPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 06:15:08 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1578395ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 03:15:07 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH 05/19] orinoco: Add function to execute Hermes initialisation commands synchronously
Date: Sat,  2 Aug 2008 11:14:19 +0100
Message-Id: <1217672073-7094-6-git-send-email-kilroyd@gmail.com> (sfid-20080802_121511_753523_5418416A)
In-Reply-To: <1217672073-7094-5-git-send-email-kilroyd@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-3-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-4-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-5-git-send-email-kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current synchronous execution function doesn't work
for certain Hermes commands which clear the MAGIC number from
SWSUPPORT0. These commands seem to be related to initialisation or
programming, for example HERMES_CMD_INIT.

Replicate hermes_docmd_wait for commands which clear the MAGIC number
from SWSUPPORT0. This version accepts two extra arguments which are
passed straight to the firmware.

Functionality copied out of hermes_init.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/hermes.c |   94 +++++++++++++++++++++++++----------------
 drivers/net/wireless/hermes.h |    3 +
 2 files changed, 60 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/hermes.c b/drivers/net/wireless/hermes.c
index aa95349..13072d0 100644
--- a/drivers/net/wireless/hermes.c
+++ b/drivers/net/wireless/hermes.c
@@ -116,6 +116,61 @@ static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16 param0,
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
+EXPORT_SYMBOL(hermes_doicmd_wait);
+
 void hermes_struct_init(hermes_t *hw, void __iomem *address, int reg_spacing)
 {
 	hw->iobase = address;
@@ -126,7 +181,7 @@ EXPORT_SYMBOL(hermes_struct_init);
 
 int hermes_init(hermes_t *hw)
 {
-	u16 status, reg;
+	u16 reg;
 	int err = 0;
 	int k;
 
@@ -164,43 +219,8 @@ int hermes_init(hermes_t *hw)
 
 	/* We don't use hermes_docmd_wait here, because the reset wipes
 	   the magic constant in SWSUPPORT0 away, and it gets confused */
-	err = hermes_issue_cmd(hw, HERMES_CMD_INIT, 0, 0, 0);
-	if (err)
-		return err;
-
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
+	err = hermes_doicmd_wait(hw, HERMES_CMD_INIT, 0, 0, 0, NULL);
 
-	if (status & HERMES_STATUS_RESULT)
-		err = -EIO;
-
- out:
 	return err;
 }
 EXPORT_SYMBOL(hermes_init);
diff --git a/drivers/net/wireless/hermes.h b/drivers/net/wireless/hermes.h
index 8e3f0e3..287f536 100644
--- a/drivers/net/wireless/hermes.h
+++ b/drivers/net/wireless/hermes.h
@@ -353,6 +353,9 @@ void hermes_struct_init(hermes_t *hw, void __iomem *address, int reg_spacing);
 int hermes_init(hermes_t *hw);
 int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
 		      struct hermes_response *resp);
+int hermes_doicmd_wait(hermes_t *hw, u16 cmd,
+		       u16 parm0, u16 parm1, u16 parm2,
+		       struct hermes_response *resp);
 int hermes_allocate(hermes_t *hw, u16 size, u16 *fid);
 
 int hermes_bap_pread(hermes_t *hw, int bap, void *buf, int len,
-- 
1.5.4.5

