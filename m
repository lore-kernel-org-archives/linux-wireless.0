Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:46985 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbeEKMIv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 08:08:51 -0400
Subject: Re: [PATCH V2 1/2] Revert "ssb: Prevent build of PCI host features in
 module"
To: Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>,
        Matt Redfearn <matt.redfearn@mips.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20180511091715.1989-1-zajec5@gmail.com>
 <CACna6ry-91oR1u697NRymLsN28fnnHDp9OQrdiVwA7A3KTV1fg@mail.gmail.com>
 <87bmdmcxf6.fsf@codeaurora.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <727571cb-5d1f-2d99-b050-979edd02106f@lwfinger.net> (sfid-20180511_140906_215346_1DB1C206)
Date: Fri, 11 May 2018 07:08:48 -0500
MIME-Version: 1.0
In-Reply-To: <87bmdmcxf6.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2018 05:13 AM, Kalle Valo wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
> 
>> On 11 May 2018 at 11:17, Rafał Miłecki <zajec5@gmail.com> wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> This reverts commit 882164a4a928bcaa53280940436ca476e6b1db8e.
>>>
>>> Above commit added "SSB = y" dependency to the wrong symbol
>>> SSB_DRIVER_PCICORE_POSSIBLE and prevented SSB_DRIVER_PCICORE from being
>>> selected when needed. PCI core driver for core running in clienthost
>>> mode is important for bus initialization. It's perfectly valid scenario
>>> to have ssb built as module and use it with buses on PCI cards.
>>>
>>> This fixes regression that affected all *module* users with PCI cards.
>>>
>>> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1572349
>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>
>> As these patches fix regression/build error, I believe both should get
>> into 4.17.
> 
> How much confidence do we have that we don't need to end up reverting
> patch 2 as well? I rather be pushing patch 2 to 4.18 so that there's
> more time for testing and waiting for feedback.

Although I do not have the hardware to test the builds, I worked closely with 
the OP in the bug at b.r.c noted above. From that effort, it became clear what 
configuration variables were missing to cause the x86 failures. Patch 2 
satisfies the requirement, and prevents the build problems found by the MIPS 
users. Both patches are needed in 4.17.

Larry
