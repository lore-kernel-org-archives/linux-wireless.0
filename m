Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:37213 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbbDUKQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 06:16:54 -0400
Received: by igblo3 with SMTP id lo3so11392049igb.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2015 03:16:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55355E9D.30209@broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
	<1429035033-14076-11-git-send-email-arend@broadcom.com>
	<CACna6rwJn695OzCdHu9KWUczcXext5mrLHvfVSMXsLekBm2tUg@mail.gmail.com>
	<F51492713EF10846800D8C0ED37A7DCE019304D6@SJEXCHMB15.corp.ad.broadcom.com>
	<CACna6rzVfDqe_TBaLSoV704ZHU--d_JqrzDF2fM85pnTYUJMeg@mail.gmail.com>
	<5530C940.6010407@broadcom.com>
	<CACna6ryZYvVN_svcv3W+4F6yiJf2QYHxYD-VXhGcUUTAHZDYSg@mail.gmail.com>
	<55353364.3050101@broadcom.com>
	<CACna6ryb_v2Jw1DOudhXvAoQAbjBvdjb_UbdSG_PAC0A=5U9cA@mail.gmail.com>
	<55355E9D.30209@broadcom.com>
Date: Tue, 21 Apr 2015 12:16:53 +0200
Message-ID: <CACna6rxHOqn3pynTQY0VfP0Gm_R24ogPfUXDLOsQOuVfayBWzw@mail.gmail.com> (sfid-20150421_121657_677654_17F39E84)
Subject: Re: [PATCH 10/10] brcmfmac: Add support for multiple PCIE devices in nvram.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hante Meuleman <meuleman@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	mailinglist <openwrt-devel@lists.openwrt.org>,
	Florian Fainelli <fainelli@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 April 2015 at 22:16, Arend van Spriel <arend@broadcom.com> wrote:
> On 04/20/15 20:49, Rafał Miłecki wrote:
>>
>> On 20 April 2015 at 19:12, Arend van Spriel<arend@broadcom.com>  wrote:
>>>
>>> On 04/20/15 13:26, Rafał Miłecki wrote:
>>>>
>>>>
>>>> On 17 April 2015 at 10:50, Arend van Spriel<arend@broadcom.com>   wrote:
>>>>>
>>>>> Another option is to add the parsing stuff in that nvram code and have
>>>>> an
>>>>> api to get the appropriate portion based on pcie domain and bus number
>>>>> as
>>>>> used in brcmf_fw_get_firmwares_pcie(). However, I would prefer to have
>>>>> this
>>>>> in the driver and not in arch specific code as there may be other
>>>>> platforms
>>>>> like our set-top boxes needing this.
>>>>
>>>>
>>>>
>>>> This is some plan for the future I was lacking from the beginning. It
>>>> makes things more clear now, thanks.
>>>
>>>
>>> You're welcome. Do you want to see this clarification in the commit
>>> message?
>>
>>
>> I don't really need that, I'm leaving it up to you :)
>>
>> The last remaining question from me is if  about this NVRAM validation
>> function (if it exists).
>
>
> Ok. I can try to answer that one. The nvram parsing code in firmware.c
> intends to do just that. So apart from stripping comments and whitespace it
> validates each line and gives off a warning if a wrongly formatted entry is
> found.

OK, thanks. So I guess this patch is OK after all?

-- 
Rafał
