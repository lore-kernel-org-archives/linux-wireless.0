Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:45152 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaIOFNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:38 -0400
Received: by mail-we0-f169.google.com with SMTP id w61so3397730wes.0
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:37 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/28] iwlwifi: mvm: update QoS parameters when they change
Date: Mon, 15 Sep 2014 08:12:55 +0300
Message-Id: <1410757980-2138-23-git-send-email-egrumbach@gmail.com> (sfid-20140915_073115_333086_05F6EA16)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The QoS parameters can change during the lifetime of the BSS,
and more importantly hostapd only sets up the correct ones
after having started the AP/GO. Resend the MAC context when
the parameters change, with the updated parameters.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index e4d62f2..56901f8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1739,7 +1739,7 @@ iwl_mvm_bss_info_changed_ap_ibss(struct iwl_mvm *mvm,
 		return;
 
 	if (changes & (BSS_CHANGED_ERP_CTS_PROT | BSS_CHANGED_HT |
-		       BSS_CHANGED_BANDWIDTH) &&
+		       BSS_CHANGED_BANDWIDTH | BSS_CHANGED_QOS) &&
 	    iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL))
 		IWL_ERR(mvm, "failed to update MAC %pM\n", vif->addr);
 
-- 
1.9.1

