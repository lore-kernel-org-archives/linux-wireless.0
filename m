Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35752 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab2DQVNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 17:13:25 -0400
Message-ID: <4F8DDCF1.1080304@candelatech.com> (sfid-20120417_231335_990267_764FCDC9)
Date: Tue, 17 Apr 2012 14:13:21 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k: Gather and report IRQ sync_cause errors.
References: <1334250240-21038-1-git-send-email-greearb@candelatech.com> <1334250240-21038-2-git-send-email-greearb@candelatech.com> <4F8DDB9F.8030302@openwrt.org>
In-Reply-To: <4F8DDB9F.8030302@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2012 02:07 PM, Gabor Juhos wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> Report all defined sync_cause errors in debugfs
>> to aid with debugging.
>>
>> Use a macro to print out the interrupts file contents
>> to decrease code duplication.
>
> Now, that the patch is in wireless-testing, I have noticed a minor problem with it.

Thanks for the report.

I'll fix this shortly.

Thanks,
Ben

>> +#ifdef CONFIG_ATH9K_DEBUGFS
>> +void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause);
>> +#else
>> +static void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause) {}
>
> Due to a missing 'inline' keyword, this causes a bunch of warnings if
> CONFIG_ATH9K_DEBUGFS is not enabled:
>
>     CC [M]  drivers/net/wireless/ath/main.o
>     CC [M]  drivers/net/wireless/ath/regd.o
>     CC [M]  drivers/net/wireless/ath/hw.o
>     CC [M]  drivers/net/wireless/ath/key.o
>     LD [M]  drivers/net/wireless/ath/ath.o
>     CC [M]  drivers/net/wireless/ath/ath9k/beacon.o
>   drivers/net/wireless/ath/ath9k/hw.h:962: warning: ‘ath9k_debug_sync_cause’
> defined but not used

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

