Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43956 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaFFQB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 12:01:27 -0400
Message-ID: <5391E5D7.1030302@candelatech.com> (sfid-20140606_180131_874127_42617108)
Date: Fri, 06 Jun 2014 09:01:27 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 1/4] ath10k:  provide firmware crash info via debugfs.
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com> <87bnu6msra.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bnu6msra.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2014 11:55 PM, Kalle Valo wrote:
> greearb@candelatech.com writes:
> 
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Store the firmware crash registers and last 128 or so
>> firmware debug-log ids and present them to user-space
>> via debugfs.
>>
>> Should help with figuring out why the firmware crashed.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
> 
> [...]
> 
>> +	dump_data->kernel_ver_code = LINUX_VERSION_CODE;
>> +	strncpy(dump_data->kernel_ver, VERMAGIC_STRING,
>> +		sizeof(dump_data->kernel_ver) - 1);
> 
> Other thing nice to have here is the kernel timestamp in the kernel log
> "[123456.4321]". How difficult would it be to add that to the dump?

It's easy to get the time-of-day, if that is what you mean.

I'll add that...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

