Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39233 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaBWT5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:21 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi5so2360331wib.2
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:19 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/17] iwlwifi: mvm: add debugfs for prph reg read/write
Date: Sun, 23 Feb 2014 21:56:56 +0200
Message-Id: <1393185428-8524-5-git-send-email-egrumbach@gmail.com> (sfid-20140223_205733_275771_96F8F4E1)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Allow reading/writing prph registers.

The address is set in the first argument
of the write operation. second argument
is optional and can be used for writing.

e.g.
echo '0xA01234 0x99' > /sys/kernel/debug/ieee80211/phy0/iwlwifi/iwlmvm/prph_reg
will write 0x99 into reg 0xA01234

cat /sys/kernel/debug/ieee80211/phy0/iwlwifi/iwlmvm/prph_reg
will show its current value (probably 0x99)

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |   44 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |    1 +
 2 files changed, 45 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 6853e5e..9b98337 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -907,6 +907,49 @@ static ssize_t iwl_dbgfs_d0i3_refs_write(struct iwl_mvm *mvm, char *buf,
 #define MVM_DEBUGFS_ADD_FILE(name, parent, mode) \
 	MVM_DEBUGFS_ADD_FILE_ALIAS(#name, name, parent, mode)
 
+static ssize_t
+iwl_dbgfs_prph_reg_read(struct file *file,
+			char __user *user_buf,
+			size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	int pos = 0;
+	char buf[32];
+	const size_t bufsz = sizeof(buf);
+
+	if (!mvm->dbgfs_prph_reg_addr)
+		return -EINVAL;
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Reg 0x%x: (0x%x)\n",
+		mvm->dbgfs_prph_reg_addr,
+		iwl_read_prph(mvm->trans, mvm->dbgfs_prph_reg_addr));
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
+static ssize_t
+iwl_dbgfs_prph_reg_write(struct iwl_mvm *mvm, char *buf,
+			 size_t count, loff_t *ppos)
+{
+	u8 args;
+	u32 value;
+
+	args = sscanf(buf, "%i %i", &mvm->dbgfs_prph_reg_addr, &value);
+	/* if we only want to set the reg address - nothing more to do */
+	if (args == 1)
+		goto out;
+
+	/* otherwise, make sure we have both address and value */
+	if (args != 2)
+		return -EINVAL;
+
+	iwl_write_prph(mvm->trans, mvm->dbgfs_prph_reg_addr, value);
+out:
+	return count;
+}
+
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(prph_reg, 64);
+
 /* Device wide debugfs entries */
 MVM_DEBUGFS_WRITE_FILE_OPS(tx_flush, 16);
 MVM_DEBUGFS_WRITE_FILE_OPS(sta_drain, 8);
@@ -951,6 +994,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(fw_nmi, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(scan_ant_rxchain, mvm->debugfs_dir,
 			     S_IWUSR | S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE(prph_reg, mvm->debugfs_dir, S_IWUSR | S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(d0i3_refs, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index bde8190..29d11d9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -518,6 +518,7 @@ struct iwl_mvm {
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct dentry *debugfs_dir;
 	u32 dbgfs_sram_offset, dbgfs_sram_len;
+	u32 dbgfs_prph_reg_addr;
 	bool disable_power_off;
 	bool disable_power_off_d3;
 
-- 
1.7.9.5

