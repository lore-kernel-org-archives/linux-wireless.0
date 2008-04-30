Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.Stanford.EDU ([171.67.20.26]:39099 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbYD3SIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 14:08:45 -0400
Received: from smtp3.stanford.edu (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 7284060EF39
	for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2008 11:00:55 -0700 (PDT)
Received: from localhost (DNab42390a.Stanford.EDU [171.66.57.10])
	by smtp3.stanford.edu (Postfix) with ESMTP id 62B1660E213
	for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2008 11:00:53 -0700 (PDT)
Date: Wed, 30 Apr 2008 11:00:53 -0700
From: Gautam Iyer <gi1242@stanford.edu>
To: linux-wireless@vger.kernel.org
Subject: Re: b43 reduced performance in Linux-2.6.25
Message-ID: <20080430180053.GA21403@stanford.edu> (sfid-20080430_200837_020891_A0F5696C)
References: <20080429215629.GC17790@stanford.edu> <4817A28E.2050309@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
In-Reply-To: <4817A28E.2050309@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2008 at 05:34:54PM -0500, Larry Finger wrote:

>> I saw a few threads about reduced performance in b43 in the 2.6.24 /
>> 2.6.25_rcXX kernels, but couldn't manage to fix the problem myself:
>> On my system, using ndiswrapper and the windows drivers gives me about
>> 1.5 times the performance of the in kernel b43 drivers.
>> Here are my system specs:
>>     Broadcom Corporation BCM4312 802.11a/b/g [14e4:4312] (rev 02)
>>     Linux 2.6.25 (gentoo-sources-2.6.25-r1).
>>     b43 wireless driver with firmware 410.2160 (2007-05-26 15:32:10)
>> I measured the performance by running "ttcp" between my Laptop and my
>> router. Using b43 on my Laptop gives about 2MB/s reported, and using
>> ndiswrapper gives me about 3MB/s under exactly the same situations.
>> Any ideas about what's going on? (I would be happy to provide you with
>> any further specs on my computer).
>
> Yes. Broadcom wrote the Windows drivers, but never gave the
> specifications to anyone else. Obvious those specs from their
> engineers are better than those from the _reverse_ engineers for your
> card. On my BCM4311/2 I get better throughput with the b43 driver than
> I get when running Windows. I _NEVER_ use ndiswrapper. Now that b43
> works, why would I want to taint my kernel?

I just moved to a different network and compared the performance between
b43 and ndiswrapper. They are now *almost* identical (both 2.5MB/s). I'd
even say that b43 sometimes performs slightly (50KB/s) better on
average! (GO LINUX WIRELESS!)

Looking at my syslog shows that on my home network (where b43 performed
50% worse), I find the following messages just after association:

    wlan0: switched to short barker preamble (BSSID=3D00:14:a5:0c:17:dc)
    wlan0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D3 cWmin=3D15 cWmax=3D1023 b=
urst=3D0
    wlan0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D15 cWmax=3D1023 b=
urst=3D0
    wlan0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D7 cWmax=3D15 burs=
t=3D30
    wlan0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D3 cWmax=3D7 burst=
=3D15

I don't find these messages when I connect on campus (and get the high
performance). So maybe the performance loss is WMM related.

My home router is of course running Linux (OpenWRT), so maybe I can
tweak the WMM parameters of the router to match what b43 is happy with!

Any suggestions,

Thanks again for your help!

GI

--=20
'Pessimist' -- Optimist with experience.

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkgYs9UACgkQ6plSLtsExHFL+wCfRPvT/SHWmujMEOnuMisw+eL1
BgYAn2QGtEvWoMPxw4ugW2PezuJ3HTRJ
=RRB1
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
