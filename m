Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33216 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753356AbcGFKlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:41:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:03 +0300
Message-Id: <1467801651-1816-8-git-send-email-luca@coelho.fi> (sfid-20160706_124132_092072_429AB2B6)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 08/56] iwlwifi: mvm: silence uninitialized variable warning
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

"max_amsdu_len" isn't set if kstrtouint() fails.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 406cf1c..b344898 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1020,6 +1020,8 @@ static ssize_t iwl_dbgfs_max_amsdu_len_write(struct iwl_mvm *mvm,
 	int ret;
 
 	ret = kstrtouint(buf, 0, &max_amsdu_len);
+	if (ret)
+		return ret;
 
 	if (max_amsdu_len > IEEE80211_MAX_MPDU_LEN_VHT_11454)
 		return -EINVAL;
-- 
2.8.1

