Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbbLAJ7b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:31 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Moshe Harel <moshe.harel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/41] iwlwifi: mvm: add bt settings to debugfs
Date: Tue,  1 Dec 2015 11:58:42 +0200
Message-Id: <1448963947-24302-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110311_568273_18D7E982)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Moshe Harel <moshe.harel@intel.com>

Add mplut and sync2sco and corunning to debugfs.

Signed-off-by: Moshe Harel <moshe.harel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 05928fb..2322c99 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -532,6 +532,13 @@ static ssize_t iwl_dbgfs_bt_notif_read(struct file *file, char __user *user_buf,
 				 mvm->last_ant_isol, mvm->last_corun_lut);
 	}
 
+	pos += scnprintf(buf + pos, bufsz - pos, "sync_sco = %d\n",
+			 IWL_MVM_BT_COEX_SYNC2SCO);
+	pos += scnprintf(buf + pos, bufsz - pos, "mplut = %d\n",
+			 IWL_MVM_BT_COEX_MPLUT);
+	pos += scnprintf(buf + pos, bufsz - pos, "corunning = %d\n",
+			 IWL_MVM_BT_COEX_CORUNNING);
+
 	mutex_unlock(&mvm->mutex);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-- 
2.5.0

