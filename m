Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17196 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab0KPQGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:43 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/18] iwlagn: avoid crash if vif is not assigned
Date: Tue, 16 Nov 2010 08:01:45 -0800
Message-Id: <1289923311-14920-13-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For reasons that aren't entirely clear to me,
we sometimes get here during hardware reset
without the interface being set. Don't crash,
but keep a warning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 2d927a9..fbaa8d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -507,6 +507,11 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
+	if (WARN_ON(!ctx->vif)) {
+		mutex_unlock(&priv->mutex);
+		return;
+	}
+
 	if (changes & BSS_CHANGED_BEACON_INT)
 		force = true;
 
-- 
1.7.0.4

