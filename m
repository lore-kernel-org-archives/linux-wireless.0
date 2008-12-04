Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbYLDR1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 12:27:40 -0500
Subject: Re: [RFC PATCH v4 1/5] mac80211: enable IEEE80211_CONF_PS only
	when associated
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081202200359.5507.40576.stgit@tikku> (sfid-20081202_210409_204193_1599C0A5)
References: <20081202200219.5507.83250.stgit@tikku>
	 <20081202200359.5507.40576.stgit@tikku>
	 (sfid-20081202_210409_204193_1599C0A5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UTAuUC8YgBI/Yqx/1CDx"
Date: Thu, 04 Dec 2008 18:27:38 +0100
Message-Id: <1228411658.5692.19.camel@johannes.berg> (sfid-20081204_182748_018418_EBB580A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UTAuUC8YgBI/Yqx/1CDx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-02 at 22:03 +0200, Kalle Valo wrote:

> -	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> +	if (ps =3D=3D local->powersave)
> +		return ret;
> +
> +set:
> +	local->powersave =3D ps;
> +
> +	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> +		return ret;

Shouldn't that test be earlier? There's little sense in supporting PS if
you have a non-STA interface. In fact, it might make sense to check that
there's no other interface (except monitor) open?

johannes

--=-UTAuUC8YgBI/Yqx/1CDx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOBMGAAoJEKVg1VMiehFYmRMP/jylvZdwXrLjITRNF77xOSy9
1ug+zCZZtvk4oJ6wZ4jsf2HWPMkmaqMhKIZIy+SwnZ3qLOedl8rwTTdlz8y3kyt/
1eXTCxZMQvQf8/BNY0qmbp48NprVcM4nNixnhKYdKXIWXDXFIAtWMGqMcVXW3wZN
xfwEoU2TW4qfCJfhq4iouzQQ8KPmN7F6ZYViwBLZvDlDLTCHzqm67KeN/MkKd0yG
RSJdTZfTaFuxQTNHmZJ7nKsCgF5m+pIAcDyGFVzSGTTI3qd+/QhDNV0Q5gvZeo7t
zuTB5sKeXbnHeM2qa3JGZbPpjUh6uApChnFaeCztN6IGGQvLUHn1PWRdJ7Fb2MhM
7grfhy/fobekyP4S9VxWICuthG+ECM0lxSPMTMoGP2GCbZA3hYhGechGhdcI+8L0
3CfmU7L2doKYql0KB5KIS63/gSpDKuGbXYigr9eO3DYvxyb6/HplTvOQe2PT2cfX
obGEPmCYXdsBgJcfOzl6BeJlVJ0LcXqYKPBZ7Xoo/1x/eq7wfn5GKPoyXZUk2rOK
KTbpQSNwdppFSvSjn6DGinPqrz2YtHqqepUp2FG9C90VwYxf+NDPfEuhA3OVTk+f
ALjj0quVQs9P44RFDZBDjcyENWYpTY/i5eDgj1EQLF/rAzprc6DrjLSZhPfXcbFO
PE1ocpqtc8tA3dLkmvA6
=mFTl
-----END PGP SIGNATURE-----

--=-UTAuUC8YgBI/Yqx/1CDx--

