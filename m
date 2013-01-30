Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54088 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3A3FSC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 00:18:02 -0500
Received: from [50.54.140.2] (50-54-140-2.evrt.wa.frontiernet.net [50.54.140.2])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r0U5I18b027125
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2013 21:18:01 -0800
Message-ID: <5108AD09.9020308@candelatech.com> (sfid-20130130_061807_008646_1F3CFFD0)
Date: Tue, 29 Jan 2013 21:18:01 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: WARNING: at drivers/net/wireless/ath/ath9k/beacon.c:362 ath9k_beacon_tasklet+0xcc/0x5f0)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I hit this warning in ath9k.  Shortly after the machine blew up elsewhere,
but not sure if this is to blame or not.

Code is slightly modified 3.7.5 (just a few patches, not my normal mass of hackings!)

The warning that hit is the one below:

	bf = ath9k_beacon_generate(sc->hw, vif);
	WARN_ON(!bf);

Test case is dual-core Atom system with ath9k NIC, 10 or so virtual stations,
two virtual APs.  Two stations send traffic to each other once everything associates, but
not sure it got that far when this crash happened.


[   50.101409] device rddVR1 entered promiscuous mode
[   52.898741] IPv6: ADDRCONF(NETDEV_CHANGE): vap1: link becomes ready
[   54.119148] ------------[ cut here ]------------
[   54.124563] WARNING: at /home/greearb/git/linux-3.7.dev.y/drivers/net/wireless/ath/ath9k/beacon.c:362 ath9k_beacon_tasklet+0xcc/0x5f0)
[   54.138053] Hardware name: To Be Filled By O.E.M.
[   54.143048] Modules linked in: bridge veth ip_gre gre 8021q garp stp llc fuse macvlan pktgen nfsv3 nfs_acl nfsv4 auth_rpcgss nfs fscao
[   54.194049] Pid: 0, comm: swapper/0 Tainted: G         C   3.7.5+ #39
[   54.200819] Call Trace:
[   54.203474]  [<c04451bd>] warn_slowpath_common+0x6d/0xa0
[   54.209086]  [<f8b2e95c>] ? ath9k_beacon_tasklet+0xcc/0x5f0 [ath9k]
[   54.215738]  [<f8b2e95c>] ? ath9k_beacon_tasklet+0xcc/0x5f0 [ath9k]
[   54.222398]  [<c044520d>] warn_slowpath_null+0x1d/0x20
[   54.227905]  [<f8b2e95c>] ath9k_beacon_tasklet+0xcc/0x5f0 [ath9k]
[   54.234236]  [<c04cb37e>] ? check_for_new_grace_period+0x9e/0x120
[   54.240655]  [<c049d561>] ? trace_hardirqs_on_caller+0xa1/0x180
[   54.246885]  [<c044cf8c>] tasklet_action+0xbc/0xd0
[   54.251960]  [<c044d440>] __do_softirq+0xa0/0x170
[   54.256959]  [<c044d3a0>] ? irq_enter+0x70/0x70
[   54.261772]  <IRQ>  [<c044d2fd>] ? irq_exit+0xbd/0xe0
[   54.273227]  [<c040d426>] ? do_IRQ+0x46/0xb0
[   54.283802]  [<c097a7f8>] ? common_interrupt+0x38/0x40
[   54.295293]  [<c049007b>] ? profile_setup+0x1fb/0x270
[   54.306686]  [<c06ac18b>] ? intel_idle+0xab/0x110
[   54.317660]  [<c0825746>] ? cpuidle_enter+0x16/0x30
[   54.328715]  [<c082576c>] ? cpuidle_enter_state+0xc/0x40
[   54.340275]  [<c0825cf9>] ? cpuidle_idle_call+0x79/0xb0
[   54.351619]  [<c041390f>] ? cpu_idle+0xaf/0xf0
[   54.362096]  [<c0957405>] ? rest_init+0xd5/0x140
[   54.372738]  [<c0957330>] ? __read_lock_failed+0x1c/0x1c
[   54.384133]  [<c0beeb82>] ? start_kernel+0x37c/0x382
[   54.395109]  [<c0bee677>] ? repair_env_string+0x5b/0x5b
[   54.406368]  [<c093ae29>] ? datagram_send_ctl+0x129/0x540
[   54.417819]  [<c0bee306>] ? i386_start_kernel+0xa9/0xb0
[   54.429049] ---[ end trace fbfaaa6758c4d963 ]---
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

