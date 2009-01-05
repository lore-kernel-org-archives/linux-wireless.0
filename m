Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40201 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZAELLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 06:11:55 -0500
Subject: Re: [PATCH] mac80211: Handle power constraint level advertised in
	11d+h beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1231148165-10529-1-git-send-email-vasanth@atheros.com> (sfid-20090105_103849_565950_8A6A9F2D)
References: <1231148165-10529-1-git-send-email-vasanth@atheros.com>
	 (sfid-20090105_103849_565950_8A6A9F2D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ySDou/tDkfen3tTpNEmW"
Date: Mon, 05 Jan 2009 12:12:34 +0100
Message-Id: <1231153954.3334.4.camel@johannes> (sfid-20090105_121159_320989_482927E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ySDou/tDkfen3tTpNEmW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-05 at 15:06 +0530, Vasanthakumar Thiagarajan wrote:

> -	if (!local->hw.conf.user_power_level)
> +	if (local->sw_scanning)
>  		power =3D chan->max_power;
>  	else
> -		power =3D min(chan->max_power, local->hw.conf.user_power_level);
> +		power =3D local->hw.conf.power_constr_level ?
> +			(chan->max_power - local->hw.conf.power_constr_level) :
> +			chan->max_power;

I think I'd prefer that to be written as

if (!scanning && power_constr_level)
	power =3D ... - ...
else
	power =3D chan->max_power;

Also, I don't understand the subtraction? And why are you checking only
for sw scanning and not hw scanning?

> +void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
> +				 u16 capab_info, u8 *pwr_constr_elem,
> +				 u8 pwr_constr_elem_len)
> +{
> +	struct ieee80211_conf *conf =3D &sdata->local->hw.conf;
> +
> +	if (!(capab_info & WLAN_CAPABILITY_SPECTRUM_MGMT))
> +		return;
> +
> +	/* Power constraint IE length should be 1 octet */
> +	if (pwr_constr_elem_len !=3D 1)
> +		return;
> +
> +	if ((*pwr_constr_elem <=3D conf->channel->max_power) &&
> +	    (*pwr_constr_elem !=3D conf->power_constr_level)) {
> +		conf->power_constr_level =3D *pwr_constr_elem;
> +		ieee80211_hw_config(sdata->local, 0);

That needs a changed flag, no? And how does the subtraction make sense
like this? The spec talks about the country element's max power, and
then subtracting this, to get the local power, but if the local power
was set lower than that then we shouldn't subtract even more, no?

johannes

--=-ySDou/tDkfen3tTpNEmW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJYesgAAoJEKVg1VMiehFYzdkQAIscaNl5g5C1XX77+L65hUD7
Piok6D8UJ3Rr7ztUbZ/QNph3cyZ55DW6x7CdD3AvOE5/pwnrnxMPXwDI01iNSodE
EtXLMKXSlcV4d/YNYz/dPo96YgxrSZ6rIlsCo6+WG05+W7cn18MJ1vlV+afYak54
klFDWlCMn0bZdzS2TDynf5gEUyxQe7+vzH4NWL/32eANl95dWoAw+D+jSM/C2Fww
6vYBaqY0qHhEF8TrR0tK08x9FMa6FHAS5w9C4sZboPUQdujPISsLWWUFxgLIbEKx
/aVqPp4xsDmhHdzJI0x9+2RhX7MUtQ6RKwHEA2jh+/mUpQu+tOKC+1S8uFMnG/cQ
rJVDDTKBNAoVKpkSr8e+X5l2sUBbTPQ9ZX1YLYuMoQ8LUvWF5gE4SHhqcfCdPNmj
xX3mK8qwmK/LYx6eIITEdAGnfu1Dpx1kBwKEJ+u6IA3phVk+Mgnz2MvoNM9mNAle
bPHnyweSA9FRSZlCTED3/KBzE6aJSWoPW2ivgLz1QuQDh/LnxAboe/vWB7hPSSI+
NE7Q6HB4UV/bt03iNufpsEUo4NO/PMNa2Z3b84awHQvQ2uE7fwVeKr37XBNk+G2o
t+XNASbVO6ntT+zi/EjEml6cUNJMJIi47hDgi64qtc5gB9wH1x3+XBIksUPfuJk0
/RpkWmva2mrNYNyB5Dvj
=lCXJ
-----END PGP SIGNATURE-----

--=-ySDou/tDkfen3tTpNEmW--

