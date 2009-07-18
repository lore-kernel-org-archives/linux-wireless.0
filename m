Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42740 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbZGRJ53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 05:57:29 -0400
Subject: Re: Setting rfkill from user space
From: Johannes Berg <johannes@sipsolutions.net>
To: tim.gardner@canonical.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A60E5EC.1080700@canonical.com>
References: <4A60E5EC.1080700@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pkwQYTiw6KSAig6/H6Il"
Date: Sat, 18 Jul 2009 11:57:24 +0200
Message-Id: <1247911044.1055.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pkwQYTiw6KSAig6/H6Il
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-17 at 14:58 -0600, Tim Gardner wrote:
> Johannes,
>=20
> Because the rfkill sysfs info moved around, I've been working on a
> program for the Debian acpi-support package that can be used to perform
> 2 operations; 1) discover if there are any wireless devices powered on,
> and 2) toggle the states of all wireless devices (at the same time).
>=20
> git://kernel.ubuntu.com/rtg/rfkill

Oh, I'm sorry, we already had http://git.sipsolutions.net/rfkill.git/, I
really should have publicised that more (and wasn't around when you
asked the question yesterday).

> I'm a bit confused about what idx is in the event structure. Other then
> ascending (though not monotonically), idx appears to have no real value
> to user space. I see in the rfkill driver where its being assigned, and
> it appears to be an rfkill instance number that describes a relationship
> to a device. For example:

Well, the index is just a unique identifier for each rfkill instance,
like the network interface index for instance. Yes, it doesn't really
have any value, but if you hot-plug rfkill instances (e.g. with a USB
wireless device) then you may want to know it's now a new instance.

> Here is the output before toggling and right after a boot:
>=20
> rtg@xps1330:~$ ./rfkill
> bluetooth 0 UNBLOCKED soft:0 hard:0
> wlan 1 UNBLOCKED soft:0 hard:0
> bluetooth 2 UNBLOCKED soft:0 hard:0
> wlan 3 UNBLOCKED soft:0 hard:0
> UNBLOCKED
>=20
> After toggling to BLOCKED:
>=20
> rtg@xps1330:~$ sudo ./rfkill 1
> [sudo] password for rtg:
> rtg@xps1330:~$ ./rfkill
> wlan 1 SOFT_BLOCKED soft:1 hard:0
> bluetooth 2 SOFT_BLOCKED soft:1 hard:0
> wlan 3 HARD_BLOCKED soft:1 hard:1
> BLOCKED
>=20
> After toggling to UNBLOCKED:
>=20
> rtg@xps1330:~$ sudo ./rfkill 0
> rtg@xps1330:~$ ./rfkill
> wlan 1 HARD_BLOCKED soft:0 hard:1
> bluetooth 2 HARD_BLOCKED soft:0 hard:1
> wlan 3 UNBLOCKED soft:0 hard:0
> bluetooth 4 UNBLOCKED soft:0 hard:0
> UNBLOCKED
>=20
> This laptop only has one wlan and one bluetooth device. Why the extra
> index values?

You mean, why the extra wlan? Well, if you poke sysfs (which our tool
does) you'll notice that you have different instances, in my case (no
laptop wireless button):

# ./rfkill list
11: hci0: Bluetooth
	Soft blocked: no
	Hard blocked: no
12: phy3: Wireless LAN
	Soft blocked: no
	Hard blocked: no

So I have 'hci0' and 'phy3', which is a cfg80211 device. You will,
additionally, have something like 'acer-wireless' or 'hp-wireless' or
whatever, which is the platform's rfkill.

That's also why you see 'hard blocked' in your case, because your
platform's soft-block is wired up to your wireless card's hard block.

johannes

--=-pkwQYTiw6KSAig6/H6Il
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKYZyBAAoJEODzc/N7+Qma8AUP/0speggik/MY+Moax9wGWxkk
wXmrgk3+kXBb0q8eUZeCZQTQyz5Lj2hHfCfcLNoza/lGPGcnoO3h4HWXOFrbH8le
RPsvWRlyKbez1wmtfUQPySJAlqWCEajW0ohDjRrHcvIUK3+B3KBM5EMguH+IMNB4
90l5oMIMAuftszDfRMBIuxbdBnuercayif//WqI932dwM8B4uBu3xZVWqaZM7NML
yuPU4tIie1+alqHHo9R+9KTHwDguzrY4NrDx0LhXiw94YbQpLXYw7mecvbrcmRBk
+Cj4Ym+UXyBEw21naMGqOdgEhJTnNsn97+aqlMBymI8yRJ19SGJrvv7JQC0TSK1S
vZSj1HYq0Sao4wcT1O9n2TVGbq9i9l0ng9KgYFDhpIRT5JOcbXF5tBp5M1C+E2X+
Cnc7h51fY94mka71tiMnA1t3/uZbpWlzSvAXXOdPu/C+vzbgBMPV9I8nEWydUona
jy5xZkcY0z0A9b46XogBHVIOyDnWHsraSVhtPQ2Xl+H+E1T83YO+5exK9Kp5E/gA
Lcf42r2J0hPcIo/ojn3YtpSn4ffs44fk+LGxWSmLSXtdKtqx4nvy3YaSLakVPT50
U8irDDazLxeoOs6IY5mXwsWIL9jlrRXA9M9CO1/LqNHEG0VogQ5d7oqc6rAY+5x2
psZd8lwAF5WbUEBf9hBE
=o7PL
-----END PGP SIGNATURE-----

--=-pkwQYTiw6KSAig6/H6Il--

