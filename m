Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37705 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718AbaJ2LvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:16 -0400
Received: by mail-wi0-f178.google.com with SMTP id q5so4315946wiv.17
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:14 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/25] iwlwifi: pcie: fix recovery from ARC reset in WoWLAN
Date: Wed, 29 Oct 2014 13:50:32 +0200
Message-Id: <1414583446-11032-11-git-send-email-egrumbach@gmail.com> (sfid-20141029_125202_168828_5D71244F)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When the ARC is reset when we exit from Sx in case we had
WoWLAN running, we can't access the prph before we reset
the NIC.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 5c9064f..aea0fe9 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1023,14 +1023,6 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 		return 0;
 	}
 
-	iwl_pcie_set_pwr(trans, false);
-
-	val = iwl_read32(trans, CSR_RESET);
-	if (val & CSR_RESET_REG_FLAG_NEVO_RESET) {
-		*status = IWL_D3_STATUS_RESET;
-		return 0;
-	}
-
 	/*
 	 * Also enables interrupts - none will happen as the device doesn't
 	 * know we're waking it up, only when the opmode actually tells it
@@ -1050,6 +1042,8 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 		return ret;
 	}
 
+	iwl_pcie_set_pwr(trans, false);
+
 	iwl_trans_pcie_tx_reset(trans);
 
 	ret = iwl_pcie_rx_init(trans);
@@ -1058,7 +1052,12 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 		return ret;
 	}
 
-	*status = IWL_D3_STATUS_ALIVE;
+	val = iwl_read32(trans, CSR_RESET);
+	if (val & CSR_RESET_REG_FLAG_NEVO_RESET)
+		*status = IWL_D3_STATUS_RESET;
+	else
+		*status = IWL_D3_STATUS_ALIVE;
+
 	return 0;
 }
 
-- 
1.9.1

