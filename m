Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:62000 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaGFQL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 12:11:26 -0400
Received: by mail-ob0-f171.google.com with SMTP id nu7so3553775obb.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 09:11:26 -0700 (PDT)
Message-ID: <53B97537.3040608@lwfinger.net> (sfid-20140706_181131_605959_3EECEC64)
Date: Sun, 06 Jul 2014 11:11:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Microcode SW errors for Intel 7260
References: <53B756D8.1080909@lwfinger.net>	<CANUX_P0wGNT-E0TnuMkrHV+LWyZAJjiaz+hEzYDVO9EWpJYzfA@mail.gmail.com>	<53B8D0AA.7020703@lwfinger.net> <CANUX_P3vSTDbaQ3fFdacQuCt11vECN0MtGZxJpdMCpqFTfLw3g@mail.gmail.com>
In-Reply-To: <CANUX_P3vSTDbaQ3fFdacQuCt11vECN0MtGZxJpdMCpqFTfLw3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/05/2014 11:56 PM, Emmanuel Grumbach wrote:
> Hi Larry,
>
>> I am obviously missing something. Neither iwlwifi nor iwlwifi_msg are listed
>> in /sys/kernel/debug/tracing/available_events/, thus trace-cmd cannot enable
>> logging those events. The output is as follows:
>>
>> finger@linux-rcu3:~/wireless-testing> sudo trace-cmd record -e iwlwifi -e
>> iwlwifi_msg
>> /sys/kernel/debug/tracing/events/iwlwifi_msg/filter
>> /sys/kernel/debug/tracing/events/*/iwlwifi_msg/filter
>> trace-cmd: No such file or directory
>>    No events enabled with iwlwifi_msg
>> finger@linux-rcu3:~/wireless-testing>
>>
>>
>> I compared my .config with one for the openSUSE kernel 3.11.10, and the
>> kernel hacking section has the same settings.
>>
>> Do you have any suggestions?
>>
>
> Do you have CONFIG_IWLWIFI_DEVICE_TRACING enabled?
> If not, please enable it.
> Note that I don't really need iwlwifi_msg. iwlwifi should be enough.
>
> If you have CONFIG_IWLWIFI_DEBUG, then running with debug=0x00000800
> as a module parameter should be enough if that can save you a kernel
> compilation.

Apparently, I was caught by a bug in the kernel configuration system. Using 
'make xconfig', none of the entries under 'menu "Debugging Options"' in 
drivers/net/wireless/iwlwifi/Kconfig appear. Using 'make menuconfig' reveals 
them. I will report the problem to the appropriate persons - it does not seem to 
be a wireless bug.

The rebuilt kernel is running with the appropriate trace turned on. Now it only 
takes a retriggering of the original problem. I just hope that having debugging 
enabled does not affect the timing enough to prevent the errors. :)

Thanks,

Larry


