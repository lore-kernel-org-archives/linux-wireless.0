Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44052 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1EJSej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 14:34:39 -0400
Received: by vxi39 with SMTP id 39so6909708vxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 11:34:39 -0700 (PDT)
Message-ID: <4DC9853A.1090508@lwfinger.net> (sfid-20110510_203442_717684_CD713B83)
Date: Tue, 10 May 2011 13:34:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Juan Carlos Romero <juancarlos.romero@gmail.com>,
	=?UTF-8?B?TWljaGFlbA==?= =?UTF-8?B?IELDvHNjaA==?= <mb@bu3sch.de>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43 error under heavy load
References: <4CEAB969.20702@lwfinger.net>	<1290451982.20888.2.camel@maggie>	<4CEAC095.7020706@lwfinger.net> <BANLkTimjRA5CsSDp_+LrGq8PNgaR4JFD=w@mail.gmail.com>
In-Reply-To: <BANLkTimjRA5CsSDp_+LrGq8PNgaR4JFD=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 12:08 AM, Rafał Miłecki wrote:
> 2010/11/22 Larry Finger<Larry.Finger@lwfinger.net>:
>> On 11/22/2010 12:53 PM, Michael Büsch wrote:
>>> On Mon, 2010-11-22 at 12:41 -0600, Larry Finger wrote:
>>>> Under heavy load with multiple streams, I'm getting errors from my BCM4312
>>>> (14e4:4315) device as follows:
>>>>
>>>> b43-phy0 debug: TX-status contains invalid cookie: 0x0D4D
>>>> b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 74, but got 76
>>>> b43-phy0 debug: Out of order TX status report on DMA ring 1. Expected 74, but got 78
>>>> (and continues).
>>>>
>>>> Clearly that cookie is garbage as it has a slot number of 0. Any suggestions on
>>>> diagnostic information that I could dump to help debug this?
>>>
>>> I think that probably is a firmware or hardware bug. The affected
>>> kernel code was not changed in years, as far as I know.
>>
>> Thanks. I'll see if I can figure out a way for the driver to recover more
>> gracefully. In the meantime, I will be dumping the entire TX status struct to
>> see if that helps in seeing what is wrong.
>
> Larry, did you try debugging this? Juan noticed this issue on his
> 14e4:4315 as well.
> [  854.826369] b43-phy0 debug: Out of order TX status report on DMA
> ring 1. Expected 74, but got 54
> [  854.827348] b43-phy0 debug: Out of order TX status report on DMA
> ring 1. Expected 74, but got 56
> [  854.828080] b43-phy0 debug: Out of order TX status report on DMA
> ring 1. Expected 74, but got 58
> [  854.831431] b43-phy0 debug: Out of order TX status report on DMA
> ring 1. Expected 74, but got 60
> [  854.831453] b43-phy0 debug: Out of order TX status report on DMA
> ring 1. Expected 74, but got 62
> [  854.832440] b43-phy0 debug: Out of order TX status report on DMA
> ring 1. Expected 74, but got 64
> [  854.833836] b43-phy0 debug: Out of order TX status report on DMA
> ring 1. Expected 74, but got 66
> [  854.834567] b43-phy0 debug: Out of order TX status report on DMA
> ring 1. Expected 74, but got 68
> [  854.834588] b43-phy0 debug: Out of order TX status report on DMA
> ring 1. Expected 74, but got 70
> [  854.835378] b43-phy0 debug: Out of order TX status report on DMA
> ring 1. Expected 74, but got 72
>
> Connection is lost, reloading of the driver is needer.

I have not gotten any further with this problem, but I just noticed a curious 
"coincidence". The expected status number was 74 in both cases. I do not think 
there is anything special about that particular slot. After all, there are 256 
TX ring slots. As the comment says at line 1407 of dma.c, there might be a 
firmware error. If so, it is common to several versions as I have seen it on a 
BCM4318.

Larry
