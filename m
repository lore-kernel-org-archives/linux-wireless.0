Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49556 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752245AbdIHJNW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 05:13:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>, stable@vger.kernel.org
Date: Fri,  8 Sep 2017 12:12:52 +0300
Message-Id: <20170908091256.25279-7-luca@coelho.fi> (sfid-20170908_111326_059984_583BFF73)
In-Reply-To: <20170908091256.25279-1-luca@coelho.fi>
References: <20170908091256.25279-1-luca@coelho.fi>
Subject: [PATCH 06/10] iwlwifi: mvm: use IWL_HCMD_NOCOPY for MCAST_FILTER_CMD
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The MCAST_FILTER_CMD can get quite large when we have many mcast
addresses to set (we support up to 255).  So the command should be
send as NOCOPY to prevent a warning caused by too-long commands:

WARNING: CPU: 0 PID: 9700 at /root/iwlwifi/stack-dev/drivers/net/wireless/intel/iwlwifi/pcie/tx.c:1550 iwl_pcie_enqueue_hcmd+0x8c7/0xb40 [iwlwifi]
Command MCAST_FILTER_CMD (0x1d0) is too large (328 bytes)

This fixes: https://bugzilla.kernel.org/show_bug.cgi?id=196743

Cc: stable@vger.kernel.org
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 3a6ce4222ff5..635db63f972e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1546,6 +1546,11 @@ static void iwl_mvm_mc_iface_iterator(void *_data, u8 *mac,
 	struct iwl_mvm_mc_iter_data *data = _data;
 	struct iwl_mvm *mvm = data->mvm;
 	struct iwl_mcast_filter_cmd *cmd = mvm->mcast_filter_cmd;
+	struct iwl_host_cmd hcmd = {
+		.id = MCAST_FILTER_CMD,
+		.flags = CMD_ASYNC,
+		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
+	};
 	int ret, len;
 
 	/* if we don't have free ports, mcast frames will be dropped */
@@ -1560,7 +1565,10 @@ static void iwl_mvm_mc_iface_iterator(void *_data, u8 *mac,
 	memcpy(cmd->bssid, vif->bss_conf.bssid, ETH_ALEN);
 	len = roundup(sizeof(*cmd) + cmd->count * ETH_ALEN, 4);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, MCAST_FILTER_CMD, CMD_ASYNC, len, cmd);
+	hcmd.len[0] = len;
+	hcmd.data[0] = cmd;
+
+	ret = iwl_mvm_send_cmd(mvm, &hcmd);
 	if (ret)
 		IWL_ERR(mvm, "mcast filter cmd error. ret=%d\n", ret);
 }
-- 
2.14.1
