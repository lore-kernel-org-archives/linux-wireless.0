Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58193 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2F1Pwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 11:52:38 -0400
Received: by wgbdr13 with SMTP id dr13so2348083wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 08:52:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FD4F793.2030507@hauke-m.de>
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
	<1338933307-13446-7-git-send-email-hauke@hauke-m.de>
	<2716026.rMfCBzMpF9@flexo>
	<CACna6rw_5dcR9tu_Nnq_0Z3u+KJ--Lmx7yi+uHJm-kJPepqrng@mail.gmail.com>
	<4FD4F793.2030507@hauke-m.de>
Date: Thu, 28 Jun 2012 17:52:36 +0200
Message-ID: <CACna6rwYawBawu_KP4rADKjGTspKdvRrvJbhzA18ApBP1tvAiQ@mail.gmail.com> (sfid-20120628_175241_862981_95E98F19)
Subject: Re: [PATCH 6/8] bcma: handle SoCs in pmu initialization
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Florian Fainelli <florian@openwrt.org>, linville@tuxdriver.com,
	b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/10 Hauke Mehrtens <hauke@hauke-m.de>:
> On 06/10/2012 06:54 PM, Rafał Miłecki wrote:
>> 2012/6/6 Florian Fainelli <florian@openwrt.org>:
>>> Hi Hauke,
>>>
>>> On Tuesday 05 June 2012 23:55:05 Hauke Mehrtens wrote:
>>>> The SoCs do not need any special handling in bcma_pmu_pll_init(),
>>>> bcma_pmu_resources_init(), bcma_pmu_swreg_init() and
>>>> bcma_pmu_workarounds. This patches suppresses some warnings in the log.
>>>
>>> This does not look like it scales very good, how about you turn the pr_err()
>>> into a pr_debug() so that developpers porting bcma on a new chip need to turn
>>> on the appropriate debug knobs to get the message?
>>
>> debug sounds fine for me
>>
> Hi Rafał,
>
> bcma_pmu_swreg_init() and bcma_pmu_pll_init() are doing nothing should
> they get removed? In the current version of the patch I also removed the
> chip ids of the PCIe based cards from the switch case statement if they
> just ended in a break, is that ok with you?

Original si_pmu_pll_init had some meaning for BCM4329, BCM4319,
BCM4336 and BCM4330. I guess all of them are fullmac devices, right?

Original si_pmu_swreg_init got meaning for BCM4336 and BCM4336.

Seems both can be dropped?

-- 
Rafał
