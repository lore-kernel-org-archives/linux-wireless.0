Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55903 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab1HYVHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 17:07:45 -0400
Received: by qyk38 with SMTP id 38so3736185qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 14:07:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOiHx=narxG2WG1+8jDTah=u=XQ337K7UZZgd8Fv9xksufkEKw@mail.gmail.com>
References: <20110707002034.GA17885@broadcom.com>
	<20110824222801.GA5280@broadcom.com>
	<CAOiHx=mfqv9CPNRsZ0pbXMfkDstyNcioqww77EDvU35q0CGMWw@mail.gmail.com>
	<20110825002032.GA7577@broadcom.com>
	<CAOiHx=narxG2WG1+8jDTah=u=XQ337K7UZZgd8Fv9xksufkEKw@mail.gmail.com>
Date: Thu, 25 Aug 2011 23:07:44 +0200
Message-ID: <CACna6rxRG_yPsCMG3tNTiHp5GratUn8qYiDYKxa85vuaBLjCtw@mail.gmail.com> (sfid-20110825_230749_339659_A66A9308)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Jonas Gorski <jonas.gorski@gmail.com>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/25 Jonas Gorski <jonas.gorski@gmail.com>:
> Hi,
>
> On 25 August 2011 02:20, Henry Ptasinski <henryp@broadcom.com> wrote:
>> On Wed, Aug 24, 2011 at 04:41:54PM -0700, Jonas Gorski wrote:
>>> Hi Henry,
>>>
>>> On 25 August 2011 00:28, Henry Ptasinski <henryp@broadcom.com> wrote:
>>> > With the latest series of cleanup patches merged in by Greg KH, I'd like to
>>> > once again propose moving brcm80211 out of staging and into mainline.
>>>
>>> While I like the Idea of brcm80211 going mainline, I'd like to throw
>>> in the suggestion that brcm80211 should be made a bcma/ssb driver
>>> first (AFACT brcmfmac would use ssb, not bcma, therefore both).
>>>
>>> My reasoning is that it needs to be done eventually anyway, and the
>>> earlier this is done the less work it will be in the long term, also
>>> it would reduce the duplicate code in bcma, ssb, and brcm80211.
>>>
>>> Of course this is just a suggestion, and it's yours and Greg's call
>>> whether you agree with me or not (since it's quite late in the game to
>>> add a new TODO, and I suspect a rather big one).
>>
>> We started converting brcmsmac to bcma, but bcma is evolving rapidly in the
>> wireless-testing tree.  Since wireless-testing and staging-next only get in
>> sync during a kernel merge, the version of bcma we have to work with in staging
>> is usually quit outdated.  Unless Greg and John want to come up with a process
>> for keeping bcma consistent between their two repos, I don't really see how we
>> can productively use bcma until we cross over.  We do intend to switch to using
>> bcma as soon as possible.
>
> Okay, then no objections from me. The keeping in sync is a valid
> reason. I'm looking forward to seeing your bcma patches :-)
>
>> I believe the only SB bus functions that brcmfmac uses are the core reset and
>> disable functions, and only when initializing the chip to download firmware
>> (all other management of the bus is handled by the on-chip CPU).  Is it
>> possible to use those funtions from ssb, without the ssb module trying to
>> manage the bus?
>
> I haven't really looked at how much the brcmfmac driver uses ssb; I
> just saw s(s)b_* stuff in there and remembered that ssb supports SDIO
> host, so I assumed that there's part of the stack hidden in brcmfmac.
> But if it's only core reset and disable, then what Michael said
> applies ;-)

Still, is there any good reason for duplicating that code?

I think that it's not only about duplicating enable/disable/reset.
What about managing sliding window? Reading available cores? Clocks
management? Requesting & releasing device? Interrupts management?

About the code quality, short question: is the duplication of the code
done on purpose between dhd_siod.c and bcmsdh.c? Two identical
functions:
brcmf_sdcard_set_sbaddr_window
brcmf_sdbrcm_set_siaddr_window

-- 
Rafał
