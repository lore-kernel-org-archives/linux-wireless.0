Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37278 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3BGAoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 19:44:11 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r170iAwL011637
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 6 Feb 2013 16:44:10 -0800
Message-ID: <5112F8D9.5060206@candelatech.com> (sfid-20130207_014415_868355_33170FE8)
Date: Wed, 06 Feb 2013 16:44:09 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 3.7.6+:  WARNING: at net/mac80211/iface.c:705 ieee80211_do_stop
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This came from my patched 3.7.6+ kernel...it has some additional printout for the
WDS/flush states, in case that helps any...

Doesn't seem to have caused any lasting harm.

.....
[13040.210852] sta6: switched off addBA timer for 00:ab:87:60:10:10 tid 0
[13040.210872] sta6: Aggregation is on for 00:ab:87:60:10:10 tid 0
[13041.234814] sta7: delba from 00:ab:87:60:10:10 (recipient) tid 0 reason code 39
[13041.234814] sta7: Tx BA session stop requested for 00:ab:87:60:10:10 tid 0
[13041.243131] sta7: Stopping Tx BA session for 00:ab:87:60:10:10 tid 0
[13044.467824] sta5: Open BA session requested for 00:ab:87:60:10:10 tid 0
[13044.490181] sta5: activated addBA response timer on 00:ab:87:60:10:10 tid 0
[13044.493147] sta5: switched off addBA timer for 00:ab:87:60:10:10 tid 0
[13044.493149] sta5: Aggregation is on for 00:ab:87:60:10:10 tid 0
[13045.346104] sta6: tx session timer expired on 00:ab:87:60:10:10 tid 0
[13045.346199] sta6: Tx BA session stop requested for 00:ab:87:60:10:10 tid 0
[13045.357154] sta6: Stopping Tx BA session for 00:ab:87:60:10:10 tid 0
[13048.647010] sta8: Open BA session requested for 00:ab:87:60:10:10 tid 0
[13048.647384] sta8: activated addBA response timer on 00:ab:87:60:10:10 tid 0
[13048.649710] sta8: switched off addBA timer for 00:ab:87:60:10:10 tid 0
[13048.649738] sta8: Aggregation is on for 00:ab:87:60:10:10 tid 0
[13049.620723] sta5: delba from 00:ab:87:60:10:10 (recipient) tid 0 reason code 39
[13049.621007] sta5: Tx BA session stop requested for 00:ab:87:60:10:10 tid 0
[13049.630255] sta5: Stopping Tx BA session for 00:ab:87:60:10:10 tid 0
[13050.095003] sta7: Open BA session requested for 00:ab:87:60:10:10 tid 0
[13050.113141] sta7: activated addBA response timer on 00:ab:87:60:10:10 tid 0
[13050.114845] sta7: switched off addBA timer for 00:ab:87:60:10:10 tid 0
[13050.114869] sta7: Aggregation is on for 00:ab:87:60:10:10 tid 0
[13050.739696] sta6: deauthenticating from 00:ab:87:60:10:10 by local choice (reason=3)
[13051.891626] IPv6: ADDRCONF(NETDEV_UP): sta6: link is not ready
[13051.909152] wiphy0: start_sw_scan: running-other-vifs: 2  running-station-vifs: 8, associated-stations: 7 scanning current channel: 5180 MHz
[13051.973344] sta6: authenticate with 00:ab:87:60:10:10
[13052.099487] sta6: send auth to 00:ab:87:60:10:10 (try 1/3)
[13052.139177] sta6: authenticated
[13052.176209] sta6: Invalid WDS/flush state, type: 2  WDS: 5  flushed: 1
[13052.193241] ------------[ cut here ]------------
[13052.206642] WARNING: at /home/greearb/git/linux-3.7.dev.y/net/mac80211/iface.c:705 ieee80211_do_stop+0x647/0x6a0 [mac80211]()
[13052.227200] Hardware name: To Be Filled By O.E.M.
[13052.238787] Modules linked in: iptable_raw xt_CT bridge nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack veth ip_gre gre 8021q garp stp llc 
fuse macvlan wanlink(O) pktgen nfsv3 nfs_acl nfsv4 auth_rpcgss nfs fscache lockd sunrpc binfmt_misc uinput arc4 snd_hda_codec_realtek ath9k snd_hda_intel 
mac80211 snd_hda_codec snd_hwdep coretemp snd_seq iTCO_wdt snd_seq_device ath9k_common snd_pcm gpio_ich iTCO_vendor_support ath9k_hw snd_timer microcode snd 
i2c_i801 ath lpc_ich serio_raw pcspkr soundcore cfg80211 snd_page_alloc r8169 mii rfkill i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: 
iptable_nat]
[13052.337183] Pid: 26365, comm: ip Tainted: G         C O 3.7.6+ #47
[13052.350669] Call Trace:
[13052.359551]  [<c044417d>] warn_slowpath_common+0x6d/0xa0
[13052.372070]  [<f8b4c1b7>] ? ieee80211_do_stop+0x647/0x6a0 [mac80211]
[13052.385106]  [<f8b4c1b7>] ? ieee80211_do_stop+0x647/0x6a0 [mac80211]
[13052.399193]  [<c04441cd>] warn_slowpath_null+0x1d/0x20
[13052.416803]  [<f8b4c1b7>] ieee80211_do_stop+0x647/0x6a0 [mac80211]
[13052.431507]  [<c093372f>] ? _raw_spin_unlock_bh+0x2f/0x40
[13052.453520]  [<c08557b1>] ? dev_deactivate_many+0x1e1/0x210
[13052.471179]  [<f8b4c222>] ieee80211_stop+0x12/0x20 [mac80211]
[13052.486507]  [<c083b1c1>] __dev_close_many+0x61/0xb0
[13052.500384]  [<c044bc62>] ? local_bh_enable_ip+0x42/0xa0
[13052.515556]  [<c083b22f>] __dev_close+0x1f/0x30
[13052.529078]  [<c083a56d>] __dev_change_flags+0x7d/0x150
[13052.543250]  [<c083bb2e>] dev_change_flags+0x1e/0x60
[13052.556564]  [<c084ab10>] do_setlink+0x190/0x8f0
[13052.568896]  [<c064c852>] ? nla_parse+0x22/0xd0
[13052.580306]  [<c084ceee>] rtnl_newlink+0x52e/0x5b0
[13052.592733]  [<c05dbf57>] ? security_capable+0x17/0x20
[13052.603526]  [<c044eef5>] ? ns_capable+0x25/0x60
[13052.614057]  [<c09312c1>] ? __mutex_lock_common+0x301/0x3e0
[13052.625775]  [<c084c9c0>] ? rtnl_configure_link+0xa0/0xa0
[13052.641185]  [<c084a467>] rtnetlink_rcv_msg+0x267/0x2c0
[13052.652616]  [<c084a200>] ? rtnetlink_rcv+0x20/0x20
[13052.663600]  [<c085ea06>] netlink_rcv_skb+0x86/0xb0
[13052.674764]  [<c084a1f7>] rtnetlink_rcv+0x17/0x20
[13052.685221]  [<c085e755>] netlink_unicast+0x175/0x1f0
[13052.695549]  [<c085f3bc>] netlink_sendmsg+0x1fc/0x300
[13052.706297]  [<c0829f5d>] sock_sendmsg+0xbd/0xf0
[13052.717299]  [<c0828578>] ? copy_from_user+0x8/0x10
[13052.741002]  [<c0834483>] ? verify_iovec+0x53/0xb0
[13052.751249]  [<c082b0a5>] __sys_sendmsg+0x2c5/0x2e0
[13052.764696]  [<c082a550>] ? sock_aio_write+0x170/0x170
[13052.775097]  [<c0435dae>] ? arch_flush_lazy_mmu_mode+0x3e/0x60
[13052.787582]  [<c043da2c>] ? kmap_atomic_prot+0x10c/0x130
[13052.798127]  [<c04f3c99>] ? handle_mm_fault+0x1c9/0x250
[13052.808407]  [<c082b226>] sys_sendmsg+0x36/0x60
[13052.818396]  [<c082b537>] sys_socketcall+0x107/0x2d0
[13052.828792]  [<c04f7d15>] ? sys_brk+0xd5/0x110
[13052.838278]  [<c0938b0d>] sysenter_do_call+0x12/0x33
[13052.848390] ---[ end trace 38ad468e97568339 ]---
[13052.862855] sta7: deauthenticating from 00:ab:87:60:10:10 by local choice (reason=3)
[13052.876642] sta7: Tx BA session stop requested for 00:ab:87:60:10:10 tid 0
[13052.876926] sta7: Stopping Tx BA session for 00:ab:87:60:10:10 tid 0
[13052.938262] IPv6: ADDRCONF(NETDEV_UP): sta6: link is not ready
[13053.776084] sta8: tx session timer expired on 00:ab:87:60:10:10 tid 0
[13053.776180] sta8: Tx BA session stop requested for 00:ab:87:60:10:10 tid 0
[13053.787178] sta8: Stopping Tx BA session for 00:ab:87:60:10:10 tid 0
[13054.368624] sta5: deauthenticating from 00:ab:87:60:10:10 by local choice (reason=3)
[13057.133369] wiphy0: start_sw_scan: running-other-vifs: 2  running-station-vifs: 6, associated-stations: 5 scanning current channel: 5180 MHz
[13057.207416] sta6: authenticate with 00:ab:87:60:10:10
[13057.337127] sta6: send auth to 00:ab:87:60:10:10 (try 1/3)
[13057.362168] sta6: authenticated
[13057.410809] sta6: associate with 00:ab:87:60:10:10 (try 1/3)
[13057.430801] sta6: RX AssocResp from 00:ab:87:60:10:10 (capab=0x1 status=0 aid=1)
[13057.447890] IPv6: ADDRCONF(NETDEV_CHANGE): sta6: link becomes ready
[13057.461071] sta6: associated
[13057.569209] sta6: Open BA session requested for 00:ab:87:60:10:10 tid 0
[13057.588103] sta6: activated addBA response timer on 00:ab:87:60:10:10 tid 0
[13057.597554] sta6: switched off addBA timer for 00:ab:87:60:10:10 tid 0
[13057.597566] sta6: Aggregation is on for 00:ab:87:60:10:10 tid 0
[13058.045908] IPv6: ADDRCONF(NETDEV_UP): sta5: link is not ready

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

