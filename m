Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:49258 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXITVSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 17:18:38 -0400
Received: by ug-out-1314.google.com with SMTP id z38so454937ugc
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2007 14:18:36 -0700 (PDT)
Message-ID: <46F2E3A9.2040605@gmail.com>
Date: Thu, 20 Sep 2007 23:18:33 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH] ath5k - Fix filters for AR5212, correct return values  for WEP
References: <43e72e890709201413w4cee6ea5v799f4b88e1982e5a@mail.gmail.com>
In-Reply-To: <43e72e890709201413w4cee6ea5v799f4b88e1982e5a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2007 11:13 PM, Luis R. Rodriguez wrote:
> I was not get getting DHCP replies back with ath5k on a AR5212. Turns
> out out of all filter flags if I enable AR5K_RX_FILTER_PROM I get my
> replies back. I've tested enabling AR5K_RX_FILTER_BCAST and
> AR5K_RX_FILTER_MCAST but AR5K_RX_FILTER_PROM only does the trick. This
> may fix this for other cards if you are not getting DHCP replies
> please let us know. For now we can enable AR5K_RX_FILTER_PROM on STA
> and Ad-hoc only for AR5212 until we sort out the filter flags
> properly. This patch also takes into account new changes to mac80211
> for ieee80211_ops's set_key().
> 
> Filter API changes to come soon.
> 
> In summary this patch has these changes:
> 
> * AR5212 now receives broadcasts (DHCP works now)
> * ath5k_hw_set_key() was checking against key table size against
> key->keyid -- this can only be 0, 1, 2 or 3. Check against key->keylen
> and divide the table size by 8.
> * return proper values for WEP setting as per mac80211 documenation
> 
> This patch applies to the ath5k branch of wireless-dev.
> 
> Changes to ath5k_base.c
> Changes-licensed-under: BSD
> 
> Changes to ath5k_hw.c, ath5k_reg.h
> Changes-licensed-under: ISC
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
> 
> ---
> 
>  drivers/net/wireless/ath5k_base.c |   26 ++++++++++++++++++--------
>  1 files changed, 18 insertions(+), 8 deletions(-
> 
>  drivers/net/wireless/ath5k_hw.c  |   12 +++++++++---
>  drivers/net/wireless/ath5k_reg.h |   12 ++++++++++++
>  2 files changed, 21 insertions(+), 3 deletions(-)
> 
diff --git a/drivers/net/wireless/ath5k_base.c b/drivers/net/wireless/ath5k_base.c
index fead9a7..c49a744 100644
--- a/drivers/net/wireless/ath5k_base.c
+++ b/drivers/net/wireless/ath5k_base.c
@@ -734,7 +734,7 @@ static u32 ath_calcrxfilter(struct ath_softc *sc)
 		AR5K_RX_FILTER_UCAST | AR5K_RX_FILTER_BCAST |
 		AR5K_RX_FILTER_MCAST | AR5K_RX_FILTER_RADARERR;

-	if (sc->opmode == IEEE80211_IF_TYPE_MNTR)
+	if (opmode == IEEE80211_IF_TYPE_MNTR)
 		rfilt |= AR5K_RX_FILTER_CONTROL | AR5K_RX_FILTER_BEACON |
 			AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
 	if (opmode != IEEE80211_IF_TYPE_STA)
@@ -742,8 +742,14 @@ static u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (opmode != IEEE80211_IF_TYPE_AP && test_bit(ATH_STAT_PROMISC,
 				sc->status))
 		rfilt |= AR5K_RX_FILTER_PROM;
-	if (opmode == IEEE80211_IF_TYPE_STA || opmode == IEEE80211_IF_TYPE_IBSS)
+	if (opmode == IEEE80211_IF_TYPE_STA || opmode == IEEE80211_IF_TYPE_IBSS) {
 		rfilt |= AR5K_RX_FILTER_BEACON;
+		/* Note: AR5212 requires AR5K_RX_FILTER_PROM to receive broadcasts,
+		 * perhaps the flags are off, for now to be safe we'll enable it for
+		 * STA and ADHOC until we have this properly mapped */
+		if (ah->ah_version == AR5K_AR5212)
+			rfilt |= AR5K_RX_FILTER_PROM;
+	}

 	return rfilt;
 }
@@ -1437,21 +1443,28 @@ static int ath_set_key(struct ieee80211_hw *hw,
set_key_cmd cmd,
 	struct ath_softc *sc = hw->priv;
 	int ret = 0;

+	switch(key->alg) {
+        case ALG_WEP:
+		break;
+        case ALG_TKIP:
+        case ALG_CCMP:
+		return -EOPNOTSUPP;

Some broken whitespace here :).

+	case ALG_NONE:
+		break;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
 	mutex_lock(&sc->lock);

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
