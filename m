Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbbLUUvC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:02 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/45] iwlwifi: mvm: rs: fix a potential out of bounds access
Date: Mon, 21 Dec 2015 22:50:06 +0200
Message-Id: <1450731046-2796-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215109_621244_AA68CAC4)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Klocwork pointed these out. There is a theoretical possibility
that rate->index might be set to IWL_RATE_INVALID (15).
This could trigger an out of bounds access on ht_vht_rates or
legacy_rates arrays. Fix it by adding some checks.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index feb775a..31b082e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -552,9 +552,10 @@ static char *rs_pretty_rate(const struct rs_rate *rate)
 	};
 	const char *rate_str;
 
-	if (is_type_legacy(rate->type))
+	if (is_type_legacy(rate->type) && (rate->index <= IWL_RATE_54M_INDEX))
 		rate_str = legacy_rates[rate->index];
-	else if (is_type_ht(rate->type) || is_type_vht(rate->type))
+	else if ((is_type_ht(rate->type) || is_type_vht(rate->type)) &&
+		 (rate->index <= IWL_RATE_MCS_9_INDEX))
 		rate_str = ht_vht_rates[rate->index];
 	else
 		rate_str = "BAD_RATE";
-- 
2.5.0

