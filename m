Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54528 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbaJUQFB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 12:05:01 -0400
Received: by mail-wi0-f180.google.com with SMTP id em10so2307755wid.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 09:04:59 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/8] iwlwifi: mvm: Add tx power condition to bss_info_changed_ap_ibss
Date: Tue, 21 Oct 2014 19:04:36 +0300
Message-Id: <1413907479-9073-5-git-send-email-egrumbach@gmail.com> (sfid-20141021_180524_838308_4C7A67DC)
In-Reply-To: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
References: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

The tx power should be limited from many reasons.
currently, setting the tx power is available by the mvm only for
station interface. Adding the tx power condition to
bss_info_changed_ap_ibss make it available also for AP.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index c7a73c6..892a6bc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1734,6 +1734,13 @@ iwl_mvm_bss_info_changed_ap_ibss(struct iwl_mvm *mvm,
 	if (changes & BSS_CHANGED_BEACON &&
 	    iwl_mvm_mac_ctxt_beacon_changed(mvm, vif))
 		IWL_WARN(mvm, "Failed updating beacon data\n");
+
+	if (changes & BSS_CHANGED_TXPOWER) {
+		IWL_DEBUG_CALIB(mvm, "Changing TX Power to %d\n",
+				bss_conf->txpower);
+		iwl_mvm_set_tx_power(mvm, vif, bss_conf->txpower);
+	}
+
 }
 
 static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
-- 
1.9.1

