Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:64262 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060AbXDABXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2007 21:23:12 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: mac80211 does not support WPA when used with wext
Date: Sat, 31 Mar 2007 21:21:22 -0400
Cc: Johannes Berg <johannes@sipsolutions.net>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@redhat.com>, Jiri Benc <jbenc@suse.cz>
References: <460E2B8C.4030002@gmail.com> <200703311503.53445.flamingice@sourmilk.net> <1175388940.10282.7.camel@localhost.localdomain>
In-Reply-To: <1175388940.10282.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2719364.TiBnRuYrJU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703312121.26758.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2719364.TiBnRuYrJU
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 31 March 2007 20:55, Dan Williams wrote:
> wpa_supplicant works fine with it because it parses the custom events.
>
> NetworkManager will not parse custom events by design, in the same way
> that it will not allow WPA to be used on a card unless the driver
> explicitly advertises WPA support, and requires the use of the
> wpa_supplicant WEXT driver.  I'm not going to spend my time implementing
> stuff 3 different ways; we need to standardize this stuff and stick with
> it.
>
> Draw a line in the sand and all that.  Sure, it's made some people's
> lives harder, but NetworkManager was the reason madwifi added WE-19
> support, for example.
>
NetworkManager doesn't parse custom events? I'm pretty sure WPA/WPA2 was=20
reported correctly in the scan results before.. maybe because of this littl=
e=20
bit of code?

NetworkManager-0.6.4/src/nm-device-802-11-wireless.c:
case IWEVCUSTOM:
    clen =3D iwe->u.data.length;
    if (custom + clen > end)
        break;
    if (clen > 7 && ((strncmp (custom, "wpa_ie=3D", 7) =3D=3D 0) || (strncm=
p=20
(custom, "rsn_ie=3D", 7) =3D=3D 0)))
=2E..

But that's besides the point. It is true that proper events should be used,=
=20
but that issue has nothing to do with why WPA isn't working with=20
NetworkManager. That was my point.

> Patch looks good though; thanks!  One thing I just thought of, which no
> drivers probably do.  Should mac80211 check that there's enough space
> left in the WE stream to actually add the IE?  There are usually checks
> to ensure that there's enough space to add the next whole BSS, but I
> don't know if we do checks to during the addition of each BSS.  Maybe
> I'm wrong and this isn't an issue.
>
iwe_stream_add_point(char *     stream,         /* Stream of events */
                     char *     ends,           /* End of stream */
                     struct iw_event *iwe,      /* Payload length + flags */
                     char *     extra)          /* More payload */
{
        int     event_len =3D IW_EV_POINT_LEN + iwe->u.data.length;
        /* Check if it's possible */
        if(likely((stream + event_len) < ends)) {

=2DMichael Wu

--nextPart2719364.TiBnRuYrJU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGDwkWT3Oqt9AH4aERAj4WAJ4seT7y9tzhmHT4i1U9ho5xT4RRiwCg0Zzl
kluxprSQiFSo9QSa35/ueS8=
=fPGz
-----END PGP SIGNATURE-----

--nextPart2719364.TiBnRuYrJU--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
