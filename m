Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46483 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZCOSC0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 14:02:26 -0400
Subject: Re: [PATCH] mac80211: Tear down aggregation sessions for
 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	me@bobcopeland.com
In-Reply-To: <18876.41851.397740.847705@gargle.gargle.HOWL>
References: <18876.41851.397740.847705@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HmYhxmkqGmIrCAMJff3q"
Date: Sun, 15 Mar 2009 19:02:14 +0100
Message-Id: <1237140134.24621.0.camel@johannes.local> (sfid-20090315_190228_174126_79225113)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HmYhxmkqGmIrCAMJff3q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-15 at 12:13 +0530, Sujith wrote:
> When the driver has been notified with a STA_REMOVE, it tears down
> the internal ADDBA state. On resume, trying to initiate aggregation would
> fail because mac80211 has not cleared the operational state for that <TID=
,STA>.
> This can be fixed by tearing down the existing sessions on a suspend.

Agreed, but Bob said there were some deadlocks with this?

johannes

> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  net/mac80211/pm.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
> index f845601..ab9c989 100644
> --- a/net/mac80211/pm.c
> +++ b/net/mac80211/pm.c
> @@ -21,6 +21,13 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
>  	list_for_each_entry(sdata, &local->interfaces, list)
>  		ieee80211_disable_keys(sdata);
> =20
> +	/* Tear down aggregation sessions */
> +	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
> +		list_for_each_entry(sta, &local->sta_list, list) {
> +			ieee80211_sta_tear_down_BA_sessions(sta);
> +		}
> +	}
> +
>  	/* remove STAs */
>  	if (local->ops->sta_notify) {
>  		spin_lock_irqsave(&local->sta_lock, flags);

--=-HmYhxmkqGmIrCAMJff3q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJvUKjAAoJEKVg1VMiehFYTbYP/1pkIJq/kcQWfHIY0dge6/SV
107KCF8yCRJLAOJQNcGB6JkEQYFfDklR95Q3r30Emd/6EtA/PYOcwlT2zi8Eo1Og
HVUFJf9qFcF0mmWrZSP3KFmwouU9V9oQtDOF1IiJi7Q2xgcQTio/uW+A3lk+XwUL
WMrk769rjJlovtqbNrtG29POaLl4J+wne5M08Cli2nk+uIJf8JPlPcovWqdbV8l0
Ug/9oo6Jdv35dSQsHsE6GgK2CjJbAGmv4NePKrgaYJM1C9VHUN8IYcQV1aZrFtPm
d1fgedQ0VVVvk6a0y9eY3kA0iC+Wx3tGPn4GdEdLKN/ttDk4oQAj6gvZY9p2qcwe
p8+e4vhitgtk14bQ90fn84u+iXxZijwhzxWCelTjyCS4DqsEBezu5GOKDBa4ii/F
e52Kw6KuZ2Juhx98nQExAaGGA93lGTauTSOwtq5DGDwZP6C6oLO10Hoj576WxVyg
OcMeHYHYQj9L7A+xKnUFVNuR6lkNiFAAwbul8xSplI1RitH4Vad5Co9r6H1LyX5b
9WUchKupa8mS6JK4cOZgX2iTnVDeodgzlig8qkkSvBd8JznKseV2fhs11jqzyLcd
oAkMSvl3HmxRxt+ng9cLNtjZ2/pROLgYBuZ4nJsRdCsd9NHJgcIMbcoBquJqBq7W
cslsEakMTq0IVPZqZCON
=+kXx
-----END PGP SIGNATURE-----

--=-HmYhxmkqGmIrCAMJff3q--

