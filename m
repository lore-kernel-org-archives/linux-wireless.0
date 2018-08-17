Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:3347 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbeHQHea (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Aug 2018 03:34:30 -0400
Date: Fri, 17 Aug 2018 10:02:33 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <nicolas.ferre@microchip.com>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: feedback on mainlining wilc1000 staging driver
Message-ID: <20180817100233.7f1c00d9@ajaysk-VirtualBox> (sfid-20180817_063244_064136_46ACF50E)
In-Reply-To: <87o9e2twe9.fsf@purkki.adurom.net>
References: <20180816015243.545cd009@ajaysk-VirtualBox>
        <87sh3etwoj.fsf@purkki.adurom.net>
        <87o9e2twe9.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 16 Aug 2018 13:53:50 +0300
Kalle Valo <kvalo@codeaurora.org> wrote:

> Kalle Valo <kvalo@codeaurora.org> writes:
> 
> > Ajay Singh <ajay.kathat@microchip.com> writes:
> >  
> >> Hi Greg,
> >>
> >> We all are working on submitting and reviewing patches for
> >> wilc1000 in staging driver for quite some time. 
> >>
> >> We would like to have feedback on the next steps to bring wilc1000
> >> driver closer to move into the wireless subsystem tree. 
> >>
> >> In summary, the following major things from TODO have been
> >> addressed in staging:
> >> -remove the defined feature as kernel versions
> >> -remove OS wrapper functions
> >> -remove custom debug and tracing functions
> >> -rework comments and function headers(also coding style)
> >> -remove build warnings
> >> -replace all semaphores with mutexes or completions
> >> -make spi and sdio components coexist in one build
> >> -turn compile-time platform configuration (BEAGLE_BOARD,
> >> PANDA_BOARD, PLAT_WMS8304, PLAT_RKXXXX, CUSTOMER_PLATFORM, ...)
> >> into run-time options that are read from DT
> >> -replace SIOCDEVPRIVATE commands with generic API functions
> >> -use wext-core handling instead of private SIOCSIWPRIV
> >> implementation  
> >
> > From wireless point of view: if I see wext mentioned anywhere in the
> > driver I stop right there. cfg80211 is a hard requirement for us
> > nowadays.  
> 
> Clarification: Depending on the hardware design either cfg80211 or
> mac80211 is a hard requirement. I haven't checked wilc1000 at all so I
> don't know what design it has but if it's a "softmac" design then it
> has to use mac80211, we do not want to support multiple 802.11 UMAC
> stacks.
> 

The TODO item to make use of wext-core is obsolete. Previously wilc1000
driver also had few wext ioctl use but now it’s completely removed and
cfg80211 operation callbacks are used.

wilc1000 driver make use of cfg80211 and isn’t a "softmac".

We need help to review and identify if there are any pending items
for wilc1000 driver, so we can address those issues and make it ready
to move to the wireless subsystem.

Regards,
Ajay
