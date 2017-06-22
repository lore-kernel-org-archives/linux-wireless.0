Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34250 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753765AbdFVVVQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:41 +0300
Message-Id: <20170622212101.16422-6-luca@coelho.fi> (sfid-20170622_232121_413831_24B8530F)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 05/25] iwlwifi: mvm: avoid unnecessary cache trashing in Tx path
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When sending a Tx Command with a Tx packet, we allocate the
Tx command separately from the payload of the packet.
The WiFi MAC header is then copied into the buffer that was
allocated for the Tx Command. This means that this buffer
needs to be big enough to contain both. This is why it is
allocated with iwl_trans_alloc_tx_cmd which returns a
pointer to a newly allocated not zeroed struct
iwl_device_cmd.

The Tx command has a few bit fields and hence it needs to
be zeroed, but all the rest of the buffer doesn't need to
be zeroed since it will either be memcopy'ed with the MAC
header, or not even sent to the device.
This means that we don't need to zero all the
iwl_device_cmd structure, but rather only the size of
the iwl_tx_cmd structure.

Since sizeof(iwl_tx_cmd) - sizeof(iwl_tx_cmd) is about
260 bytes, this can avoid touching 4 cache lines for each
packet.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index aa3a3f336929..63b938028144 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -473,7 +473,10 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (unlikely(!dev_cmd))
 		return NULL;
 
-	memset(dev_cmd, 0, sizeof(*dev_cmd));
+	/* Make sure we zero enough of dev_cmd */
+	BUILD_BUG_ON(sizeof(struct iwl_tx_cmd_gen2) > sizeof(*tx_cmd));
+
+	memset(dev_cmd, 0, sizeof(dev_cmd->hdr) + sizeof(*tx_cmd));
 	dev_cmd->hdr.cmd = TX_CMD;
 
 	if (iwl_mvm_has_new_tx_api(mvm)) {
-- 
2.11.0
