Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57402 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933814Ab3BSXYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 18:24:37 -0500
Message-ID: <512409B1.7090800@candelatech.com> (sfid-20130220_002440_751673_4E93B2BD)
Date: Tue, 19 Feb 2013 15:24:33 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Crash on removal of 400 interfaces (3.7.6+)
References: <5122A7C7.3070508@candelatech.com>  (sfid-20130218_231436_933191_3F8FE600) <1361225773.8555.50.camel@jlt4.sipsolutions.net> <51240249.6060801@candelatech.com>
In-Reply-To: <51240249.6060801@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2013 02:52 PM, Ben Greear wrote:
> On 02/18/2013 02:16 PM, Johannes Berg wrote:
>> On Mon, 2013-02-18 at 14:14 -0800, Ben Greear wrote:
>>> We often see crashes in work-queue processing when deleting
>>> lots of wifi station interfaces.  I'm guessing that there is probably
>>> a work item that was not properly un-registered before deleting
>>> memory.  I have backported some wifi fixes from upstream, so
>>> maybe they are to blame, but in case anyone has any suggestions
>>> for places to look, please let me know.
>>
>> Enable CONFIG_DEBUG_OBJECTS and CONFIG_DEBUG_OBJECTS_WORK :)
>
> That did not catch anything.

Ahh, enabled a bunch more debugging options, and got this:

sta40: deauthenticating from 00:88:aa:88:aa:88 by local choice (reason=3)
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.7.dev.y/lib/debugobjects.c:261 debug_print_object+0x7c/0x8d()
Hardware name: To be filled by O.E.M.
ODEBUG: free active (active state 0) object type: work_struct hint: ieee80211_sta_monitor_work+0x0/0x14 [mac80211]
Modules linked in: nf_nat_ipv4 nf_nat 8021q garp stp llc macvlan pktgen lockd sunrpc f71882fg iTCO_wdt iTCO_vendor_support coretemp gpio_ich hwmon mperf kvm 
cdc_acm snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep microcode snd_seq snd_seq_device serio_raw pcspkr snd_pcm ath9k ath9k_common ath9k_hw ath 
i2c_i801 ppdev mac80211 lpc_ich cfg80211 snd_page_alloc e1000e snd_timer snd soundcore parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm 
i2c_core [last unloaded: iptable_nat]
Pid: 14743, comm: iw Tainted: G         C O 3.7.9+ #11
Call Trace:
  [<ffffffff81087ef8>] warn_slowpath_common+0x80/0x98
  [<ffffffff81087fa4>] warn_slowpath_fmt+0x41/0x43
  [<ffffffff812a2608>] debug_print_object+0x7c/0x8d
  [<ffffffffa025f5ad>] ? ieee80211_beacon_connection_loss_work+0x88/0x88 [mac80211]
  [<ffffffff812a2b9a>] ? debug_check_no_obj_freed+0x65/0x1c3
  [<ffffffff812a2bca>] debug_check_no_obj_freed+0x95/0x1c3
  [<ffffffff8149f465>] ? netdev_release+0x39/0x3e
  [<ffffffff8114cc69>] slab_free_hook+0x70/0x79
  [<ffffffff8114ea3e>] kfree+0x62/0xb7
  [<ffffffff8149f465>] netdev_release+0x39/0x3e
  [<ffffffff8136ad67>] device_release+0x52/0x8a
  [<ffffffff812937db>] kobject_release+0x121/0x158
  [<ffffffff81293612>] kobject_put+0x4c/0x50
  [<ffffffff8148f0d7>] netdev_run_todo+0x25c/0x27e
  [<ffffffff8149b2a0>] rtnl_unlock+0x9/0xb
  [<ffffffffa01d31a7>] nl80211_post_doit+0x49/0x4e [cfg80211]
  [<ffffffff814b0928>] genl_rcv_msg+0x25b/0x288
  [<ffffffff814b06a3>] ? genl_lock+0x12/0x14
  [<ffffffff814b06cd>] ? genl_rcv+0x28/0x28
  [<ffffffff814aef13>] netlink_rcv_skb+0x3e/0x8f
  [<ffffffff814b06c6>] genl_rcv+0x21/0x28
  [<ffffffff814aecd1>] netlink_unicast+0xe9/0x16f
  [<ffffffff814af4b3>] netlink_sendmsg+0x264/0x282
  [<ffffffff8147d785>] ? rcu_read_unlock+0x5b/0x5d
  [<ffffffff814784ab>] __sock_sendmsg_nosec+0x58/0x61
  [<ffffffff814798e6>] __sock_sendmsg+0x3d/0x48
  [<ffffffff8147995a>] sock_sendmsg+0x69/0x82
  [<ffffffff8112c835>] ? might_fault+0x84/0x8b
  [<ffffffff814849ce>] ? copy_from_user+0x2a/0x2c
  [<ffffffff81484da0>] ? verify_iovec+0x4f/0xa3
  [<ffffffff8147b8e7>] __sys_sendmsg+0x1fe/0x280
  [<ffffffff810a8058>] ? up_read+0x1e/0x36
  [<ffffffff8116ea14>] ? fcheck_files+0xac/0xea
  [<ffffffff8116efd3>] ? fget_light+0x35/0xae
  [<ffffffff8147badb>] sys_sendmsg+0x3d/0x5b
  [<ffffffff815595e9>] system_call_fastpath+0x16/0x1b
---[ end trace 791ff0751a368327 ]---


Will go poke around in the code to see what I can see....


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

