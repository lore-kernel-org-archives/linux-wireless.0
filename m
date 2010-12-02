Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33706 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab0LBQSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:18:08 -0500
Received: by wwa36 with SMTP id 36so8905045wwa.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 08:18:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CF73BC6.8080400@candelatech.com>
References: <4CF6ED18.5010704@candelatech.com>
	<4CF6EE43.2020905@candelatech.com>
	<AANLkTi=tRagv2dC8Vh3kQz1CFifPXOB3wNdhvGGziOSE@mail.gmail.com>
	<4CF73BC6.8080400@candelatech.com>
Date: Thu, 2 Dec 2010 18:18:06 +0200
Message-ID: <AANLkTik8KPAw=C-EJaUSAq2acUMWxD5cd=5htjm3-PnY@mail.gmail.com>
Subject: Re: ath5k: invalid hw_rix with 64 stations.
From: Nick Kossifidis <mickflemm@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/2 Ben Greear <greearb@candelatech.com>:
> On 12/01/2010 08:19 PM, Nick Kossifidis wrote:
>>
>> 2010/12/2 Ben Greear<greearb@candelatech.com>:
>>>
>>> On 12/01/2010 04:49 PM, Ben Greear wrote:
>>>>
>>>> We were testing with 64 virtual stations running WPA, with
>>>> a single instance of supplicant controlling all interfaces and
>>>> the scan-sharing enabled. It was running clean w/out encryption
>>>> (and w/out supplicant).
>>>>
>>>> We see a large number of these types of warnings. We had a proprietary
>>>> module loaded, but it was not in active use. We're going to reproduce
>>>> without it, but in the meantime, here is a representative trace:
>>>
>>> Here's another one from a non-tainted kernel.  Seems this is trivial
>>> to reproduce.
>>>
>>> ------------[ cut here ]------------
>>> WARNING: at
>>>
>>> /home/greearb/git/linux.wireless-testing-ct/drivers/net/wireless/ath/ath5k/base.c:620
>>> ath5k_hw_to_driver_rix+0x5b/0x5f [ath5k]()
>>> Hardware name:
>>> invalid hw_rix: 1b
>>> Modules linked in: 8021q garp stp llc fuse michael_mic macvlan pktgen
>>> w83627hf hwmon_vid hwmon nfs lockd fscache nfs_acl auth_rpcgss sunrpc
>>> ipv6
>>> dm_multipath uinput arc4 ecb ath5k ath mac80211 cfg80211 e1000e i2c_i801
>>> e100 i2c_core output serio_raw pcspkr mii iTCO_wdt iTCO_vendor_support
>>> ata_generic pata_acpi [last unloaded: ipt_addrtype]
>>> Pid: 1225, comm: rsyslogd Tainted: G        W   2.6.37-rc4-wl+ #9
>>> Call Trace:
>>>  [<8043144d>] warn_slowpath_common+0x77/0x8c
>>>  [<f8663994>] ? ath5k_hw_to_driver_rix+0x5b/0x5f [ath5k]
>>>  [<f8663994>] ? ath5k_hw_to_driver_rix+0x5b/0x5f [ath5k]
>>>  [<804314de>] warn_slowpath_fmt+0x2e/0x30
>>>  [<f8663994>] ath5k_hw_to_driver_rix+0x5b/0x5f [ath5k]
>>>  [<f8663ba5>] ath5k_tasklet_tx+0x1ab/0x2f0 [ath5k]
>>>  [<80435948>] tasklet_action+0x78/0xc1
>>>  [<80436034>] __do_softirq+0x75/0x121
>>>  [<80435fbf>] ? __do_softirq+0x0/0x121
>>>  <IRQ>    [<80435f0c>] ? irq_exit+0x29/0x5d
>>>  [<804042c9>] ? do_IRQ+0x8e/0xa2
>>>  [<80403729>] ? common_interrupt+0x29/0x30
>>>  [<8044007b>] ? __queue_work+0x138/0x1af
>>>  [<804b8e53>] ? mntput+0x0/0x15
>>>  [<804b8fb1>] ? path_put+0x15/0x18
>>>  [<8046b551>] ? audit_free_names+0x40/0x59
>>>  [<8046b6fe>] ? audit_syscall_exit+0x91/0x10f
>>>  [<804031d0>] ? sysexit_audit+0x24/0x44
>>> ---[ end trace e87e98eb2549568d ]---
>>>
>>> Thanks,
>>> Ben
>>>
>>> --
>>> Ben Greear<greearb@candelatech.com>
>>> Candela Technologies Inc  http://www.candelatech.com
>>>
>>
>> That's a weird one, I've seen it again sometimes but couldn't
>> reproduce it easily to debug it...
>
> This script is likely to reproduce it for you..it's a simplistic
> version of the test that caused this:
>
> http://www.spinics.net/lists/linux-wireless/msg60126.html
>
> Also, we can currently reproduce this easily in our setup, and we're
> more than happy to test patches.
>
>> #define ATH5K_RATE_CODE_1M      0x1B
>> is not an invalid rate code and if driver couldn't handle 0x1b I guess
>> we would have a problem receiving beacons or other management frames
>> sent @ 1Mbit.
>
> In case it matters, most of the warnings are 0x1B, but a few are 0x18
> and one was 0x19.
>

Also valid rates for b/g ;-)
#define ATH5K_RATE_CODE_5_5M    0x19
#define ATH5K_RATE_CODE_11M     0x18

>
> WPA is definitely doing lots of scans, even with the scan-sharing
> logic enabled.
>
> I'm using latest wireless-testing, and will look for some debug to enable.
>
> I'm not sure we'll have time to set up a sniffer in the near term.
>
> Also, I have a patch in the kernel that allows it to keep from scanning
> channels other than the current channel as long as one interface
> is associated.  This still tends to cause the off-channel/on-channel
> logic to happen, as the scan core logic isn't smart enough to figure
> out it isn't really leaving channels to scan..but at least it shouldn't
> be walking to different bands.  Of course, maybe no VIFs are
> associated when this happened, or something managed to request
> a full scan.
>
>
> Thanks,
> Ben
>

At least try skipping 11a on ath5k_setup_bands, just comment out the 11a part...



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
