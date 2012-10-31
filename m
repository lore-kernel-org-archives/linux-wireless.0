Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58091 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab2JaTB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 15:01:27 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q9VJ1RdM007349
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2012 12:01:27 -0700
Message-ID: <50917587.9010305@candelatech.com> (sfid-20121031_200131_307985_1A302D25)
Date: Wed, 31 Oct 2012 12:01:27 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Problem with drv_remove_interface when associated in 3.5.7?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am working on debugging the splat I reported a few days ago in a tainted
3.5.7 kernel.  I've removed the tainting module, and added some debug.

I think at least part of the problem is that drv_remove_interface can
be called with ifmgd->associated != NULL.  I added the following code and
got the splat below:


static inline void drv_remove_interface(struct ieee80211_local *local,
					struct ieee80211_sub_if_data *sdata)
{
	might_sleep();

	check_sdata_in_driver(sdata);

	trace_drv_remove_interface(local, sdata);
	local->ops->remove_interface(&local->hw, &sdata->vif);
	sdata->flags &= ~IEEE80211_SDATA_IN_DRIVER;
	{
		struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
		WARN_ON(ifmgd->associated);
	}
	printk("%s:  drv-remove-interface\n", sdata->name);
	trace_drv_return_void(local);
}

We are clearing something from the driver that is still associated???



------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.5.dev.y/net/mac80211/driver-ops.h:197 drv_remove_interface+0x82/0x9c [mac80211]()
Hardware name: To be filled by O.E.M.
Modules linked in: ath5k ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nfs nfs_acl auth_rpcgss fscache 8021q garp stp llc macvlan pktgen lockd sunrpc 
gpio_ich joydev coretemp hwmon ppdev kvm snd_hda_codec_realtek microcode snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device serio_raw pcspkr snd_pcm 
snd_page_alloc snd_timer snd i2c_i801 lpc_ich mfd_core soundcore e1000e mei parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core 
[last unloaded: nf_nat]
Pid: 2500, comm: ip Tainted: G        W  O 3.5.7+ #1
Call Trace:
  [<ffffffff8105d94c>] warn_slowpath_common+0x80/0x98
  [<ffffffff8105d979>] warn_slowpath_null+0x15/0x17
  [<ffffffffa04bfa0e>] drv_remove_interface+0x82/0x9c [mac80211]
  [<ffffffffa04c0014>] ieee80211_do_stop+0x447/0x5cf [mac80211]
  [<ffffffff8146703e>] ? dev_deactivate_many+0x121/0x167
  [<ffffffffa04c01b1>] ieee80211_stop+0x15/0x19 [mac80211]
  [<ffffffff8144f54a>] __dev_close_many+0x9e/0xcf
  [<ffffffff8144f5ac>] __dev_close+0x31/0x42
  [<ffffffff8144cb6b>] __dev_change_flags+0xb9/0x13c
  [<ffffffff8144ff19>] dev_change_flags+0x1c/0x51
  [<ffffffff8145ce91>] do_setlink+0x2e3/0x7f5
  [<ffffffff8145ba5f>] ? rtnl_fill_ifinfo+0x9a2/0xa62
  [<ffffffff8145d6f0>] rtnl_newlink+0x272/0x4ce
  [<ffffffff8145d52d>] ? rtnl_newlink+0xaf/0x4ce
  [<ffffffff810a57e8>] ? __lock_acquire+0x39f/0xdd1
  [<ffffffff8150f6b4>] ? __mutex_lock_common+0x3ef/0x4a1
  [<ffffffff810a5181>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff81067dfa>] ? ns_capable+0x4a/0x62
  [<ffffffff8145c347>] ? rtnl_lock+0x12/0x14
  [<ffffffff8145c5a2>] rtnetlink_rcv_msg+0x231/0x24e
  [<ffffffff8145c371>] ? rtnetlink_rcv+0x28/0x28
  [<ffffffff8146fbb0>] netlink_rcv_skb+0x3e/0x8f
  [<ffffffff8145c36a>] rtnetlink_rcv+0x21/0x28
  [<ffffffff8146f96e>] netlink_unicast+0xe4/0x16a
  [<ffffffff81470154>] netlink_sendmsg+0x242/0x260
  [<ffffffff8143e733>] ? rcu_read_unlock+0x5b/0x5d
  [<ffffffff8143abdf>] __sock_sendmsg_nosec+0x5f/0x6a
  [<ffffffff8143ac27>] __sock_sendmsg+0x3d/0x48
  [<ffffffff8143b2b3>] sock_sendmsg+0xa3/0xbc
  [<ffffffff810ff871>] ? might_fault+0x4e/0x9e
  [<ffffffff810ff8ba>] ? might_fault+0x97/0x9e
  [<ffffffff81445b72>] ? copy_from_user+0x2a/0x2c
  [<ffffffff81445f44>] ? verify_iovec+0x4f/0xa3
  [<ffffffff8143ca2a>] __sys_sendmsg+0x1fe/0x280
  [<ffffffff8107cc8e>] ? up_read+0x1e/0x38
  [<ffffffff81132508>] ? fcheck_files+0xac/0xea
  [<ffffffff8113266d>] ? fget_light+0x35/0xae
  [<ffffffff8143cc15>] sys_sendmsg+0x3d/0x5b
  [<ffffffff81517179>] system_call_fastpath+0x16/0x1b
---[ end trace 03bb877f0a1bdfd2 ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

