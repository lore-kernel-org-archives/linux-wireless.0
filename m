Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47955 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364AbZGPWTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 18:19:23 -0400
Subject: Re: unable to bring up iwlagn wireless after update from 2.6.29.6
 to 2.6.31-rc3
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Backlund <tmb@mandriva.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A5FA52D.7030701@mandriva.org>
References: <4A5D0374.5040702@mandriva.org>
	 <1247611024.1796.21.camel@johannes.local>  <4A5D0A7F.5090108@mandriva.org>
	 <1247672725.17896.1974.camel@rc-desk>  <4A5FA52D.7030701@mandriva.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ElKcmEpYEIxGudLZxkZr"
Date: Fri, 17 Jul 2009 00:18:51 +0200
Message-Id: <1247782731.31442.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ElKcmEpYEIxGudLZxkZr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-17 at 01:09 +0300, Thomas Backlund wrote:

> Nope.
> Nothing gets logged when I press the rfkill...
>=20
> I'd say that the rfkill rewrite killed my wireless :-(
>=20
> Bluetooth works at it whould, but not the wireless
>=20
> But now I have atleast found one way to get it working...
>=20
> I've built the rfkill utility, and with it I can get the wireless working=
...

Thanks for the analysis!

> Here is the output when wireless works:
> [root@tmb-laptop rfkill]# ./rfkill list
> 0: acer-wireless: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: no
> 1: acer-bluetooth: Bluetooth
> 	Soft blocked: yes
> 	Hard blocked: no
> 2: phy0: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: no

Makes sense that it works at this point :)

> Pressing the rfkill button gets me this:
> [root@tmb-laptop rfkill]# ./rfkill list
> 0: acer-wireless: Wireless LAN
> 	Soft blocked: yes
> 	Hard blocked: no
> 1: acer-bluetooth: Bluetooth
> 	Soft blocked: yes
> 	Hard blocked: no
> 2: phy0: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: yes

So far so good. Your platform's soft-switch is wired to the card's hard
kill line. Mind trying

	./rfkill unblock 0

(or whatever ID the acer-wireless has) at this point to see what
happens? I would hope it goes back to the working state.

> And pressing it again gets this:
> [root@tmb-laptop rfkill]# ./rfkill list
> 0: acer-wireless: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: no
> 1: acer-bluetooth: Bluetooth
> 	Soft blocked: yes
> 	Hard blocked: no
> 2: phy0: Wireless LAN
> 	Soft blocked: yes
> 	Hard blocked: no
>=20
> And after that I cant get wireless back until I again do a:
> ./rfkill unblock 2
> (works only when acer-wireless is no/no and Wireless LAN is yes/no)

Right. This is bad. The button press shouldn't have affected the
soft-state of the rfkill #2.

> Applying this patch:
> [PATCH] rfkill: fix rfkill_set_states() to set the hw state
> sent by Alan Jenkins does not help this issue either...
>=20
> Any  suggestions how to fix the rfkill ?

I'll poke at the acer code to see what it's doing wrong...

johannes

--=-ElKcmEpYEIxGudLZxkZr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKX6dIAAoJEODzc/N7+QmaViQP/RPWU174cTZjYCpd/Hzdp5GG
rAoj9PW3o7MsU+KYcnDy3Rah+GKP7clpyBjgUW0n2PsXGDYkguC/rSPSyQFIrjem
0zRCmQKQ57m1oD/waODtbgl1me9lX7mscn4Vm5i+4VVZ3TCZDsI8HC/PMbmqlxuZ
JO3wMn05jcNWTH0p3Q6VlQoSYAFbmRJe2eQmkmzSy01REfcZG5+ZmCfJGjNDqp9p
tIrAdSVrQKmGgMsTqdBb5CRST2s0ZyooAVGkn61E0hIGK0s2FeDhd//EFj1dopFC
tCkH27stl7yBQ1N0iBxcmScT9z+RoA7R6suqMZPEhgpa/YP95WwWePo+6lyAXUkB
oBEFsZaVSVu2KmgYIIFPHYYd9RrxA3hyGnHSfsTTDgSngIpgya8EmfRNw2v39Jnq
f6D8lVPJS4bPLDjzVSkz7kVlH2PafTNxDScrYvEwrGyyKP+iMnJV9+bQA2HCwbZm
VfUoSGbvtmFNpP8SpAnMH4sa+MncXJ1LbnlyT7YQBhjUhgUIeC+n6bZZT6ikTzj6
YnSpJOWMdYdxUCvCGg6jbvy2MHleJEVzR+I18JNV6F8gidy76o38ISBtFKViQtjX
cwaKVn0j228LnH7tRMgK+WpS0KASLtSU6du8DXr8mX6l7rR5RuEExteTW/ScmzK+
lsA4GMwNIMqbmijhLzeM
=HGkg
-----END PGP SIGNATURE-----

--=-ElKcmEpYEIxGudLZxkZr--

