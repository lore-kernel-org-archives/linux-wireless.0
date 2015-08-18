Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbbHRH6Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:24 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/26] iwlwifi: convert hex_dump_to_buffer() to %*ph
Date: Tue, 18 Aug 2015 10:57:28 +0300
Message-Id: <1439884656-18146-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100109_824615_9AFA9E11)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

There is no need to use hex_dump_to_buffer() in the cases like this:

	hexdump_to_buffer(buf, len, 16, 1, outbuf, outlen, false);	/* len <= 16 */
	sprintf("%s\n", outbuf);

since it maybe easily converted to simple:

	sprintf("%*ph\n", len, buf);

Note: it seems in one case the output is groupped by 2 bytes and looks like a
typo. Thus, patch changes that to plain byte stream.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/debugfs.c | 8 ++------
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 7 +------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index 0ffb6ff..b15e44f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -310,12 +310,8 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	pos += scnprintf(buf + pos, buf_size - pos,
 			 "NVM version: 0x%x\n", nvm_ver);
 	for (ofs = 0 ; ofs < eeprom_len ; ofs += 16) {
-		pos += scnprintf(buf + pos, buf_size - pos, "0x%.4x ", ofs);
-		hex_dump_to_buffer(ptr + ofs, 16 , 16, 2, buf + pos,
-				   buf_size - pos, 0);
-		pos += strlen(buf + pos);
-		if (buf_size - pos > 0)
-			buf[pos++] = '\n';
+		pos += scnprintf(buf + pos, buf_size - pos, "0x%.4x %16ph\n",
+				 ofs, ptr + ofs);
 	}
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 17d7a05..ca4a1f8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1200,12 +1200,7 @@ static ssize_t iwl_dbgfs_d3_sram_read(struct file *file, char __user *user_buf,
 	if (ptr) {
 		for (ofs = 0; ofs < len; ofs += 16) {
 			pos += scnprintf(buf + pos, bufsz - pos,
-					 "0x%.4x ", ofs);
-			hex_dump_to_buffer(ptr + ofs, 16, 16, 1, buf + pos,
-					   bufsz - pos, false);
-			pos += strlen(buf + pos);
-			if (bufsz - pos > 0)
-				buf[pos++] = '\n';
+					 "0x%.4x %16ph\n", ofs, ptr + ofs);
 		}
 	} else {
 		pos += scnprintf(buf + pos, bufsz - pos,
-- 
2.1.4

