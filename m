Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39196 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932349AbdBHL27 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 06:28:59 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 13:23:10 +0200
Message-Id: <20170208112322.29413-6-luca@coelho.fi> (sfid-20170208_122905_664565_CE8BEBC7)
In-Reply-To: <20170208112322.29413-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
Subject: [PATCH 05/17] iwlwifi: mvm: fix a print of NSS for HT rate
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

Handling of the number of space time streams was missing for HT rate in
rate printing function. Fix it.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 80f99c365b6a..13be9a5b83ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -3616,6 +3616,8 @@ int rs_pretty_print_rate(char *buf, const u32 rate)
 	} else if (rate & RATE_MCS_HT_MSK) {
 		type = "HT";
 		mcs = rate & RATE_HT_MCS_INDEX_MSK;
+		nss = ((rate & RATE_HT_MCS_NSS_MSK)
+		       >> RATE_HT_MCS_NSS_POS) + 1;
 	} else {
 		type = "Unknown"; /* shouldn't happen */
 	}
-- 
2.11.0
