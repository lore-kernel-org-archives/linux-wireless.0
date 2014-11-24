Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52517 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaKXOfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:18 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so5861229wiv.6
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:17 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/75] iwlwifi: pcie: introduce delay when waking up the device
Date: Mon, 24 Nov 2014 16:33:50 +0200
Message-Id: <1416839691-28533-14-git-send-email-egrumbach@gmail.com> (sfid-20141124_154437_841281_36A1DD3E)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In some rare cases, the firmware can put the device to
sleep after the driver requested the access. This is
because the access request can take a short time to be
propagated to the firmware.

If that happens, the driver may think that it has access
since the firmware hasn't put the device to sleep yet, but
right after the driver's check, the firmware might put the
device to sleep.

Warn when this happens by allowing the firmware to finish
the "put the device sleep" flow so that the driver will
not get access to the device. This will make the issue
visible.

This still doesn't fix the race, but at least it makes
it more visible.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 5 +++++
 drivers/net/wireless/iwlwifi/pcie/tx.c    | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 40a2906..d872749 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1031,6 +1031,9 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 	iwl_set_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	iwl_set_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+		udelay(2);
+
 	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
 			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
@@ -1233,6 +1236,8 @@ static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans, bool silent,
 	/* this bit wakes up the NIC */
 	__iwl_trans_pcie_set_bit(trans, CSR_GP_CNTRL,
 				 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+		udelay(2);
 
 	/*
 	 * These bits say the device is running, and should keep running for
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index eb8e298..4a4104e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1431,6 +1431,9 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		trans_pcie->cmd_in_flight = true;
 		__iwl_trans_pcie_set_bit(trans, CSR_GP_CNTRL,
 					 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+		if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+			udelay(2);
+
 		ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
 				   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
 				   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
-- 
1.9.1

