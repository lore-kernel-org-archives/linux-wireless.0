Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:27785 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702Ab1GORC5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 13:02:57 -0400
Message-ID: <4E2072BF.6000306@gnu.org> (sfid-20110715_190300_373848_4451EBBA)
Date: Fri, 15 Jul 2011 13:02:55 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Roman Shishkin <r.shishkin@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Binary for carl9170
References: <CACAiNS3-3K06Cro+VWypyWGetUW-v0qeJ29noXi7WNtUaCWzTw@mail.gmail.com> <201107141119.08932.chunkeey@googlemail.com> <CACAiNS3rirp4i=pGK2j1Q8CSbVGXthGuHx+nwr21FEyCd3=F_Q@mail.gmail.com> <201107151509.23258.chunkeey@googlemail.com>
In-Reply-To: <201107151509.23258.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/15/2011 09:09 AM, Christian Lamparter wrote:
> On Friday 15 July 2011 14:31:07 Roman Shishkin wrote:
>> Source code avaliable of course, but I need just the binary of 1.9.4.
>> Probably lot of casual linux users needs this binary too :)
> Oh no, the firmware is supposed to be shipped by the distribution and
> not "installed by hand". After all, they provide compiled and fully tested
> packages for kernel+driver+userland and in doing so verify that no
> malicious code compromises the system's security.

Christian, I think the latest firmware needs to be on the site.  I 
understand that you want to keep the entry barrier high, but it's 
hurting wrong people.

I made some changes to the ath module and wanted to make a quick check 
that carl9170 is OK.  First I found that the 1.9.2 firmware won't work 
with wireless-testing.  Then I found that the binary is not there.  Then 
I downloaded the sources and ran "make -C toolchain".  After a long 
download, I got

configure: error: Building GCC requires GMP 4.2+, MPFR 2.3.1+ and MPC 
0.8.0+.
Try the --with-gmp, --with-mpfr and/or --with-mpc options to specify

No big deal, I'll need to install some libraries and restart make.  But 
that's more time to spend on something I thought would take minutes. 
And I'll have to keep the toolchain somewhere if I want to compile 
future version of the firmware.

At this point I start having doubts whether it's easier just to look at 
my changes more carefully and send them.

I was complaining recently that AR5210 hard to get to work (it only 
works on old motherboards), but I think I can get it to work faster than 
AR9170.

Not providing the binary hurts potential tester and contributors.

-- 
Regards,
Pavel Roskin
