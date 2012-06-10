Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50539 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab2FJTiB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 15:38:01 -0400
Message-ID: <4FD4F793.2030507@hauke-m.de> (sfid-20120610_213806_084878_0EC09CD9)
Date: Sun, 10 Jun 2012 21:37:55 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Florian Fainelli <florian@openwrt.org>, linville@tuxdriver.com,
	b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/8] bcma: handle SoCs in pmu initialization
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de> <1338933307-13446-7-git-send-email-hauke@hauke-m.de> <2716026.rMfCBzMpF9@flexo> <CACna6rw_5dcR9tu_Nnq_0Z3u+KJ--Lmx7yi+uHJm-kJPepqrng@mail.gmail.com>
In-Reply-To: <CACna6rw_5dcR9tu_Nnq_0Z3u+KJ--Lmx7yi+uHJm-kJPepqrng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2012 06:54 PM, Rafał Miłecki wrote:
> 2012/6/6 Florian Fainelli <florian@openwrt.org>:
>> Hi Hauke,
>>
>> On Tuesday 05 June 2012 23:55:05 Hauke Mehrtens wrote:
>>> The SoCs do not need any special handling in bcma_pmu_pll_init(),
>>> bcma_pmu_resources_init(), bcma_pmu_swreg_init() and
>>> bcma_pmu_workarounds. This patches suppresses some warnings in the log.
>>
>> This does not look like it scales very good, how about you turn the pr_err()
>> into a pr_debug() so that developpers porting bcma on a new chip need to turn
>> on the appropriate debug knobs to get the message?
> 
> debug sounds fine for me
> 
Hi Rafał,

bcma_pmu_swreg_init() and bcma_pmu_pll_init() are doing nothing should
they get removed? In the current version of the patch I also removed the
chip ids of the PCIe based cards from the switch case statement if they
just ended in a break, is that ok with you?

Hauke
