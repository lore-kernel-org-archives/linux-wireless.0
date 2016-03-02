Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34250 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbcCBH47 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:56:59 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/43] iwlwifi: mvm: rs: fix a theoretical access to uninitialized array elements
Date: Wed,  2 Mar 2016 09:56:08 +0200
Message-Id: <1456905404-14435-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085702_257256_201A70DE)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Klocwork is unhappy as ht_vht_rates might be accessed with
rate->index being set to values between 0 and 3 which will
lead to accessing uninitialized array elements. Effectively this
doesn't happen as in HT/VHT we're not using these rate indices.
Still fix this.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 6e7e78a..3dc94d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -556,6 +556,7 @@ static char *rs_pretty_rate(const struct rs_rate *rate)
 	if (is_type_legacy(rate->type) && (rate->index <= IWL_RATE_54M_INDEX))
 		rate_str = legacy_rates[rate->index];
 	else if ((is_type_ht(rate->type) || is_type_vht(rate->type)) &&
+		 (rate->index >= IWL_RATE_MCS_0_INDEX) &&
 		 (rate->index <= IWL_RATE_MCS_9_INDEX))
 		rate_str = ht_vht_rates[rate->index];
 	else
-- 
2.5.0

