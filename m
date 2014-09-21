Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41175 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaIUTWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:30 -0400
Received: by mail-wi0-f174.google.com with SMTP id fb4so1818624wid.13
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:22:29 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Assaf Krauss <assaf.krauss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/17] iwlwifi: mvm: Announce Quiet Period support
Date: Sun, 21 Sep 2014 22:22:04 +0300
Message-Id: <1411327338-23099-3-git-send-email-egrumbach@gmail.com> (sfid-20140921_212234_730446_B88CB33D)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

Add a ucode capability flag for support of Quiet Period (part of RRM).
If this flag is set, advertise device support.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h       | 6 ++++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 6ab40bc..081a93d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -148,10 +148,12 @@ enum iwl_ucode_tlv_api {
  * @IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT: supports insertion of current
  *	tx power value into TPC Report action frame and Link Measurement Report
  *	action frame
+ * @IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT: supports Quiet Period requests
  */
 enum iwl_ucode_tlv_capa {
-	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT		= BIT(0),
-	IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT = BIT(8),
+	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= BIT(0),
+	IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT	= BIT(8),
+	IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT		= BIT(11),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index ba029f6..5a169ab 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -415,6 +415,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (mvm->fw->ucode_capa.capa[0] &
 	    IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT)
 		hw->wiphy->features |= NL80211_FEATURE_TX_POWER_INSERTION;
+	if (mvm->fw->ucode_capa.capa[0] &
+	    IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT)
+		hw->wiphy->features |= NL80211_FEATURE_QUIET;
 
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 
-- 
1.9.1

