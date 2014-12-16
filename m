Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33667 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaLPI5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2014 03:57:10 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so11697547wiv.13
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2014 00:57:09 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] mac80211: notify NSS changed when IBSS and HT
Date: Tue, 16 Dec 2014 09:56:05 +0100
Message-Id: <1418720165-19810-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20141216_095722_584862_C2B8F905)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using IBSS in HT mode, we always get NSS=1
in rc_update callback. Force NSS recalculation when
rates updated and notify driver that NSS changed.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ibss.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 509bc15..d95c2dd 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1069,9 +1069,16 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		}
 
 		if (sta && rates_updated) {
+			u8 rx_nss = sta->sta.rx_nss;
+
 			drv_sta_rc_update(local, sdata, &sta->sta,
 					  IEEE80211_RC_SUPP_RATES_CHANGED);
+			/* Force rx_nss recalculation */
+			sta->sta.rx_nss = 0;
 			rate_control_rate_init(sta);
+			if (rx_nss != sta->sta.rx_nss)
+				drv_sta_rc_update(local, sdata, &sta->sta,
+						  IEEE80211_RC_NSS_CHANGED);
 		}
 
 		rcu_read_unlock();
-- 
1.9.1

