Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23747 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaFGMuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 08:50:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/4] ath10k:  provide firmware crash info via debugfs.
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
	<87bnu6msra.fsf@kamboji.qca.qualcomm.com>
	<5391E5D7.1030302@candelatech.com>
Date: Sat, 7 Jun 2014 15:50:01 +0300
In-Reply-To: <5391E5D7.1030302@candelatech.com> (Ben Greear's message of "Fri,
	6 Jun 2014 09:01:27 -0700")
Message-ID: <878up8khom.fsf@kamboji.qca.qualcomm.com> (sfid-20140607_145131_447711_2A39F9F8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 06/05/2014 11:55 PM, Kalle Valo wrote:
>> greearb@candelatech.com writes:
>> 
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> Store the firmware crash registers and last 128 or so
>>> firmware debug-log ids and present them to user-space
>>> via debugfs.
>>>
>>> Should help with figuring out why the firmware crashed.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> 
>> [...]
>> 
>>> +	dump_data->kernel_ver_code = LINUX_VERSION_CODE;
>>> +	strncpy(dump_data->kernel_ver, VERMAGIC_STRING,
>>> +		sizeof(dump_data->kernel_ver) - 1);
>> 
>> Other thing nice to have here is the kernel timestamp in the kernel log
>> "[123456.4321]". How difficult would it be to add that to the dump?
>
> It's easy to get the time-of-day, if that is what you mean.

That's actually seconds from boot, not wall time:

[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2793.393 MHz processor
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.78 BogoMIP
S (lpj=27933930)
[    0.000009] pid_max: default: 32768 minimum: 301
[    0.000016] ACPI: Core revision 20140214
[    0.023399] ACPI: All ACPI Tables successfully acquired

There's function print_time() which prints the time and the timestamp
apparently comes from local_clock().

-- 
Kalle Valo
