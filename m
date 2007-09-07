Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57330 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965352AbXIGNjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 09:39:07 -0400
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
In-Reply-To: <1189146702.16788.103.camel@debian.sh.intel.com>
References: <1188875058.13078.428.camel@debian.sh.intel.com>
	 <1189076408.28781.49.camel@johannes.berg>
	 <1189146702.16788.103.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cYVLPPoMnv/BdEGnWBmL"
Date: Fri, 07 Sep 2007 15:40:36 +0200
Message-Id: <1189172436.28781.148.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cYVLPPoMnv/BdEGnWBmL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-07 at 14:31 +0800, Zhu Yi wrote:

> >                 /* XXX: ACK flag must be set for CCMP even if it
> >                  * is a multicast/broadcast packet, because CCMP
> >                  * group communication encrypted by GTK is
> >                  * actually done by the AP. */
> >                 cmd->cmd.tx.tx_flags |=3D TX_CMD_FLG_ACK_MSK;
> >=20
> > and it doesn't make any sense at all. Care to explain? If we're a
> > station associated to some other AP, then mac80211 will *obviously* set
> > the "expect ack" bit on a "multicast data" packet that's being sent
> > since it's actually unicast in 802.11 terms to the AP before it resends
> > it using the group key...=20
>=20
> This is what exactly the above comment tells you. The comment speaks for
> the non-AP STA mode (the AP code was not there at that time). The
> tx_flags is used by the firmware, so whatever mac80211 set its flag, it
> has to be translated to the firmware's language -- because you are using
> hardware crypto.

But you need to have another place where this flag is set based on the
equivalent mac80211 flag, so this is not necessary.

> BTW=EF=BC=8C the whole 802.11 qdisc hack will be removed with
> the multiqueue supported in .24. =20

Yeah, is anybody working on that? I have to admit I didn't look into
that yet.

> We have the HT AGG support in our mac80211. Will submit the patch for
> review when we are ready.

Yeah I gathered that much from what Tomas said, but why do you keep
pushing for including this driver when you know it's not the right thing
to do?

> > iwl4965_sign_extend can be implemented a lot better like such:
> >=20
> > static inline s32 sign_extend(u32 value, u8 bits)
> > {
> > 	u8 shift =3D 32 - bits;
> >=20
> > 	return (s32)(value << shift) >> shift;
> > }
>=20
> Really? Are you sure this work?

Hmm? Of course, shift it up and then do a signed shift down.

> > Enough for now again.=20
>=20
> Please don't. We have given you enough time for commenting the code.
> Please do it in a batch like other people did. Don't squeeze a little in
> -rc2 and another little in -rc4, ... You are wasting people's time.

I just don't have enough time/energy to read through all this at once.

> James had done this several months ago. We did everything the mac80211
> people suggested, but the patch is still not merged. Do you think we'd
> really like to workaound the mac80211 issues in the driver, or even have
> our own mac80211 package? Absolutely not, if you mac80211 guys are easy
> to work with. Without creating our own mac80211 package, today, the
> users are still no better rate scale algorithm selection, no advanced
> wireless QoS, no 11N support, not even mention about link aggregation.

You still haven't fixed the issues we pointed out in the 11N
deaggregation code. And maybe we missed some things too. Also, I
personally only recently started working on mac80211 and Jiri seems to
have vanished completely.

> Something working is always better than something not working whatever
> how beautiful the code looks like. And I believe the current iwlwifi
> driver has reached the quality to be merged mainline (both it looks and
> it works).

Well, I disagree. I see no incentive for you to help improving mac80211
when we have a driver with lots of stuff that works around mac80211.

In any case, let's get back to more productive things. I apologise for
anything I might have said that offended you, I didn't mean to. All the
code that superficially looks like workarounds around mac80211 stuff
made me not like the code and I suppose that showed.

Can you post patches against the iwlwifi currently included in
wireless-dev? Currently, it seems that I have to either dig in your
repository or through your patches to figure out the current state of
things I commented on, which is suboptimal because I don't even get to
see the fixes to things I pointed out. I'd like to have iwlwifi in
wireless-dev be essentially the same as is merged into mainline, modulo
the bits that depend on things like HT deaggregation that are not in
mainline yet.

Incidentally, I currently have just about as much a hard time getting
things changed in mac80211 as you do because nobody wants to review that
code. Hence, it would even help if you could review the patches I posted
and maybe look if that is easy/possible to support with iwlwifi and
possibly even adapt iwlwifi and test so that John feels more confident
in merging patches. Conversely, I promise I'll review and test any
patches you make to mac80211 as time permits.

johannes

--=-cYVLPPoMnv/BdEGnWBmL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4VTU/ETPhpq3jKURAoQJAJ0VnxziHT6md7jjFRrxhFlJdpCSFQCfbZ+I
OUTvJqSI+EZIFPOVjOAwnW8=
=wk0E
-----END PGP SIGNATURE-----

--=-cYVLPPoMnv/BdEGnWBmL--

