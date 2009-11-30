Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZK3PUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 10:20:25 -0500
Subject: Re: [PATCH v3 1/2] wireless: add ieee80211_amsdu_to_8023s
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1259555157-10866-1-git-send-email-yi.zhu@intel.com>
References: <1259555157-10866-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zQo5scr/7MyT7Qevn8K0"
Date: Mon, 30 Nov 2009 16:20:15 +0100
Message-ID: <1259594415.32171.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zQo5scr/7MyT7Qevn8K0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-30 at 12:25 +0800, Zhu Yi wrote:

> +		__skb_queue_tail(list, frame);
> +	}
> +
> +	return 0;
> +
> + purge:
> +	__skb_queue_purge(list);
> + out:
> +	dev_kfree_skb(skb);
> +	return -1;

I'm not sure there's much use in the return value, since it otherwise
leaves the list empty and you don't _really_ care all that much to
iterate an empty list in that case, but it doesn't really matter.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-zQo5scr/7MyT7Qevn8K0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLE+KsAAoJEODzc/N7+QmaFcUQAMigavzK/lAI8HbaF2WMk3qn
KZvK5kmjN09TnmscLg6jG8d9mm+qOTlaJ+rrUxpNd/YdtfLYhvqCT/JhIxxbvpK2
OFKo/mTgu0nM9SmS57Vw7ievFZ9vvLFOvdZHXu7VRhHsd/0r0/JBoF6wVc+eMYok
czenfwTdZcXJXhnqmzOdmouipvWY/bJpcExFArNUBcbdVv3gSq7SWWjIQnmPyalx
uHywgRKAywk2rQJIZWl5A0+JgS2GkyGMrxAa6h6w3rcfvJ8iZjOA/sc+olyBMkwT
/bVnLQCbcapD5qDTbhYhihCA2h5X0jFG/Z9TTJNvj8jN0gpoMahuj6P5UCkqOPnm
yZQZJFCaL171fFH7u1rDi4QIwFPZSOdXuQpHa5/sxePUq0Npwk7B/mNPpheABU9+
J2yiQyPv96Ubt3CajET4fBsJ6vJlLRN/A0V2fpALQ506u+KxcpBntoKmfLryptMd
5+BDUauk8D+Bt3KYgHVQnxONQ6to2gPfLsvWNMsXkHDFfGLetTwl8m8CVsSQ7Ej7
t7veYDoCRyE40g7JV8M8EOoQLGCqUFZyp+QXqRHChUotxfg10MbRM2fmnx2eGjRh
XshbcaAaCBr1xsEml98oxt2MHhGIIilGTeEodgRua36yMEZnHQuQQhpe2BSEUEJp
UCR9v9dm233C5M/ChEH6
=fhr3
-----END PGP SIGNATURE-----

--=-zQo5scr/7MyT7Qevn8K0--

