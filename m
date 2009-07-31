Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZGaOGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 10:06:45 -0400
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1249048571.32395.6.camel@maxim-laptop>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <1249024097.7653.6.camel@maxim-laptop>
	 <1249026181.29587.14.camel@johannes.local>
	 <1249046380.6418.6.camel@maxim-laptop>
	 <1249047576.29587.76.camel@johannes.local>
	 <1249048571.32395.6.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QXrxST/FzFFZRyCHxJFm"
Date: Fri, 31 Jul 2009 16:06:35 +0200
Message-Id: <1249049195.29587.87.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QXrxST/FzFFZRyCHxJFm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-31 at 16:56 +0300, Maxim Levitsky wrote:

> > That appears to be in the wrong place. Shouldn't that be in the
> > _set_associated function? Otherwise you're always setting it to 0 befor=
e
> > sending the probe?
> I thought about this too, but I think this is the right place.
> ieee80211_mgd_probe_ap is called to start a probe on an AP, it will
> ignore following calls till ether AP responds or we reconnect.
> What I did is not to fail after first timeout, but resend the assoc
> request once more, thus this function won't be called again.

Ok, that makes sense.

> > > +		else if (ifmgd->probe_miss_count < IEEE80211_ASSOC_RETRIES) {
> > > +
> > > +			printk(KERN_DEBUG "No probe response from AP %pM"
> >=20
> > and that one too
> same here
> >=20
> > > +				" after %dms, try %d\n", bssid,
> > > +				(1000 * IEEE80211_PROBE_WAIT)/HZ,
> > > +				(int)ifmgd->probe_miss_count);
> > > +
> > > +			ifmgd->probe_miss_count++;
> > > +			ifmgd->probe_timeout =3D jiffies + IEEE80211_PROBE_WAIT;
> > > +			run_again(ifmgd, ifmgd->probe_timeout);
> > > +
> > > +			ssid =3D ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_=
SSID);
> > > +			ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
> > > +				ssid + 2, ssid[1], NULL, 0);
> > > +		} else {
> >=20
> > Shouldn't this just call _probe_ap() again? After you move the setting
> > to 0 out of it, that is?

> No, first of all I tried it :-).=20

:)

> It takes the ifmgd->mtx first of all,
> and besides this way it is more logical, ieee80211_mgd_probe_ap is
> called once per AP ping, and here we continue it.
> Since I have copied these 3 lines from ieee80211_mgd_probe_ap I have no
> objection to put them in a new function.

Don't think it really matters, it's just two function calls anyway...
But maybe it would make sense to put this whole block into a
_mgd_probe_ap_retry function or so? On the other hand, it's just a
handful lines of code, so this is fine too.

johannes

--=-QXrxST/FzFFZRyCHxJFm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcvpmAAoJEODzc/N7+Qma/1oQAIPUNr7RLhyTxqauJiIKbphZ
4imHKiO6NpVLVs7LayKQzg2AjLJDLVOklbGIMSP9ykJFPdcAmHLzTOR38MSQdGjD
zpWxz8FSOk2lE41Ctxq9pZgl4tpplGVTQzrDzB4hqL9IPCsJk1axx8eIxFC9NFrd
Mfe86wx1p/4NQdPlCcishklazEI6WJTRkdbXds6Onh26zI1rCt1qio1I7nfoUkdB
ZJtIkRC8YcKHZI2mEABCYf+5QCVOSp4447PuIFSouYbzc/qUy6E4ZxrM7oGoGB5n
rxmbUYIf17AO41h2mWAMCxmGaKSKdoHwjDnEHqW1DRw/uTKXIIfOkFAo4WR52amQ
HfzwFce+FvyafKqkZBRUq/YP9SFZSLDp3a0h8wfI7ZWm41fmX8aMOsii4nHz7NWW
gNNZ/qoh8MC2D+UOtNM4oI6HU1Tz6+9Y37sUVA3uh4EB0yTry2yJIiHzAL1YBZ7M
jgIoFY5A0MchhcczJ/V5Z538l/N4ZxzbWKnCHkV1TCCCM1t4jq0qGGp9Tf/RtU/4
lLmOS3GoAj0rBS+BysYpyGdBw8c4crqKIP7k38ODnslsjRFTqCe/UDYorOC4TjBr
cY37A8coX9j+pfUQhFmwlU2JUWh0bVkNuvEHQGTNDHPVFNYoy1gauL/lPCBnYjNP
aWDk8Zs9sCXB6j2zIIUg
=jMtm
-----END PGP SIGNATURE-----

--=-QXrxST/FzFFZRyCHxJFm--

