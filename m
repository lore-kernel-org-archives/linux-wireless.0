Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39164 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752511AbdBHL2X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 06:28:23 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 13:23:09 +0200
Message-Id: <20170208112322.29413-5-luca@coelho.fi> (sfid-20170208_122859_672091_96F9059B)
In-Reply-To: <20170208112322.29413-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
Subject: [PATCH 04/17] iwlwifi: pcie: Re-configure IVAR table after stop device
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

When getting RF_KILL and disabling radio, the device gets stopped
and reset. This erases the IVAR table that matches the interrupt
to its cause, and is essential for MSIX proper functionality.
Till now, the table wasn't re-configured after the reset, and
therefore the interrupt that enabled radio didn't fire on the
right irq, and the driver didn't handle it correctly.

To fix this, configure the IVAR table again after resetting the
device.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index bb2a9a151957..7f05fc56587a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1246,6 +1246,15 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 	usleep_range(1000, 2000);
 
 	/*
+	 * Upon stop, the IVAR table gets erased, so msi-x won't
+	 * work. This causes a bug in RF-KILL flows, since the interrupt
+	 * that enables radio won't fire on the correct irq, and the
+	 * driver won't be able to handle the interrupt.
+	 * Configure the IVAR table again after reset.
+	 */
+	iwl_pcie_conf_msix_hw(trans_pcie);
+
+	/*
 	 * Upon stop, the APM issues an interrupt if HW RF kill is set.
 	 * This is a bug in certain verions of the hardware.
 	 * Certain devices also keep sending HW RF kill interrupt all
-- 
2.11.0
