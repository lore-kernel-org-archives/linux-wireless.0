Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYISI4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 04:56:40 -0400
Subject: Re: technology preview: scan with cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <1ba2fa240809190103i69c66978he4762fd350ab2e5d@mail.gmail.com> (sfid-20080919_100303_802308_72777315)
References: <1221794329.10419.9.camel@johannes.berg>
	 <1221795715.10419.15.camel@johannes.berg>
	 <1ba2fa240809190103i69c66978he4762fd350ab2e5d@mail.gmail.com>
	 (sfid-20080919_100303_802308_72777315)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r10flTTu5Fb++hvIy6A9"
Date: Fri, 19 Sep 2008 10:56:05 +0200
Message-Id: <1221814565.10419.19.camel@johannes.berg> (sfid-20080919_105644_674511_EC36B4A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r10flTTu5Fb++hvIy6A9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-19 at 11:03 +0300, Tomas Winkler wrote:
> On Fri, Sep 19, 2008 at 6:41 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2008-09-19 at 05:18 +0200, Johannes Berg wrote:
> >> This is totally incomplete:
> >>
> >> cfg80211 needs to
> >>  * actually hash on the BSSID instead of putting things into a list
> >>  * provide BSS list functions so mac80211 need not keep track
> >>  * allow a "private" area in each scan result with hw-provided size
> >>  * handle mesh properly
> >>  * provide a way for the hw to limit the number of SSIDs in a scan

> Don't understand this requirement?

Limiting the number of SSIDs? Well I don't want to have userspace
request an active scan for like 100 SSIDs, which currently _is_ possible
(mac80211 will reject anything but 1 right now though). Hence, I want to
have a "max probes" or something like that in the wiphy structure that
we can use (a) tell userspace how many we support and (b) limit the
number appropriately.

>   * provide a way to limit the number of channels in a scan (for
> faster roaming candidate search)

Hey, unfair! ;) I did leave a lot of TODOs but this wasn't one of them.
You can provide a channel list and it'll scan only those (except hw scan
right now but that'll be fixed once we pass the scan request struct
through)

johannes

--=-r10flTTu5Fb++hvIy6A9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI02kgAAoJEKVg1VMiehFYHzUP/2k0EkfA6bkgxm9HEu+U58Xh
ZDtaF8u6NIbhN6Bb3sUcFFYm0flADurOvudvJNr+wZxWhf/dd+v3VoXugHAigQCR
/dhTsKg4oBGw0QrmkqRKk6MaOOsHAAk8nJpWGH128zU6Nqkv0kY5Cif8E8DLGwsU
GLnvD6T4nodHgum4ydA3uj0YBL6gayGdWslx8DcVGz3fAGX20tRtAcfmx9W3SZaG
LGcWnb6KWlH689Z4sv2rAoXpjdc1CZLwyHmfgy9z5iOGfhjQPKReTyAaelCSD35m
42+5Z9gmuwo3Axfnwq3SWh1dlH8qpLXFuhqKfFBYnlw1PVviY9vkaVb0eEA8mMfT
h6YQeKeCuP6pUQaUp9Ggn/sK5u+F96vUI+lr23Dv3mKGtFBmyE1xODOJpWiOgozw
WPjJ9ApGWbdBU8YqHG1AAv7mw+ddOSEFBER2On/4CQPd5XcH2tMLSltZ2gG19K21
VzRlH4q9ztBjVXaQdID66B7Nxo6mvfiaJ2Gxh+ahAlRhKpEf9+Z3UUk42w0dRW2O
aam/Qumtni0ZpxwbEEna/Zi8x5ng8hD9rayMhC4Yt0p/DiO+u5PioxgmB3ivZLUB
DdymLPsMO9/6u2ZxI+DF6dxo/TX4Eq+eqWVFZZl+FzxEGEGzWJP1ZF1bISjhUW/A
AHlZkXheMNhDZpX1L4aj
=WMv3
-----END PGP SIGNATURE-----

--=-r10flTTu5Fb++hvIy6A9--

