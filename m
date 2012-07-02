Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52225 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab2GBFhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 01:37:52 -0400
Received: by eeit10 with SMTP id t10so1912834eei.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jul 2012 22:37:51 -0700 (PDT)
From: Mariusz Fik <fisiu82@jabster.pl>
To: linux-wireless@vger.kernel.org
Subject: Re: Intel N 1030 desn't connect to AP with WPA2 | Linux 3.4.2
Date: Mon, 02 Jul 2012 07:37:46 +0200
Message-ID: <121930535.dxfIfIrgZC@vostro> (sfid-20120702_073755_847598_59C626CC)
In-Reply-To: <1340729582.4484.8.camel@jlt3.sipsolutions.net>
References: <2073595.T30nNVXCf4@pendrak> <1340729582.4484.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1390997.JLGRSxc5Cg"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1390997.JLGRSxc5Cg
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Dnia wtorek, 26 czerwca 2012 18:53:02 Johannes Berg pisze:
> On Tue, 2012-06-26 at 18:27 +0200, Mariusz Fik wrote:
> > Hi,
> > 
> > I installed openSUSE 12.2 Beta 2 with linux 3.4.2 recently and my wifi
> > card
> > 
> > has problems with connecting to AP with WPA2. Hardware I have:
> > | 02:00.0 Network controller [0280]: Intel Corporation Centrino Wireless-N
> > 
> > 1030 [8086:008a] (rev 34)
> > 
> > After boot I connected to my AP and wifi worked fine. After few seconds
> > connection was disconnected and nm asked me again for password. Every try
> > of connection was unsuccessful since now. `dmesg`, in the time of trying
> > to> 
> > connect, gives me:
> > | [  434.134710] wlan0: authenticate with 00:22:15:0b:55:a3
> > | [  434.143822] wlan0: direct probe to 00:22:15:0b:55:a3 (try 1/3)
> > | [  434.344492] wlan0: direct probe to 00:22:15:0b:55:a3 (try 2/3)
> > | [  434.545185] wlan0: send auth to 00:22:15:0b:55:a3 (try 3/3)
> > | [  434.745882] wlan0: authentication with 00:22:15:0b:55:a3 timed out
> 
> You're probably running into the TX power issue, that is fixed in 3.4.4:
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdi
> ff;h=75862961e9b445a9bfce25b9da70ef930a857762
> > | [  434.747111] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active
> > | station id> 
> > 0 addr 00:22:15:0b:55:a3
> 
> I have a separate fix for this, but I think it's a red herring and
> probably doesn't cause your problem.
> 
> johannes

I updated kernel to 3.4.4 and it fixed my issue.
Thanks a lot.
-- 
Pozdrawiam / Best regards,
Mariusz Fik
openSUSE Community Member
GPG: 5FCE 7241 B3B9 32FD 455B C30E 42D6 6C88 9E83 7C3D
--nextPart1390997.JLGRSxc5Cg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk/xM6oACgkQQtZsiJ6DfD3qcwCeM6d8NVUSwc+FkhyDZUNldPys
jDoAn2aX+gJXgfhB4g8KRKj04hUvYG4L
=NthZ
-----END PGP SIGNATURE-----

--nextPart1390997.JLGRSxc5Cg--

