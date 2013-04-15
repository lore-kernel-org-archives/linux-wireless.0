Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:60009 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3DOPOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 11:14:10 -0400
Received: by mail-we0-f170.google.com with SMTP id z2so3744370wey.15
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 08:14:08 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH 1/2] mac80211: VHT off-by-one NSS
Date: Mon, 15 Apr 2013 17:09:29 +0200
Message-Id: <1366038570-12457-1-git-send-email-karl.beldan@gmail.com> (sfid-20130415_171419_407874_4CB69D2B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

The number of VHT spatial streams (NSS) is found in:
- s8 ieee80211_tx_rate.rate.idx[6:4] (tx - filled by rate control)
- u8 ieee80211_rx_status.vht_nss     (rx - filled by driver)
Tx discriminates valid rates indexes with the sign bit and encodes NSS
starting from 0 to 7 (note this matches some hw encodings e.g IWLMVM).
Rx does not have the same constraints, and encodes NSS starting from 1
to 8 (note this matches what wireshark expects in the radiotap header).

To handle ieee80211_tx_rate.rate.idx[6:4] ieee80211_rate_set_vht() and
ieee80211_rate_get_vht_nss() assume their nss parameter and return value
respectively runs from 0 to 7.
ATM, there are only 2 users of these: cfg.c:sta_set_rate_info_t() and
iwlwifi/mvm/tx.c:iwl_mvm_hwrate_to_tx_control(), but both assume nss
runs from 1 to 8.
This patch fixes this inconsistency by making ieee80211_rate_set_vht()
and ieee80211_rate_get_vht_nss() handle an nss running from 1 to 8.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
This might feel very verbose for such a trivial thing.

 include/net/mac80211.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
-- 
1.8.2

