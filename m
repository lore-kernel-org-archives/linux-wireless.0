Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:17943 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbYHBKPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 06:15:04 -0400
Received: by nf-out-0910.google.com with SMTP id d3so537527nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 03:15:03 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH 04/19] orinoco: Move EXPORT_SYMBOL declarations next to exported function
Date: Sat,  2 Aug 2008 11:14:18 +0100
Message-Id: <1217672073-7094-5-git-send-email-kilroyd@gmail.com> (sfid-20080802_121507_829911_1548CCE0)
In-Reply-To: <1217672073-7094-4-git-send-email-kilroyd@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-3-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-4-git-send-email-kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/hermes.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/hermes.c b/drivers/net/wireless/hermes.c
index 5504155..aa95349 100644
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
1.5.4.5

