Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20549 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYFLBth (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:37 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 07/29] iwlwifi: use ieee80211_conf to examine rate capabilities
Date: Thu, 12 Jun 2008 09:46:57 +0800
Message-Id: <1213235239-2954-8-git-send-email-yi.zhu@intel.com> (sfid-20080612_034943_134587_9BF7F09F)
In-Reply-To: <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch switches the use of internal iwlwifi structure with
ieee80211_conf in order to examine ht rate capabilities.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 7f9178b..a928741 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -2245,25 +2245,19 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	 * active_siso_rate mask includes 9 MBits (bit 5), and CCK (bits 0-3),
 	 * supp_rates[] does not; shift to convert format, force 9 MBits off.
 	 */
-	lq_sta->active_siso_rate =
-		priv->current_ht_config.supp_mcs_set[0] << 1;
-	lq_sta->active_siso_rate |=
-		priv->current_ht_config.supp_mcs_set[0] & 0x1;
+	lq_sta->active_siso_rate = conf->ht_conf.supp_mcs_set[0] << 1;
+	lq_sta->active_siso_rate |= conf->ht_conf.supp_mcs_set[0] & 0x1;
 	lq_sta->active_siso_rate &= ~((u16)0x2);
 	lq_sta->active_siso_rate <<= IWL_FIRST_OFDM_RATE;
 
 	/* Same here */
-	lq_sta->active_mimo2_rate =
-		priv->current_ht_config.supp_mcs_set[1] << 1;
-	lq_sta->active_mimo2_rate |=
-		priv->current_ht_config.supp_mcs_set[1] & 0x1;
+	lq_sta->active_mimo2_rate = conf->ht_conf.supp_mcs_set[1] << 1;
+	lq_sta->active_mimo2_rate |= conf->ht_conf.supp_mcs_set[1] & 0x1;
 	lq_sta->active_mimo2_rate &= ~((u16)0x2);
 	lq_sta->active_mimo2_rate <<= IWL_FIRST_OFDM_RATE;
 
-	lq_sta->active_mimo3_rate =
-		priv->current_ht_config.supp_mcs_set[2] << 1;
-	lq_sta->active_mimo3_rate |=
-		priv->current_ht_config.supp_mcs_set[2] & 0x1;
+	lq_sta->active_mimo3_rate = conf->ht_conf.supp_mcs_set[2] << 1;
+	lq_sta->active_mimo3_rate |= conf->ht_conf.supp_mcs_set[2] & 0x1;
 	lq_sta->active_mimo3_rate &= ~((u16)0x2);
 	lq_sta->active_mimo3_rate <<= IWL_FIRST_OFDM_RATE;
 
-- 
1.5.3.6

