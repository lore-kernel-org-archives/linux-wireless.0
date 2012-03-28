Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58708 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104Ab2C1Tpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 15:45:38 -0400
Message-ID: <4F736A5A.4030408@candelatech.com> (sfid-20120328_214543_245678_84D86D4A)
Date: Wed, 28 Mar 2012 12:45:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Bryan Phillippe <Bryan.Phillippe@watchguard.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bss_info_change_notify warning (hacked 3.3.0-rc5+)
References: <4F57B7E6.1050103@candelatech.com>   <D6CE340A-7CE4-42DA-B1C3-4137C1D13BFF@watchguard.com>   <4F735EF5.3010708@candelatech.com>  <1332961193.3479.40.camel@jlt3.sipsolutions.net>  <4F73620D.507@candelatech.com> <1332962004.3479.42.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332962004.3479.42.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2012 12:13 PM, Johannes Berg wrote:
> On Wed, 2012-03-28 at 12:10 -0700, Ben Greear wrote:
>> On 03/28/2012 11:59 AM, Johannes Berg wrote:

>>> Hm. Maybe this is the problem?
>>>
>>> http://p.sipsolutions.net/d432de678ae3ff17.txt
>>
>> I don't see any code that matches that in 3.3.0 (nothing with nl80211_start_ap, for instance)
>
> ah, well, it's set_beacon there or so
>
> johannes


I tried this patch, but it still spews (see below)

[greearb@build-32 mac80211]$ git diff
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 56a363f..c4f5f82 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6313,7 +6313,7 @@ static struct genl_ops nl80211_ops[] = {
                 .policy = nl80211_policy,
                 .flags = GENL_ADMIN_PERM,
                 .doit = nl80211_addset_beacon,
-               .internal_flags = NL80211_FLAG_NEED_NETDEV |
+               .internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
                                   NL80211_FLAG_NEED_RTNL,
         },
         {
@@ -6321,7 +6321,7 @@ static struct genl_ops nl80211_ops[] = {
                 .policy = nl80211_policy,
                 .flags = GENL_ADMIN_PERM,
                 .doit = nl80211_addset_beacon,
-               .internal_flags = NL80211_FLAG_NEED_NETDEV |
+               .internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
                                   NL80211_FLAG_NEED_RTNL,
         },
         {



ieee80211 wiphy0: device now idle
ADDRCONF(NETDEV_UP): wlan0: link is not ready
cfg80211: Calling CRDA for country: US
cfg80211: Regulatory domain changed to country: US
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
ADDRCONF(NETDEV_UP): wlan0: link is not ready
ADDRCONF(NETDEV_UP): sta1: link is not ready
ADDRCONF(NETDEV_UP): sta1: link is not ready
ADDRCONF(NETDEV_UP): sta0: link is not ready
ADDRCONF(NETDEV_UP): sta0: link is not ready
ADDRCONF(NETDEV_UP): sta4: link is not ready
ADDRCONF(NETDEV_UP): sta4: link is not ready
ADDRCONF(NETDEV_UP): sta3: link is not ready
ADDRCONF(NETDEV_UP): sta3: link is not ready
ADDRCONF(NETDEV_UP): sta2: link is not ready
ADDRCONF(NETDEV_UP): sta2: link is not ready
ieee80211 wiphy0: device no longer idle - in use
ieee80211 wiphy0: device now idle
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.3.dev.y/net/mac80211/driver-ops.h:12 check_sdata_in_driver+0x26/0x2b [mac80211]()
Hardware name: To Be Filled By O.E.M.
vap0:  Failed check-sdata-in-driver check, flags: 0x0
Modules linked in: ath5k arc4 ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 xt_CT iptable_raw 8021q garp stp llc macvlan wanlink(PO) pktgen fuse w83627ehf 
hwmon_vid coretemp hwmon nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 uinput snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq 
snd_seq_device snd_pcm microcode iTCO_wdt pcspkr i2c_i801 serio_raw iTCO_vendor_support snd_timer r8169 snd soundcore mii snd_page_alloc i915 drm_kms_helper drm 
i2c_algo_bit video [last unloaded: arc4]
Pid: 7307, comm: hostapd Tainted: P        W  O 3.3.0+ #41
Call Trace:
  [<c04263d1>] warn_slowpath_common+0x65/0x7a
  [<f96a28d1>] ? check_sdata_in_driver+0x26/0x2b [mac80211]
  [<c042644a>] warn_slowpath_fmt+0x26/0x2a
  [<f96a28d1>] check_sdata_in_driver+0x26/0x2b [mac80211]
  [<f96a3438>] ieee80211_set_txq_params+0x97/0xec [mac80211]
  [<c059edb5>] ? nla_parse+0x3f/0x98
  [<f9556c74>] nl80211_set_wiphy+0x1cb/0x4ba [cfg80211]
  [<c07264ef>] genl_rcv_msg+0x1ce/0x200
  [<c0726321>] ? genl_rcv+0x22/0x22
  [<c0725567>] netlink_rcv_skb+0x30/0x76
  [<c072631a>] genl_rcv+0x1b/0x22
  [<c07253a3>] netlink_unicast+0xc1/0x11c
  [<c07259fe>] netlink_sendmsg+0x1d2/0x1ea
  [<c06fe57e>] __sock_sendmsg_nosec+0x4a/0x52
  [<c06fe5b0>] __sock_sendmsg+0x2a/0x33
  [<c06fead5>] sock_sendmsg+0x93/0xa7
  [<c06fead5>] ? sock_sendmsg+0x93/0xa7
  [<c0488b26>] ? __generic_file_aio_write+0x24c/0x27d
  [<c05945bd>] ? _copy_from_user+0x31/0x118
  [<c07069ec>] ? copy_from_user+0x8/0xa
  [<c0706ce6>] ? verify_iovec+0x3e/0x78
  [<c06ff4ea>] __sys_sendmsg+0x18d/0x20b
  [<c070b265>] ? dev_name_hash+0x1e/0x31
  [<c05944b6>] ? copy_to_user+0x2f/0x105
  [<c070e88a>] ? dev_ioctl+0x417/0x56a
  [<c04b19ea>] ? kmem_cache_alloc+0x24/0x99
  [<c0702e39>] ? sk_prot_alloc+0x23/0xd1
  [<c07a9164>] ? _raw_spin_unlock+0x8/0xa
  [<c06fe0df>] ? sock_destroy_inode+0x23/0x26
  [<c06fe0df>] ? sock_destroy_inode+0x23/0x26
  [<c04ccd36>] ? __d_free+0x3c/0x3f
  [<c04ccd36>] ? __d_free+0x3c/0x3f
  [<c06ff667>] sys_sendmsg+0x2b/0x43
  [<c070053e>] sys_socketcall+0x16a/0x1d4
  [<c0471d68>] ? __audit_syscall_exit+0x102/0x117
  [<c07adb58>] sysenter_do_call+0x12/0x28
---[ end trace dec15cdc90696e7d ]---


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

