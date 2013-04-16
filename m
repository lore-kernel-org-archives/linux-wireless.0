Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148Ab3DPNh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 09:37:28 -0400
Date: Tue, 16 Apr 2013 15:38:29 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] iwlwifi: fix freeing uninitialized pointer
Message-ID: <20130416133828.GA20024@redhat.com> (sfid-20130416_153732_618259_B802848A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If on iwl_dump_nic_event_log() error occurs before that function
initialize buf, we process uninitiated pointer in
iwl_dbgfs_log_event_read() and can hit "BUG at mm/slub.c:3409"

Resolves:
https://bugzilla.redhat.com/show_bug.cgi?id=951241

Reported-by: ian.odette@eprize.com
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
Patch is only compile tested, but I'm sure it fixes the problem.

 drivers/net/wireless/iwlwifi/dvm/debugfs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index 7b8178b..cb6dd58 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -2237,15 +2237,15 @@ static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 					 size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = file->private_data;
-	char *buf;
-	int pos = 0;
-	ssize_t ret = -ENOMEM;
+	char *buf = NULL;
+	ssize_t ret;
 
-	ret = pos = iwl_dump_nic_event_log(priv, true, &buf, true);
-	if (buf) {
-		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-		kfree(buf);
-	}
+	ret = iwl_dump_nic_event_log(priv, true, &buf, true);
+	if (ret < 0)
+		goto err;
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+err:
+	kfree(buf);
 	return ret;
 }
 
-- 
1.7.11.7

