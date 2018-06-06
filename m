Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52114 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933567AbeFFRE0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Jun 2018 13:04:26 -0400
Subject: Re: How to let devcoredump know data has been read?
To: Brian Norris <briannorris@chromium.org>
References: <6f54d11c-74a5-568a-ba1e-3f37edb28384@candelatech.com>
 <20180605225324.GA195207@rodete-desktop-imager.corp.google.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <cc4346a9-7eb9-3ac1-5568-8fae4ba7a82b@candelatech.com> (sfid-20180606_190436_658895_A07B20CC)
Date: Wed, 6 Jun 2018 10:04:23 -0700
MIME-Version: 1.0
In-Reply-To: <20180605225324.GA195207@rodete-desktop-imager.corp.google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2018 03:53 PM, Brian Norris wrote:
> Hi,
>
> On Tue, Jun 05, 2018 at 03:27:28PM -0700, Ben Greear wrote:
>> I have been testing ath10k on 4.16, which uses the devcoredump API
>> to notify about dumps.
>>
>> I am able to see the binary crash dump at /sys/class/devcoredump/devcd2/data,
>> for instance, but if I do another crash quickly, I get no new uevent sent
>> and no new crash.
>>
>> I see there is a 5 minute timer on the coredump data, but it also seems to indicate
>> that if I read the crash, the data should be cleared and ready to be
>> recreated again?  How do you notify the system that the crash data has
>> been read?
>>
>> I tried 'cat' on the data file, but that did not seem to clear anything.
>
> Try *writing* to it?
>
> https://elixir.bootlin.com/linux/v4.16/source/drivers/base/devcoredump.c#L91
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=833c95456a70826d1384883b73fd23aff24d366f
>
> <quote>
> The dumped data will be readable in sysfs in the virtual device's
> data file under /sys/class/devcoredump/devcd*/. Writing to it will
> free the data and remove the device, as does a 5-minute timeout.
> </quote>
>
> e.g.:
>
> # ls -l /sys/class/devcoredump/devcd1
> lrwxrwxrwx. 1 root root 0 Jun  5 15:49 /sys/class/devcoredump/devcd1 -> ../../devices/virtual/devcoredump/devcd1
> # echo 1 > /sys/class/devcoredump/devcd1/data
> # ls -l /sys/class/devcoredump/devcd1
> ls: cannot access '/sys/class/devcoredump/devcd1': No such file or directory

Thanks to all who responded.  That indeed works just fine.

Just in case you know a quick answer:  I opened a netlink socket to listen
to uevents so I would know when FW crashed.  It receives the kernel messages,
but also receives 'libudev' events which seem to have some binary header in
them (which I could not google any info about how to decode it).  Is there
an easy way to tell the socket to not send the libudev events?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
