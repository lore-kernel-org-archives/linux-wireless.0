Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15281 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760102AbZKFWxD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:03 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/20] iwlwifi: do not base station's sm_ps setting on AP
Date: Fri,  6 Nov 2009 14:52:56 -0800
Message-Id: <1257547983-12590-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Do not use AP's SM_PS setting for our own SM_PS setting.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e5854a9..7ffa0f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2317,12 +2317,6 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 					>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
 			maxstreams += 1;
 
-			ht_conf->sm_ps =
-				(u8)((ht_cap->cap & IEEE80211_HT_CAP_SM_PS)
-				>> 2);
-			IWL_DEBUG_MAC80211(priv, "sm_ps: 0x%x\n",
-				ht_conf->sm_ps);
-
 			if ((ht_cap->mcs.rx_mask[1] == 0) &&
 			    (ht_cap->mcs.rx_mask[2] == 0))
 				ht_conf->single_chain_sufficient = true;
-- 
1.5.6.3

