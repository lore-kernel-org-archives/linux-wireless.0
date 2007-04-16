Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbXDPSF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2007 14:05:26 -0400
From: Andreas Schwab <schwab@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] ieee80211-crypt: Make some TKIP and CCMP error logging conditional on IEEE80211_DEBUG_DROP
References: <461a68c9.Nx0/XQSxDR1PJhM4%Larry.Finger@lwfinger.net>
Date: Mon, 16 Apr 2007 20:05:10 +0200
In-Reply-To: <461a68c9.Nx0/XQSxDR1PJhM4%Larry.Finger@lwfinger.net> (Larry
	Finger's message of "Mon, 09 Apr 2007 11:24:41 -0500")
Message-ID: <jeirbwfb55.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> There are messages arising from ieee80211_crypt that spam the logs of
> casual users. These are changed to be logged only if the user specifi=
cally
> requests the IEEE80211_DEBUG_DROP messages. In either case, the error=
/drop count
> is incremented.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> Index: wireless-2.6/net/ieee80211/ieee80211_crypt_tkip.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-2.6.orig/net/ieee80211/ieee80211_crypt_tkip.c
> +++ wireless-2.6/net/ieee80211/ieee80211_crypt_tkip.c
> @@ -465,7 +465,7 @@ static int ieee80211_tkip_decrypt(struct
> =20
>  	if (tkip_replay_check(iv32, iv16, tkey->rx_iv32, tkey->rx_iv16)) {
>  		if (net_ratelimit()) {
> -			printk(KERN_DEBUG "TKIP: replay detected: STA=3D" MAC_FMT
> +			IEEE80211_DEBUG_DROP("TKIP: replay detected: STA=3D" MAC_FMT
>  			       " previous TSC %08x%04x received TSC "
>  			       "%08x%04x\n", MAC_ARG(hdr->addr2),
>  			       tkey->rx_iv32, tkey->rx_iv16, iv32, iv16);
> @@ -507,7 +507,7 @@ static int ieee80211_tkip_decrypt(struct
>  			tkey->rx_phase1_done =3D 0;
>  		}
>  		if (net_ratelimit()) {
> -			printk(KERN_DEBUG "TKIP: ICV error detected: STA=3D"
> +			IEEE80211_DEBUG_DROP("TKIP: ICV error detected: STA=3D"
>  			       MAC_FMT "\n", MAC_ARG(hdr->addr2));
>  		}
>  		tkey->dot11RSNAStatsTKIPICVErrors++;
> Index: wireless-2.6/net/ieee80211/ieee80211_crypt_ccmp.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-2.6.orig/net/ieee80211/ieee80211_crypt_ccmp.c
> +++ wireless-2.6/net/ieee80211/ieee80211_crypt_ccmp.c
> @@ -338,7 +338,7 @@ static int ieee80211_ccmp_decrypt(struct
> =20
>  	if (ccmp_replay_check(pn, key->rx_pn)) {
>  		if (net_ratelimit()) {
> -			printk(KERN_DEBUG "CCMP: replay detected: STA=3D" MAC_FMT
> +			IEEE80211_DEBUG_DROP("CCMP: replay detected: STA=3D" MAC_FMT
>  			       " previous PN %02x%02x%02x%02x%02x%02x "
>  			       "received PN %02x%02x%02x%02x%02x%02x\n",
>  			       MAC_ARG(hdr->addr2), MAC_ARG(key->rx_pn),
>
>

This is causing an undefined refrence to ieee80211_debug_level with
CONFIG_IEEE80211_DEBUG=3Dy and CONFIG_IEEE80211_CRYPT_CCMP=3Dm and/or
CONFIG_IEEE80211_CRYPT_TKIP=3Dm.

WARNING: "ieee80211_debug_level" [net/ieee80211/ieee80211_crypt_tkip.ko=
] undefined!
WARNING: "ieee80211_debug_level" [net/ieee80211/ieee80211_crypt_ccmp.ko=
] undefined!

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
