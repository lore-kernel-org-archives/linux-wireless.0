Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:8226 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754723AbeEaLWl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 07:22:41 -0400
From: Yisheng Xie <xieyisheng1@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: <andy.shevchenko@gmail.com>, Yisheng Xie <xieyisheng1@huawei.com>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v2 06/21] iwlwifi: mvm: use match_string() helper
Date: Thu, 31 May 2018 19:11:11 +0800
Message-ID: <1527765086-19873-7-git-send-email-xieyisheng1@huawei.com> (sfid-20180531_132749_318224_80C54F89)
In-Reply-To: <1527765086-19873-1-git-send-email-xieyisheng1@huawei.com>
References: <1527765086-19873-1-git-send-email-xieyisheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

match_string() returns the index of an array for a matching string,
which can be used instead of open coded variant.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
---
v2:
 - let ret get return value of match_string  - per Andy

 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 0e6401c..d7ac511 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -671,16 +671,11 @@ static ssize_t iwl_dbgfs_bt_cmd_read(struct file *file, char __user *user_buf,
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
-		return -EINVAL;
+	ret = match_string(modes_str, ARRAY_SIZE(modes_str), buf);
+	if (ret < 0)
+		return ret;
 
+	bt_force_ant_mode = ret;
 	ret = 0;
 	mutex_lock(&mvm->mutex);
 	if (mvm->bt_force_ant_mode == bt_force_ant_mode)
-- 
1.7.12.4
