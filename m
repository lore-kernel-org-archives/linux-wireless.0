Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:33838 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaAMUWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:16 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so943543eek.9
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:14 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/18] iwlwifi: mvm: rs: fix a theoretical out of bounds access
Date: Mon, 13 Jan 2014 22:21:48 +0200
Message-Id: <1389644517-22807-9-git-send-email-egrumbach@gmail.com> (sfid-20140113_212220_656132_C43539D0)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Discovered by klocwork

Array 'iwl_rate_mcs' of size 15 may use index value(s) -1
  * rs.c:2562: index = iwl_hwrate_to_plcp_idx(rate)
    * rs.c:2562: Result of function call 'iwl_hwrate_to_plcp_idx(rate)' is '[-1,14]'
  * rs.c:2565: Array 'iwl_rate_mcs' size is 15.
  * rs.c:2565: Possible attempt to access element -1 of array 'iwl_rate_mcs'.

While at it stop using index = -1 and always use IWL_RATE_INVALID

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 54887b9..c4f214d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -357,7 +357,7 @@ static int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
 				return idx;
 	}
 
-	return -1;
+	return IWL_RATE_INVALID;
 }
 
 static void rs_rate_scale_perform(struct iwl_mvm *mvm,
@@ -703,10 +703,8 @@ static int rs_rate_from_ucode_rate(const u32 ucode_rate,
 	memset(rate, 0, sizeof(*rate));
 	rate->index = iwl_hwrate_to_plcp_idx(ucode_rate);
 
-	if (rate->index == IWL_RATE_INVALID) {
-		rate->index = -1;
+	if (rate->index == IWL_RATE_INVALID)
 		return -EINVAL;
-	}
 
 	rate->ant = (ant_msk >> RATE_MCS_ANT_POS);
 
@@ -2562,7 +2560,9 @@ static int rs_pretty_print_rate(char *buf, const u32 rate)
 		int index = iwl_hwrate_to_plcp_idx(rate);
 
 		return sprintf(buf, "Legacy | ANT: %s Rate: %s Mbps\n",
-			       rs_pretty_ant(ant), iwl_rate_mcs[index].mbps);
+			       rs_pretty_ant(ant),
+			       index == IWL_RATE_INVALID ? "BAD" :
+			       iwl_rate_mcs[index].mbps);
 	}
 
 	if (rate & RATE_MCS_VHT_MSK) {
-- 
1.7.9.5

