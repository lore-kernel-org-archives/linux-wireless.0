Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbXFHJaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 05:30:16 -0400
Subject: Re: IEEE802.11e/WMM TS management and DLS support
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1181290617.3039.158.camel@debian.sh.intel.com>
References: <20070606082152.GA28639@mail.intel.com>
	 <1181160060.3398.35.camel@johannes.berg>
	 <1181290617.3039.158.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8k59LGUYpPkzchlnAIuL"
Date: Fri, 08 Jun 2007 11:30:29 +0200
Message-Id: <1181295029.6533.45.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8k59LGUYpPkzchlnAIuL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-08 at 16:16 +0800, Zhu Yi wrote:

> Yes, the user space API should be in the cfg80211 format. End users
> definitely don't want to play with debugfs, it's only for developer's
> debugging. Defining a good API is not easy, but since the core code is
> there, we can begin the API discussion now.

Good :)
Can we start with use cases? I don't really know about TSM. DLS seems
easy enough though:

DLS_UC1:
 * Ariel wants to transfer large file from wireless peer

DLS_UC2:
 * Bert wants to stream video from a wireless peer

DLS_UC3:
 * Carla is developing firmware for a wireless file server and wants to
   support DLS for better performance

DLS_UC4:
 * Dorothy is using Carla's file server with a stock linux/mac80211
   laptop and wants to do the least thing possible to get DLS working
   when offered

Any more?

> I think 2) is the way to go. Kernel shouldn't involve in the decision
> making of DLS.=20

Alright.

> Switch to DLS intelligently in the user space sounds good
> but it doesn't relate to the kernel <-> user space API, you can do it
> all in the user space.

Actually, it does, because you do need all the information to make that
decision. I don't think we have per-MAC-address traffic statistics or
something.

> 1) User requests kernel to setup or tear down a DLS link with another
> STA (sync and async)
>=20
> 2) Kernel notifies the user space (daemon) a DLS request is sent from
> another STA and let user space to make the decision or an existed DLS
> connection is torn down by the peer (via event).

I'd think this should both be part of nl80211. It shouldn't be too hard
to add (1) (except I don't see the point in doing it synchronously and
would rather not) to nl80211, but I do appreciate that (2) isn't
something that's easily possible for lack of event API in
cfg80211/nl80211.

> BTW, I'd agree move the kernel MLME to user space if possible. I
> implemented in the kernel because a) it's simple and other MLMEs are
> also there, i.e ASSOC_REQ.  b) I don't know where to implement it in the
> user space, wpa_supplicant?  But if we=20

But if we [...]?

I'm not sure if we can live with having parts of the MLME in userspace
and parts in the kernel like if we'd put DLS setup into userspace now.
What somebody really needs to do is
 1) integrate the injection patches
 2) implement a nl80211 API for the userspace MLME
 3) fix the userspace MLME implementation stuff in mac80211 to work with
    the injection patches and the new nl80211 API
 4) publish an adapted userspace MLME that uses this (or patches to wpa
    supplicant)
 5) write some documentation
 6) put that userspace MLME into git, publish the tree on kernel.org and
    maintain it
 7) decree that wpa supplicant is on-topic for linux-wireless


Some of these have sub-points:
 2a) in mac80211, rip out all the userspace MLME stuff and analyse what
     is required
 2b) add the commands to nl80211 (make sure that only one userspace MLME
     can drive a single interface)
 2c) add the commands to cfg80211
 2d) re-implement the commands in mac80211 based on cfg80211
 2e) since we want to be able to configure the userspace MLME through
     the kernel, implement nl80211 command forwarding to the userspace
     MLME [1]

[1] Actually, I'd think that *all* commands should be forwarded to the
userspace MLME except for commands *from* the userspace MLME. That way,
the userspace MLME can act as a filter for commands which should make a
whole bunch of things easier.

Btw, Jouni, your email address in the wpa_supplicant developer docs is
still the old one :)

johannes

--=-8k59LGUYpPkzchlnAIuL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGaSG1/ETPhpq3jKURAvEoAJ96D7XIFO6nh19Dc4CcEA7SNXxJbgCfSU8j
0kfPV7HTNHCvzSsiNAR5l4k=
=fm0t
-----END PGP SIGNATURE-----

--=-8k59LGUYpPkzchlnAIuL--

