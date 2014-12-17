Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35359 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbaLQJB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 04:01:59 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so15245038wiv.2
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 01:01:58 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2] mac80211: notify NSS changed when IBSS and HT
Date: Wed, 17 Dec 2014 10:00:52 +0100
Message-Id: <1418806852-558-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20141217_100211_493020_7C0F302D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using IBSS in HT mode, we always get NSS=1
in rc_update callback. Force NSS recalculation when
rates updated and notify driver that NSS changed.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ibss.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 509bc15..b606b53 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1069,9 +1069,16 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		}
 
 		if (sta && rates_updated) {
-			drv_sta_rc_update(local, sdata, &sta->sta,
-					  IEEE80211_RC_SUPP_RATES_CHANGED);
+			u32 changed = IEEE80211_RC_SUPP_RATES_CHANGED;
+			u8 rx_nss = sta->sta.rx_nss;
+
+			/* Force rx_nss recalculation */
+			sta->sta.rx_nss = 0;
 			rate_control_rate_init(sta);
+			if (sta->sta.rx_nss != rx_nss)
+				changed |= IEEE80211_RC_NSS_CHANGED;
+
+			drv_sta_rc_update(local, sdata, &sta->sta, changed);
 		}
 
 		rcu_read_unlock();
-- 
1.9.1

