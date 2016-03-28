Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52743 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbcC1SZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2016 14:25:30 -0400
Subject: Re: hashing error in hacked 4.4.6+ kernel.
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <56F5DE21.9050601@candelatech.com>
 <1459020054.8901.8.camel@sipsolutions.net> <56F6E81C.5050309@candelatech.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56F97718.4080407@candelatech.com> (sfid-20160328_202534_633677_2A58840B)
Date: Mon, 28 Mar 2016 11:25:28 -0700
MIME-Version: 1.0
In-Reply-To: <56F6E81C.5050309@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, it appears at least part of the problem is that the station is not
added to the hash to begin with, and existing code does not check for that failure
or deal with it.  I added a check and I see this below.

That -16 value means EBUSY from what I can tell, because two rehashes
are scheduled at once (see hashtable_insert_rehash)

What we can do to protect against this?


ath10k_pci 0000:05:00.0: ATH10K_END
ath10k_pci 0000:05:00.0: Unknown eventid: 36898
sta10: 04:f0:21:db:c8:d1 authenticate with 04:f0:21:f6:85:1c at: 1459188823.781974
------------[ cut here ]------------
WARNING: CPU: 2 PID: 3114 at /home/greearb/git/linux-4.4.dev.y/net/mac80211/sta_info.c:327 sta_info_insert_finish+0x2d1/0x6da [mac80211]()
Modules linked in: nf_conntrack_netlink nf_conntrack nfnetlink nf_defrag_ipv4 8021q garp mrp stp llc bnep bluetooth fuse macvlan wanlink(O) pktgen 
rpcsec_gss_krb5 nfsv4 nfs fscache iTCO_wdt iTCO_vendor_support coretemp ath9k hwmon ath10k_pci intel_rapl iosf_mbi ath9k_common ath10k_core ath9k_hw 
x86_pkg_temp_thermal intel_powerclamp kvm_intel ath joydev kvm mac80211 irqbypass serio_raw pcspkr cfg80211 snd_hda_codec_hdmi lpc_ich i2c_i801 
snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm 8250_fintek snd_timer snd shpchp 
soundcore tpm_tis tpm nfsd auth_rpcgss nfs_acl lockd grace sunrpc ata_generic pata_acpi e1000e ptp i915 i2c_algo_bit pps_core drm_kms_helper drm i2c_core video 
fjes ipv6 [last unloaded: nf_conntrack]
CPU: 0 PID: 3114 Comm: wpa_supplicant Tainted: G        W  O    4.4.6+ #21
Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
ath10k_pci 0000:05:00.0: ath10k_pci ATH10K_DBG_BUFFER:
ath10k: [0000]: 000092F4 07FC4C02 00000001 000092F4 07FC4C02 00000001 000092FF 082C3812
ath10k: [0008]: 000F5C2C 0042507C 000092FF 102C3809 0000143C 00000001 00000000 00000000
ath10k: [0016]: 00009348 17FC5823 004402E0 851C0000 00000000 00000040 00000001 0000934A
ath10k: [0024]: 17FC4C01 0F00851C 0000000A 06003007 0000FFAA FFFFFFFF 0000934B 17FC4C01
ath10k: [0032]: 71108880 00000000 00C400BF 00000000 00000FF0 0000934B 17FC4C01 71108880
ath10k: [0040]: 00010000 00C400BF 00000000 FFFFFFFF 0000934B 17FC4C01 71108880 00020000
ath10k: [0048]: 00C400BF 00000000 FFFFFFFF 0000934B 17FC4C01 71108880 00030000 00C400BF
ath10k: [0056]: 000000FF FFFFFFFF 0000934B 17FC4C01 71108880 00040000 00C400BF 000000FF
ath10k: [0064]: FFFFFFFF 0000934B 17FC4C01 71108880 00050000 00C400BF 000000FF FBFFFFFF
ath10k_pci 0000:05:00.0: ATH10K_END
  0000000000000000 ffff8801fee5b490 ffffffff8137086d 0000000000000000
  0000000000000009 ffff8801fee5b4c8 ffffffff810ee1eb ffffffffa07d4519
  ffff8800d5350a60 00000000fffffff0 ffff8801ff330000 ffff8800cec6ca40
Call Trace:
  [<ffffffff8137086d>] dump_stack+0x81/0xb6
  [<ffffffff810ee1eb>] warn_slowpath_common+0x94/0xad
  [<ffffffffa07d4519>] ? sta_info_insert_finish+0x2d1/0x6da [mac80211]
  [<ffffffff810ee2a8>] warn_slowpath_null+0x15/0x17
  [<ffffffffa07d4519>] sta_info_insert_finish+0x2d1/0x6da [mac80211]
  [<ffffffff81144bb6>] ? rcu_read_lock_sched_held+0x54/0x5c
  [<ffffffffa0e6cff5>] ? ath10k_dbg_dump+0x1cc/0x259 [ath10k_core]
  [<ffffffff8112dda4>] ? __lock_acquire+0x641/0xde7
  [<ffffffffa0f53608>] ? ath10k_pci_hif_tx_sg+0x48/0x1b7 [ath10k_pci]
  [<ffffffff8112b2a9>] ? __lock_is_held+0x3c/0x57
  [<ffffffff8112d0d0>] ? mark_lock+0x24/0x201
  [<ffffffff8112d30b>] ? mark_held_locks+0x5e/0x74
  [<ffffffff810f23a8>] ? __local_bh_enable_ip+0x9f/0xb9
  [<ffffffff8112d490>] ? trace_hardirqs_on_caller+0x16f/0x18b
  [<ffffffffa0f53742>] ? ath10k_pci_hif_tx_sg+0x182/0x1b7 [ath10k_pci]
  [<ffffffff8112d4b9>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff810f23ad>] ? __local_bh_enable_ip+0xa4/0xb9
  [<ffffffff8112d0d0>] ? mark_lock+0x24/0x201
  [<ffffffff8112dda4>] ? __lock_acquire+0x641/0xde7
  [<ffffffffa07d5204>] ? sta_info_insert_rcu+0xa0/0xb7 [mac80211]
  [<ffffffff8112b2a9>] ? __lock_is_held+0x3c/0x57
  [<ffffffff8112b30d>] ? lock_is_held+0x49/0x50
  [<ffffffff8112b2a9>] ? __lock_is_held+0x3c/0x57
  [<ffffffff8112d0d0>] ? mark_lock+0x24/0x201
  [<ffffffff8112d30b>] ? mark_held_locks+0x5e/0x74
  [<ffffffff816f7131>] ? mutex_lock_nested+0x32e/0x3cf
  [<ffffffff8112d490>] ? trace_hardirqs_on_caller+0x16f/0x18b
  [<ffffffff816f7139>] ? mutex_lock_nested+0x336/0x3cf
  [<ffffffffa07d5204>] ? sta_info_insert_rcu+0xa0/0xb7 [mac80211]
  [<ffffffff8110f621>] ? ___might_sleep+0xc8/0x1ba
  [<ffffffffa07d520c>] sta_info_insert_rcu+0xa8/0xb7 [mac80211]
  [<ffffffffa07d5225>] sta_info_insert+0xa/0x17 [mac80211]
  [<ffffffffa0817630>] ieee80211_prep_connection+0x743/0x78e [mac80211]
  [<ffffffffa081c02c>] ieee80211_mgd_auth+0x20f/0x2cd [mac80211]
  [<ffffffffa05b67e5>] ? cfg80211_get_bss+0x26d/0x2ec [cfg80211]
  [<ffffffff8112b2a9>] ? __lock_is_held+0x3c/0x57
  [<ffffffffa07eae2a>] ieee80211_auth+0x13/0x15 [mac80211]
  [<ffffffffa05d334d>] cfg80211_mlme_auth+0x1d8/0x277 [cfg80211]
  [<ffffffffa05c96d2>] nl80211_authenticate+0x25b/0x283 [cfg80211]
  [<ffffffff8166ac78>] genl_family_rcv_msg+0x23a/0x28a
  [<ffffffff8166ad07>] genl_rcv_msg+0x3f/0x58
  [<ffffffff8166acc8>] ? genl_family_rcv_msg+0x28a/0x28a
  [<ffffffff81669293>] netlink_rcv_skb+0x45/0x89
  [<ffffffff816698db>] genl_rcv+0x23/0x32
  [<ffffffff81668c0a>] netlink_unicast+0xdc/0x154
  [<ffffffff8166913d>] netlink_sendmsg+0x4bb/0x4d2
  [<ffffffff8162477d>] sock_sendmsg+0x2e/0x3f
  [<ffffffff81625095>] ___sys_sendmsg+0x1bb/0x253
  [<ffffffff81152de0>] ? current_kernel_time64+0xb/0x31
  [<ffffffff8112eb5c>] ? lock_release+0x1bb/0x3bd
  [<ffffffff8112e928>] ? lock_acquire+0x152/0x1cb
  [<ffffffff8112eb5c>] ? lock_release+0x1bb/0x3bd
  [<ffffffff8112e908>] ? lock_acquire+0x132/0x1cb
  [<ffffffff81152a9c>] ? read_seqcount_begin.constprop.23+0x6b/0x87
  [<ffffffff8112d490>] ? trace_hardirqs_on_caller+0x16f/0x18b
  [<ffffffff81225af1>] ? __fget_light+0x48/0x6c
  [<ffffffff81625403>] __sys_sendmsg+0x3d/0x5b
  [<ffffffff81625403>] ? __sys_sendmsg+0x3d/0x5b
  [<ffffffff8162542e>] SyS_sendmsg+0xd/0x17
  [<ffffffff816fa736>] entry_SYSCALL_64_fastpath+0x16/0x7a
---[ end trace 6a7a92839dd92121 ]---
info-hash-add, rv: -16 addr: 04:f0:21:f6:85:1c
sta10: send auth to 04:f0:21:f6:85:1c (try 1/3) at: 1459188824.431766
sta10: authenticated at: 1459188824.440810
ath10k_pci 0000:05:00.0: band: 1  ratemask: 0xff  hw-nss: 4
sta10: associate with 04:f0:21:f6:85:1c (try 1/3)
ath10k_pci 0000:05:00.0: Unknown eventid: 36898
sta10: RX AssocResp from 04:f0:21:f6:85:1c (capab=0x11 status=0 aid=21) at: 1459188824.470288
ath10k_pci 0000:05:00.0: band: 1  ratemask: 0xff  hw-nss: 4
ath10k_pci 0000:05:00.0: Unknown eventid: 36898
IPv6: ADDRCONF(NETDEV_CHANGE): sta10: link becomes ready
sta10: associated at: 1459188824.488553
ath10k_pci 0000:05:00.0: band: 1  ratemask: 0xff  hw-nss: 4
ath10k_pci 0000:05:00.0: band: 1  ratemask: 0xff  hw-nss: 4
ath10k_pci 0000:05:00.0: band: 1  ratemask: 0xff  hw-nss: 4
ath10k_pci 0000:05:00.0: band: 1  ratemask: 0xff  hw-nss: 4
sta13: 04:f0:21:88:43:d1 authenticate with 04:f0:21:f6:85:1c at: 1459188824.508504
ath10k_pci 0000:05:00.0: Unknown eventid: 36898
ath10k_pci 0000:05:00.0: Unknown eventid: 36898
ath10k_pci 0000:05:00.0: Unknown eventid: 36898
....


/* Caller must hold local->sta_mtx */
static void sta_info_hash_add(struct ieee80211_local *local,
			      struct sta_info *sta)
{
	int idx = STA_HASH(sta->sta.addr);
	int rv;

	rv = rhashtable_insert_fast(&local->sta_hash, &sta->hash_node,
				    sta_rht_params);
	WARN_ON(rv);
	pr_err("info-hash-add, rv: %d addr: %pM\n", rv, sta->sta.addr);

	sta->vnext = sta->sdata->sta_vhash[idx];
	rcu_assign_pointer(sta->sdata->sta_vhash[idx], sta);
}


Thanks,
Ben


On 03/26/2016 12:50 PM, Ben Greear wrote:
>
>
> On 03/26/2016 12:20 PM, Johannes Berg wrote:
>> On Fri, 2016-03-25 at 17:56 -0700, Ben Greear wrote:
>>>
>>> Mar 25 17:02:05 ath10k.candelatech.com kernel: sta28:
>>> deauthenticating from 04:f0:21:f6:85:1c by local choice (Reason:
>>> 3=DEAUTH_LEAVING)
>>> Mar 25 17:02:05 ath10k.candelatech.com kernel: ------------[ cut here
>>> ]------------
>>> Mar 25 17:02:05 ath10k.candelatech.com kernel: WARNING: CPU: 2 PID:
>>> 6227 at /home/greearb/git/linux-
>>> 4.4.dev.y/net/mac80211/sta_info.c:921
>>> __sta_info_destroy_part1+0x91/0x422 [mac80211]()
>>
>> In upstream, this warning goes straight to rhashtable not finding the
>> entry.
>>
>> In your code though (looking at the commit introducing it, hoping you
>> didn't change it later), there's considerably more code in
>> sta_info_hash_del() that can return an error. It might be interesting
>> to find out *which* error is happening.
>>
>> I'd agree though, from my brief look at the code it doesn't seem likely
>> that there's a problem with the code you add.
>
> In my current code, I'm always returning whatever the rhashtable returned
> (rv is never actually assigned after that).  I figured that was
> most likely to not introduce bugs.
>
> http://dmz2.candelatech.com/?p=linux-4.4.dev.y/.git;a=summary
>
> or, grab the whole thing for easier looking:
>
> git clone git://dmz2.candelatech.com/linux-4.4.dev.y
>
>> johannes
>>
>> PS: you should probably write "return 0" instead of "return rv"
>> whenever it's clear that "rv" must be 0 :)
>>
>> PPS: why are you not using rhashtable for the vhash?
>
> Err, I was confused by the usage of rhashtable...and I had working
> and tested code that patched in pretty easily.  Since it was not needed
> upstream anyway, that seemed simplest.
>
> Thanks,
> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

