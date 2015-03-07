Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:36711 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbbCGCkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 21:40:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kalle Valo <kvalo@codeaurora.org>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
References: <874mpy2gw5.fsf@kamboji.qca.qualcomm.com>
	<87fv9h7cwl.fsf@x220.int.ebiederm.org>
Date: Fri, 06 Mar 2015 20:37:03 -0600
In-Reply-To: <87fv9h7cwl.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Fri, 06 Mar 2015 20:35:22 -0600")
Message-ID: <8761ad7cts.fsf_-_@x220.int.ebiederm.org> (sfid-20150307_034048_491395_B363E5EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Subject: [PATCH net-next 2/2] iwlwifi: mvm: Fix the build of mvm/phy-ctxt.c with debugfs disabled
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


When attempting to build my kernel I get:

 CC      drivers/net/wireless/iwlwifi/mvm/phy-ctxt.o
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c: In function ‘iwl_mvm_phy_ctxt_cmd_data’:
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c:178:6: error: ‘struct iwl_mvm’ has no member named ‘dbgfs_rx_phyinfo’
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c:179:23: error: ‘struct iwl_mvm’ has no member named ‘dbgfs_rx_phyinfo’
make[6]: *** [drivers/net/wireless/iwlwifi/mvm/phy-ctxt.o] Error 1

Fix it by making the new code depend on debugfs.

Fixes: ddf89ab10a93e8b iwlwifi: mvm: allow to force the Rx chains from debugfs
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index 1bd10eda01f9..192b74bc8cf6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -175,8 +175,10 @@ static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
 	cmd->rxchain_info |= cpu_to_le32(idle_cnt << PHY_RX_CHAIN_CNT_POS);
 	cmd->rxchain_info |= cpu_to_le32(active_cnt <<
 					 PHY_RX_CHAIN_MIMO_CNT_POS);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (unlikely(mvm->dbgfs_rx_phyinfo))
 		cmd->rxchain_info = cpu_to_le32(mvm->dbgfs_rx_phyinfo);
+#endif
 
 	cmd->txchain_info = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
 }
-- 
2.2.1

