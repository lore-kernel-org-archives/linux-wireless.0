Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47181 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbZG3OcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 10:32:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	me@bobcopeland.com
Subject: Ath5k/mac80211 triggers WARN_ON in kernel/softirq.c
Date: Thu, 30 Jul 2009 16:31:50 +0200
Cc: wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <200907301631.50780.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ath5k from today's compat-wireless triggers the following WARNing
on hostapd startup.

[ 1588.927501] cfg80211: Calling CRDA to update world regulatory domain
[ 1588.967169] ath5k 0000:04:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[ 1588.967334] ath5k 0000:04:00.0: registered as 'phy0'
[ 1588.974208] cfg80211: World regulatory domain updated:
[ 1588.974271] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1588.974342] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[ 1589.157198] ath: EEPROM regdomain: 0x809c
[ 1589.157205] ath: EEPROM indicates we should expect a country code
[ 1589.157210] ath: doing EEPROM country->regdmn map search
[ 1589.157215] ath: country maps to regdmn code: 0x52
[ 1589.157220] ath: Country alpha2 being used: CN
[ 1589.157224] ath: Regpair used: 0x52
[ 1589.157563] phy0: Selected rate control algorithm 'minstrel'
[ 1589.158027] ath5k phy0: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)
[ 1589.158516] cfg80211: Calling CRDA for country: CN
[ 1589.168612] cfg80211: Regulatory domain changed to country: CN
[ 1589.168670] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1589.168739] 	(2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1589.168788] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (N/A, 3000 mBm)
[ 1668.667833] cfg80211: Calling CRDA for country: DE
[ 1668.674341] cfg80211: Regulatory domain changed to country: DE
[ 1668.674397] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1668.674463] 	(2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1668.674528] 	(5150000 KHz - 5255000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[ 1668.674577] 	(5470000 KHz - 5650000 KHz @ 40000 KHz), (N/A, 3000 mBm)
[ 1669.799870] ------------[ cut here ]------------
[ 1669.799934] WARNING: at kernel/softirq.c:141 local_bh_enable_ip+0x8b/0xb0()
[ 1669.799982] Hardware name:         
[ 1669.800023] Modules linked in: ath5k mac80211 ath cfg80211
[ 1669.800192] Pid: 24862, comm: hostapd Not tainted 2.6.30.2 #3
[ 1669.800238] Call Trace:
[ 1669.800287]  [<ffffffff80248e3b>] ? local_bh_enable_ip+0x8b/0xb0
[ 1669.800340]  [<ffffffff802432f8>] warn_slowpath_common+0x78/0xd0
[ 1669.800391]  [<ffffffff8024335f>] warn_slowpath_null+0xf/0x20
[ 1669.800441]  [<ffffffff80248e3b>] local_bh_enable_ip+0x8b/0xb0
[ 1669.800493]  [<ffffffff807e0fef>] _spin_unlock_bh+0xf/0x20
[ 1669.800564]  [<ffffffffa0040b92>] ieee80211_beacon_get+0x2c2/0x2d0 [mac80211]
[ 1669.800625]  [<ffffffffa006a283>] ath5k_beacon_update+0x23/0x430 [ath5k]
[ 1669.800682]  [<ffffffffa006b0ac>] ? ath5k_beacon_config+0xcc/0x200 [ath5k]
[ 1669.800735]  [<ffffffff807de4b0>] ? wait_for_common+0x150/0x170
[ 1669.800791]  [<ffffffffa006b30f>] ath5k_bss_info_changed+0x12f/0x1e0 [ath5k]
[ 1669.800854]  [<ffffffffa002c18a>] ieee80211_bss_info_change_notify+0x10a/0x1e0 [mac80211]
[ 1669.800931]  [<ffffffffa003ac8b>] ieee80211_config_beacon+0x17b/0x1c0 [mac80211]
[ 1669.801006]  [<ffffffffa003ad28>] ieee80211_add_beacon+0x28/0x40 [mac80211]
[ 1669.801068]  [<ffffffffa00096b1>] nl80211_addset_beacon+0x181/0x1e0 [cfg80211]
[ 1669.801136]  [<ffffffff806b4a76>] genl_rcv_msg+0x1b6/0x1f0
[ 1669.801186]  [<ffffffff806b48c0>] ? genl_rcv_msg+0x0/0x1f0
[ 1669.801235]  [<ffffffff806b40a9>] netlink_rcv_skb+0x89/0xb0
[ 1669.801286]  [<ffffffff806b48a7>] genl_rcv+0x27/0x40
[ 1669.801335]  [<ffffffff806b3ab8>] netlink_unicast+0x2a8/0x2c0
[ 1669.801386]  [<ffffffff8066744e>] ? __alloc_skb+0x6e/0x160
[ 1669.801436]  [<ffffffff806b3cb3>] netlink_sendmsg+0x1e3/0x2e0
[ 1669.801487]  [<ffffffff8065e8bf>] sock_sendmsg+0xdf/0x110
[ 1669.801538]  [<ffffffff8025a510>] ? autoremove_wake_function+0x0/0x40
[ 1669.801589]  [<ffffffff8025a510>] ? autoremove_wake_function+0x0/0x40
[ 1669.801642]  [<ffffffff8029212b>] ? find_get_page+0x1b/0xb0
[ 1669.801691]  [<ffffffff80292485>] ? find_lock_page+0x25/0x70
[ 1669.801740]  [<ffffffff80292b04>] ? filemap_fault+0x144/0x450
[ 1669.801790]  [<ffffffff8066da62>] ? __dev_get_by_name+0xa2/0xc0
[ 1669.801841]  [<ffffffff8065d8eb>] ? move_addr_to_kernel+0x2b/0x40
[ 1669.801891]  [<ffffffff80668a3c>] ? verify_iovec+0x3c/0xd0
[ 1669.801940]  [<ffffffff8065ea79>] sys_sendmsg+0x189/0x320
[ 1669.801990]  [<ffffffff8065d2d4>] ? sock_destroy_inode+0x14/0x20
[ 1669.802041]  [<ffffffff802dc10e>] ? destroy_inode+0x2e/0x60
[ 1669.802091]  [<ffffffff802d890a>] ? __d_free+0x3a/0x60
[ 1669.802142]  [<ffffffff802dfe7a>] ? mntput_no_expire+0x2a/0x140
[ 1669.802192]  [<ffffffff802d89e6>] ? d_kill+0x56/0x70
[ 1669.802242]  [<ffffffff802c8521>] ? __fput+0x161/0x1e0
[ 1669.802291]  [<ffffffff802c85bd>] ? fput+0x1d/0x30
[ 1669.802340]  [<ffffffff802c4d0b>] ? filp_close+0x5b/0x90
[ 1669.802391]  [<ffffffff8020b3eb>] system_call_fastpath+0x16/0x1b
[ 1669.802439] ---[ end trace e56b46f2a3c5ff89 ]---
[ 1680.059849] wlan0: no IPv6 routers present

-- 
Greetings, Michael.
