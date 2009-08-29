Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57342 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZH2Jed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2009 05:34:33 -0400
Subject: Re: [PATCH 1/2] cfg80211: initialize rate control after station
 inserted
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1251497929.3805.173.camel@rc-desk>
References: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>
	 <1251445557.4189.14.camel@johannes.local>
	 <1251474321.3805.73.camel@rc-desk>
	 <1251493298.3456.34.camel@johannes.local>
	 <1251497929.3805.173.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jPGC7eqvSGFTmpVLvhok"
Date: Sat, 29 Aug 2009 11:34:29 +0200
Message-Id: <1251538470.19422.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jPGC7eqvSGFTmpVLvhok
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Reinette,

> > Interesting. I've been thinking about making it go the other way --
> > remove rate scaling hooks completely. wl1271 apparently has rate scalin=
g
> > completely in the firmware, so the RS algorithm on the host is just
> > overhead. I've been thinking putting 4965+ RS into the _driver_ makes
> > more sense since it really does a lot in the firmware and not on the
> > host.
>=20
> Yes, it does do a lot in firmware. Unfortunately I am not too familiar
> with the details (yet).

As far as I know/can tell, you basically upload the LQ command to the
firmware for each station and it in a way controls the parameters. What
exactly it does I'm not sure, but I am pretty sure that we don't have up
to 16 retries programmed into the TX descriptor for each packet, but we
can do that many retries.

iwl_tx_cmd contains only a single rate_n_flags field, and then there's
TX_CMD_FLG_STA_RATE_MSK, there's a comment on that definition that
explains some more.

> > I've also been thinking if there's a way to make sta_notify() able to
> > sleep but so far I don't see one unfortunately.
>=20
> Having it sleep will help a lot. When a station is added we need to tell
> the device about it. Since the call cannot sleep we cannot really tell
> mac80211 if this failed because the failure will only be known at a
> later time. I have not yet figured out how to deal with this case.

Yeah, that would help. On the other hand, mac80211 isn't actually
prepared to deal with that. In fact, sta_notify has no return value. And
I'm not really sure how to deal with errors from it. Leaving AP aside
for a minute, I think we probably can't do anything. If we exceed the
capacity of the microcode's station memory, I think the best we can do
is just not use rate control for that station, and use the broadcast
station. It won't really happen anyway. And software crypto, of course.
So there's not much to be done.

Now looking at AP again, it _might_ make sense to tell hostapd "sorry we
can't really talk to that station well", but on the other hand I suspect
it's not a case we should really consider. I'd say we can export the
number of stations so that hostapd can actually try not to exceed the
limit in the first place.

As such, having the sta_notify callback sleep will not actually help
much.

I'd say we do the following: At startup, we program the broadcast STA
into the device so we always have that, and do that synchronously so if
that fails for some stupid reason. I think we already do that.

Then, we use a station private area that mac80211 can allocate for us to
store the STA_ID for each station. Set this to the broadcast STA ID,
which is always valid in some sense, at sta_notify(add) time. Then,
asynchronously, tell the device about the station. Once that command
finishes, look up the sta struct again and set the STA_ID to the new ID
that we used in the device. This way, a sta struct will always have a
valid sta ID in it.

Now, when we need to set a key for a station, we actually get the
station struct. Thus, we can keep two separate flag in the station
struct that tells us whether the STA_ADD was successful. If this flag is
unset, then we reject the add_key with -ENOSPC. Or when we detect that
the key command was too fast after the sta_notify we can wait for the
ADD_STA to finish in the key notification since that can sleep.

And then rate stuff we can just also do as part of the async sta add
command, so that the sta ID is only set after we have the sta programmed
into the device and also initialised rate control properly for it.
Ultimately the rate control algorithm could do nothing at all, and then
we can remove it completely.

> > As soon as sta_insert() got called, a packet transmitted to that statio=
n
> > can be processed, find the sta info, and it seems we could end up
> > calling rate_control_get_rate() before the init was done, through a rac=
e
> > condition.
>=20
> oh - I see - that's bad. Although, that may explain why iwlwifi is
> adding stations in get_rate() also.=20

No, the explanation for that is "history" :) The rate algorithm was
written before mac80211 actually _had_ the sta_notify command, and it
was (and still is, as you've pointed out in these patches) the first
place that is notified about the new station. But I think we don't
really need that.

johannes

--=-jPGC7eqvSGFTmpVLvhok
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKmPYjAAoJEODzc/N7+QmaoBgQAMnaXK67gQmt+ngRo7oPftfJ
j++5K9gkQ0CX4Qis8l4gxkeGbUcBTh8cDeGCEScDel0G2mDN2Yo3uBTQ57yy2GoW
kxvqnyi2afjl1MzRsByPFUZTOvjm3iKTtVgIy0ZvviwSBvdsOJGX3bzC7QPOyWmN
o70wl6SqLXJsDBobUjsGzDgbRWHbI6YOYl/6TqDINcTJajIGxILDlSAxESDRDHfK
Ouu3Ae9xSGenMewJMqz0CnUr2JP8PVU7SyinTaiWwl+bEiD9I56xlWMaCnIVwBW6
Packkr011tGqDV7rtlLkmkgiij2pOdoOcc610kveQOarTHPaC12JL0lvMThuq5IV
bPUQKN5Mm3EzDMhhrTugPMp+67X9ZYDxuPiGCCVw1gxg6nP41Mj2vwzk+cp6BsWg
ZQscKdc0UUVDDJsbnkXOfRli/UQcIjunh4kv48pOw3JjwImrdNBJPKjGOY9USnPe
R1AnIk+fMaqbZR2glhdaXV1hOF/2maT+xZvep1Jv6GpJvfgGqdsUFFFMhKMdasy3
6iqAhsa7DIvblqUeavWolitOBYJZyihC2uAUorEPuECN7gS0uRisAdx8S4+yQrUw
ZoFCI4e9ej0PFpoH0vG7TCoMW40JgDTFEfOcciP9c/dhRNH0jLXyJXqlM5kLvj1F
BDKoHPaMqqlyX2/vSQtY
=rD4Q
-----END PGP SIGNATURE-----

--=-jPGC7eqvSGFTmpVLvhok--

