Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49469 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbbKZTpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 14:45:00 -0500
Date: Thu, 26 Nov 2015 22:44:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: (bug report) iwlwifi: inconsitent NULL checking
Message-ID: <20151126194451.GH7289@mwanda> (sfid-20151126_204503_278586_92ED7EE0)
References: <20151126120317.GJ10556@mwanda>
 <1448540211.2167.7.camel@sipsolutions.net>
 <20151126123756.GF7289@mwanda>
 <1448542297.2167.10.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448542297.2167.10.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are two issues in Smatch that would need to be fixed:

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index d1ad103..d3bc193 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -2767,6 +2767,7 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, init);
 }
 
+#include "/home/dcarpenter/progs/smatch/devel/check_debug.h"
 static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
 			struct ieee80211_tx_rate_control *txrc)
 {
@@ -2795,9 +2796,13 @@ static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
 		mvm_sta = NULL;
 	}
 
+	if (mvm_sta)
+		__smatch_implied(lq_sta);
+
 	/* Send management frames and NO_ACK data using lowest rate. */
 	if (rate_control_send_low(sta, mvm_sta, txrc))
 		return;
+	__smatch_implied(mvm_sta);
 
 	iwl_mvm_hwrate_to_tx_rate(lq_sta->last_rate_n_flags,
 				  info->band, &info->control.rates[0]);


If apply that patch (with changes for your system) and run
kchecker drivers/net/wireless/intel/iwlwifi/mvm/rs.c then it prints:

drivers/net/wireless/intel/iwlwifi/mvm/rs.c:2800 rs_get_rate() implied: lq_sta = '0,4096-2117777777777777777'
drivers/net/wireless/intel/iwlwifi/mvm/rs.c:2805 rs_get_rate() implied: mvm_sta = 's64min-(-1),1-s64max'

The first problem is that it doesn't see that if mvm_sta is non-NULL
then that implies lq_sta is non-NULL.  But even if that worked, after we
do the function call, it sees that the function that mvm_sta is non-NULL
but it wouldn't see that that means lq_sta is non-NULL.  It's not so
terribly far from working but it's not there yet.

regards,
dan carpenter
