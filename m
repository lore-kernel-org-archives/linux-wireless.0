Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22360 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbcCBH5d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:33 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/43] iwlwifi: mvm: allow to limit the A-MSDU from debugfs
Date: Wed,  2 Mar 2016 09:56:17 +0200
Message-Id: <1456905404-14435-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085736_038693_179CA93F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

in order to be able to tune the size of the desired A-MSDU
based on link condition, add a knob to modify the length
of the A-MSDU.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 19 +++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c      |  5 +++++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 54d0d7d..56e6b0b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -64,6 +64,7 @@
  *
  *****************************************************************************/
 #include <linux/vmalloc.h>
+#include <linux/ieee80211.h>
 
 #include "mvm.h"
 #include "fw-dbg.h"
@@ -1080,6 +1081,22 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_max_amsdu_len_write(struct iwl_mvm *mvm,
+					     char *buf, size_t count,
+					     loff_t *ppos)
+{
+	unsigned int max_amsdu_len;
+	int ret;
+
+	ret = kstrtouint(buf, 0, &max_amsdu_len);
+
+	if (max_amsdu_len > IEEE80211_MAX_MPDU_LEN_VHT_11454)
+		return -EINVAL;
+	mvm->max_amsdu_len = max_amsdu_len;
+
+	return count;
+}
+
 #define ADD_TEXT(...) pos += scnprintf(buf + pos, bufsz - pos, __VA_ARGS__)
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 static ssize_t iwl_dbgfs_bcast_filters_read(struct file *file,
@@ -1497,6 +1514,7 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(fw_dbg_conf, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_dbg_collect, 64);
 MVM_DEBUGFS_WRITE_FILE_OPS(cont_recording, 8);
+MVM_DEBUGFS_WRITE_FILE_OPS(max_amsdu_len, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(indirection_tbl,
 			   (IWL_RSS_INDIRECTION_TABLE_SIZE * 2));
 
@@ -1541,6 +1559,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(d0i3_refs, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_conf, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_collect, mvm->debugfs_dir, S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(max_amsdu_len, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(send_echo_cmd, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(cont_recording, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(indirection_tbl, mvm->debugfs_dir, S_IWUSR);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index bb811a2..416aedb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -861,6 +861,7 @@ struct iwl_mvm {
 
 	/* Indicate if device power save is allowed */
 	u8 ps_disabled; /* u8 instead of bool to ease debugfs_create_* usage */
+	unsigned int max_amsdu_len; /* used for debugfs only */
 
 	struct ieee80211_vif __rcu *csa_vif;
 	struct ieee80211_vif __rcu *csa_tx_blocked_vif;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index ff08b17..a5a55da1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -448,6 +448,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	bool ipv4 = (skb->protocol == htons(ETH_P_IP));
 	u16 ip_base_id = ipv4 ? ntohs(ip_hdr(skb)->id) : 0;
 	u16 amsdu_add, snap_ip_tcp, pad, i = 0;
+	unsigned int dbg_max_amsdu_len;
 	u8 *qc, tid;
 
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
@@ -477,6 +478,10 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	}
 
 	max_amsdu_len = sta->max_amsdu_len;
+	dbg_max_amsdu_len = ACCESS_ONCE(mvm->max_amsdu_len);
+	if (dbg_max_amsdu_len)
+		max_amsdu_len = min_t(unsigned int, max_amsdu_len,
+				      dbg_max_amsdu_len);
 
 	/*
 	 * Limit A-MSDU in A-MPDU to 4095 bytes when VHT is not
-- 
2.5.0

