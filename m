Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:58253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbYHUW23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:28:29 -0400
Received: by nf-out-0910.google.com with SMTP id d3so81281nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:28:29 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 05/19] orinoco: Add function to execute Hermes initialisation commands synchronously
Date: Thu, 21 Aug 2008 23:27:50 +0100
Message-Id: <ac0da2799e97f5256019ad669f5a6c461bd0d82a.1219352674.git.kilroyd@gmail.com> (sfid-20080822_002832_389280_6485E6F6)
In-Reply-To: <77df696e5b53b5e4db3b8c8e70b23cf5aaa2aca2.1219352674.git.kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
 <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
 <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com>
 <6e9e9826934e0256adbe561e587f93212e042bf2.1219352674.git.kilroyd@gmail.com>
 <77df696e5b53b5e4db3b8c8e70b23cf5aaa2aca2.1219352674.git.kilroyd@gmail.com>
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
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
index 240118f..bfa3753 100644
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
1.5.6.4

