Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59229 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626AbXHPPc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 11:32:26 -0400
Subject: Re: Kernel BUG when using ad-hoc mode in rt2x00
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Baker <linux@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200708161625.44057.linux@baker-net.org.uk>
References: <200708082324.17186.linux@baker-net.org.uk>
	 <200708152249.09948.linux@baker-net.org.uk>
	 <1187272082.5141.53.camel@johannes.berg>
	 <200708161625.44057.linux@baker-net.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j56HuVryeBYzODvXs8VM"
Date: Thu, 16 Aug 2007 17:35:08 +0200
Message-Id: <1187278509.23489.24.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j56HuVryeBYzODvXs8VM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-16 at 16:25 +0100, Adam Baker wrote:

> I'm starting to think that scanning from the remote device always causes =
a crash
> if done just after the iwconfig essid and never does if left for a while =
first
> (~ 1 minute). Scanning on the local machine I've usually done when the sc=
an and
> subsequent connect from the remote machine has succeeded. I'm not yet sur=
e if
> that is a necessary condition for the crash.

To be fair, I managed to reproduce it once with b43 but not again. Maybe
this weird timing behaviour was the cause of that.

> I've added some printk's as you suggested, the log is attached. I
> haven't yet
> managed to capture this on the serial port so I can't yet guarantee
> that there
> aren't any calls that didn't get logged just as it crashed - I'll keep
> trying.

Ok. I'll look through.

> Aug 16 15:53:34 gromit kernel: [  633.972956] wmaster0: Entering ieee8021=
1_tx_h_multicast_ps_buf(), hw.flags 1746
> Aug 16 15:53:34 gromit kernel: [  633.972960] Leaving ieee80211_tx_h_mult=
icast_ps_buf

Hm. I thought it crashed in there. Could you put printk's into the two
functions called from this, and then switch to a console and tell me
which one shows up last? Elevate the printk priority to something like
KERN_ERR or change your console to show all messages.

johannes

--=-j56HuVryeBYzODvXs8VM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxG6s/ETPhpq3jKURArAmAJ9jQUMR3hZu7wQ/u5LCelTwStndewCeJ7J+
USbwcWge3PTsqxjpodYswcc=
=jWd9
-----END PGP SIGNATURE-----

--=-j56HuVryeBYzODvXs8VM--

