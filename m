Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:39803 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbZGaWrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 18:47:49 -0400
Message-ID: <4A73745F.6040709@redfish-solutions.com>
Date: Fri, 31 Jul 2009 15:46:55 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Ath5k/mac80211 triggers WARN_ON in kernel/softirq.c
References: <200907301631.50780.mb@bu3sch.de> <b6c5339f0907300745l3e7ec63eu9819503c4e7766bb@mail.gmail.com>
In-Reply-To: <b6c5339f0907300745l3e7ec63eu9819503c4e7766bb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Thu, Jul 30, 2009 at 10:31 AM, Michael Buesch<mb@bu3sch.de> wrote:
>   
>> Ath5k from today's compat-wireless triggers the following WARNing
>> on hostapd startup.
>> [ 1669.799870] ------------[ cut here ]------------
>> [ 1669.799934] WARNING: at kernel/softirq.c:141 local_bh_enable_ip+0x8b/0xb0()
>>     
>
> because ath5k calls ieee80211_beacon_get inside a spin_lock_irqsave()
> and this is WARN_ON_ONCE(in_irq() || irqs_disabled).
>
>   
>> [ 1669.799982] Hardware name:
>> [ 1669.800023] Modules linked in: ath5k mac80211 ath cfg80211
>> [ 1669.800192] Pid: 24862, comm: hostapd Not tainted 2.6.30.2 #3
>> [ 1669.800238] Call Trace:
>> [ 1669.800287]  [<ffffffff80248e3b>] ? local_bh_enable_ip+0x8b/0xb0
>> [ 1669.800340]  [<ffffffff802432f8>] warn_slowpath_common+0x78/0xd0
>> [ 1669.800391]  [<ffffffff8024335f>] warn_slowpath_null+0xf/0x20
>> [ 1669.800441]  [<ffffffff80248e3b>] local_bh_enable_ip+0x8b/0xb0
>> [ 1669.800493]  [<ffffffff807e0fef>] _spin_unlock_bh+0xf/0x20
>> [ 1669.800564]  [<ffffffffa0040b92>] ieee80211_beacon_get+0x2c2/0x2d0 [mac80211]
>>     
>
> I guess this is the first victim of spin_lock_bh conversion?
>
>   

I just booted with compat-wireless-2009-07-30 built against 2.6.27.26
and am also seeing:

------------[ cut here ]------------
WARNING: at kernel/softirq.c:136 _local_bh_enable_ip+0x2f/0x7c()
Modules linked in: lm90 hwmon scx200_acb i2c_core bridge stp llc dummy ath5k mac80211 ath cfg80211 rfkill_backport dahdi_dummy dahdi sha512_generic sha256_generic deflate zlib_deflate arc4 ecb sha1_generic blowfish des_generic cbc cryptosoft cryptodev(P) ocf(P) geodewdt geode_rng geode_aes crypto_blkcipher via_rhine rtc
Pid: 1615, comm: hostapd Tainted: P          2.6.27.26-astlinux #1
 [<c0116739>] warn_on_slowpath+0x40/0x63
 [<c0127c01>] hrtimer_forward+0xe2/0xfe
 [<c01ccf78>] rb_insert_color+0x8c/0xad
 [<c0127d69>] enqueue_hrtimer+0xc8/0xd3
 [<c0112014>] calc_delta_fair+0x16/0x24
 [<c0249cd1>] __alloc_skb+0x4b/0x108
 [<d0920dfb>] ieee80211_beacon_add_tim+0x4f/0x111 [mac80211]
 [<c011a194>] _local_bh_enable_ip+0x2f/0x7c
 [<d0921167>] ieee80211_beacon_get+0xe9/0x262 [mac80211]
 [<d08ed5f5>] ath5k_beacon_update+0x2b/0x1a5 [ath5k]
 [<c02a2cfb>] schedule_timeout+0x13/0x8f
 [<d08ef81a>] ath5k_bss_info_changed+0x118/0x16e [ath5k]
 [<d08ef702>] ath5k_bss_info_changed+0x0/0x16e [ath5k]
 [<d091060d>] ieee80211_bss_info_change_notify+0x141/0x151 [mac80211]
 [<d091bc2e>] ieee80211_config_beacon+0x142/0x153 [mac80211]
 [<d091c0b3>] ieee80211_add_beacon+0x0/0x1c [mac80211]
 [<d08ce6ee>] nl80211_addset_beacon+0x13f/0x171 [cfg80211]
 [<c0262915>] genl_rcv_msg+0x13a/0x154
 [<c02627db>] genl_rcv_msg+0x0/0x154
 [<c026073d>] netlink_rcv_skb+0x2d/0x72
 [<c02621c7>] genl_rcv+0x14/0x17
 [<c0260605>] netlink_unicast+0xd1/0x125
 [<c02613fb>] netlink_sendmsg+0x1ee/0x1fb
 [<c02445ec>] __sock_sendmsg+0x20/0x24
 [<c0245331>] sock_sendmsg+0x95/0xad
 [<c0125714>] autoremove_wake_function+0x0/0x2b
 [<c0112014>] calc_delta_fair+0x16/0x24
 [<c0112266>] __dequeue_entity+0x1f/0x71
 [<c013ab79>] page_count+0x8/0x14
 [<c013aca6>] get_pageblock_flags_group+0xf/0x50
 [<c024b551>] verify_iovec+0x3e/0x6d
 [<c02454d6>] sys_sendmsg+0x18d/0x1ed
 [<c0113a7b>] __wake_up+0x1d/0x45
 [<c0113a93>] __wake_up+0x35/0x45
 [<c0113a7b>] __wake_up+0x1d/0x45
 [<c0113a93>] __wake_up+0x35/0x45
 [<c024dc8e>] dev_name_hash+0x13/0x42
 [<c024dc8e>] dev_name_hash+0x13/0x42
 [<c024dcec>] __dev_get_by_name+0x2f/0x39
 [<c02484a4>] sk_alloc+0x30/0x36
 [<c011a1d7>] _local_bh_enable_ip+0x72/0x7c
 [<c0246dd0>] lock_sock_nested+0xb1/0xb8
 [<c011a1d7>] _local_bh_enable_ip+0x72/0x7c
 [<c0246377>] sys_socketcall+0x15b/0x193
 [<c0152703>] sys_close+0x75/0xc5
 [<c01038b6>] syscall_call+0x7/0xb
 [<c02a0000>] pci_read_bridge_bases+0x273/0x298
 =======================
---[ end trace 5a73e54cdc253a36 ]---


I'll try again after an update fixing this (backing it out?) gets posted.

BTW:  Where does scripts/markup_oops.pl live?

-Philip


