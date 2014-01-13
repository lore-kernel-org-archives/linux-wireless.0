Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:53077 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaAMUWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:16 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so3577742ead.8
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:15 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/18] iwlwifi: mvm: fix SRAM dump debugfs handler
Date: Mon, 13 Jan 2014 22:21:49 +0200
Message-Id: <1389644517-22807-10-git-send-email-egrumbach@gmail.com> (sfid-20140113_213436_539176_90540348)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

If the length isn't set it means we want all the SRAM.
Also - this is perfectly valid to partially dump starting
at offset 0.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 76cdce9..369d4c9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -135,7 +135,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file, char __user *user_buf,
 	ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
 	len = img->sec[IWL_UCODE_SECTION_DATA].len;
 
-	if (!mvm->dbgfs_sram_offset && !mvm->dbgfs_sram_len) {
+	if (mvm->dbgfs_sram_len) {
 		ofs = mvm->dbgfs_sram_offset;
 		len = mvm->dbgfs_sram_len;
 	}
-- 
1.7.9.5

