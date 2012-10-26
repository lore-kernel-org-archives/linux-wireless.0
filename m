Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36232 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab2JZAlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 20:41:21 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so1546432pad.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 17:41:21 -0700 (PDT)
Date: Thu, 25 Oct 2012 17:41:16 -0700
From: Thomas Pedersen <thomas@cozybit.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath9k-devel] ath9k_htc and reported mactime
Message-ID: <20121026004116.GF20609@shredder> (sfid-20121026_024132_000351_3940E75D)
References: <CAJ-Vmokr0293M-yqQ6LvM4WKC+P0w0N2mHjpKK+rSFFjAmhwfQ@mail.gmail.com>
 <20121024194547.GA19060@shredder>
 <CAJ-VmonEZbKiVqnu1SDDbNDTj3qeWB2QgTN=h3NHdiZrMp8LDA@mail.gmail.com>
 <CAJ-VmonzYsUsSOyr34Xj9=mTpsHEbGNUS2RoN=BenqthGfakVw@mail.gmail.com>
 <20121024220813.GB6723@shredder>
 <CAJ-VmokGeCLY8pCpL5H0VgznXnB-ob1z_sPaSQUZn0PengSgow@mail.gmail.com>
 <CAJ-Vmo=-Dj+Le8y0EYNgVednUT7GTedSwdNP5q1P5iLKymRBLg@mail.gmail.com>
 <CAJ-Vmom0cg09C1D2Eh79K2zoOxL0Ry7g3+DC2iNGBFTa4+Zhzg@mail.gmail.com>
 <CAG6hwVM_9TkKmMs0MyyiuO8TAUSLkBJTWiQ8+4AAa19YG+guCw@mail.gmail.com>
 <CAJ-Vmok3+ts43ow_Btj7sG3DfWNeD7O=gNWagJrSGkBWFvyQMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmok3+ts43ow_Btj7sG3DfWNeD7O=gNWagJrSGkBWFvyQMQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 25, 2012 at 03:27:39PM -0700, Adrian Chadd wrote:
> On 25 October 2012 15:25, Thomas Pedersen <thomas@cozybit.com> wrote:
> 
> >> Thomas, is the TSF in the RX status descriptor actually 32 bits, or is
> >> this a printing error?
> >
> > Looking at the printk again, I'm pretty sure I'm just an idiot and the
> > printed value is being truncated to 32 bits. Will test and verify the
> > TSF wraps correctly again.

Yep, the TSF actually wraps to 64 bits correctly :|

[ 4394.156056] got beacon with ts         ABA184D3 from 00:03:7f:10:4e:0a at         FEF0D969, now:         FEF0DC84. offset == -795
[ 4395.723180] got beacon with ts        1020E8597 from 00:03:7f:10:4e:1a at         FF08C20E, now:         FF08C526. offset == -792
[ 4397.771811] got beacon with ts        1022DC649 from 00:03:7f:10:4e:1a at         FF2802BC, now:         FF280671. offset == -949
[ 4406.446193] got beacon with ts         AC5D0568 from 00:03:7f:10:4e:0a at         FFAC5A30, now:         FFAC5D68. offset == -824
[ 4412.109937] got beacon with ts        103088637 from 00:03:7f:10:4e:1a at        10002C292, now:        10002C5F0. offset == -862
[ 4416.205946] got beacon with ts        10347041B from 00:03:7f:10:4e:1a at        100414070, now:        100414376. offset == -774
[ 4418.253827] got beacon with ts        103664224 from 00:03:7f:10:4e:1a at        100607E74, now:        1006081C7. offset == -851
[ 4418.735826] got beacon with ts         AD188414 from 00:03:7f:10:4e:0a at        10067D90F, now:        10067DC4B. offset == -828

Thanks,
Thomas
