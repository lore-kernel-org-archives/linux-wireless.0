Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab2GEIZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 04:25:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "Richard A. Griffiths" <richardx.a.griffiths@intel.com>
Subject: [PATCH 9/9] iwlwifi: disallow log_event access if interface down
Date: Thu,  5 Jul 2012 10:24:55 +0200
Message-Id: <1341476695-6889-10-git-send-email-johannes@sipsolutions.net> (sfid-20120705_102524_736216_C141F536)
In-Reply-To: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
References: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Richard A. Griffiths" <richardx.a.griffiths@intel.com>

'echo 1 > log_event' generates the bogus "MAC is in deep sleep"
or "Timeout waiting for hardware access" log messages when
the interface is down, we should just disallow accessing the
device through debugfs when it is down.

Signed-off-by: Richard A. Griffiths <richardx.a.griffiths@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/debugfs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index 8a2d9e6..b0f125c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -83,7 +83,7 @@ static ssize_t iwl_dbgfs_##name##_write(struct file *file,              \
 #define DEBUGFS_READ_FILE_OPS(name)                                     \
 	DEBUGFS_READ_FUNC(name);                                        \
 static const struct file_operations iwl_dbgfs_##name##_ops = {          \
-	.read = iwl_dbgfs_##name##_read,                       		\
+	.read = iwl_dbgfs_##name##_read,				\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
 };
@@ -2254,6 +2254,10 @@ static ssize_t iwl_dbgfs_log_event_write(struct file *file,
 	char buf[8];
 	int buf_size;
 
+	/* check that the interface is up */
+	if (!iwl_is_ready(priv))
+		return -EAGAIN;
+
 	memset(buf, 0, sizeof(buf));
 	buf_size = min(count, sizeof(buf) -  1);
 	if (copy_from_user(buf, user_buf, buf_size))
-- 
1.7.10

