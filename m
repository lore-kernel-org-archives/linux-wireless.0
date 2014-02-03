Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:49874 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBCU63 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:29 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so3868937eei.35
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:28 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/62] iwlwifi: pcie: make FH debugfs file code easier to understand
Date: Mon,  3 Feb 2014 22:57:14 +0200
Message-Id: <1391461088-8082-8-git-send-email-egrumbach@gmail.com> (sfid-20140203_220007_293282_F229CC60)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code seems fine, as buf won't be assigned when an error
is returned, but checking for the error first is easier to
understand.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 7290f42..61ae1af 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1434,16 +1434,15 @@ static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
 {
 	struct iwl_trans *trans = file->private_data;
 	char *buf = NULL;
-	int pos = 0;
-	ssize_t ret = -EFAULT;
-
-	ret = pos = iwl_dump_fh(trans, &buf);
-	if (buf) {
-		ret = simple_read_from_buffer(user_buf,
-					      count, ppos, buf, pos);
-		kfree(buf);
-	}
+	ssize_t ret;
 
+	ret = iwl_dump_fh(trans, &buf);
+	if (ret < 0)
+		return ret;
+	if (!buf)
+		return -EINVAL;
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+	kfree(buf);
 	return ret;
 }
 
-- 
1.7.9.5

