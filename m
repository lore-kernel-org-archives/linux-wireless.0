Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51168 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbZLFT2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 14:28:50 -0500
Received: by ewy19 with SMTP id 19so4804642ewy.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Dec 2009 11:28:56 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: remove spare KERN_DEBUG
Date: Sun,  6 Dec 2009 19:28:47 +0000
Message-Id: <1260127727-29276-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A KERN_DEBUG didn't get removed when transitioning from printk to
pr_debug

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/hermes_dld.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hermes_dld.c b/drivers/net/wireless/orinoco/hermes_dld.c
index a3eefe1..6d5660d 100644
--- a/drivers/net/wireless/orinoco/hermes_dld.c
+++ b/drivers/net/wireless/orinoco/hermes_dld.c
@@ -427,7 +427,7 @@ int hermesi_program_init(hermes_t *hw, u32 offset)
 	if (err)
 		return err;
 
-	pr_debug(KERN_DEBUG PFX "Enabling volatile, EP 0x%08x\n", offset);
+	pr_debug(PFX "Enabling volatile, EP 0x%08x\n", offset);
 	err = hermes_doicmd_wait(hw,
 				 HERMES_PROGRAM_ENABLE_VOLATILE,
 				 offset & 0xFFFFu,
-- 
1.6.4.4

