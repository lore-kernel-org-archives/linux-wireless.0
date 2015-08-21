Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32272 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbbHUIsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 04:48:35 -0400
Date: Fri, 21 Aug 2015 11:48:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Eliad Peller <eliad@wizery.com>,
	Liad Kaufman <liad.kaufman@intel.com>,
	Matti Gottlieb <matti.gottlieb@intel.com>,
	Alexander Bondar <alexander.bondar@intel.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] iwlwifi: mvm: catch underflow error earlier
Message-ID: <20150821084821.GC25369@mwanda> (sfid-20150821_104844_403491_4F33B361)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My static checker complains that we don't check for underflows in
iwl_dbgfs_fw_dbg_conf_write().  This is harmless because we have a
sanity check in iwl_mvm_start_fw_dbg_conf(), but we may as well make
this unsigned and silence the underflow warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index ca4a1f8..7d69a55 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -949,9 +949,10 @@ static ssize_t iwl_dbgfs_fw_dbg_conf_write(struct iwl_mvm *mvm,
 					   char *buf, size_t count,
 					   loff_t *ppos)
 {
-	int ret, conf_id;
+	unsigned int conf_id;
+	int ret;
 
-	ret = kstrtoint(buf, 0, &conf_id);
+	ret = kstrtouint(buf, 0, &conf_id);
 	if (ret)
 		return ret;
 
