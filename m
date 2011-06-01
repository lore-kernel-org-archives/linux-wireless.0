Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56939 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab1FAWP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 18:15:56 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p51MFtWr026251
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 1 Jun 2011 15:15:56 -0700
Message-ID: <4DE6BA1B.8090805@candelatech.com> (sfid-20110602_001600_398414_025A398E)
Date: Wed, 01 Jun 2011 15:15:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 2 VAP ath9k system hits warning in agg-tx.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is with a hacked kernel, but no significant hacks to ath9k.
The ath9k _is_ running with regdomain == 0x0 (instead of the 0x6a
world-domain in it's eeprom).  NIC is Sparklan 127N (AR9830 chipset).

Kernel is 2.6.39-wl+.

The code that is complaining is:

	if (WARN_ON(!tid_tx)) {
#ifdef CONFIG_MAC80211_HT_DEBUG
		printk(KERN_DEBUG "addBA was not requested!\n");
#endif
		goto unlock;
	}

We were associating 128 stations using another AR9380 system as
virtual STA interfaces.  Aside from scary messages, the system
seems fine, and it quit spewing these messages a short time after
bringup.


WARNING: at
/home/greearb/git/linux.wireless-testing-ct/net/mac80211/agg-tx.c:559
ieee80211_start_tx_ba_cb+0x7c/0xa5 [mac80211]()
Hardware name: To Be Filled By O.E.M.
Modules linked in: cryptd aes_i586 aes_generic xt_CT iptable_raw xt_DSCP
xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange
xt_hashlimit xt_connmark xt_addrtype xt_TPROXY nf_tproxy_core xt_socket
ip6_tables nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit veth 8021q garp
stp llc fuse macvlan wanlink(P) pktgen coretemp hwmon nfs lockd fscache
auth_rpcgss nfs_acl sunrpc ipv6 uinput arc4 snd_hda_codec_realtek ath9k
snd_hda_intel mac80211 snd_hda_codec snd_hwdep snd_seq snd_seq_device
ath9k_common snd_pcm ath9k_hw snd_timer ath cfg80211 snd r8169 iTCO_wdt
soundcore iTCO_vendor_support microcode i2c_i801 snd_page_alloc pcspkr mii
serio_raw i915 drm_kms_helper drm i2c_algo_bit video [last unloaded:
xt_connmark]
Pid: 38, comm: kworker/u:2 Tainted: P        W   2.6.39-wl+ #26
Call Trace:
  [<c0430a17>] warn_slowpath_common+0x65/0x7a
  [<f8d84b2e>] ? ieee80211_start_tx_ba_cb+0x7c/0xa5 [mac80211]
  [<c0430a3b>] warn_slowpath_null+0xf/0x13
  [<f8d84b2e>] ieee80211_start_tx_ba_cb+0x7c/0xa5 [mac80211]
  [<f8d8c598>] ieee80211_iface_work+0x99/0x258 [mac80211]
  [<c043f85c>] process_one_work+0x16a/0x219
  [<f8d8c4ff>] ? ieee80211_teardown_sdata+0xaf/0xaf [mac80211]
  [<c044124a>] worker_thread+0xf7/0x1fe
  [<c0425ccc>] ? complete+0x34/0x3e
  [<c0441153>] ? manage_workers+0x164/0x164
  [<c0443c85>] kthread+0x62/0x67
  [<c0443c23>] ? __init_kthread_worker+0x28/0x28
  [<c07856f6>] kernel_thread_helper+0x6/0xd
---[ end trace 5212779ba7fc27a4 ]---


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

