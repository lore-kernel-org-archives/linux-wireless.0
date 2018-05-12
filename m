Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 14.mo6.mail-out.ovh.net ([46.105.56.113]:36899 "EHLO
        14.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbeELNgB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 09:36:01 -0400
Received: from player699.ha.ovh.net (unknown [10.109.120.114])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id CE11915A6C5
        for <linux-wireless@vger.kernel.org>; Sat, 12 May 2018 12:00:17 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sat, 12 May 2018 12:00:07 +0200
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Matt Redfearn <matt.redfearn@mips.com>,
        linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] Revert "ssb: Prevent build of PCI host features in
 module"
In-Reply-To: <20180512100136.1d26e6d3@wiggum>
References: <20180511091715.1989-1-zajec5@gmail.com>
 <CACna6ry-91oR1u697NRymLsN28fnnHDp9OQrdiVwA7A3KTV1fg@mail.gmail.com>
 <87bmdmcxf6.fsf@codeaurora.org>
 <727571cb-5d1f-2d99-b050-979edd02106f@lwfinger.net>
 <877eo9b9d9.fsf@codeaurora.org> <20180512100136.1d26e6d3@wiggum>
Message-ID: <2a401060858a337f84039eddef4b3b87@milecki.pl> (sfid-20180512_153605_613170_B6FDD6BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-12 10:01, Michael Büsch wrote:
> On Sat, 12 May 2018 10:50:42 +0300
> Kalle Valo <kvalo@codeaurora.org> wrote:
> 
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>> 
>> > On 05/11/2018 05:13 AM, Kalle Valo wrote:
>> >> Rafał Miłecki <zajec5@gmail.com> writes:
>> >>
>> >>> On 11 May 2018 at 11:17, Rafał Miłecki <zajec5@gmail.com> wrote:
>>  [...]
>> >>>
>> >>> As these patches fix regression/build error, I believe both should get
>> >>> into 4.17.
>> >>
>> >> How much confidence do we have that we don't need to end up reverting
>> >> patch 2 as well? I rather be pushing patch 2 to 4.18 so that there's
>> >> more time for testing and waiting for feedback.
>> >
>> > Although I do not have the hardware to test the builds, I worked
>> > closely with the OP in the bug at b.r.c noted above. From that effort,
>> > it became clear what configuration variables were missing to cause the
>> > x86 failures. Patch 2 satisfies the requirement, and prevents the
>> > build problems found by the MIPS users. Both patches are needed in
>> > 4.17.
>> 
>> And I assume Michael is ok with this approach as well as I haven't 
>> heard
>> from him. I'll then push both of these to 4.17.
>> 
> 
> Yes, I'm OK with the patch, if we have a third patch that cleans up the
> PCI_DRIVERS_LEGACY dependency by moving it to SSB_PCICORE_HOSTMODE
> where it belongs. (This doesn't need to go into the stable tree.)
> We currently implicitly get that via dependency chain, so this is OK
> for now as-is.

I'm planning to handle PCI_DRIVERS_LEGACY cleanup once my patches hit
net-next.git and then wireless-drivers-next.git. It's to avoid
conflicts.
