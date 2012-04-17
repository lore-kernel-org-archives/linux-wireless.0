Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42630 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab2DQV3u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 17:29:50 -0400
Message-ID: <4F8DE0D0.5000701@openwrt.org> (sfid-20120417_233000_031284_137AE867)
Date: Tue, 17 Apr 2012 23:29:52 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k: Gather and report IRQ sync_cause errors.
References: <1334250240-21038-1-git-send-email-greearb@candelatech.com> <1334250240-21038-2-git-send-email-greearb@candelatech.com> <4F8DDB9F.8030302@openwrt.org> <4F8DDCF1.1080304@candelatech.com>
In-Reply-To: <4F8DDCF1.1080304@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.04.17. 23:13 keltezéssel, Ben Greear írta:
> On 04/17/2012 02:07 PM, Gabor Juhos wrote:
>>> From: Ben Greear<greearb@candelatech.com>
>>>
>>> Report all defined sync_cause errors in debugfs
>>> to aid with debugging.
>>>
>>> Use a macro to print out the interrupts file contents
>>> to decrease code duplication.
>>
>> Now, that the patch is in wireless-testing, I have noticed a minor problem
>> with it.
> 
> Thanks for the report.

Np.

> I'll fix this shortly.

Thanks,
Gabor

> 
> Thanks,
> Ben
> 
>>> +#ifdef CONFIG_ATH9K_DEBUGFS
>>> +void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause);
>>> +#else
>>> +static void ath9k_debug_sync_cause(struct ath_common *common, u32
>>> sync_cause) {}
>>
>> Due to a missing 'inline' keyword, this causes a bunch of warnings if
>> CONFIG_ATH9K_DEBUGFS is not enabled:
>>
>>     CC [M]  drivers/net/wireless/ath/main.o
>>     CC [M]  drivers/net/wireless/ath/regd.o
>>     CC [M]  drivers/net/wireless/ath/hw.o
>>     CC [M]  drivers/net/wireless/ath/key.o
>>     LD [M]  drivers/net/wireless/ath/ath.o
>>     CC [M]  drivers/net/wireless/ath/ath9k/beacon.o
>>   drivers/net/wireless/ath/ath9k/hw.h:962: warning: ‘ath9k_debug_sync_cause’
>> defined but not used
> 

