Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39890 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbcEDGUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2016 02:20:09 -0400
Date: Wed, 4 May 2016 09:19:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Golan Ben-Ami <golan.ben.ami@intel.com>,
	Moshe Harel <moshe.harel@intel.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] iwlwifi: mvm: silence unintialized variable warning
Message-ID: <20160504061954.GD22064@mwanda> (sfid-20160504_082018_402266_72B57710)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"max_amsdu_len" isn't set if kstrtouint() fails.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 362a546..cb8db23 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1020,6 +1020,8 @@ static ssize_t iwl_dbgfs_max_amsdu_len_write(struct iwl_mvm *mvm,
 	int ret;
 
 	ret = kstrtouint(buf, 0, &max_amsdu_len);
+	if (ret)
+		return ret;
 
 	if (max_amsdu_len > IEEE80211_MAX_MPDU_LEN_VHT_11454)
 		return -EINVAL;
