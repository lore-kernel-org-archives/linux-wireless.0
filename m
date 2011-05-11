Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:42988 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757586Ab1EKQ1v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:27:51 -0400
Subject: Re: Optimization: keeping pointer all the time, or defining getter?
From: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTi=xOtAaxh8Q7Nk84Rwz9jM-6EP1Ww@mail.gmail.com>
References: <BANLkTi=xOtAaxh8Q7Nk84Rwz9jM-6EP1Ww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 18:27:45 +0200
Message-ID: <1305131265.16850.6.camel@maggie> (sfid-20110511_182807_238524_A92A7561)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-11 at 18:22 +0200, Rafał Miłecki wrote: 
> I try to abstract bus in b43 driver. For frequently used fields
> solution is obvious:
> At init time I get info from bus-specific stuct and put it in generic field.
> Example: core revision. We often refer to it, I put it in abstraction struct.
> 
> My question: what is the policy for cases with less frequently used fields?
> Example: I need to use "struct device" for registering some low lever stuff.
> 
> I have two solutions:
> 
> 1) Realtime:
> struct device *get_device(...)
> {
> if (dev->bus_type = B43_BUS_SSB)
> return dev->ssbdev->device;
> else if (dev->bus_type = B43_BUS_BCMA)
> return dev->bcmadev->device;
> }
> 
> 2) Init time:
> void b43_ssb_init(struct ssb_device *ssbdev)
> {
> dev->struct = ssbdev->device;
> }
> 
> The first one is slower but we don't keep "struct device" pointer in
> abstraction struct. Situation is opposite for the second one.
> 
> Does anyone care? ;)

Put a struct device pointer into b43_wldev.
The pointer is needed on every DMA transaction several times, so this
seems worth it.

-- 
Greetings Michael.

