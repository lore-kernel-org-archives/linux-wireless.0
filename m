Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:53618 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752055AbeFFTC0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Jun 2018 15:02:26 -0400
Received: by mail-wm0-f65.google.com with SMTP id x6-v6so13387921wmc.3
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2018 12:02:26 -0700 (PDT)
Subject: Re: How to let devcoredump know data has been read?
To: Ben Greear <greearb@candelatech.com>,
        Brian Norris <briannorris@chromium.org>
References: <6f54d11c-74a5-568a-ba1e-3f37edb28384@candelatech.com>
 <20180605225324.GA195207@rodete-desktop-imager.corp.google.com>
 <cc4346a9-7eb9-3ac1-5568-8fae4ba7a82b@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B182FC0.3060300@broadcom.com> (sfid-20180606_210231_069158_C06A04A9)
Date: Wed, 6 Jun 2018 21:02:24 +0200
MIME-Version: 1.0
In-Reply-To: <cc4346a9-7eb9-3ac1-5568-8fae4ba7a82b@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/6/2018 7:04 PM, Ben Greear wrote:
> On 06/05/2018 03:53 PM, Brian Norris wrote:
>> Hi,
>>
>> On Tue, Jun 05, 2018 at 03:27:28PM -0700, Ben Greear wrote:
>>> I have been testing ath10k on 4.16, which uses the devcoredump API
>>> to notify about dumps.
>>>
>>> I am able to see the binary crash dump at
>>> /sys/class/devcoredump/devcd2/data,
>>> for instance, but if I do another crash quickly, I get no new uevent
>>> sent
>>> and no new crash.
>>>
>>> I see there is a 5 minute timer on the coredump data, but it also
>>> seems to indicate
>>> that if I read the crash, the data should be cleared and ready to be
>>> recreated again?  How do you notify the system that the crash data has
>>> been read?
>>>
>>> I tried 'cat' on the data file, but that did not seem to clear anything.
>>
>> Try *writing* to it?
>>
>> https://elixir.bootlin.com/linux/v4.16/source/drivers/base/devcoredump.c#L91
>>
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=833c95456a70826d1384883b73fd23aff24d366f
>>
>>
>> <quote>
>> The dumped data will be readable in sysfs in the virtual device's
>> data file under /sys/class/devcoredump/devcd*/. Writing to it will
>> free the data and remove the device, as does a 5-minute timeout.
>> </quote>
>>
>> e.g.:
>>
>> # ls -l /sys/class/devcoredump/devcd1
>> lrwxrwxrwx. 1 root root 0 Jun  5 15:49 /sys/class/devcoredump/devcd1
>> -> ../../devices/virtual/devcoredump/devcd1
>> # echo 1 > /sys/class/devcoredump/devcd1/data
>> # ls -l /sys/class/devcoredump/devcd1
>> ls: cannot access '/sys/class/devcoredump/devcd1': No such file or
>> directory
>
> Thanks to all who responded.  That indeed works just fine.
>
> Just in case you know a quick answer:  I opened a netlink socket to listen
> to uevents so I would know when FW crashed.  It receives the kernel
> messages,
> but also receives 'libudev' events which seem to have some binary header in
> them (which I could not google any info about how to decode it).  Is there
> an easy way to tell the socket to not send the libudev events?

Hi Ben,

When I was playing with..eh..implementing devcoredump functionality in 
brcmfmac, I created a small app for it based on [1]. I should have put 
it under version control so I can not make it easier for you.

Regards,
Arend

[1] http://www.signal11.us/oss/udev/
