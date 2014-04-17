Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49952 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaDQVgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 17:36:08 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id s3HLa7Yp006305
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2014 14:36:07 -0700
Message-ID: <53504944.1040105@candelatech.com> (sfid-20140417_233613_534616_67AD58F0)
Date: Thu, 17 Apr 2014 14:36:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Scan related crash in hacked 3.14.0 kernel.
References: <535045F4.3050609@candelatech.com>
In-Reply-To: <535045F4.3050609@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2014 02:21 PM, Ben Greear wrote:
> This kernel is larded up with a fair amount of my patches, so it
> could be my bug.  But, in case someone sees something similar,
> here's my crash:

Ahhh, a bit further up in the logs I notice my ath10k has decided
firmware is hung and so it's resetting itself...that is likely
the case of this..will go poke around there...

Ben

> 
> It hit this BUG_ON in core.h:
> 
> 
> static inline
> struct cfg80211_registered_device *wiphy_to_dev(struct wiphy *wiphy)
> {
> 	BUG_ON(!wiphy);
> 	return container_of(wiphy, struct cfg80211_registered_device, wiphy);
> }
> 
> 
> Test system was 32 ath10k stations, and I had just rebooted the AP
> machine...
> 
> 
> ------------[ cut here ]------------
> kernel BUG at /mnt/sda/home/greearb/git/linux-3.14.dev.y/net/wireless/core.h:91!
> invalid opcode: 0000 [#1] PREEMPT SMP
> Modules linked in: ath10k_pci ath10k_core ath5k ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nf_nat_ipv4 nf_nat]
> CPU: 3 PID: 9663 Comm: kworker/u8:2 Tainted: G        WC O 3.14.0+ #17
> Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
> ath10k: Creating vdev id: 17  map: 3230793728
> ath10k: mac vdev create 17 (add interface) type 2 subtype 0
> ath10k: ep 2 used 1 credits, remaining 5 dbg 1896910865 (0x71109011)
> ath10k: ep 2 used 1 credits, remaining 4 dbg 1896910874 (0x7110901a)
> ath10k: ep 2 used 1 credits, remaining 3 dbg 1896910896 (0x71109030)
> ath10k: ep 2 used 1 credits, remaining 2 dbg 1896910896 (0x71109030)
> ath10k: ep 2 used 1 credits, remaining 1 dbg 1896910896 (0x71109030)
> ath10k: ep 2 used 1 credits, remaining 0 dbg 1896910874 (0x7110901a)
> ath10k: ep 2 got 1 credits tot 1
> ath10k: ep 2 used 1 credits, remaining 0 dbg 1896910874 (0x7110901a)
> ath10k: mac vdev 17 cts_prot 0
> ath10k: ep 2 got 5 credits tot 5
> ath10k: ep 2 got 1 credits tot 6
> ath10k: ep 2 used 1 credits, remaining 5 dbg 1896910874 (0x7110901a)
> ath10k: mac vdev 17 slot_time 1
> ath10k: ep 2 used 1 credits, remaining 4 dbg 1896910874 (0x7110901a)
> ath10k: mac vdev 17 preamble 1n
> ath10k: ep 2 used 1 credits, remaining 3 dbg 1896910874 (0x7110901a)
> ath10k: ep 2 used 1 credits, remaining 2 dbg 1896910857 (0x71109009)
> ath10k: ep 2 used 1 credits, remaining 1 dbg 1896910896 (0x71109030)
> ath10k: ep 2 used 1 credits, remaining 0 dbg 1896910896 (0x71109030)
> ath10k: ep 2 got 1 credits tot 1
> ath10k: ep 2 used 1 credits, remaining 0 dbg 1896910857 (0x71109009)
> ath10k: ep 2 got 6 credits tot 6
> ath10k: ep 2 used 1 credits, remaining 5 dbg 1896910896 (0x71109030)
> ath10k: ep 2 used 1 credits, remaining 4 dbg 1896910896 (0x71109030)
> ath10k: ep 2 used 1 credits, remaining 3 dbg 1896910857 (0x71109009)
> ath10k: ep 2 used 1 credits, remaining 2 dbg 1896910896 (0x71109030)
> ath10k: ep 2 used 1 credits, remaining 1 dbg 1896910896 (0x71109030)
> ath10k: ep 2 used 1 credits, remaining 0 dbg 1896910857 (0x71109009)
> ath10k: ep 2 got 1 credits tot 1
> ath10k: ep 2 used 1 credits, remaining 0 dbg 1896910896 (0x71109030)
> ath10k: ep 2 got 6 credits tot 6
> ath10k: ep 2 used 1 credits, remaining 5 dbg 1896910896 (0x71109030)
> ath10k: ep 2 got 1 credits tot 6
> IPv6: ADDRCONF(NETDEV_UP): sta217: link is not ready
> Workqueue: phy1 ieee80211_scan_work [mac80211]
> task: ffff88021622c2a0 ti: ffff8800d579e000 task.ti: ffff8800d579e000
> RIP: 0010:[<ffffffffa0bbb15a>]  [<ffffffffa0bbb15a>] wiphy_to_dev+0x9/0x14 [cfg80211]
> RSP: 0018:ffff8800d579fce8  EFLAGS: 00010246
> RAX: ffff8800d4849401 RBX: ffff880214b96000 RCX: 000000018010000e
> RDX: 000000018010000f RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff8800d579fce8 R08: 0000000000000006 R09: ffffffffa0bfb868
> R10: ffffffffa0bfb868 R11: 0000000000000000 R12: ffff8800d54ea500
> R13: ffff8800d5480a01 R14: 0000000000000022 R15: ffff8800d54ea4a8
> FS:  0000000000000000(0000) GS:ffff88021fb80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000003a59154cc5 CR3: 0000000001a0d000 CR4: 00000000000407e0
> Stack:
>  ffff8800d579fd08 ffffffffa0bbb604 ffff8800d54e88c0 ffff8800d54ea500
>  ffff8800d579fd38 ffffffffa0bfacd6 ffff8800d54e88c0 ffff8800d54ea578
>  ffff8800d5480a80 ffff8800d54ea420 ffff8800d579fd98 ffffffffa0bfbc27
> Call Trace:
>  [<ffffffffa0bbb604>] cfg80211_scan_done+0x16/0x5e [cfg80211]
>  [<ffffffffa0bfacd6>] __ieee80211_scan_completed+0xec/0x1c8 [mac80211]
>  [<ffffffffa0bfbc27>] ieee80211_scan_work+0x3fa/0x411 [mac80211]
>  [<ffffffff810d7a9e>] process_one_work+0x1cb/0x2ee
>  [<ffffffff810d7a33>] ? process_one_work+0x160/0x2ee
>  [<ffffffff810d4e95>] ? spin_lock_irq+0x9/0xb
>  [<ffffffff810d7f95>] worker_thread+0x12f/0x1fd
>  [<ffffffff810d7e66>] ? rescuer_thread+0x27b/0x27b
>  [<ffffffff810d7e66>] ? rescuer_thread+0x27b/0x27b
>  [<ffffffff810dd251>] kthread+0xc4/0xcc
>  [<ffffffff810dd18d>] ? __kthread_parkme+0x5c/0x5c
>  [<ffffffff815dabcc>] ret_from_fork+0x7c/0xb0
> 
> Thanks,
> Ben
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

