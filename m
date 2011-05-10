Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55990 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1EJVTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 17:19:14 -0400
Received: by qyg14 with SMTP id 14so4951293qyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 14:19:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DC9853A.1090508@lwfinger.net>
References: <4CEAB969.20702@lwfinger.net>
	<1290451982.20888.2.camel@maggie>
	<4CEAC095.7020706@lwfinger.net>
	<BANLkTimjRA5CsSDp_+LrGq8PNgaR4JFD=w@mail.gmail.com>
	<4DC9853A.1090508@lwfinger.net>
Date: Tue, 10 May 2011 23:19:13 +0200
Message-ID: <BANLkTimBpGRxfidpE4hYCVscmX-Hy5q5jw@mail.gmail.com> (sfid-20110510_231928_981463_95BA0102)
Subject: Re: b43 error under heavy load
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Juan Carlos Romero <juancarlos.romero@gmail.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/10 Larry Finger <Larry.Finger@lwfinger.net>:
> On 05/10/2011 12:08 AM, Rafał Miłecki wrote:
>>
>> 2010/11/22 Larry Finger<Larry.Finger@lwfinger.net>:
>>>
>>> On 11/22/2010 12:53 PM, Michael Büsch wrote:
>>>>
>>>> On Mon, 2010-11-22 at 12:41 -0600, Larry Finger wrote:
>>>>>
>>>>> Under heavy load with multiple streams, I'm getting errors from my
>>>>> BCM4312
>>>>> (14e4:4315) device as follows:
>>>>>
>>>>> b43-phy0 debug: TX-status contains invalid cookie: 0x0D4D
>>>>> b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected
>>>>> 74, but got 76
>>>>> b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected
>>>>> 74, but got 78
>>>>> (and continues).
>>>>>
>>>>> Clearly that cookie is garbage as it has a slot number of 0. Any
>>>>> suggestions on
>>>>> diagnostic information that I could dump to help debug this?
>>>>
>>>> I think that probably is a firmware or hardware bug. The affected
>>>> kernel code was not changed in years, as far as I know.
>>>
>>> Thanks. I'll see if I can figure out a way for the driver to recover more
>>> gracefully. In the meantime, I will be dumping the entire TX status
>>> struct to
>>> see if that helps in seeing what is wrong.
>>
>> Larry, did you try debugging this? Juan noticed this issue on his
>> 14e4:4315 as well.
>> [  854.826369] b43-phy0 debug: Out of order TX status report on DMA
>> ring 1. Expected 74, but got 54
>> [  854.827348] b43-phy0 debug: Out of order TX status report on DMA
>> ring 1. Expected 74, but got 56
>> [  854.828080] b43-phy0 debug: Out of order TX status report on DMA
>> ring 1. Expected 74, but got 58
>> [  854.831431] b43-phy0 debug: Out of order TX status report on DMA
>> ring 1. Expected 74, but got 60
>> [  854.831453] b43-phy0 debug: Out of order TX status report on DMA
>> ring 1. Expected 74, but got 62
>> [  854.832440] b43-phy0 debug: Out of order TX status report on DMA
>> ring 1. Expected 74, but got 64
>> [  854.833836] b43-phy0 debug: Out of order TX status report on DMA
>> ring 1. Expected 74, but got 66
>> [  854.834567] b43-phy0 debug: Out of order TX status report on DMA
>> ring 1. Expected 74, but got 68
>> [  854.834588] b43-phy0 debug: Out of order TX status report on DMA
>> ring 1. Expected 74, but got 70
>> [  854.835378] b43-phy0 debug: Out of order TX status report on DMA
>> ring 1. Expected 74, but got 72
>>
>> Connection is lost, reloading of the driver is needer.
>
> I have not gotten any further with this problem, but I just noticed a
> curious "coincidence". The expected status number was 74 in both cases. I do
> not think there is anything special about that particular slot. After all,
> there are 256 TX ring slots. As the comment says at line 1407 of dma.c,
> there might be a firmware error. If so, it is common to several versions as
> I have seen it on a BCM4318.

Yeah, it seems to be always 74 (the expected one). Here is the full log:
http://pastebin.com/bDpVXTtb

It's the first time I see the full log. It perfectly shows firmware
omitted 74, transmitted every next packet until reaching 72 and then
stopped.

Do you have any idea what can we do to debug this?

It seems to happen only under heavy load... maybe it has something to
do with reaching end of the ring (not whole ring, just end of free
slots)?

Did you try verbose debugging? I wonder if there is any relation
between Out of order and:
if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
	b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
}

Could you try it?

-- 
Rafał
