Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:57327 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbZCWABd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 20:01:33 -0400
Date: Sun, 22 Mar 2009 19:54:16 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: G?bor Stefanik <gst@remote-exploit.org>
Cc: "Info[at]Giuppi" <info@giuppi.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8187 bug report
Message-ID: <20090322235416.GA32143@drd1813.cave.swamp> (sfid-20090323_010139_248240_290FB716)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <49C12DFA.80308@giuppi.com> <3ace41890903191439q1c375925md2e4227f79147399@mail.gmail.com> <49C2D537.6080406@giuppi.com> <3ace41890903191856s234118c9j2f4de15486cb37a9@mail.gmail.com> <49C39A83.5090004@giuppi.com> <69e28c910903201406o1e908214s4f0ab8cfa28392f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
In-Reply-To: <69e28c910903201406o1e908214s4f0ab8cfa28392f1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 20, 2009 at 10:06:49PM +0100, G?bor Stefanik wrote:
> Could you please test if you can see packets originating from your
> network in Kismet or Wireshark?
> Also, did you use the included airmon-ng script to enable monitor
> mode, or did you just do "ifconfig wlan0 down; iwconfig wlan0 mode
> monitor, ifconfig wlan0 up"? (The two are significantly different, as
> airmon-ng uses iw/nl80211 to enable monitor mode on a separate
> interface - it would be good if you tried it both ways.)

I have actually seen similar problems with the 8187 (unknown if it is B
or L - the drivers think it's B, but the production run of the hardware
is NORMALLY L and may have recently changed;  I have known-B generic cards=
=20
and maybe-B Alfa cards)

Kismet currently still uses setsiociwmode to set monitor mode on at
interface, it only uses nl80211 when you're starting a device with an
aux vap for rfmon.

I haven't been able to narrow down the trigger, but I've seen current
(.28 + compat-wireless 02-05 and 03-16) drivers stop reporting any
packets from the device a few minutes into run.  It isn't linked to
changing channel (tested with and without), and I've been told that when
it happens on multi-card systems it disables all other cards as well
(ath5k in this case).

Symptoms are the card stops reporting packets in monitor mode; tcpdump
also stops showing packets, ifdown/ifup doesn't reset the card to a
working state. =20

This occurs with a single VAP being set to down/monitor/up.

-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

Todays lesson is always to ignore your feelings and listen to the robot hea=
d.

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAknGz6gACgkQ17KIInOLvbFBKwCeIYSdtP68r4QF4MNcvTx+0Zsw
mhUAoK+BZmUJ97eEuYqxin0xove9P5sC
=FL6z
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
