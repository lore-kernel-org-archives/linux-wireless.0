Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46922 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727579AbeIEJep (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 05:34:45 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Sep 2018 08:06:07 +0300
Message-Id: <20180905050614.23273-3-luca@coelho.fi> (sfid-20180905_070630_602019_33BAD3F4)
In-Reply-To: <20180905050614.23273-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
 <20180905050614.23273-1-luca@coelho.fi>
Subject: [RESEND PATCH v2 2/9] mac80211: fix saving a few HE values
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naftali Goldstein <naftali.goldstein@intel.com>

After masking the he_oper_params, to get the requested values as
integers one must rshift and not lshift.  Fix that by using the
le32_get_bits() macro.

Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
[converted to use le32_get_bits()]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1bd714376635..3b1b7a77fa7d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3173,19 +3173,16 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (bss_conf->he_support) {
-		u32 he_oper_params =
-			le32_to_cpu(elems.he_operation->he_oper_params);
+		bss_conf->bss_color =
+			le32_get_bits(elems.he_operation->he_oper_params,
+				      IEEE80211_HE_OPERATION_BSS_COLOR_MASK);
 
-		bss_conf->bss_color = he_oper_params &
-				      IEEE80211_HE_OPERATION_BSS_COLOR_MASK;
 		bss_conf->htc_trig_based_pkt_ext =
-			(he_oper_params &
-			 IEEE80211_HE_OPERATION_DFLT_PE_DURATION_MASK) <<
-			IEEE80211_HE_OPERATION_DFLT_PE_DURATION_OFFSET;
+			le32_get_bits(elems.he_operation->he_oper_params,
+			      IEEE80211_HE_OPERATION_DFLT_PE_DURATION_MASK);
 		bss_conf->frame_time_rts_th =
-			(he_oper_params &
-			 IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK) <<
-			IEEE80211_HE_OPERATION_RTS_THRESHOLD_OFFSET;
+			le32_get_bits(elems.he_operation->he_oper_params,
+			      IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK);
 
 		bss_conf->multi_sta_back_32bit =
 			sta->sta.he_cap.he_cap_elem.mac_cap_info[2] &
-- 
2.18.0
