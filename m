Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54285 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbZDTSfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 14:35:46 -0400
Subject: Re: WARN on return of ieee80211_if_config
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1240252271.5206.63.camel@rc-desk>
References: <1240252271.5206.63.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VmQd4xpLxAe2Dm5fEZEz"
Date: Mon, 20 Apr 2009 20:35:11 +0200
Message-Id: <1240252511.4632.17.camel@johannes.local> (sfid-20090420_203600_864098_F93622FF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VmQd4xpLxAe2Dm5fEZEz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Reinette,

> In 2.6.30 we are starting to see people encountering a WARN when
> resuming with HW rfkill enabled. The WARN is printed from
> net/mac80211/pm.c:159 in 2.6.30, for current wireless-testing it is=20
> net/mac80211/util.c:1050.

Hmm, ok, that makes sense.

> With that function resuming multiple interfaces I do not know if it will
> make sense to return an error code if one fails. So, it seems that
> __ieee80211_resume()/ieee80211_reconfig() will always return zero. Even
> so, the case where ieee80211_if_config() fails needs to be
> accommodated.=20
>=20
> Would something like this make sense?
>=20
> diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
> index 0273023..46f2961 100644
> --- a/net/mac80211/pm.c
> +++ b/net/mac80211/pm.c
> @@ -156,8 +156,11 @@ int __ieee80211_resume(struct ieee80211_hw *hw)
>  		case NL80211_IFTYPE_ADHOC:
>  		case NL80211_IFTYPE_AP:
>  		case NL80211_IFTYPE_MESH_POINT:
> -			WARN_ON(ieee80211_if_config(sdata, changed));
> -			ieee80211_bss_info_change_notify(sdata, ~0);
> +			if (ieee80211_if_config(sdata, changed))
> +				printk(KERN_DEBUG "%s: failed to configure interface\n",
> +				       sdata->dev->name);
> +			else
> +				ieee80211_bss_info_change_notify(sdata, ~0);

Not sure. That doesn't seem to make sense anyway, since iwlwifi does
this:

        if (iwl_is_rfkill(priv))
                goto done;
...
 done:
...
	return 0;


Or will this test:
        if (!iwl_is_alive(priv))
                return -EAGAIN;

kick us out before even getting to the rfkill test?

johannes

--=-VmQd4xpLxAe2Dm5fEZEz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7MBcAAoJEKVg1VMiehFY6xUP/iBvL6aFnG/+ekHBi1qngYtf
/qrTpKMIPrTpmNw7NTEUexTfWvP3o9B2I3ALIOhkEgX91a/67xUj6QyWQMuQIFWX
alu2poXfUKMgkFVGgoF5Uw8YT9mudUlbnBAwUCp8qtDNGI3vlaSGr5qwKKj1fNGC
umyqE1a3C85QYMBmGM6O+ri1cCBEys//8kT0DSm3B3ZzoJKw6IWfnCKLJW9CWWy0
GLfav5T+2apdBQA+eZeLxjpmZOVKTXVHOZRUHbWZuqiRiguWU5F1VkVzj4F25iXk
SDZ1vANTOQfqWiQtdgpuUU3QDce0Phbj6AF0IsdMJ6zJ1fWeL+25CNeU5TL5J65E
J6d8tS3wjCD5KzmZvXe51zYdAp7x1XzadoK1MBJV9wLRR6OuU+UxusveWNgYTFQy
glerGOTssF0vo2GiqA7gMaQIThLuy3vORvP+xha9k5egODr65W3aJPAGr8pcWn4K
Vcp5+f3bwEKgkJBlJP3AEFDmzywVw1Ki/vbgmBppEf8VOcZkwH9rOTFXhgSAFlsN
p7wIuGWUZNOSQTMqWSHt3n4k1Ss+BhN/GIhiKU/3A0QdfAmJG0/5K37pA0BKGyiY
gTHLfGDHqhNNg2BeoOK9ybAqA/G31k7rfsFVgQ2Hvx9sRSxiQWR1R2RoChtH+0n2
h4LdD3LzjMBL6jqXRUgP
=QqH2
-----END PGP SIGNATURE-----

--=-VmQd4xpLxAe2Dm5fEZEz--

