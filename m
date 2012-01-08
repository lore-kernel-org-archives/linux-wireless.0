Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade2.minaslivre.org ([74.50.53.203]:33697 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2AHOON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 09:14:13 -0500
Date: Sun, 8 Jan 2012 12:07:56 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Strange behavior with rtl8192se
Message-ID: <20120108140753.GA2246@nautilus.holoscopio.com> (sfid-20120108_151433_015215_47F80224)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello, Larry.

I have some problems with rtl819se that I couldn't find out what the
reason is. I would like some ideas as to what look after, what debugging
I can make or what changes I could try in the driver to fix it.

The problem is that, sometimes, the adapter cannot receive probe
responses from my AP. Other devices in my network can reconnect to it,
so it's not a problem in the AP itself. There are other evidence that
point out to a problem with rtl8192se, as I will point out below.

So, usually this happens when, for some reason, I can't receive any
packages from the network. After that, I try to reconnect, with no
success. The problem is that, even after a reboot, I keep trying without
no success to associate. I need to shutdown the machine to get the
adapter back to work. And that's another evidence that the AP is not to
blame. And it also happens with other AP I have around. Below is what I
get in dmesg when trying to associate.

wlan0: direct probe to 36:d9:98:74:ff:42 (try 1/3)
wlan0: direct probe to 36:d9:98:74:ff:42 (try 2/3)
wlan0: direct probe to 36:d9:98:74:ff:42 (try 3/3)
wlan0: direct probe to 36:d9:98:74:ff:42 timed out
wlan0: direct probe to 36:d9:98:74:ff:42 (try 1/3)
wlan0: direct probe to 36:d9:98:74:ff:42 (try 2/3)
wlan0: direct probe to 36:d9:98:74:ff:42 (try 3/3)
wlan0: direct probe to 36:d9:98:74:ff:42 timed out

Since a reboot didn't work and a shutdown did fix it, I have tried
shutting down only the adapter, putting it into D3_cold state and then
back into D0, but that didn't work. That may be a problem with my
notebook and its ACPI implementation. What I have managed to do is to
hibernate: after a resume from that, it works as if I have shutdown. So,
it's really a matter of shutting down the adapter or the system, instead
of rebooting.

And that tells more: I have also tried to reload the driver and mac80211
stack, with no success. And since hibernate works, that is in their
favour to some extent. It indicates that's not a problem in a software
state. Well, there is the suspend and resume functions, but since
suspend didn't work and hibernate uses the same functions, they are not
fixing anything, neither breaking it.

So, what I suspect is either there is some state in the hardware, like a
filter for the BSSID or anything like that, that is not being cleared by
the driver, or there is something wrong with the platform, perhaps ACPI
is doing something stupid. There is not much reason to suspect the
latter, however, since this bug does not require me to switch rfkill off
and on or to unplug the notebook from the wall. It just happens if I
have to reconnect for any reason.

Since the adapter is not receiving probe responses from my AP, I decided
to run it on monitor too. And, well, it does not receive the probe
responses from my AP, but receives from some APs nearby. If I try to
associate with my other AP, however, it fails too. I have put another
device in monitor state too and have seen that the AP is sending the
responses, so the adapter is really sending the requests (which I also
saw in the monitor), but it's just not receivig the responses.

Note that this was all done two meters from the AP, so this should not
be a matter of distance or power. The other AP, whose responses I see
should be further away, since it's not in my apartment.

Any clues? I have run these monitor tests using 3.2-rc6. But I have also
run into this same problem running 3.2-03023-g02550d6, which is latest
rc, containing a merge from the last net-next.

Regards.
Cascardo.

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPCaM3AAoJEEWxSg7udFZIfzoP/2FTRYY3gGWkVMeIRLDjsIqA
ZigKtPxPfqt7auzPNuiiQekERc+5OwtYXbmWG9vHySvMKAXSuOnhsk0ghYUObJHm
PGA6K7gVc+ohfQgO49dCKrAucTZKOe5//5DJuGeYuaua8XaARE/OpvnNjoLAYZf1
xQzIcwCWGUDV10ot6BLGXIoHS2XgRSZWdHau5+UkoFyp0nlHVrwqEgi5xXRUHUBd
RtTY6lnOcSmLUcxtngoHswXeRYpNA8eLBmRf6ahlreEXJpI+jf83APSLyxp5S7qz
P5UmE7geFLZI56oN3phQOAPllrjrPRuYEkd/TaDqTXB3kYa1tae/HpYOB/VlHeQ1
eyfmNfOfWftOXmSZV40eZHtCSWnjUslQ0NKfqik4L0VfR+x7iBblnTUGnQ5+UkjI
a/Jz71dN+63WfpU5HOoH2x2U9bxiHd6GnUXDQhPo4dEIzNNDDBcthCCkPBsBPcgN
8SJ0W+gmkf++BmdIibWfFS/eHDNqNkCHnbC4R5jraruG6I8XMogTWvMEU5u0EiyU
5Bal1I/zLJQ2D1+dZI1dDNPc3ragQB8pCAKZNnCxZiws7OuGQAJmC4e7dDjlD3CN
ZdpwW0d/8+5beO6W7UIca3u2SApKc+/ctnJQkEhWGEGi1SfLULIl7IHnGsRMqUmA
iW8ymAG6RVicT5S71LUc
=3ACF
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
