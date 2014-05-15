Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49036 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaEORFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:05 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so3788350wgh.14
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:04 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/24] iwlwifi: mvm: Add power management support for P2P DCM
Date: Thu, 15 May 2014 20:04:25 +0300
Message-Id: <1400173481-9047-8-git-send-email-egrumbach@gmail.com> (sfid-20140515_190610_681037_965559FA)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

If two clients are active while each one is alone on its channel,
and the applicable flags are set, power management should be enabled.
This condition is referred to as Different Channel Mode (DCM).
Up to now, in DCM power management was supported only on BSS.
This patch adds support for P2P power management in DCM as well.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 78309f7..258405f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -613,11 +613,15 @@ iwl_mvm_power_set_pm(struct iwl_mvm *mvm,
 		ap_same_channel = (bss_mvmvif->phy_ctxt->id ==
 				   ap_mvmvif->phy_ctxt->id);
 
-	/* bss is not stand alone: enable PM if alone on its channel */
-	if (vifs->bss_active && !(client_same_channel || ap_same_channel) &&
+	/* clients are not stand alone: enable PM if DCM */
+	if (!(client_same_channel || ap_same_channel) &&
 	    (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM)) {
+		if (vifs->bss_active)
 			bss_mvmvif->pm_enabled = true;
-			return;
+		if (vifs->p2p_active &&
+		    (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PM))
+			p2p_mvmvif->pm_enabled = true;
+		return;
 	}
 
 	/*
-- 
1.8.3.2

