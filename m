Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbYIOFXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 01:23:30 -0400
Subject: Re: WEP and enc restricted
From: Dan Williams <dcbw@redhat.com>
To: Ortwin =?ISO-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48CD314C.40105@odi.ch>
References: <48CD314C.40105@odi.ch>
Content-Type: text/plain; charset=utf-8
Date: Mon, 15 Sep 2008 01:24:08 -0400
Message-Id: <1221456248.27102.43.camel@localhost.localdomain> (sfid-20080915_072337_218806_93DC9E74)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-09-14 at 17:44 +0200, Ortwin Gl=C3=BCck wrote:
> Hi,
>=20
> I am pretty sure that the mac80211 code doesn't handle WEP with share=
d keys=20
> correctly. Using the ath9k driver on my MacBook I am unable to put th=
e driver=20
> into restricted mode (shared key). It stays in open mode. That is the=
 following=20
> command has no effect: iwconfig wlan0 enc restricted. I can also conf=
irm this=20
> when looking at the authentication packets that go over the air: they=
 are sent=20
> with the open flag, and not the shared key flag.

It looks like ieee80211_rx_mgmt_auth() in mlme.c should be cycling
through the various auth methods when it gets an "auth not supported"
response from the AP.  I wonder why that's not working in your case.
Can you put some printks in there and see if that code gets triggered
and if not, poke around a bit to see why?

> Surprisingly nowhere in the mac80211 code the ifsta->auth_alg is set =
to=20
> WLAN_AUTH_SHARED_KEY so far. The attached small patch does just that.=
 I am not=20
> 100% sure if that's the way to do it, so please review carefully.

It looks like it does get set from the SIWAUTH handler if you pass in
the right auth algs bits; but you're correct in that SIWENCODE won't se=
t
the auth alg.  The patch seems to be correct.

However, the submission format needs a few things: the signed-off-by
line, and the patch should be inlined rather than attached to make for
easier review.  Please see here:

http://linux.yyz.us/patch-format.html

Thanks!
Dan

> With this patch authentication works. The AP now denies association, =
but that is=20
> another problem.
>=20
> Cheers
>=20
> Ortwin
> plain text document attachment (patch.diff)
> --- wext.c.orig	2008-07-21 22:18:29.000000000 +0200
> +++ wext.c	2008-09-14 16:46:09.000000000 +0200
> @@ -929,6 +929,14 @@
>  	else
>  		idx--;
> =20
> +	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_STA) {
> +		struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
> +		if (erq->flags & IW_ENCODE_OPEN)
> +			ifsta->auth_alg =3D WLAN_AUTH_OPEN;
> +		else if (erq->flags & IW_ENCODE_RESTRICTED)
> +			ifsta->auth_alg =3D WLAN_AUTH_SHARED_KEY;
> +	}
> +
>  	if (erq->flags & IW_ENCODE_DISABLED)
>  		remove =3D 1;
>  	else if (erq->length =3D=3D 0) {

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
