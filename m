Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36536 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752748AbcJETGZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 15:06:25 -0400
Received: by mail-wm0-f51.google.com with SMTP id k125so285089976wma.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2016 12:06:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bdd2b4f1-114b-f114-c908-fc0f57b08ce8@candelatech.com>
References: <CAFBinCAuCfTeWw3SMVLbeARkUs_66YT6MJVbsd9QH_CqW9SCtg@mail.gmail.com>
 <bdd2b4f1-114b-f114-c908-fc0f57b08ce8@candelatech.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Wed, 5 Oct 2016 21:06:02 +0200
Message-ID: <CAFBinCAv9PDYQ7J+0LtQg7vKnqp2HVpotqwjALrAUQf57YM4tg@mail.gmail.com> (sfid-20161005_210629_796271_16C33C47)
Subject: Re: ath10k: device stops working ("failed to install key for vdev"
 error in kernel log)
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 5, 2016 at 8:58 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/05/2016 11:51 AM, Martin Blumenstingl wrote:
>>>
>>> [54064.293597] ath10k_pci 0000:02:00.0: failed to install key for vdev
>>> 0 peer [AP MAC addr]: -145
>>> [54064.301234] wlan0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from
>>> hardware (-145)
>>> [54067.305703] ath10k_pci 0000:02:00.0: failed to install key for vdev
>>> 0 peer [AP MAC addr]: -145
>>> [54067.313307] wlan0: failed to set key (1, ff:ff:ff:ff:ff:ff) to
>>> hardware (-145)
>>
>> it just happened again:
>> ...
>> [130266.948005] ath10k_pci 0000:02:00.0: failed to install key for
>> vdev 0 peer [AP MAC address]: -145
>> [130266.955697] wlan0: failed to remove key (2, ff:ff:ff:ff:ff:ff)
>> from hardware (-145)
>> [130269.964069] ath10k_pci 0000:02:00.0: failed to install key for
>> vdev 0 peer [AP MAC address]: -145
>> [130269.971775] wlan0: failed to set key (2, ff:ff:ff:ff:ff:ff) to
>> hardware (-145)
>> [172198.889700] ath10k_pci 0000:02:00.0: failed to send pdev bss chan
>> info request
>> [172201.897770] ath10k_pci 0000:02:00.0: failed to send pdev bss chan
>> info request
>>
>> I tried to get more information from the firmware by looking at the
>> fw_* debugfs files:
>> # cat /sys/kernel/debug/ieee80211/phy0/ath10k/fw_reset_stats
>> fw_crash_counter                0
>> fw_warm_reset_counter           4
>> fw_cold_reset_counter           0
>> # cat /sys/kernel/debug/ieee80211/phy0/ath10k/fw_stats
>> cat: can't open '/sys/kernel/debug/ieee80211/phy0/ath10k/fw_stats':
>> Resource temporarily unavailable
>> # cat /sys/kernel/debug/ieee80211/phy0/ath10k/fw_crash_dump
>> cat: can't open
>> '/sys/kernel/debug/ieee80211/phy0/ath10k/fw_crash_dump': No data
>> available
>> # cat /sys/kernel/debug/ieee80211/phy0/ath10k/fw_dbglog
>> 0x00000000 0
>> # cat /sys/kernel/debug/ieee80211/phy0/ath10k/fw_checksums
>> firmware-N.bin          9d340dd9
>> athwlan                 8d25deed
>> otp                     f3efeb4f
>> codeswap                00000000
>> board-N.bin             bebc7c08
>> board                   bebc7c08
>>
>> This is still with firmware 10.2.4.70.54.
>> Please let me know if you need further information.
>
>
> Not sure about your firmware exactly, but the timeout might happen because
> firmware has leaked and/or run-out of resources, fails to insert the key,
> and then it just doesn't respond instead of sending an event.  So, driver
> gets the timeout message and who knows what state your system is in.
>
> I hit this when doing capacity tests, and I modified my firmware to always
> send an event, and driver to deal with it.  I also fixed some resource leaks
> and tuned firmware objects to make sure I do not hit the key exhaustion
> state.
That sounds bad.
Especially as I would not describe my current setup as "high capacity" network.
The worst-case I have is 5 devices:
- Nexus 5
- Sony Xperia Z3 Compact
- Notebook with Intel AC 7260
- QCA9880-2R4E in station (client) mode
- BCM4330 based device

> What is your test scenario in this case?
with this specific crash it was pretty easy:
- AP did not have any connections while I was at work
- when I came back home two devices (Nexus 5 and Sony Xperia Z3
Compact) tried to connect to the AP
- device went into error state

I already had days where only one phone was turned on and I was still
able to reproduce it.


Regards,
Martin
