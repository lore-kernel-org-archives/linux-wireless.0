Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55747 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbaEORFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:07 -0400
Received: by mail-wg0-f46.google.com with SMTP id n12so3812097wgh.29
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:05 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/24] iwlwifi: mvm: Disable uAPSD for a DCM client
Date: Thu, 15 May 2014 20:04:26 +0300
Message-Id: <1400173481-9047-9-git-send-email-egrumbach@gmail.com> (sfid-20140515_190613_088572_5CDB3FBC)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

A binding object associates virtual MACs to a Phy.
Binding object can ask (and get) air time, thus
allowing several MACs to share the medium.
A binding object can be in either one of 3 states:
1) standalone - A single active MAC
2) Different Channel Mode (DCM) - There are 2 active
   MACs or more (not necessarily just clients), but each
   has its own channel.
3) Same Channel Mode (SCM) - There are 2 active
   MACs or more (not necessarily just clients), that
   share the same channel.
This patch introduces an additional condition for enabling uAPSD:
uAPSD should be disabled for a client in DCM.
The reason for that is a low latency issue in Miracast.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 258405f..9985273 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -268,10 +268,30 @@ static void iwl_mvm_power_configure_uapsd(struct iwl_mvm *mvm,
 		IWL_MVM_PS_HEAVY_RX_THLD_PERCENT;
 }
 
+static void iwl_mvm_binding_iterator(void *_data, u8 *mac,
+				      struct ieee80211_vif *vif)
+{
+	unsigned long *data = _data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (!mvmvif->phy_ctxt)
+		return;
+
+	if (vif->type == NL80211_IFTYPE_STATION ||
+	    vif->type == NL80211_IFTYPE_AP)
+		__set_bit(mvmvif->phy_ctxt->id, data);
+}
+
 static bool iwl_mvm_power_allow_uapsd(struct iwl_mvm *mvm,
 				       struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	unsigned long phy_ctxt_counter = 0;
+
+	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   iwl_mvm_binding_iterator,
+						   &phy_ctxt_counter);
 
 	if (!memcmp(mvmvif->uapsd_misbehaving_bssid, vif->bss_conf.bssid,
 		    ETH_ALEN))
@@ -289,6 +309,13 @@ static bool iwl_mvm_power_allow_uapsd(struct iwl_mvm *mvm,
 	    IEEE80211_P2P_OPPPS_ENABLE_BIT))
 		return false;
 
+	/*
+	 * Avoid using uAPSD if client is in DCM -
+	 * low latency issue in Miracast
+	 */
+	if (hweight8(phy_ctxt_counter) >= 2)
+		return false;
+
 	return true;
 }
 
-- 
1.8.3.2

