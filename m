Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43550 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab1EKQel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:34:41 -0400
Received: by qyk7 with SMTP id 7so2416545qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 09:34:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305131265.16850.6.camel@maggie>
References: <BANLkTi=xOtAaxh8Q7Nk84Rwz9jM-6EP1Ww@mail.gmail.com>
	<1305131265.16850.6.camel@maggie>
Date: Wed, 11 May 2011 18:34:40 +0200
Message-ID: <BANLkTinR=+vdYNModL_yOKhAqKv3e0nQ4A@mail.gmail.com> (sfid-20110511_183447_067589_411E2343)
Subject: Re: Optimization: keeping pointer all the time, or defining getter?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 11 maja 2011 18:27 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Wed, 2011-05-11 at 18:22 +0200, Rafał Miłecki wrote:
>> I try to abstract bus in b43 driver. For frequently used fields
>> solution is obvious:
>> At init time I get info from bus-specific stuct and put it in generic field.
>> Example: core revision. We often refer to it, I put it in abstraction struct.
>>
>> My question: what is the policy for cases with less frequently used fields?
>> Example: I need to use "struct device" for registering some low lever stuff.
>>
>> I have two solutions:
>>
>> 1) Realtime:
>> struct device *get_device(...)
>> {
>> if (dev->bus_type = B43_BUS_SSB)
>> return dev->ssbdev->device;
>> else if (dev->bus_type = B43_BUS_BCMA)
>> return dev->bcmadev->device;
>> }
>>
>> 2) Init time:
>> void b43_ssb_init(struct ssb_device *ssbdev)
>> {
>> dev->struct = ssbdev->device;
>> }
>>
>> The first one is slower but we don't keep "struct device" pointer in
>> abstraction struct. Situation is opposite for the second one.
>>
>> Does anyone care? ;)
>
> Put a struct device pointer into b43_wldev.
> The pointer is needed on every DMA transaction several times, so this
> seems worth it.

Oops, OK, that was example. I thought DMA uses "dma_dev" frequently, not "dev".

But if we assume there is some not frequently used struct. What
solution should be used then?

-- 
Rafał
