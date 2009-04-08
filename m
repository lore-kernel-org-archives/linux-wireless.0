Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379AbZDHSdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:33:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/6] iwlwifi: check triple_stream_basic_rates in iwl_full_rxon_required
Date: Wed,  8 Apr 2009 11:39:30 -0700
Message-Id: <1239215972-1795-5-git-send-email-reinette.chatre@intel.com> (sfid-20090408_203406_509217_177106FA)
In-Reply-To: <1239215972-1795-4-git-send-email-reinette.chatre@intel.com>
References: <1239215972-1795-1-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-2-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-3-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

For completeness, we should also make sure that the 3x3 MIMO rates are also checked when seeing if one rxon struct matches another.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3b34b18..9fac8f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -735,6 +735,8 @@ int iwl_full_rxon_required(struct iwl_priv *priv)
 	     priv->active_rxon.ofdm_ht_single_stream_basic_rates) ||
 	    (priv->staging_rxon.ofdm_ht_dual_stream_basic_rates !=
 	     priv->active_rxon.ofdm_ht_dual_stream_basic_rates) ||
+	    (priv->staging_rxon.ofdm_ht_triple_stream_basic_rates !=
+	     priv->active_rxon.ofdm_ht_triple_stream_basic_rates) ||
 	    (priv->staging_rxon.assoc_id != priv->active_rxon.assoc_id))
 		return 1;
 
-- 
1.5.6.3

