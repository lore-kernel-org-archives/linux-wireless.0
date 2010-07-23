Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9523 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760328Ab0GWQN6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 12:13:58 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/10] iwlwifi: reduce beacon fill conditions
Date: Fri, 23 Jul 2010 09:15:38 -0700
Message-Id: <1279901739-10541-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the ibss_beacon variable will only be
filled in the appropriate modes, there's no
reason to be checking the mode again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 +---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f8f8ea2..9a78189 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -292,9 +292,7 @@ static u32 iwl_fill_beacon_frame(struct iwl_priv *priv,
 					  struct ieee80211_hdr *hdr,
 					  int left)
 {
-	if (!iwl_is_associated(priv) || !priv->ibss_beacon ||
-	    ((priv->iw_mode != NL80211_IFTYPE_ADHOC) &&
-	     (priv->iw_mode != NL80211_IFTYPE_AP)))
+	if (!priv->ibss_beacon)
 		return 0;
 
 	if (priv->ibss_beacon->len > left)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8eb3471..9a7209d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -311,9 +311,7 @@ unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 				int left)
 {
 
-	if (!iwl_is_associated(priv) || !priv->ibss_beacon ||
-	    ((priv->iw_mode != NL80211_IFTYPE_ADHOC) &&
-	     (priv->iw_mode != NL80211_IFTYPE_AP)))
+	if (!iwl_is_associated(priv) || !priv->ibss_beacon)
 		return 0;
 
 	if (priv->ibss_beacon->len > left)
-- 
1.7.0.4

