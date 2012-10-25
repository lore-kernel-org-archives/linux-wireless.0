Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65093 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2JYWZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 18:25:51 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1676654wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 15:25:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmom0cg09C1D2Eh79K2zoOxL0Ry7g3+DC2iNGBFTa4+Zhzg@mail.gmail.com>
References: <CAG6hwVP5YkBEN9vZPGGEHbK=9ow2wJJ1x_BvSQbDzUscTiOHTA@mail.gmail.com>
 <CAJ-Vmokr0293M-yqQ6LvM4WKC+P0w0N2mHjpKK+rSFFjAmhwfQ@mail.gmail.com>
 <20121024194547.GA19060@shredder> <CAJ-VmonEZbKiVqnu1SDDbNDTj3qeWB2QgTN=h3NHdiZrMp8LDA@mail.gmail.com>
 <CAJ-VmonzYsUsSOyr34Xj9=mTpsHEbGNUS2RoN=BenqthGfakVw@mail.gmail.com>
 <20121024220813.GB6723@shredder> <CAJ-VmokGeCLY8pCpL5H0VgznXnB-ob1z_sPaSQUZn0PengSgow@mail.gmail.com>
 <CAJ-Vmo=-Dj+Le8y0EYNgVednUT7GTedSwdNP5q1P5iLKymRBLg@mail.gmail.com> <CAJ-Vmom0cg09C1D2Eh79K2zoOxL0Ry7g3+DC2iNGBFTa4+Zhzg@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 25 Oct 2012 15:25:28 -0700
Message-ID: <CAG6hwVM_9TkKmMs0MyyiuO8TAUSLkBJTWiQ8+4AAa19YG+guCw@mail.gmail.com> (sfid-20121026_002554_731924_F1A690E4)
Subject: Re: [ath9k-devel] ath9k_htc and reported mactime
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 25, 2012 at 1:42 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 24 October 2012 18:54, Adrian Chadd <adrian@freebsd.org> wrote:
>
>> Yup, found it. The firmware TSF code was treating the TSF like it was
>> an older pre-11n NIC and only dealing with the low handful of bits.
>> Thomas has verified my test image works.
>>
>> I'll go and see about pushing this into the tree so Sujith's next
>> ath9k_htc drop will include this fix.
>>
>> Thanks for the debugging info Thomas!
>
> Thomas, is the TSF in the RX status descriptor actually 32 bits, or is
> this a printing error?

Looking at the printk again, I'm pretty sure I'm just an idiot and the
printed value is being truncated to 32 bits. Will test and verify the
TSF wraps correctly again.

Thomas
