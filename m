Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:15324 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759110AbYHUW2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:28:22 -0400
Received: by ik-out-1112.google.com with SMTP id c28so104766ika.5
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:28:21 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 03/19] orinoco: Specify all three parameters to every Hermes command.
Date: Thu, 21 Aug 2008 23:27:48 +0100
Message-Id: <6e9e9826934e0256adbe561e587f93212e042bf2.1219352674.git.kilroyd@gmail.com> (sfid-20080822_002824_584698_B6F780A9)
In-Reply-To: <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
 <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
 <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com>
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hermes_issue_cmd now takes two more parameters.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/hermes.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/hermes.c b/drivers/net/wireless/hermes.c
index 2cd86af..3a6ce5a 100644
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
1.5.6.4

