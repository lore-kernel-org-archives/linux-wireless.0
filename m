Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45416 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727238AbeHaMkX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:40:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 11:31:22 +0300
Message-Id: <20180831083130.15525-21-luca@coelho.fi> (sfid-20180831_103408_175125_ADD9DE68)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 20/28] mac80211: fix saving a few HE values
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

)

From: Naftali Goldstein <naftali.goldstein@intel.com>

After masking the he_oper_params, to get the requested values as
integers one must rshift and not lshift. Fix that.

Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 764a0f8e1dd1..b2a5ca96412d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3246,11 +3246,11 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 				      IEEE80211_HE_OPERATION_BSS_COLOR_MASK;
 		bss_conf->htc_trig_based_pkt_ext =
 			(he_oper_params &
-			 IEEE80211_HE_OPERATION_DFLT_PE_DURATION_MASK) <<
+			 IEEE80211_HE_OPERATION_DFLT_PE_DURATION_MASK) >>
 			IEEE80211_HE_OPERATION_DFLT_PE_DURATION_OFFSET;
 		bss_conf->frame_time_rts_th =
 			(he_oper_params &
-			 IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK) <<
+			 IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK) >>
 			IEEE80211_HE_OPERATION_RTS_THRESHOLD_OFFSET;
 
 		bss_conf->multi_sta_back_32bit =
-- 
2.18.0
