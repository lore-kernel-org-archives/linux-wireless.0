Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:34417 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3DOKNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 06:13:14 -0400
Received: by mail-we0-f171.google.com with SMTP id i48so1848230wef.30
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 03:13:12 -0700 (PDT)
Date: Mon, 15 Apr 2013 12:09:09 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: vht off-by-one nss
Message-ID: <20130415100909.GA29924@magnum.frso.rivierawaves.com> (sfid-20130415_121317_993144_EF942E2D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems to me we have to perform one of the following, otherwise one
driver may set negative rate indexes and iw et.al will report VHT NSSes
starting at 0.

{
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0dde213..2317ca9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -601,8 +601,8 @@ static inline void ieee80211_rate_set_vht(struct ieee80211_tx_rate *rate,
 					  u8 mcs, u8 nss)
 {
 	WARN_ON(mcs & ~0xF);
-	WARN_ON(nss & ~0x7);
-	rate->idx = (nss << 4) | mcs;
+	WARN_ON((nss - 1) & ~0x7);
+	rate->idx = ((nss - 1) << 4) | mcs;
 }
 
 static inline u8
@@ -614,7 +614,7 @@ ieee80211_rate_get_vht_mcs(const struct ieee80211_tx_rate *rate)
 static inline u8
 ieee80211_rate_get_vht_nss(const struct ieee80211_tx_rate *rate)
 {
-	return rate->idx >> 4;
+	return (rate->idx >> 4) + 1;
 }
 
 /**
}

or:

{
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 56df249..9631391 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -545,7 +545,7 @@ static void iwl_mvm_hwrate_to_tx_control(u32 rate_n_flags,
 		ieee80211_rate_set_vht(
 			r, rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK,
 			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
-						RATE_VHT_MCS_NSS_POS) + 1);
+						RATE_VHT_MCS_NSS_POS));
 		r->flags |= IEEE80211_TX_RC_VHT_MCS;
 	} else {
 		r->idx = iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fdd95bd..358d93c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -389,7 +389,7 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 	} else if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
 		rinfo->flags |= RATE_INFO_FLAGS_VHT_MCS;
 		rinfo->mcs = ieee80211_rate_get_vht_mcs(rate);
-		rinfo->nss = ieee80211_rate_get_vht_nss(rate);
+		rinfo->nss = ieee80211_rate_get_vht_nss(rate) + 1;
 	} else {
 		struct ieee80211_supported_band *sband;
 		sband = sta->local->hw.wiphy->bands[
}

 
Karl
