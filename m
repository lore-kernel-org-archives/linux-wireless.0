Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38236 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754503AbcJETLE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 15:11:04 -0400
Subject: Re: ath10k: device stops working ("failed to install key for vdev"
 error in kernel log)
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
References: <CAFBinCAuCfTeWw3SMVLbeARkUs_66YT6MJVbsd9QH_CqW9SCtg@mail.gmail.com>
 <bdd2b4f1-114b-f114-c908-fc0f57b08ce8@candelatech.com>
 <CAFBinCAv9PDYQ7J+0LtQg7vKnqp2HVpotqwjALrAUQf57YM4tg@mail.gmail.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <eac2478e-b05c-01b0-c91f-08257beacc07@candelatech.com> (sfid-20161005_211125_051181_0E850796)
Date: Wed, 5 Oct 2016 12:11:03 -0700
MIME-Version: 1.0
In-Reply-To: <CAFBinCAv9PDYQ7J+0LtQg7vKnqp2HVpotqwjALrAUQf57YM4tg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2016 12:06 PM, Martin Blumenstingl wrote:
> On Wed, Oct 5, 2016 at 8:58 PM, Ben Greear <greearb@candelatech.com> wrote:
>> On 10/05/2016 11:51 AM, Martin Blumenstingl wrote:
>>>>
>>>> [54064.293597] ath10k_pci 0000:02:00.0: failed to install key for vdev
>>>> 0 peer [AP MAC addr]: -145
>>>> [54064.301234] wlan0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from
>>>> hardware (-145)
>>>> [54067.305703] ath10k_pci 0000:02:00.0: failed to install key for vdev
>>>> 0 peer [AP MAC addr]: -145
>>>> [54067.313307] wlan0: failed to set key (1, ff:ff:ff:ff:ff:ff) to
>>>> hardware (-145)
>>>
>>> it just happened again:
>>> ...
>>> [130266.948005] ath10k_pci 0000:02:00.0: failed to install key for
>>> vdev 0 peer [AP MAC address]: -145
>>> [130266.955697] wlan0: failed to remove key (2, ff:ff:ff:ff:ff:ff)
>>> from hardware (-145)
>>> [130269.964069] ath10k_pci 0000:02:00.0: failed to install key for
>>> vdev 0 peer [AP MAC address]: -145
>>> [130269.971775] wlan0: failed to set key (2, ff:ff:ff:ff:ff:ff) to
>>> hardware (-145)
>>> [172198.889700] ath10k_pci 0000:02:00.0: failed to send pdev bss chan
>>> info request
>>> [172201.897770] ath10k_pci 0000:02:00.0: failed to send pdev bss chan
>>> info request
>>>
>>> I tried to get more information from the firmware by looking at the
>>> fw_* debugfs files:
>>> # cat /sys/kernel/debug/ieee80211/phy0/ath10k/fw_reset_stats
>>> fw_crash_counter                0
>>> fw_warm_reset_counter           4
>>> fw_cold_reset_counter           0
>>> # cat /sys/kernel/debug/ieee80211/phy0/ath10k/fw_stats
>>> cat: can't open '/sys/kernel/debug/ieee80211/phy0/ath10k/fw_stats':
>>> Resource temporarily unavailable
>>> # cat /sys/kernel/debug/ieee80211/phy0/ath10k/fw_crash_dump
>>> cat: can't open
>>> '/sys/kernel/debug/ieee80211/phy0/ath10k/fw_crash_dump': No data
>>> available
>>> # cat /sys/kernel/debug/ieee80211/phy0/ath10k/fw_dbglog
>>> 0x00000000 0
>>> # cat /sys/kernel/debug/ieee80211/phy0/ath10k/fw_checksums
>>> firmware-N.bin          9d340dd9
>>> athwlan                 8d25deed
>>> otp                     f3efeb4f
>>> codeswap                00000000
>>> board-N.bin             bebc7c08
>>> board                   bebc7c08
>>>
>>> This is still with firmware 10.2.4.70.54.
>>> Please let me know if you need further information.
>>
>>
>> Not sure about your firmware exactly, but the timeout might happen because
>> firmware has leaked and/or run-out of resources, fails to insert the key,
>> and then it just doesn't respond instead of sending an event.  So, driver
>> gets the timeout message and who knows what state your system is in.
>>
>> I hit this when doing capacity tests, and I modified my firmware to always
>> send an event, and driver to deal with it.  I also fixed some resource leaks
>> and tuned firmware objects to make sure I do not hit the key exhaustion
>> state.
> That sounds bad.
> Especially as I would not describe my current setup as "high capacity" network.
> The worst-case I have is 5 devices:
> - Nexus 5
> - Sony Xperia Z3 Compact
> - Notebook with Intel AC 7260
> - QCA9880-2R4E in station (client) mode
> - BCM4330 based device
>
>> What is your test scenario in this case?
> with this specific crash it was pretty easy:
> - AP did not have any connections while I was at work
> - when I came back home two devices (Nexus 5 and Sony Xperia Z3
> Compact) tried to connect to the AP
> - device went into error state
>
> I already had days where only one phone was turned on and I was still
> able to reproduce it.

Firmware sometimes sends dbglog messages when it detects errors.  You can hack your driver with patches
I have posted to enable printing this out, and then maybe QCA firmware guys could debug this issue
for you.

Or, if you can reproduce this with my firmware and kernel (which enables the dbglog print
by default), email dmesg or similar output to me and maybe I will have a clue as to what
is going on.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
