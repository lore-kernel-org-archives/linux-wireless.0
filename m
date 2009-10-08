Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f203.google.com ([209.85.212.203]:36572 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758750AbZJHS0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:26:40 -0400
Received: by vws41 with SMTP id 41so3355929vws.4
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2009 11:26:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1254876274-1145-8-git-send-email-lrodriguez@atheros.com>
References: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
	 <1254876274-1145-8-git-send-email-lrodriguez@atheros.com>
Date: Thu, 8 Oct 2009 14:26:03 -0400
Message-ID: <b6c5339f0910081126h3fe2dd25x9198dedf09a20cea@mail.gmail.com>
Subject: Re: [PATCH 7/7] ath5k: enable Power-Save Polls by setting the
	association ID
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 6, 2009 at 8:44 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> @@ -3226,6 +3225,14 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
>                        set_beacon_filter(hw, sc->assoc);
>                ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
>                        AR5K_LED_ASSOC : AR5K_LED_INIT);
> +               if (bss_conf->assoc) {
> +                       ATH5K_DBG(sc, ATH5K_DEBUG_ANY,
> +                                 "Bss Info ASSOC %d, bssid: %pM\n",
> +                                 bss_conf->aid, common->curbssid);
> +                       common->curaid = bss_conf->aid;
> +                       ath5k_hw_set_associd(ah);
> +                       /* Once ANI is available you would start it here */
> +               }

Just quick question - do we only want to call this if we are associated?

Or maybe we should call it to reset the mask if we are unassociated...

I wrote a patch a while ago to the ath5k list that did something similar,
but I did:

       if (changes & (BSS_CHANGED_BSSID | BSS_CHANGED_ASSOC)) {
               ath5k_hw_set_associd(ah, ah->ah_bssid, ah->ah_aid);
       }

Thus if it changed regardless of the reason why, we update the mask.

-- 
Bob Copeland %% www.bobcopeland.com
