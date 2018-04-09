Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:60857 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbeDINhR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 09:37:17 -0400
Subject: Re: iwlwifi: FW error in SYNC CMD TIME_QUOTA_CMD
From: Daniel Borkmann <daniel@iogearbox.net>
To: Luciano Coelho <luciano.coelho@intel.com>, johannes.berg@intel.com
Cc: emmanuel.grumbach@intel.com, linux-wireless@vger.kernel.org
References: <799ecceb-8b2a-bf8c-b408-374a02280306@iogearbox.net>
 <1523084065.4488.11.camel@intel.com>
 <71396747-1be5-78de-3ff7-d0df91d37d36@iogearbox.net>
Message-ID: <1a94e616-7dcc-6b70-abb4-684d2f69eb23@iogearbox.net> (sfid-20180409_153721_652978_4582C5AE)
Date: Mon, 9 Apr 2018 15:37:14 +0200
MIME-Version: 1.0
In-Reply-To: <71396747-1be5-78de-3ff7-d0df91d37d36@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2018 12:13 AM, Daniel Borkmann wrote:
> Hi Luciano,
> 
> On 04/07/2018 08:54 AM, Luciano Coelho wrote:
>> On Thu, 2018-04-05 at 16:55 +0200, Daniel Borkmann wrote:
> [...]
>>> after upgrading to 4608f064532c ("Merge
>>> git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next")
>>> my kernel log gets constantly flooded with the below message and
>>> wireless stops
>>> working ... just in case you haven't had a report on this yet.
>>> Downgrading back
>>> to older v4.16-rcX kernel gets everything back to normal working
>>> state; haven't
>>> had time for bisection yet, but hopefully the below would provide
>>> some clue.
>>
>> [...]
>>
>>> [  513.429773] iwlwifi 0000:04:00.0: Failed to send quota: -5
>>> [  513.429775] iwlwifi 0000:04:00.0: Failed to update quotas after
>>> restart (-5)
>>> [  514.163758] iwlwifi 0000:04:00.0: Microcode SW error
>>> detected.  Restarting 0x82000000.
>>> [  514.163987] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
>>> [  514.163988] iwlwifi 0000:04:00.0: Status: 0x00000100, count: 6
>>> [  514.163989] iwlwifi 0000:04:00.0: Loaded firmware version:
>>> 27.455470.0
>>> [  514.163991] iwlwifi 0000:04:00.0: 0x00000038 | BAD_COMMAND
>>
>> [...]
>>
>> I did add support for new FW APIs, so maybe some check for the FW
>> version is missing somewhere.
>>
>> Which NIC are you using? I can see that you're using an older version
>> of the firmware (27.455470.0).  For 7265D and 3168 we already have
>> version 29.  For 8000C and 8260 we have vesion 36.  You can find all
>> the latest versions in our fork of linux-firmware.git[1].  And soon the
>> main linux-firmware.git[2] will also include the latest versions, since
>> I sent a pull request yesteday ago.
>>
>> Meanwhile, I'll investigate this problem.  It shouldn't happen even if
>> you're using an older firmware.  Maybe I'll have to stop supporting
>> version 27 in newer kernels, let's see.
> 
> Here's from the log on an older (working) kernel:
> 
> $ dmesg | grep iwlwifi
> [    7.672955] iwlwifi 0000:04:00.0: enabling device (0000 -> 0002)
> [    7.705000] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-36.ucode failed with error -2
> [    7.705208] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-35.ucode failed with error -2
> [    7.705391] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-34.ucode failed with error -2
> [    7.705850] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-33.ucode failed with error -2
> [    7.706118] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-32.ucode failed with error -2
> [    7.706463] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-31.ucode failed with error -2
> [    7.706789] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-30.ucode failed with error -2
> [    7.707182] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-29.ucode failed with error -2
> [    7.707746] iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-28.ucode failed with error -2
> [    7.714899] iwlwifi 0000:04:00.0: loaded firmware version 27.455470.0 op_mode iwlmvm
> [    8.400655] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
> [    8.475161] iwlwifi 0000:04:00.0: base HW address: [...]
> [    8.568333] iwlwifi 0000:04:00.0 wlp4s0: renamed from wlan0
> 
> I'll try to upgrade the FW in the mean time, thanks!

Moved to iwlwifi-8000C-36 and that definitely helped. Thanks!

>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git/
>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
>>
>> --
>> Cheers,
>> Luca.
>>
> 
