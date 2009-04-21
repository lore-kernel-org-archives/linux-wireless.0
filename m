Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60675 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbZDUXTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 19:19:35 -0400
Subject: Re: SME/MLME notes
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <20090421204146.GA8325@jm.kir.nu>
References: <1239980203.32113.31.camel@johannes.local>
	 <20090421204146.GA8325@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-52cRKtkvW3NrPD4cMqry"
Date: Wed, 22 Apr 2009 01:18:45 +0200
Message-Id: <1240355925.17388.62.camel@johannes.local> (sfid-20090422_011940_268298_F071DB63)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-52cRKtkvW3NrPD4cMqry
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-21 at 23:41 +0300, Jouni Malinen wrote:

> > 1) I think I've asked this before but don't remember the answer, why
> >    does nl80211 not require an SSID for AUTH? It seems wpa_supplicant's
> >    sme.c always requires an SSID, so we would always have one in the
> >    kernel -- and it would seem to be easier to implement it all too.
> >    Also, it seems very strange things might happen if the SSID isn't
> >    passed and the kernel somehow knows, from a previous scan, about a
> >    hidden SSID that was unwanted, but now gets selected?! Can we just
> >    require the SSID?
> >    I know technically we don't need it, we could auth with multi-SSID
> >    network's AP and only at assoc time select the SSID, but ...
>=20
> wpa_supplicant happens to know the SSID at that point and adding SSID to
> authentication data helped in implementing some steps for
> authentication. Since SSID is not strictly speaking required for
> authentication, I did not make it a required attribute. However, I do
> not have anything against making this attribute required for
> authentication (maybe with a suitable note in nl80211.h indicating why
> it is required since that may be somewhat surprising requirement for
> someone familiar with the MLME primitives).

Alright. Yes, the MLME primitive doesn't include it so I agree it needs
a note on why it is needed (or at least _that_), but I can't see anyone
ever wanting to auth with a network they don't know the SSID for yet...

> > 2) We need a way to query which AP(s) we're authenticated with -- we
> >    should have association too but that you can get via the station
> >    code. But for authentications we don't add any station structs. Or d=
o
> >    we not care and say that the SME needs to keep track?
>=20
> I would say that SME should keep track of this regardless of whether we
> internally have that information or not. As such, I would not consider
> this mechanism essential (but sure, if we ever end up adding the STA
> entry at this point, its authentication status should be available at
> least in debugfs).

Ok.

> > 3) Related to 2), when we authenticate with two or more APs, but then g=
o
> >    to associate with one of them, which is possible to request in the
> >    current API, we might never know, due to powersaving features,
> >    whether the other APs deauthenticated us. Can we rely on the SME not
> >    doing stupid things like that?
>=20
> Which part here do you consider to be "stupid"? ;-) Authenticating with
> multiple APs? I think it would be perfectly fine for the SME to try to
> do this and the AP that deauthenticated the STA would just reply with a
> deauthentication frame (which needs to be reported to the SME). Anyway,
> I would expect a common implementation of SME to request authentication
> just before the association in all cases even if a previous
> authentication might exist.

Well, say the SMe tries to assoc with an AP it authenticated with ... 15
minutes ago. I suppose it just has to be prepared to get "no sorry", so
it's not really all _that_ stupid.

> > 4) When we try to authenticate while associated (FT-over-the-air), we
> >    need to turn off powersaving, I think?
>=20
> It depends on what exactly you mean with power saving.. Especially, if
> we were to support FT resource reservation protocol at some point, it
> would be reasonable to expect the STA to go to power save mode with the
> current (old) AP prior to starting FT over-the-air with the target AP.
> If the authentication (FT resource reservation) fails, the STA may still
> continue to use the association with the old AP.
>=20
> As far as power save state with the new AP is concerned, yes, we will
> need to remain awake to receive the authentication frame from the AP.

I was only thinking of the last bit -- to receive auth frames. This will
be fun in mac80211, but is related to what I said before, I don't think
FT from an AP to another can work properly right now, _especially_ not
if the second AP denies the association.

> > 6) The sme.c code contains a TODO about timeout -- mac80211 gives up
> >    authenticating when it doesn't get a reply to the frame after three
> >    times. Should
> >    a) those retries be configurable or at least discoverable, maybe
> >       some devices do not support configuration, or maybe both?
>=20
> I think I would be fine keeping this simple and just make this
> automatically configured in the driver and not bother with making this
> discoverable. Trying the same frame three times does not make much point
> in most cases, i.e., one attempt (at least if a reply is received)
> should be enough..
>=20
> >    b) there be an event when reached?
>=20
> Yes, that sounds like a good idea.

I keep getting bitten by it so I really have an interest in that ;) For
wext we currently send "disassoc" or whatever, but I suppose a new event
would be better here.

> > 7) Your SME code never tries to use a different authentication algorith=
m
> >    if the first one failed? Is that correct or could networks use LEAP
> >    _or_ OPEN?
>=20
> I did not yet implement proper handling for the case where multiple auth
> algs are enabled. SME should interpret the non-zero status code and
> figure otu that it need to try another authentication algorithm.

Ok. Just wondering really -- cfg80211's wext SME will need that too.

> > 8) The associate command takes a channel -- is that required? It seems
> >    that once you've authenticated you pretty much know that already, or
> >    do we need the SSID/BSSID/Channel to uniquely determine the BSS? The
> >    corresponding mac80211 code ignores it completely too.
>=20
> Since SME has it, it was simple to just pass it in. I don't know whether
> it would really ever be required. This is partly from the design where a
> single connect request could be used (the alternative for supporting
> drivers that do not support separate authentication and association
> step) and it would be useful to have all the needed information
> available.

Wrt. connect() request, I don't think it should use the assoc() command,
but that remains to be seen (of course, I know somebody who would
vehemently argue that not using it would be MSDOS) -- the thing is that
I would like to be able to validate the assoc() command in cfg80211
against the AP that we authenticated with.

> > 9) Disassoc should check that we are associated, deauth is more
> >    complicated because of multiple authentications, cf. 3), do we care
> >    about auth?
>=20
> Hmm.. There could be potential problems if the AP and STA get
> out-of-sync on auth or assoc state and we prevent the SME from sending
> out a deauthentication frame which could otherwise be used as a way to
> clean up the state in the AP (until 802.11w comes into play ;-). I
> wouldn't be concerned if we do not verify the state for deauthentication
> (or even for disassociation, for that matter).

Good point. I need to think more about how to keep track of things in
cfg80211 wrt. auth/assoc states.

> > 10) I would like the cfg80211 auth/assoc ops to take cfg80211_bss
> >     structs. This requires having the SSID -- see 1). It would mean
> >     cfg80211 could hold the BSS and keep a pointer, also fixing that
> >     "hidden SSID scan result hold forever" issue. Also, it would mean
> >     that cfg80211 has to issue a scan when it cannot find the BSS, but
> >     that scan can be restricted to the SSID (and possibly the channel)
>=20
> OK, sounds reasonable (and yes, please do restrict it to the channel,
> too, if known ;-).

Yeah, if known -- well, requested from the SME. Of course, if we just
require a channel we always know it ;) OTOH, the wext SME in cfg80211 is
related to this and doesn't always have a channel so maybe not worth
requiring one in nl80211.

> > 12) Beacon updates could update all BSS structs we know about that have
> >     the same BSSID (and channel?) -- also the one we're holding, just i=
n
> >     case we are connected to a hidden network. Not quite sure yet how t=
o
> >     do this though, the SSID might disappear then or something... Needs
> >     more thought.
>=20
> Signal strength should be updated for all entries with matching BSSID
> and same probably for other radio parameters (WMM changes, HT, quiet
> period, etc.). The parameters that are likely to be specific to an
> SSID (security configuration like WPA/RSN IE) should not be updated if
> there is not a matching SSID.

The question is how to really know what can be updated and not :)
Especially wrt. the IEs I think we probably should add another way to
pass this information to userspace, especially when we add API to
register interest in beacon changes. By that, I mean that somehow the
SME can say "I need changes in IE 42" [whatever that is] and we program
the hardware that way. But then we want an event when that actually
happens... Not really sure yet, but I have a feeling that scan results
aren't necessarily the best way. OTOH, we could just unilaterally send a
BSS struct to the application.

Maybe we should have both entries present, the one with the nulled-out
SSID and the one with the proper SSID from probe responses and have the
SME stitch it together?

johannes

--=-52cRKtkvW3NrPD4cMqry
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7lRSAAoJEKVg1VMiehFYxJUP/1olH6IllwiPF9ztuxKhS7dt
MOtuPVmRHl3bhnDxE1Wedh+qlmj6fhZ47fy1XEJoCS5zFpjfJhtgaka2JcFQ4mNZ
75fw034nlAA47e8SMuvW91jPGptXDgUnKTmuLjODcecPvPl70e2t/RHXh/ledrCe
TI3EH9h/VvF8rLpCtXhWE74DKTNeHSEMU2t+zFARPnvhST/VNv4YcZirolCuOjV1
E/H25jJ7JJOnj6fUZOzU6ZRcugp4280KQT4/EGAhaD2WU6o4qnyTw6qy3Q5n0GHz
eS2L1Li9FxyXrJ4VLn2sKCJLRRFdemZNTjorq6wN9Mv7oag/UBAjGafGZEn0jfRk
1mFv5LHT2zXtKT9E2KR3FUT90dwfjNB7QD2UQFalbb9qnZJBUjyzrnlMD2DPcSUm
US1WaewOA7UMurcxzfA+vI31WQ6Gr5WDZIkAOHY18EkVumL+VM20xpOfC0/Bj4fN
K/AgXbHmgYNytSlcL6H0YyfYwtUicMil9ZiIqk3a3wnfFEmmuVq0rFd8dw7rO8DA
VaQKKyKTQcsWrQCvxaqwjv7bya6DLW8sjBdOTmQEWmInQlpPNH2n6D952QxHX0xj
rRSax1xoANnyveZm+dEdusgE/kj3Fm2YWcxR3i85/DkYAnzmwQ8zF7iXS/gni6s0
YrGXig99TIKT1yPEck2L
=Dd8p
-----END PGP SIGNATURE-----

--=-52cRKtkvW3NrPD4cMqry--

