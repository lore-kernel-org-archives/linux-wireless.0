Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:38651 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752645AbeEUMJB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 08:09:01 -0400
From: Yisheng Xie <xieyisheng1@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Yisheng Xie <xieyisheng1@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 07/33] iwlwifi: mvm: use match_string() helper
Date: Mon, 21 May 2018 19:57:44 +0800
Message-ID: <1526903890-35761-8-git-send-email-xieyisheng1@huawei.com> (sfid-20180521_141749_746183_05F583BC)
In-Reply-To: <1526903890-35761-1-git-send-email-xieyisheng1@huawei.com>
References: <1526903890-35761-1-git-send-email-xieyisheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

match_string() returns the index of an array for a matching string,
which can be used intead of open coded variant.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 0e6401c..e8249a6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -671,14 +671,9 @@ static ssize_t iwl_dbgfs_bt_cmd_read(struct file *file, char __user *user_buf,
 	};
 	int ret, bt_force_ant_mode;
 
-	for (bt_force_ant_mode = 0;
-	     bt_force_ant_mode < ARRAY_SIZE(modes_str);
-	     bt_force_ant_mode++) {
-		if (!strcmp(buf, modes_str[bt_force_ant_mode]))
-			break;
-	}
-
-	if (bt_force_ant_mode >= ARRAY_SIZE(modes_str))
+	bt_force_ant_mode = match_string(modes_str,
+					 ARRAY_SIZE(modes_str), buf);
+	if (bt_force_ant_mode < 0)
 		return -EINVAL;
 
 	ret = 0;
-- 
1.7.12.4
