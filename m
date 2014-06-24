Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39444 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaFXTjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:39:02 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so6571120wib.11
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:39:01 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/3] Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag"
Date: Tue, 24 Jun 2014 22:38:51 +0300
Message-Id: <1403638731-2381-3-git-send-email-egrumbach@gmail.com> (sfid-20140624_213909_282617_EDD53496)
In-Reply-To: <53A9D396.1020306@gmail.com>
References: <53A9D396.1020306@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

This reverts commit dc9a19296a872644f19a06d8eeb5db222d327b41.

3610 cards don't support UAPSD.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h       | 1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 0aa7c00..b1a3332 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -88,6 +88,7 @@
  *	P2P client interfaces simultaneously if they are in different bindings.
  * @IWL_UCODE_TLV_FLAGS_P2P_BSS_PS_SCM: support power save on BSS station and
  *	P2P client interfaces simultaneously if they are in same bindings.
+ * @IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT: General support for uAPSD
  * @IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD: P2P client supports uAPSD power save
  * @IWL_UCODE_TLV_FLAGS_BCAST_FILTERING: uCode supports broadcast filtering.
  * @IWL_UCODE_TLV_FLAGS_GO_UAPSD: AP/GO interfaces support uAPSD clients
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 7215f59..1cef708 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -303,6 +303,13 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 	}
 
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT &&
+	    !iwlwifi_mod_params.uapsd_disable) {
+		hw->flags |= IEEE80211_HW_SUPPORTS_UAPSD;
+		hw->uapsd_queues = IWL_UAPSD_AC_INFO;
+		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
+	}
+
 	hw->sta_data_size = sizeof(struct iwl_mvm_sta);
 	hw->vif_data_size = sizeof(struct iwl_mvm_vif);
 	hw->chanctx_data_size = sizeof(u16);
-- 
1.8.3.2

