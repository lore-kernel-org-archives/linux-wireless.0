Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYFYKCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 06:02:54 -0400
Subject: Re: Broken fragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806250250k2ae66eddre00172f6bc871fcb@mail.gmail.com> (sfid-20080625_115014_290743_215B6A5E)
References: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com>
	 <1213878207.8967.6.camel@johannes.berg>
	 <1ba2fa240806190608h3d833dbaua412446e8a9f560d@mail.gmail.com>
	 <1213881855.8967.19.camel@johannes.berg>
	 <1ba2fa240806190745u2fe7e435y3ca207af4156767b@mail.gmail.com>
	 <1213889200.8967.26.camel@johannes.berg>
	 <1ba2fa240806191113nd6a221eiac9648edd3404a80@mail.gmail.com>
	 <1213899419.8967.59.camel@johannes.berg>
	 <1ba2fa240806191409k7200ad53y654a7f8a117c8f14@mail.gmail.com>
	 <1213910734.8967.117.camel@johannes.berg>
	 <1ba2fa240806250250k2ae66eddre00172f6bc871fcb@mail.gmail.com>
	 (sfid-20080625_115014_290743_215B6A5E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Wrl5xxlGGzF6m1nZ/rRz"
Date: Wed, 25 Jun 2008 12:02:13 +0200
Message-Id: <1214388133.21847.8.camel@johannes.berg> (sfid-20080625_120258_171286_55DA19F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Wrl5xxlGGzF6m1nZ/rRz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-25 at 12:50 +0300, Tomas Winkler wrote:
> On Fri, Jun 20, 2008 at 12:25 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >> >> Fragments are in the air but the peer is not able to reassemble the=
m.
> >> >> Something is wrong with the first fragment but I'm not sure yet.
> >> >
> >> > Hm, ok. got a packet capture? Maybe that was broken before, I rememb=
er
> >> > having problems with fragmentation but putting it down to the
> >> > known-to-be-completely-broken AP I was using.
> >>
> >> It is working the latest problem was caused by the driver, Yet i still
> >> don't understand the regression
> >> in the driver.
> >
> > Hmm, ok.
> >
> So the bug is still in mac80211. Fragments are scheduled to different
> TIDs and hence to different queues.
> Investigating further. If you have something in mind let me know

Hmm, yes, I do indeed, try

skb_copy_queue_mapping(frag, first);

where you previously added the cb copy.

johannes

--=-Wrl5xxlGGzF6m1nZ/rRz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYheiAAoJEKVg1VMiehFYq9MQAIKTVj4ofFil7LKnAjDDrkJi
vAfJdp9eb7QqVMb2LsExcYz/g09AjWo/ogxHXoaaz5ruM+E/DAinO+1yja7pFSrT
f2kWmociO9ABWnDFzMi1abYj95oTonUshVpBgYDSmeb2j5fRz7Bu45ErZewoMqz0
ZXlTx6n4d2E/fAo0T0C1gS9VShFKeFRU4KBDr2Bu+R9Ok6fXsCexjtqfC4ShtrDT
zoekr0EH6+VGoZPYNHkC5HIhuUp+1cqTTIEbanwarXE5syYtQbCyKDjxvEAYzsE1
8Vd4pi8lPHuAb09hWoT3uRjEttEkEwiVZID+fmhYNc/K0zwGmTS43NwhmVvDE8BC
7HiAq/vwk+onyJ8Z5uEPPPEchNpwte8bqW9Q1xiU2UJPtI009NQ+05+sbXkjyT3A
+gHg/BxKPKl6R4lYPQ/eSUphUakPx/ABZzppfYe+3Ez8wNkD5B75p0MzvpAG1CST
+vC8X2KBKHJewjNursnRV+G1JZ7V9O0nJGIMUgwZ3rE9n0kx53p+D1kWimTcz4LE
9u+lWxrI8goUsIpYXiT1KxQ6kY6ruddz7CN/uHeDfdtTqyktXCczZOuTeobqqtI5
01nxBFE6dl3aWJ82wHhbb05oobmg16X9okdbJzkA8IMCunDH6NPw6z94MrzMCka3
RYtIDazdeDkQ+eQY0Vlj
=VVNl
-----END PGP SIGNATURE-----

--=-Wrl5xxlGGzF6m1nZ/rRz--

