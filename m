Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47492 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751853AbdKYQe5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 11:34:57 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Adiel Aloni <adiel.aloni@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 18:34:41 +0200
Message-Id: <20171125163444.24258-9-luca@coelho.fi> (sfid-20171125_173509_269548_0F1E58D3)
In-Reply-To: <20171125163444.24258-1-luca@coelho.fi>
References: <20171125163444.24258-1-luca@coelho.fi>
Subject: [PATCH 08/11] iwlwifi: mvm: Add debugfs support for FTM initiator fields
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adiel Aloni <adiel.aloni@intel.com>

Add support to override common_calib and specific_calib FTM initatior
fields in debugfs.

Signed-off-by: Adiel Aloni <adiel.aloni@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 4228fac77f41..013b21d3aeb9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -950,6 +950,24 @@ static ssize_t iwl_dbgfs_tof_range_request_write(struct ieee80211_vif *vif,
 		goto out;
 	}
 
+	data = iwl_dbgfs_is_match("common_calib=", buf);
+	if (data) {
+		ret = kstrtou32(data, 10, &value);
+		if (ret == 0)
+			mvm->tof_data.range_req.common_calib =
+				cpu_to_le16(value);
+		goto out;
+	}
+
+	data = iwl_dbgfs_is_match("specific_calib=", buf);
+	if (data) {
+		ret = kstrtou32(data, 10, &value);
+		if (ret == 0)
+			mvm->tof_data.range_req.specific_calib =
+				cpu_to_le16(value);
+		goto out;
+	}
+
 	data = iwl_dbgfs_is_match("ap=", buf);
 	if (data) {
 		struct iwl_tof_range_req_ap_entry ap = {};
@@ -1033,6 +1051,10 @@ static ssize_t iwl_dbgfs_tof_range_request_read(struct file *file,
 			 cmd->macaddr_template);
 	pos += scnprintf(buf + pos, bufsz - pos, "macaddr_mask= %pM\n",
 			 cmd->macaddr_mask);
+	pos += scnprintf(buf + pos, bufsz - pos, "common_calib= %d\n",
+			 le16_to_cpu(cmd->common_calib));
+	pos += scnprintf(buf + pos, bufsz - pos, "specific_calib= %d\n",
+			 le16_to_cpu(cmd->specific_calib));
 	pos += scnprintf(buf + pos, bufsz - pos, "num_of_ap= %d\n",
 			 cmd->num_of_ap);
 	for (i = 0; i < cmd->num_of_ap; i++) {
-- 
2.15.0
