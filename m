Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:58253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365AbYHUW2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:28:25 -0400
Received: by nf-out-0910.google.com with SMTP id d3so81281nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:28:25 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 04/19] orinoco: Move EXPORT_SYMBOL declarations next to exported function
Date: Thu, 21 Aug 2008 23:27:49 +0100
Message-Id: <77df696e5b53b5e4db3b8c8e70b23cf5aaa2aca2.1219352674.git.kilroyd@gmail.com> (sfid-20080822_002828_312512_3A29E0A2)
In-Reply-To: <6e9e9826934e0256adbe561e587f93212e042bf2.1219352674.git.kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
 <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
 <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com>
 <6e9e9826934e0256adbe561e587f93212e042bf2.1219352674.git.kilroyd@gmail.com>
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/hermes.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/hermes.c b/drivers/net/wireless/hermes.c
index 3a6ce5a..240118f 100644
--- a/drivers/net/wireless/hermes.c
+++ b/drivers/net/wireless/hermes.c
@@ -122,6 +122,7 @@ void hermes_struct_init(hermes_t *hw, void __iomem *address, int reg_spacing)
 	hw->reg_spacing = reg_spacing;
 	hw->inten = 0x0;
 }
+EXPORT_SYMBOL(hermes_struct_init);
 
 int hermes_init(hermes_t *hw)
 {
@@ -202,6 +203,7 @@ int hermes_init(hermes_t *hw)
  out:
 	return err;
 }
+EXPORT_SYMBOL(hermes_init);
 
 /* Issue a command to the chip, and (busy!) wait for it to
  * complete.
@@ -272,6 +274,7 @@ int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
  out:
 	return err;
 }
+EXPORT_SYMBOL(hermes_docmd_wait);
 
 int hermes_allocate(hermes_t *hw, u16 size, u16 *fid)
 {
@@ -314,7 +317,7 @@ int hermes_allocate(hermes_t *hw, u16 size, u16 *fid)
 	
 	return 0;
 }
-
+EXPORT_SYMBOL(hermes_allocate);
 
 /* Set up a BAP to read a particular chunk of data from card's internal buffer.
  *
@@ -398,6 +401,7 @@ int hermes_bap_pread(hermes_t *hw, int bap, void *buf, int len,
  out:
 	return err;
 }
+EXPORT_SYMBOL(hermes_bap_pread);
 
 /* Write a block of data to the chip's buffer, via the
  * BAP. Synchronization/serialization is the caller's problem.
@@ -423,6 +427,7 @@ int hermes_bap_pwrite(hermes_t *hw, int bap, const void *buf, int len,
  out:	
 	return err;
 }
+EXPORT_SYMBOL(hermes_bap_pwrite);
 
 /* Read a Length-Type-Value record from the card.
  *
@@ -476,6 +481,7 @@ int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, unsigned bufsize,
 
 	return 0;
 }
+EXPORT_SYMBOL(hermes_read_ltv);
 
 int hermes_write_ltv(hermes_t *hw, int bap, u16 rid, 
 		     u16 length, const void *value)
@@ -503,15 +509,6 @@ int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
 
 	return err;
 }
-
-EXPORT_SYMBOL(hermes_struct_init);
-EXPORT_SYMBOL(hermes_init);
-EXPORT_SYMBOL(hermes_docmd_wait);
-EXPORT_SYMBOL(hermes_allocate);
-
-EXPORT_SYMBOL(hermes_bap_pread);
-EXPORT_SYMBOL(hermes_bap_pwrite);
-EXPORT_SYMBOL(hermes_read_ltv);
 EXPORT_SYMBOL(hermes_write_ltv);
 
 static int __init init_hermes(void)
-- 
1.5.6.4

