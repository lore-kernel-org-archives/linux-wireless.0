Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZDBVkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 17:40:22 -0400
Subject: Re: How does rfkill work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49D52D27.4010607@lwfinger.net>
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>
	 <1238689637.24708.41.camel@johannes.local> <49D5018E.6050001@lwfinger.net>
	 <1238696967.6137.5.camel@johannes.local> <49D506FE.5070405@lwfinger.net>
	 <1238698084.7630.3.camel@johannes.local>
	 (sfid-20090402_204842_882765_82560824) <1238698667.7630.7.camel@johannes.local>
	 <49D521BF.2080301@lwfinger.net> <1238705420.8363.14.camel@johannes.local>
	 <49D52D27.4010607@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-j0HGIMHlezw3ERcXLZDv"
Date: Thu, 02 Apr 2009 23:39:45 +0200
Message-Id: <1238708385.22126.4.camel@johannes.local> (sfid-20090402_234025_801639_1F05867D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j0HGIMHlezw3ERcXLZDv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 16:24 -0500, Larry Finger wrote:

> > Actually. Are you positive it works without my patch? The confusing thi=
s
> > is that this code never seems to call led_trigger_event() outside of
> > rfkill_led_trigger_activate() which is only called once... Can you try
> > this patch please?
>=20
> No, it hasn't worked for some time, but until you rationalized the rfkill=
 code,
> I didn't want to mess with it. :)

Ah, ok :) And I thought I broke it.

> This patch does the trick. Not only is the set brightness callback routin=
e being
> called, but the LED is going on/off as expected.=20

Wohoo!

> It even ends up in the off
> state when the module is loaded with the switch off.=20

Yeah I'd fixed that earlier by calling the right thing.

> It toggles on/off in that
> case, but I'm not going to complain as long as it ends up off. That part =
broke
> first, then everything broke later..

Hm, don't see a good way to fix that really. Nor am I sure why it
happens, but if it just flashes once doesn't really matter I guess.

I'll roll this into my rework patch.

johannes

--=-j0HGIMHlezw3ERcXLZDv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1TCfAAoJEKVg1VMiehFYImgP/0J4RjAGeaUM03/wbFwZpRAG
KDWYGUihdVVeiCzWmlULfBaA7bo6ohlxfY2ueynGQZRkHj9wahuCJBDwMcUeC9Tt
oH7WBQby7Valq8OF5wUAGcWd6rfRwKSJo/3WTTyczz9sggKDSgsXnM5PKpmVJb6R
G3mxHbm3EYKuhJOnmIBBnyoE+ljs5K8jJFqWPfrBU27DeWTp6aCrtPNGktHdQsj+
VulCvb+Q+JFTrYP5IrT+Rn8BT7AjxWG2jDVbItyJCzO/spTbHWGqv8sbaBdfhlPK
N4LVQ4+g9kuNt1eRDV5lFeDXFBT/p66yFVrK28XPT3AnuC3gXLOxCDXgJIuPR6nF
Uv3AKmjyr01kvLDVH7RCVsoWUCQBzrqWyMFj7t5GWOehMlu3D3hjHwlM5v5m9scE
jv+HXg0HgJZWxKZe8pFgzL0jw5X2epgvIAyfr2cGLxEN/u3Nnjv0/sHwyxCaMMHc
UYE9khBrQlI9tPgHAz/pUvVSWCR5d388SoS8VtmQZvtCYp/slmCeT6ktZKeT6Lwt
eOTLzTOGVPpLqF4A7XPFiP+rdGyQ1b2GXV+6vzQbiKoo+utAH3DdNc1l9g0a3iPx
ifuxNdKDq+5fAyy8+Xbq/FuK7ClYmfmpcSYem8eD9K/xuLVtv72pc+9s2FpNX3E7
IOFFK7glJ6GNUZ2xwRHQ
=0D7v
-----END PGP SIGNATURE-----

--=-j0HGIMHlezw3ERcXLZDv--

