Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:17943 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYHBKPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 06:15:00 -0400
Received: by nf-out-0910.google.com with SMTP id d3so537527nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 03:14:59 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH 03/19] orinoco: Specify all three parameters to every Hermes command.
Date: Sat,  2 Aug 2008 11:14:17 +0100
Message-Id: <1217672073-7094-4-git-send-email-kilroyd@gmail.com> (sfid-20080802_121503_272911_D0531427)
In-Reply-To: <1217672073-7094-3-git-send-email-kilroyd@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-3-git-send-email-kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hermes_issue_cmd now takes two more parameters.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/hermes.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/hermes.c b/drivers/net/wireless/hermes.c
index 29d3910..5504155 100644
--- a/drivers/net/wireless/hermes.c
+++ b/drivers/net/wireless/hermes.c
@@ -87,7 +87,8 @@ MODULE_LICENSE("Dual MPL/GPL");
 
    Callable from any context.
 */
-static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16 param0)
+static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16 param0,
+			    u16 param1, u16 param2)
 {
 	int k = CMD_BUSY_TIMEOUT;
 	u16 reg;
@@ -103,8 +104,8 @@ static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16 param0)
 		return -EBUSY;
 	}
 
-	hermes_write_regn(hw, PARAM2, 0);
-	hermes_write_regn(hw, PARAM1, 0);
+	hermes_write_regn(hw, PARAM2, param2);
+	hermes_write_regn(hw, PARAM1, param1);
 	hermes_write_regn(hw, PARAM0, param0);
 	hermes_write_regn(hw, CMD, cmd);
 	
@@ -162,7 +163,7 @@ int hermes_init(hermes_t *hw)
 
 	/* We don't use hermes_docmd_wait here, because the reset wipes
 	   the magic constant in SWSUPPORT0 away, and it gets confused */
-	err = hermes_issue_cmd(hw, HERMES_CMD_INIT, 0);
+	err = hermes_issue_cmd(hw, HERMES_CMD_INIT, 0, 0, 0);
 	if (err)
 		return err;
 
@@ -216,7 +217,7 @@ int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
 	u16 reg;
 	u16 status;
 
-	err = hermes_issue_cmd(hw, cmd, parm0);
+	err = hermes_issue_cmd(hw, cmd, parm0, 0, 0);
 	if (err) {
 		if (! hermes_present(hw)) {
 			if (net_ratelimit())
@@ -497,7 +498,7 @@ int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
 
 	hermes_write_bytes(hw, dreg, value, count << 1);
 
-	err = hermes_docmd_wait(hw, HERMES_CMD_ACCESS | HERMES_CMD_WRITE, 
+	err = hermes_docmd_wait(hw, HERMES_CMD_ACCESS | HERMES_CMD_WRITE,
 				rid, NULL);
 
 	return err;
-- 
1.5.4.5

