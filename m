Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39458 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751000AbdBHS3z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 13:29:55 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Golan Ben-Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 17:51:49 +0200
Message-Id: <20170208155149.1704-9-luca@coelho.fi> (sfid-20170208_193021_809570_3A82268B)
In-Reply-To: <20170208155149.1704-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
 <20170208155149.1704-1-luca@coelho.fi>
Subject: [PATCH 17/17] iwlwifi: mvm: avoid exceeding the allowed print length
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

Divide a mfuart related print so it won't exceed the allowed
MAX_MSG_LEN (110 bytes) per print.

Fixes: 19f63c531b85 ("iwlwifi: mvm: support v2 of mfuart load notification")
Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index c42ef8681b75..45cb4f476e76 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1396,19 +1396,15 @@ void iwl_mvm_rx_mfuart_notif(struct iwl_mvm *mvm,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mfuart_load_notif *mfuart_notif = (void *)pkt->data;
 
+	IWL_DEBUG_INFO(mvm,
+		       "MFUART: installed ver: 0x%08x, external ver: 0x%08x, status: 0x%08x, duration: 0x%08x\n",
+		       le32_to_cpu(mfuart_notif->installed_ver),
+		       le32_to_cpu(mfuart_notif->external_ver),
+		       le32_to_cpu(mfuart_notif->status),
+		       le32_to_cpu(mfuart_notif->duration));
+
 	if (iwl_rx_packet_payload_len(pkt) == sizeof(*mfuart_notif))
 		IWL_DEBUG_INFO(mvm,
-			       "MFUART: installed ver: 0x%08x, external ver: 0x%08x, status: 0x%08x, duration: 0x%08x, image size: 0x%08x\n",
-			       le32_to_cpu(mfuart_notif->installed_ver),
-			       le32_to_cpu(mfuart_notif->external_ver),
-			       le32_to_cpu(mfuart_notif->status),
-			       le32_to_cpu(mfuart_notif->duration),
+			       "MFUART: image size: 0x%08x\n",
 			       le32_to_cpu(mfuart_notif->image_size));
-	else
-		IWL_DEBUG_INFO(mvm,
-			       "MFUART: installed ver: 0x%08x, external ver: 0x%08x, status: 0x%08x, duration: 0x%08x\n",
-			       le32_to_cpu(mfuart_notif->installed_ver),
-			       le32_to_cpu(mfuart_notif->external_ver),
-			       le32_to_cpu(mfuart_notif->status),
-			       le32_to_cpu(mfuart_notif->duration));
 }
-- 
2.11.0
