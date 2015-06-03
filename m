Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbbFCHb6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:31:58 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/15] iwlwifi: dvm: enable IEEE80211_HW_SUPPORT_FAST_XMIT
Date: Wed,  3 Jun 2015 10:31:30 +0300
Message-Id: <1433316696-4612-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_093208_194870_38CA7C8C)
In-Reply-To: <1433316253.25661.3.camel@intel.com>
References: <1433316253.25661.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the firmware is responsible for duration calculation, the
driver can easily support fast-xmit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index ba7fc42..852461f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -112,6 +112,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 		    IEEE80211_HW_QUEUE_CONTROL |
 		    IEEE80211_HW_SUPPORTS_PS |
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
+		    IEEE80211_HW_SUPPORT_FAST_XMIT |
 		    IEEE80211_HW_WANT_MONITOR_VIF;
 
 	hw->offchannel_tx_hw_queue = IWL_AUX_QUEUE;
-- 
2.1.4

