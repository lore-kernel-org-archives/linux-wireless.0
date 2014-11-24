Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57541 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbaKXOgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:51 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so5900363wiw.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:50 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 71/75] iwlwifi: mvm: declare support for VHT BF info in radiotap
Date: Mon, 24 Nov 2014 16:34:47 +0200
Message-Id: <1416839691-28533-71-git-send-email-egrumbach@gmail.com> (sfid-20141124_153658_348201_D1139576)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The driver knows whether an rx frame was beamformed and marks
it in the radiotap VHT flags. However it should also declare
that it knows to extract this info otherwise this gets discarded
by sniffers like Wireshark.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index d9d8d30..5dbf547 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -323,7 +323,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	hw->offchannel_tx_hw_queue = IWL_MVM_OFFCHANNEL_QUEUE;
 	hw->radiotap_mcs_details |= IEEE80211_RADIOTAP_MCS_HAVE_FEC |
 				    IEEE80211_RADIOTAP_MCS_HAVE_STBC;
-	hw->radiotap_vht_details |= IEEE80211_RADIOTAP_VHT_KNOWN_STBC;
+	hw->radiotap_vht_details |= IEEE80211_RADIOTAP_VHT_KNOWN_STBC |
+		IEEE80211_RADIOTAP_VHT_KNOWN_BEAMFORMED;
 	hw->rate_control_algorithm = "iwl-mvm-rs";
 
 	/*
-- 
1.9.1

