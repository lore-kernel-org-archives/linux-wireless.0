Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54914 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab0LBETj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 23:19:39 -0500
Received: by wyb28 with SMTP id 28so7748968wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 20:19:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CF6EE43.2020905@candelatech.com>
References: <4CF6ED18.5010704@candelatech.com>
	<4CF6EE43.2020905@candelatech.com>
Date: Thu, 2 Dec 2010 06:19:36 +0200
Message-ID: <AANLkTi=tRagv2dC8Vh3kQz1CFifPXOB3wNdhvGGziOSE@mail.gmail.com>
Subject: Re: ath5k: invalid hw_rix with 64 stations.
From: Nick Kossifidis <mickflemm@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/2 Ben Greear <greearb@candelatech.com>:
> On 12/01/2010 04:49 PM, Ben Greear wrote:
>>
>> We were testing with 64 virtual stations running WPA, with
>> a single instance of supplicant controlling all interfaces and
>> the scan-sharing enabled. It was running clean w/out encryption
>> (and w/out supplicant).
>>
>> We see a large number of these types of warnings. We had a proprietary
>> module loaded, but it was not in active use. We're going to reproduce
>> without it, but in the meantime, here is a representative trace:
>
> Here's another one from a non-tainted kernel.  Seems this is trivial
> to reproduce.
>
> ------------[ cut here ]------------
> WARNING: at
> /home/greearb/git/linux.wireless-testing-ct/drivers/net/wireless/ath/ath5k/base.c:620
> ath5k_hw_to_driver_rix+0x5b/0x5f [ath5k]()
> Hardware name:
> invalid hw_rix: 1b
> Modules linked in: 8021q garp stp llc fuse michael_mic macvlan pktgen
> w83627hf hwmon_vid hwmon nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6
> dm_multipath uinput arc4 ecb ath5k ath mac80211 cfg80211 e1000e i2c_i801
> e100 i2c_core output serio_raw pcspkr mii iTCO_wdt iTCO_vendor_support
> ata_generic pata_acpi [last unloaded: ipt_addrtype]
> Pid: 1225, comm: rsyslogd Tainted: G        W   2.6.37-rc4-wl+ #9
> Call Trace:
>  [<8043144d>] warn_slowpath_common+0x77/0x8c
>  [<f8663994>] ? ath5k_hw_to_driver_rix+0x5b/0x5f [ath5k]
>  [<f8663994>] ? ath5k_hw_to_driver_rix+0x5b/0x5f [ath5k]
>  [<804314de>] warn_slowpath_fmt+0x2e/0x30
>  [<f8663994>] ath5k_hw_to_driver_rix+0x5b/0x5f [ath5k]
>  [<f8663ba5>] ath5k_tasklet_tx+0x1ab/0x2f0 [ath5k]
>  [<80435948>] tasklet_action+0x78/0xc1
>  [<80436034>] __do_softirq+0x75/0x121
>  [<80435fbf>] ? __do_softirq+0x0/0x121
>  <IRQ>  [<80435f0c>] ? irq_exit+0x29/0x5d
>  [<804042c9>] ? do_IRQ+0x8e/0xa2
>  [<80403729>] ? common_interrupt+0x29/0x30
>  [<8044007b>] ? __queue_work+0x138/0x1af
>  [<804b8e53>] ? mntput+0x0/0x15
>  [<804b8fb1>] ? path_put+0x15/0x18
>  [<8046b551>] ? audit_free_names+0x40/0x59
>  [<8046b6fe>] ? audit_syscall_exit+0x91/0x10f
>  [<804031d0>] ? sysexit_audit+0x24/0x44
> ---[ end trace e87e98eb2549568d ]---
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>

That's a weird one, I've seen it again sometimes but couldn't
reproduce it easily to debug it...

#define ATH5K_RATE_CODE_1M      0x1B
is not an invalid rate code and if driver couldn't handle 0x1b I guess
we would have a problem receiving beacons or other management frames
sent @ 1Mbit.

Maybe there is a case when switching bands (eg. when we scan), when we
switch from b/g to a in sw but hw has still a frame from b/g with a b
rate code on its descriptor (eg. a beacon). Since b rates are not
available on a band ath5k_hw_to_driver_rix will not be able to handle
it since during ath5k_setup_rate_idx we set up rate_idx per band and
ath5k_hw_to_driver_rix blindly uses sc->curband->band.

I think since we know on ath5k_receive_frame the frequency, we should
check it and not blindly set rxs->band to sc->curband->band, we should
then pass the correct band to ath5k_hw_to_driver_rix.

Also on tx we can have the same problem when we send a frame while on
b/g band, switch bands on sw and frame is sent afterwards so again
when we try to process tx status descriptor through
ath5k_tx_frame_completed we 'll hit the same error on
ath5k_hw_to_driver_rix. Unfortunately tx status descriptor doesn't
provide us with frequency so I guess we should use 0 in case we get
this error or find another workaround.

It's weird because when we switch channels through ath5k_hw_reset we
wait for tx/rx dma to stop (also on synth-only channel change) and if
they don't we reset pcu/dma unit so there shouldn't be any pending
frames and even if there are they should get dropped (well there is
nothing on documentation for that i think, they might just stay on
some buffer, we just assume they get dropped). Maybe when a tx queue
is stuck (and the beacon queue is known to get stuck sometimes -and
beacons are @1Mbit-) it gets unstuck after reset and frame gets out
(on the new channel of course).

Just out of curiosity can you check for malformed tx packets, packets
that are received on a 2.4Ghz channel and on the header they say they
are on a 5GHz channel or the opposite ? Try sniffing on channel 1, the
first 5GHz channel available and your AP's channel. Also i introduced
a debug level for DMA start/stop in one of my patches, in case you use
them, can you please enable it so that we can see what goes on ? If
you don't can you at least enable ATH5K_DEBUG_XMIT ?

Also can you try using a b/g only card or skip a band on ath5k_setup_bands ?

I know it doesn't make much sense why it gets triggered when you use
encryption (hw or sw encryption btw ?), maybe sw acts more slowly or
something, or wpa_supplicant does some extra scans...

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
