Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754657AbYENX1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 19:27:19 -0400
Message-Id: <200805142326.m4ENQFEV027079@imap1.linux-foundation.org> (sfid-20080515_012722_124144_6EABDEEB)
Subject: [patch 01/12] wireless: fix "iwlwifi: unify init driver flow"
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	ron.rindjunsky@intel.com, sfr@canb.auug.org.au,
	tomas.winkler@intel.com
From: akpm@linux-foundation.org
Date: Wed, 14 May 2008 16:26:15 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/wireless/iwlwifi/iwl-core.c: In function 'iwlcore_init_geos':
drivers/net/wireless/iwlwifi/iwl-core.c:323: error: implicit declaration of function 'iwlcore_init_ht_hw_capab'

This (or something like it) should be folded into the base patch to avoid
breaking bisection, please.

Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl-core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/net/wireless/iwlwifi/iwl-core.c~wireless-fix-iwlwifi-unify-init-driver-flow drivers/net/wireless/iwlwifi/iwl-core.c
--- a/drivers/net/wireless/iwlwifi/iwl-core.c~wireless-fix-iwlwifi-unify-init-driver-flow
+++ a/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -259,6 +259,12 @@ static void iwlcore_init_ht_hw_capab(con
 	if (priv->hw_params.tx_chains_num >= 3)
 		ht_info->supp_mcs_set[2] = 0xFF;
 }
+#else
+static inline void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
+			      struct ieee80211_ht_info *ht_info,
+			      enum ieee80211_band band)
+{
+}
 #endif /* CONFIG_IWL4965_HT */
 
 static void iwlcore_init_hw_rates(struct iwl_priv *priv,
_
