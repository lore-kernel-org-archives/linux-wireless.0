Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from betty.cbit.net.au ([202.55.154.10]:60040 "EHLO mail.cbit.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751380AbXHKG3Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2007 02:29:24 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.cbit.net.au (Postfix) with ESMTP id F0A99108056
	for <linux-wireless@vger.kernel.org>; Sat, 11 Aug 2007 16:29:21 +1000 (EST)
Received: from mail.cbit.net.au ([127.0.0.1])
	by localhost (localhost [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id lYolyaWhkcTz for <linux-wireless@vger.kernel.org>;
	Sat, 11 Aug 2007 16:29:21 +1000 (EST)
Received: from keitarou.bubblesworth.net (unknown [202.55.155.124])
	by mail.cbit.net.au (Postfix) with ESMTP id C70E7108030
	for <linux-wireless@vger.kernel.org>; Sat, 11 Aug 2007 16:29:21 +1000 (EST)
Date: Sat, 11 Aug 2007 16:29:21 +1000
From: Paul TBBle Hampson <Paul.Hampson@Pobox.com>
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 IPv6 problems
Message-ID: <20070811062921.GA27009@keitarou>
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net> <1186094778.6701.6.camel@shinybook.infradead.org> <20070803005517.GA4261@tuxdriver.com> <200708030102.17358.flamingice@sourmilk.net> <20070806170500.GE6442@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
In-Reply-To: <20070806170500.GE6442@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 06, 2007 at 01:05:00PM -0400, John W. Linville wrote:
> On Fri, Aug 03, 2007 at 01:02:12AM -0700, Michael Wu wrote:

>> This doesn't seem quite right. I think ieee80211_rx_h_data is a safer pl=
ace=20
>> for this check (inside the IEEE80211_FCTL_FROMDS case), and allows vario=
us=20
>> statistics to be updated. ieee80211_rx_h_sta_process is another function=
 that=20
>> might work though that would probably involve more code to add all the r=
ight=20
>> checks.

> The patch below seems to work for me w/ an otherwise stock F-7 kernel
> w/ iwl3945.  Thoughts?

> From: John W. Linville <linville@tuxdriver.com>

> [PATCH] mac80211: filter locally-originated multicast frames

> In STA mode, the AP will echo our traffic.  This includes multicast
> traffice.

> Receiving these frames confuses some protocols and applications,
> notably IPv6 Duplicate Address Detection.

> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Worked for me, on bcm43xx-mac80211. Got an IP address from radvd, and
was able to ping6 a couple of places out on the big bad Internet.

Whole kernel is built from wireless-dev,
f2b262a6a8771fe9595f2c08e9d598b97634b266.

Thanks. ^_^

--=20
-----------------------------------------------------------
Paul "TBBle" Hampson, B.Sc, LPI, MCSE
Very-later-year Asian Studies student, ANU
The Boss, Bubblesworth Pty Ltd (ABN: 51 095 284 361)
Paul.Hampson@Pobox.com

Of course Pacman didn't influence us as kids. If it did,
we'd be running around in darkened rooms, popping pills and
listening to repetitive music.
 -- Kristian Wilson, Nintendo, Inc, 1989

License: http://creativecommons.org/licenses/by/2.1/au/
-----------------------------------------------------------

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGvVdBexDuohKLFuARAnjVAJ48CyCAqckDtPVSHClnDtIxAJ6UKgCfSc3+
Ytd8NvADVw9NCuntqASpZG8=
=P0XI
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
