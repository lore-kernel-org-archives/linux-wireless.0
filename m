Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41398 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbZHCTBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:01:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Martin Ettl <ettl.martin@gmx.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: avoid memory leak in iwl_dbgfs_nvm_read
Date: Mon,  3 Aug 2009 14:49:48 -0400
Message-Id: <1249325388-6496-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Martin Ettl <ettl.martin@gmx.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 11e08c0..6525e41 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -318,7 +318,8 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	ptr = priv->eeprom;
 	if (!ptr) {
 		IWL_ERR(priv, "Invalid EEPROM/OTP memory\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 	pos += scnprintf(buf + pos, buf_size - pos, "NVM Type: %s\n",
 			(priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
@@ -333,6 +334,8 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	}
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+
+out:
 	kfree(buf);
 	return ret;
 }
-- 
1.6.2.5

