Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56151 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab2CJAw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 19:52:57 -0500
Message-ID: <4F5A4C83.50009@candelatech.com> (sfid-20120310_015307_343761_4AAD4320)
Date: Fri, 09 Mar 2012 10:31:31 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bss_info_change_notify warning (hacked 3.3.0-rc5+)
References: <4F57B7E6.1050103@candelatech.com>  (sfid-20120307_203301_816701_DF7D4715) <1331189709.3446.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331189709.3446.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2012 10:55 PM, Johannes Berg wrote:
> On Wed, 2012-03-07 at 11:32 -0800, Ben Greear wrote:
>> This is with a somewhat hacked 3.3.0-rc5+.  Just
>> curious if this is a known problem.
>>
>>
>> Seems very reproducible on my system.
>>
>>
>> WARNING: at /home/greearb/git/linux-3.3.dev.y/net/mac80211/driver-ops.h:10 ieee80211_bss_info_change_noti)
>
> The warning means you're modifying an interface the driver doesn't (yet)
> know about.
>
> It's odd that you should be running into this on config_beacon() though
> since that can only execute when the interface is up ... can you print
> out the interface name in the warning?

This is still reproducible in 3.3.0-rc6+ from yesterday.


I create the VAP with this command:

./local/sbin/iw phy wiphy0 interface add vap0 type __ap


vap0:  Failed check-sdata-in-driver check, flags: 0x0
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.3.dev.y/net/mac80211/driver-ops.h:13 check_sdata_in_driver+0x35/0x3)
Hardware name: To be filled by O.E.M.
Modules linked in: 8021q garp stp llc macvlan wanlink(PO) pktgen lockd joydev ppdev arc4 snd_hda_codec_re]
Pid: 3081, comm: hostapd Tainted: P        WC O 3.3.0-rc6+ #7
Call Trace:
  [<ffffffff81036f45>] warn_slowpath_common+0x80/0x98
  [<ffffffff81036f72>] warn_slowpath_null+0x15/0x17
  [<ffffffffa025b503>] check_sdata_in_driver+0x35/0x37 [mac80211]
  [<ffffffffa025bfcd>] ieee80211_set_txq_params+0x91/0xf4 [mac80211]
  [<ffffffffa019eaf9>] nl80211_set_wiphy+0x1f2/0x500 [cfg80211]
  [<ffffffff81447a9e>] ? __mutex_lock_slowpath+0x16/0x18
  [<ffffffffa00703ff>] ? i915_restore_palette+0x93/0xdd [i915]
  [<ffffffff813b5c00>] genl_rcv_msg+0x1f4/0x239
  [<ffffffff813b5a0c>] ? genl_rcv+0x28/0x28
  [<ffffffff813b4a2e>] netlink_rcv_skb+0x3e/0x8f
  [<ffffffff813b5a05>] genl_rcv+0x21/0x28
  [<ffffffff813b4809>] netlink_unicast+0xe9/0x152
  [<ffffffff813b4f62>] netlink_sendmsg+0x1f8/0x216
  [<ffffffff81384202>] __sock_sendmsg_nosec+0x5f/0x6a
  [<ffffffff8138424a>] __sock_sendmsg+0x3d/0x48
  [<ffffffff81384aea>] sock_sendmsg+0xa3/0xbc
  [<ffffffff810a81f7>] ? unlock_page+0x25/0x2a
  [<ffffffff810c2a40>] ? __do_fault+0x373/0x3b6
  [<ffffffff81383c48>] ? copy_from_user+0x9/0xb
  [<ffffffff81384792>] ? move_addr_to_kernel+0x2b/0x65
  [<ffffffff8138e9e9>] ? copy_from_user+0x9/0xb
  [<ffffffff8138ed36>] ? verify_iovec+0x4f/0xa3
  [<ffffffff8138524c>] __sys_sendmsg+0x20f/0x29c
  [<ffffffff81383799>] ? sock_destroy_inode+0x2e/0x32
  [<ffffffff8110503b>] ? destroy_inode+0x3b/0x54
  [<ffffffff810dec6f>] ? virt_to_head_page+0x9/0x2c
  [<ffffffff810e0e73>] ? kmem_cache_free+0x15/0x6e
  [<ffffffff8144c782>] ? sub_preempt_count+0x92/0xa6
  [<ffffffff81108894>] ? vfsmount_lock_local_unlock+0x46/0x53
  [<ffffffff8110934e>] ? mntput_no_expire+0x31/0x104
  [<ffffffff81109446>] ? mntput+0x25/0x27
  [<ffffffff81385436>] sys_sendmsg+0x3d/0x5b
  [<ffffffff8144e4f9>] system_call_fastpath+0x16/0x1b
---[ end trace 54cbe076448eb2c8 ]---

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

