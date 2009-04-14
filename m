Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZDNVDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 17:03:53 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <20090408180644.GH7802@khazad-dum.debian.net>
References: <1238349195.24972.5.camel@johannes.local>
	 <20090330211513.GF23749@khazad-dum.debian.net>
	 <20090405145941.GA24963@khazad-dum.debian.net>
	 <1239100579.22453.38.camel@johannes.local>
	 <20090408180644.GH7802@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hXrCBdo45oTkjcQLpaQ4"
Date: Tue, 14 Apr 2009 23:03:18 +0200
Message-Id: <1239742998.4205.15.camel@johannes.local> (sfid-20090414_234556_320895_4959DED6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hXrCBdo45oTkjcQLpaQ4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Alright, finally got some spare cycles.

> > > I.e. I can get AE_BUSY or something else while querying the thinkpad
> > > firmware, and then, what should I do to return the data on the
> > > query_state (and, for that matter, poll_hw_block) hooks?
> > >=20
> > > Since there can be a clear error path from userspace to the rfkill
> > > driver for reads and writes in many situations (e.g. on all sysfs
> > > accesses to that driver's rfkill struct), this would be a good reason
> > > to change the hooks to allow for that error path.
> >=20
> > Totally bogus argument -- 99.9% of users will be using rfkill's input
> > handler which has no way of reacting to errors, and neither does
>=20
> Well, network manager would be using sysfs, and that's something that can
> report errors properly to the user, if it gets them from the kernel.

Actually, no. I removed actually polling the rfkill driver on sysfs
accesses -- and that was intentional. If we keep that we get into
strange situations like a sysfs read can causing a uevent, or having
some userspace app poll the sysfs file because the kernel polling isn't
working properly or ...

> > userspace. And it's wrong too -- the sysfs files don't actually call
> > into rfkill, they just report the current status.
>=20
> Indeed, I just looked at the code.  I don't know why I had this wrong
> recollection that I had added a proper error path there.

You might have had that and I removed it? Anyway, I think it's bad, see
above.

> [snip]
> Yes, it _is_
> far-fetched, but that's what is behind the regulations that brought rfkil=
l
> to life.

Alright, I see where you're coming from -- I still think we shouldn't
treat rfkill as a "nuclear power plant" control but rather as a "don't
want wireless" control -- your opinion clearly differs.

> Anyway, please document that in case of errors one is to return "false" i=
n
> the kerneldoc if you won't add the error status to the API.

I'm now convinced we should just treat errors as transient and allow
poll to say "no state change". If there is a possibility that there are
errors that don't go away (are not transient) then the driver should
probably just unregister the rfkill.

> > I can be convinced to change the prototype of poll_hw_block to
> >=20
> > 	void (*poll_hw_block)(void *data, bool *blocked);
> >=20
> > so that drivers can say
> > 	"*shrug*, I dunno right now, keep whatever I told you last".
> > Returning an error, however, is completely pointless.
>=20
> See my arguments above about why I like the error status in the hook API.
> I think we will just have to agree to disagree on that.
>=20
> And I don't personally care much about the constant poll hook (poll_*),
> just about the opportunistic poll hook (get_status), and the hook to set
> radio state.

Mind you, the get_status() hook changed semantics and was renamed to
query_hw_block(); you used to call it in sysfs and some other places I
think, I now only call it for the weird case where an input button can
cause an rfkill status update... Only Dell does that weird thing afaict.

> Still, I just ask that you document these requirements explicitly in the
> kerneldoc entry for the hooks, as well as the expected behaviour the hook=
s
> should take on error conditions ("return false", "don't touch the state",
> whatever).

Will do.

> > > BTW: it is probably a good idea to document what the driver should do=
 if
> > > the core tries this on a radio that is hardware blocked, or if the
> > > driver discovers the radio is hardware blocked the instant it tries t=
o
> > > software unblock it...
> >=20
> > The first case doesn't happen... And it says so in the header file:
> >=20
> >  * @set_block: turn the transmitter on (blocked =3D=3D false) or off
> >  *      (blocked =3D=3D true) -- this is called only while the transmit=
ter
> >  *      is not hard-blocked. This must be assigned.
> >=20
> > The second case _shouldn't_ happen (but can, due to race conditions);
> > Then you just call set_hw_state before returning.
>=20
> That is the sort of stuff that belongs in a doc somewhere for sure,
> although one could infer it since the set_hw_state function makes it clea=
r
> that it can be called from anywhere, anytime... but it is not obvious.

I'll add a note.

> > > It would be nice to have the core export a way to "force" both sw and=
 hw
> > > states at once, as well.  This lets the core optimize the issuing of
> > > events and other internal changes and avoids bad mojo if the driver d=
oes
> > > sw/hw force calls in the wrong order (which might cause a unblock-blo=
ck
> > > fast sequence, etc).
> > >=20
> > > This would let drivers that have the worst case software blocking (it
> > > exists, hw blocking also exists and is separate, and both sw and hw
> > > blocking state could change behind the driver's back) work well, with=
out
> > > causing any extra complexity to the other drivers.
> >=20
> > There may be some value in that, do you need polling for both though?
> > Otherwise you'd need
> > 	if (hw_blocked)
> > 		set_hw_state(hw_blocked)
> > 		set_sw_state(sw_blocked)
> > 	else
> > 		set_sw_state(sw_blocked)
> > 		set_hw_state(hw_blocked)
>=20
> Well, *I* have full events, so I can disable polling altoghether, and do
> the above.

I'll allow you to merge it into set_state(hw, sw) though, I think.

> However, I liked the old rfkill core 'opportunistic polling' through the
> get_state hook, which the new core could also do, because it GREATLY
> reduced the time window where a state could be wrong because of some sort
> of misdelivery of events (you can NEVER trust ACPI-based crap too much).
>=20
> And to use the opportunistic pooling, I'd need to be able to return both
> states, so I'd need the query_state hook to let me return both states at
> once.
>=20
> So, I'd really appreciate a "void get_state(void *data, bool *sw, bool
> *hw)" hook (since you won't give me error status).
>=20
> Or maybe even change the get_state and poll_hw hooks to a "void
> (hook)(void *data)" thing, where the driver is expected to use
> set_hw_state and friends to do the update instead of returning values.

Indeed, that would work as well and would simplify the API.

Can you explain how such a query method can reduce the time window of a
wrong state though? I honestly don't understand that.

> As for the small code snippet above, I ask that you add a
> set_hw_sw_state() function.  It would make my life as a driver writer
> easier, it would be simpler to understand, and it would give the rfkill
> core better optimization oportunities to avoid transient spurious
> blocks/unblocks.

Yeah, will do.

> > If you really do need polling for the sw state as well as the hw state,
> > I can be convinced to change poll_hw_block to
> >=20
> > 	void (*poll_block)(void *data, bool *hw_blocked, bool *sw_blocked);
>=20
> Do that to get_state() as well, and give me set_hw_sw_state(bool sw, bool
> hw), and we have a deal.
>=20
> Or change the poll and get_state hooks to void (*hook)(void *data), and
> give us set_hw_state, set_sw_state and set_hw_sw_state functions to call.
> I find this to be easier to use, but either choice would make me happy.

I agree, removing the arguments seems simpler.

> > You need much better reasons, however, to convince me to add any error
> > return, I see absolutely no value in that. Neither rfkill's input
> > handler nor the polling nor userspace has any means to react to errors.
>=20
> Userspace can react to errors, by notifying the user.  rfkill-input can't
> do anything right now, but we COULD (if the userspace people wanted) issu=
e
> uevents to get notifications sent to the user.  My point is that we can
> certainly propagate the errors to someone who could do something about it
> if we wanted, as long as we have the errors to propagate.

Sure, and then when the user was notified how can the user react? Either
the error is transient, in which case the user can only try again (but
why don't we program it to do that then?), or the error is permanent in
which case the user cannot do anything either. So what gives?

johannes

--=-hXrCBdo45oTkjcQLpaQ4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5PoTAAoJEKVg1VMiehFYWR4QAIBu2pzu/0a8w1VEySH2oojb
6xERhh/tfotgN/LwmKhe85x7d4KVHQzrrop8z0eTHf4Qu8XEHgM6IHr319HlL9Z+
Ckem2L54aVVCmU8JfqIUzDy5yabUUdhjCj2iJ9T1DtH0Y0aWymiAhl9yRHrBhr9o
gzPqShIX6gVY9UQqPyULd/s2typtNfYiW3I2M0I/yMJ8Fc44Mzbk1XcnTdV7J+6b
4wUJZB5Fn/UHouy62XaIe4Vhw2l5vQpnovwPOdUVnj7yG/zK1HhLG6yQhakdtqeI
rdIXXD4p7pxP0+79IXerRvnQxGRXmKQWTDyDQZmIlNgd4dJCIRspRDE2BkHrBw3d
5NCYJw3FKr753AryC0Q4gM1KN3V8sWTgC81zzA51uBLMzC/UoZOraFWObT+vE4gX
6R+y83Huj7obpyHMw7FLgH11rkkq6iJ0a0XX/wHGiXIWHOdbT/Yw2yCohztWlExx
UJXu434Zsy4FwzAgu46i6QXJiVuBBOOrpxH0GMemMuA5VyH47aYCsNBUh6J2DGmx
tqEesWoLXFdd2S6BLl7NoAfGtBqbkSpwz4tswqCQuwotuRVwq4lVA7i77ZPVEe9v
neOB/OkCs3m+iwqwg4uzyaPBzPq5diMMIhAPbj+jN7fFDfRmsee9Nh5O0Ztloigq
lb9grk9uRocw1IrnlLY8
=8qdR
-----END PGP SIGNATURE-----

--=-hXrCBdo45oTkjcQLpaQ4--

