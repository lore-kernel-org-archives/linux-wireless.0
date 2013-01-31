Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48697 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3AaSQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 13:16:39 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r0VIGcvi011032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2013 10:16:38 -0800
Message-ID: <510AB506.2020405@candelatech.com> (sfid-20130131_191644_126907_F84B02B2)
Date: Thu, 31 Jan 2013 10:16:38 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 3.7.5+:  Warning in in iface.c, ieee80211_do_stop
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is with a somewhat hacked-upon 3.7.5+ kernel.  The extra wifi stuff is
mostly back-ported patches from newer upstream kernels.

Warning is from the code below...guess I'll add some more debug printing
here to try to get more useful info on exactly what failed...  I am
NOT using WDS as far as I know...

	/*
	 * Remove all stations associated with this interface.
	 *
	 * This must be done before calling ops->remove_interface()
	 * because otherwise we can later invoke ops->sta_notify()
	 * whenever the STAs are removed, and that invalidates driver
	 * assumptions about always getting a vif pointer that is valid
	 * (because if we remove a STA after ops->remove_interface()
	 * the driver will have removed the vif info already!)
	 *
	 * This is relevant only in WDS mode, in all other modes we've
	 * already removed all stations when disconnecting or similar,
	 * so warn otherwise.
	 *
	 * We call sta_info_flush_cleanup() later, to combine RCU waits.
	 */
	flushed = sta_info_flush_defer(sdata);
	WARN_ON_ONCE((sdata->vif.type != NL80211_IFTYPE_WDS && flushed > 0) ||
		     (sdata->vif.type == NL80211_IFTYPE_WDS && flushed != 1));


[  119.169543] ------------[ cut here ]------------
[  119.181949] WARNING: at /home/greearb/git/linux-3.7.dev.y/net/mac80211/iface.c:701 ieee80211_do_stop+0x639/0x680 [mac80211]()
[  119.203980] Hardware name: To Be Filled By O.E.M.
[  119.216903] Modules linked in: iptable_raw xt_CT nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack bridge veth ip_gre gre 8021q garp stp llc 
fuse macvlan wanlink(O) pktgen nfsv3 nfs_acl nfsv4 auth_rpcgss nfs fscache lockd sunrpc binfmt_misc uinput arc4 ath9k mac80211 snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec iTCO_wdt ath9k_common ath9k_hw snd_hwdep gpio_ich coretemp iTCO_vendor_support snd_seq snd_seq_device lpc_ich microcode ath i2c_i801 
snd_pcm pcspkr serio_raw cfg80211 snd_timer r8169 snd mii soundcore snd_page_alloc rfkill i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: 
iptable_nat]
[  119.339413] Pid: 5023, comm: ip Tainted: G         C O 3.7.5+ #42
[  119.355852] Call Trace:
[  119.364902]  [<c044411d>] warn_slowpath_common+0x6d/0xa0
[  119.376907]  [<f8b261c9>] ? ieee80211_do_stop+0x639/0x680 [mac80211]
[  119.390547]  [<f8b261c9>] ? ieee80211_do_stop+0x639/0x680 [mac80211]
[  119.404117]  [<c044416d>] warn_slowpath_null+0x1d/0x20
[  119.416209]  [<f8b261c9>] ieee80211_do_stop+0x639/0x680 [mac80211]
[  119.429109]  [<c044bc02>] ? local_bh_enable_ip+0x42/0xa0
[  119.441304]  [<c093362f>] ? _raw_spin_unlock_bh+0x2f/0x40
[  119.453265]  [<c08556e1>] ? dev_deactivate_many+0x1e1/0x210
[  119.466437]  [<f8b26222>] ieee80211_stop+0x12/0x20 [mac80211]
[  119.479176]  [<c083b111>] __dev_close_many+0x61/0xb0
[  119.490607]  [<c044bc02>] ? local_bh_enable_ip+0x42/0xa0
[  119.502586]  [<c083b17f>] __dev_close+0x1f/0x30
[  119.514624]  [<c083a4bd>] __dev_change_flags+0x7d/0x150
[  119.532500]  [<c083ba7e>] dev_change_flags+0x1e/0x60
[  119.545192]  [<c084aa40>] do_setlink+0x190/0x8f0
[  119.555693]  [<c064c7a2>] ? nla_parse+0x22/0xd0
[  119.566092]  [<c084ce1e>] rtnl_newlink+0x52e/0x5b0
[  119.576461]  [<c05dbea7>] ? security_capable+0x17/0x20
[  119.587417]  [<c044ee95>] ? ns_capable+0x25/0x60
[  119.597749]  [<c09311c1>] ? __mutex_lock_common+0x301/0x3e0
[  119.608846]  [<c084c8f0>] ? rtnl_configure_link+0xa0/0xa0
[  119.619788]  [<c084a397>] rtnetlink_rcv_msg+0x267/0x2c0
[  119.630436]  [<c084a130>] ? rtnetlink_rcv+0x20/0x20
[  119.640547]  [<c085e936>] netlink_rcv_skb+0x86/0xb0
[  119.651001]  [<c084a127>] rtnetlink_rcv+0x17/0x20
[  119.661077]  [<c085e685>] netlink_unicast+0x175/0x1f0
[  119.672308]  [<c085f2ec>] netlink_sendmsg+0x1fc/0x300
[  119.690238]  [<c0829ead>] sock_sendmsg+0xbd/0xf0
[  119.700857]  [<c08284c8>] ? copy_from_user+0x8/0x10
[  119.710918]  [<c08343d3>] ? verify_iovec+0x53/0xb0
[  119.720666]  [<c082aff5>] __sys_sendmsg+0x2c5/0x2e0
[  119.730549]  [<c082a4a0>] ? sock_aio_write+0x170/0x170
[  119.740744]  [<c0435d7e>] ? arch_flush_lazy_mmu_mode+0x3e/0x60
[  119.751410]  [<c043d9fc>] ? kmap_atomic_prot+0x10c/0x130
[  119.761581]  [<c04f3be9>] ? handle_mm_fault+0x1c9/0x250
[  119.772455]  [<c082b176>] sys_sendmsg+0x36/0x60
[  119.782972]  [<c082b487>] sys_socketcall+0x107/0x2d0
[  119.792880]  [<c04f7c65>] ? sys_brk+0xd5/0x110
[  119.802064]  [<c0938a0d>] sysenter_do_call+0x12/0x33
[  119.811601] ---[ end trace c1c50292a57e7eba ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

