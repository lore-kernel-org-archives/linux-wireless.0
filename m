Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:33791 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbbEKJj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 05:39:59 -0400
Received: by layy10 with SMTP id y10so89166247lay.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 02:39:57 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] mac80211: IBSS, clear fast_sta when update rates
Date: Mon, 11 May 2015 11:39:53 +0200
Message-Id: <1431337193-17472-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150511_114013_502593_D223B089)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is required to handle sta.wme correctly
after update rates (eg. when using HT/VHT) when
driver using IEEE80211_HW_SUPPORT_FAST_XMIT.

In other case fast tx path will not add QOS data and
in case of ath10k driver (rate control in the HW) only
legacy rates will be used.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ibss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index bfef1b2..f76414e 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1087,6 +1087,7 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 		if (sta->sta.rx_nss != rx_nss)
 			changed |= IEEE80211_RC_NSS_CHANGED;
 
+		ieee80211_clear_fast_xmit(sta);
 		drv_sta_rc_update(local, sdata, &sta->sta, changed);
 	}
 
-- 
1.9.1

