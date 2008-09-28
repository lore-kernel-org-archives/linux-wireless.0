Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:30326 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYI1QOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 12:14:32 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1162235fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2008 09:14:30 -0700 (PDT)
Message-ID: <48DFAD63.4010007@gmail.com> (sfid-20080928_181436_798663_5B63DC76)
Date: Sun, 28 Sep 2008 18:14:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Gregory Nietsky <gregory@dnstelecom.co.za>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [ath5k-devel] [PATCH 1/1] Ath5k: add AP mode
References: <1222519728-14989-1-git-send-email-jirislaby@gmail.com> <48DF6535.8080407@dnstelecom.co.za>
In-Reply-To: <48DF6535.8080407@dnstelecom.co.za>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2008 01:06 PM, Gregory Nietsky wrote:
> 
> Quick Observation  ...
> 
> it appears IEEE80211 types have been replaced with NL80211 types in
> kernel ... so would the following not be more correct and is opmode not
> defined as
> 
> struct ath5k_softc {
> ....
>        enum nl80211_iftype     opmode;
> .....

It already is.

> @@ -2130,14 +2129,15 @@ ath5k_beacon_config(struct ath5k_softc *sc)
> 
>                sc->imask |= AR5K_INT_SWBA;
> 
> -               if (ath5k_hw_hasveol(ah)) {
> -                       spin_lock(&sc->block);
> -                       ath5k_beacon_send(sc);
> -                       spin_unlock(&sc->block);
> -               }
> +               if (sc->opmode == NL80211_IFTYPE_ADHOC) {
> +                       if (ath5k_hw_hasveol(ah)) {
> +                               spin_lock(&sc->block);
> +                               ath5k_beacon_send(sc);
> +                               spin_unlock(&sc->block);
> +                       }
> +               } else
> +                       ath5k_beacon_update_timers(sc, -1);

Yeah, that's the correct hunk, thanks. I sent a non-updated version.

