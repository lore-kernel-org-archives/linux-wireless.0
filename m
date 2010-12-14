Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757597Ab0LNPqg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 10:46:36 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-next-2.6] iwlagn: fix witespace damage
Date: Tue, 14 Dec 2010 07:38:58 -0800
Message-Id: <1292341138-32093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

patch "iwlagn: check ready in iwlagn_bss_info_changed()" introduce
whitespace, fix it

please merge with the previous patch

Reported by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 4ed21bf..1a131dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -519,8 +519,8 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 
 	if (unlikely(!iwl_is_ready(priv))) {
-                IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
-                mutex_unlock(&priv->mutex);
+		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
+		mutex_unlock(&priv->mutex);
 		return;
         }
 
-- 
1.7.0.4

