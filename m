Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65443 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965199Ab2JYUme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 16:42:34 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so1434871pad.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 13:42:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=-Dj+Le8y0EYNgVednUT7GTedSwdNP5q1P5iLKymRBLg@mail.gmail.com>
References: <CAG6hwVP5YkBEN9vZPGGEHbK=9ow2wJJ1x_BvSQbDzUscTiOHTA@mail.gmail.com>
	<CAJ-Vmokr0293M-yqQ6LvM4WKC+P0w0N2mHjpKK+rSFFjAmhwfQ@mail.gmail.com>
	<20121024194547.GA19060@shredder>
	<CAJ-VmonEZbKiVqnu1SDDbNDTj3qeWB2QgTN=h3NHdiZrMp8LDA@mail.gmail.com>
	<CAJ-VmonzYsUsSOyr34Xj9=mTpsHEbGNUS2RoN=BenqthGfakVw@mail.gmail.com>
	<20121024220813.GB6723@shredder>
	<CAJ-VmokGeCLY8pCpL5H0VgznXnB-ob1z_sPaSQUZn0PengSgow@mail.gmail.com>
	<CAJ-Vmo=-Dj+Le8y0EYNgVednUT7GTedSwdNP5q1P5iLKymRBLg@mail.gmail.com>
Date: Thu, 25 Oct 2012 13:42:33 -0700
Message-ID: <CAJ-Vmom0cg09C1D2Eh79K2zoOxL0Ry7g3+DC2iNGBFTa4+Zhzg@mail.gmail.com> (sfid-20121025_224237_596834_C9FF1804)
Subject: Re: [ath9k-devel] ath9k_htc and reported mactime
From: Adrian Chadd <adrian@freebsd.org>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 October 2012 18:54, Adrian Chadd <adrian@freebsd.org> wrote:

> Yup, found it. The firmware TSF code was treating the TSF like it was
> an older pre-11n NIC and only dealing with the low handful of bits.
> Thomas has verified my test image works.
>
> I'll go and see about pushing this into the tree so Sujith's next
> ath9k_htc drop will include this fix.
>
> Thanks for the debugging info Thomas!

Thomas, is the TSF in the RX status descriptor actually 32 bits, or is
this a printing error?

The firmware side seems to be populating it with a 64 bit TSF value
and the rx_status field in question is actually 64 bits. Hence why I'm
confused.


Adrian
