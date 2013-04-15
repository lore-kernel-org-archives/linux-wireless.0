Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:48754 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3DOKgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 06:36:07 -0400
Received: by mail-oa0-f47.google.com with SMTP id n9so25058oag.20
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 03:36:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5168AFF8.2090808@lwfinger.net>
References: <20130411082543.GA346@ArchPC.zedat.fu-berlin.de>
	<5168AFF8.2090808@lwfinger.net>
Date: Mon, 15 Apr 2013 12:36:06 +0200
Message-ID: <CACna6rwAK_nTqg=kXb-0PwjD41Cv0VX1=Ey3jTj7ZECA-C7p_w@mail.gmail.com> (sfid-20130415_123612_240880_99D58BC2)
Subject: Re: GSoC 2013 - b43 driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Patrick Steinhardt <steinhardt.ptk@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/4/13 Larry Finger <Larry.Finger@lwfinger.net>:
> I think that your coding experience makes you qualified to undertake the
> coding necessary to improve the performance of b43 on the 14e4:432b device;
> however, I recommend that you not attempt it as a GSoC project. The reason
> is that those projects are highly visible, and what you are trying to do is
> very difficult. The actual coding is likely not a problem, but knowing what
> to code is not trivial. I would hate for you to fail in a way that would be
> so completely obvious.
>
> As you probably know, b43 has been developed using reverse engineering (RE)
> techniques. We have no knowledge of the internal workings of the chips.
> Since the LP-PHY, more and more has been required by the driver. Earlier PHY
> models did quite a lot in the firmware. With the N PHYs such as your device
> has, the problem got even worse. and the implementation is more incomplete.
> For instance, implementation of power regulation in the wireless chip has
> barely been touched.
>
> At the moment, I am the only person doing any of the RE work, and I have
> relatively little time to work on that. Much of the more recent development
> has come from comparing MMIO dumps between wl and b43 to see what parts are
> missing from b43. That requires an extremely good knowledge of the existing
> driver, and that would take a long time to acquire.
>
> The b43 project welcomes your interest, and I hope you pursue it eventually,
> but I still think you should find another project for the GSoC.

I would love to see extra developer in b43 project, but I have to
confirm what Larry has said. It's hard task and we're really missing
specifications for the hardware.

There are few things that should be easy to add, like 5GHz support
(most of the code is already there, it just needs enabling & testing)
or maybe even (some) 802.11n features.

Further improvements unfortunately are much more complicated or even
impossible due to lack of documentation.

You can try doing MMIO tracking and comparing with closed source
driver, but it's not trivial and doesn't guarantee you'll notice
important differences (not to mention understanding them).

-- 
Rafał
