Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45223 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbcCZA4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 20:56:03 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id C92AB40CF50
	for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2016 17:56:01 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: hashing error in hacked 4.4.6+ kernel.
Message-ID: <56F5DE21.9050601@candelatech.com> (sfid-20160326_015610_163402_1721825C)
Date: Fri, 25 Mar 2016 17:56:01 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First, this kernel has lots of patches, including patches to the station hashing.

http://dmz2.candelatech.com/?p=linux-4.4.dev.y/.git;a=summary

But, my hashing patches cannot cause an error return as far as I can tell,
so I'm not sure this is my bug or not.

And, I'm running custom wave-2 ath10k firmware with 35 or so station
vdevs doing encryption, and with a lot of ath10k patches from newer
development kernels....


Test case was to bring up the stations.  All but one (sta28) came up fine.

Seems it had issues on the initial connect for one reason or another, and then
on deauth, removing from the has failed (sta_info_hash_del).


I'm curious if anyone has seen anything similar lately?


Splat is below...narrative continues after...


Mar 25 17:02:05 ath10k.candelatech.com kernel: sta28: deauthenticating from 04:f0:21:f6:85:1c by local choice (Reason: 3=DEAUTH_LEAVING)
Mar 25 17:02:05 ath10k.candelatech.com kernel: ------------[ cut here ]------------
Mar 25 17:02:05 ath10k.candelatech.com kernel: WARNING: CPU: 2 PID: 6227 at /home/greearb/git/linux-4.4.dev.y/net/mac80211/sta_info.c:921 
__sta_info_destroy_part1+0x91/0x422 [mac80211]()
Mar 25 17:02:05 ath10k.candelatech.com kernel: Modules linked in: nf_conntrack_netlink nf_conntrack nfnetlink nf_defrag_ipv4 8021q garp mrp stp llc bnep 
bluetooth fuse macvlan wanlink(O) pktgen rpcsec_gss_krb5 nfsv4 nfs fscache iTCO_wdt iTCO_vendor_support coretemp hwmon ath9k intel_rapl iosf_mbi ath10k_pci 
ath9k_common ath10k_core ath9k_hw x86_pkg_temp_thermal intel_powerclamp kvm_intel ath kvm mac80211 joydev irqbypass serio_raw snd_hda_codec_hdmi pcspkr 
snd_hda_codec_realtek cfg80211 snd_hda_codec_generic i2c_i801 lpc_ich snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm 
8250_fintek snd_timer snd shpchp soundcore tpm_tis tpm nfsd auth_rpcgss nfs_acl lockd grace sunrpc ata_generic pata_acpi i915 i2c_algo_bit drm_kms_helper e1000e 
ptp pps_core drm i2c_core fjes video ipv6 [last unloaded: nf_conntrack]
Mar 25 17:02:05 ath10k.candelatech.com kernel:
Mar 25 17:02:05 ath10k.candelatech.com kernel: CPU: 2 PID: 6227 Comm: ip Tainted: G        W  O    4.4.6+ #21
Mar 25 17:02:05 ath10k.candelatech.com kernel: Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
Mar 25 17:02:05 ath10k.candelatech.com kernel:  0000000000000000 ffff8801fe0ab3b8 ffffffff8137086d 0000000000000000
Mar 25 17:02:05 ath10k.candelatech.com kernel:  0000000000000009 ffff8801fe0ab3f0 ffffffff810ee1eb ffffffffa07f5bba
Mar 25 17:02:05 ath10k.candelatech.com kernel:  ffff8800cadf9000 ffff880213770a60 00000000fffffffe ffff880204478a40
Mar 25 17:02:05 ath10k.candelatech.com kernel: Call Trace:
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8137086d>] dump_stack+0x81/0xb6
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff810ee1eb>] warn_slowpath_common+0x94/0xad
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa07f5bba>] ? __sta_info_destroy_part1+0x91/0x422 [mac80211]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff810ee2a8>] warn_slowpath_null+0x15/0x17
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa07f5bba>] __sta_info_destroy_part1+0x91/0x422 [mac80211]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa07f9474>] __sta_info_flush+0xd4/0x162 [mac80211]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa083a0a7>] ieee80211_set_disassoc+0x15e/0x31f [mac80211]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa083ea6c>] ieee80211_mgd_deauth+0x1e4/0x225 [mac80211]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa080cdcb>] ieee80211_deauth+0x13/0x15 [mac80211]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa05c27e9>] cfg80211_mlme_deauth+0x154/0x1e6 [cfg80211]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa05c2b16>] cfg80211_mlme_down+0x7a/0x9b [cfg80211]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa05c6b87>] cfg80211_disconnect+0xd4/0x24e [cfg80211]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa059e19a>] __cfg80211_leave+0x11f/0x16a [cfg80211]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa059e20d>] cfg80211_leave+0x28/0x37 [cfg80211]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa059e3dd>] cfg80211_netdev_notifier_call+0x1c1/0x5f4 [cfg80211]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff816de857>] ? rcu_read_unlock+0x3e/0x5d
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8110a75f>] notifier_call_chain+0x45/0x67
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8110a79b>] raw_notifier_call_chain+0xf/0x11
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81636381>] call_netdevice_notifiers_info+0x4d/0x54
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81636396>] call_netdevice_notifiers+0xe/0x10
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8163648c>] __dev_close_many+0x6c/0xd2
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81636524>] __dev_close+0x32/0x47
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8163ef6e>] __dev_change_flags+0xa4/0x13a
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8163f023>] dev_change_flags+0x1f/0x54
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8164a34f>] do_setlink+0x2fb/0x958
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8112d0d0>] ? mark_lock+0x24/0x201
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8112d0d0>] ? mark_lock+0x24/0x201
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8112d0d0>] ? mark_lock+0x24/0x201
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8112d0d0>] ? mark_lock+0x24/0x201
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8112d0d0>] ? mark_lock+0x24/0x201
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8164d823>] rtnl_newlink+0x363/0x6c2
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff816361e7>] ? netdev_master_upper_dev_get+0xd/0x50
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8164d5be>] ? rtnl_newlink+0xfe/0x6c2
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff810f5e7d>] ? ns_capable+0x43/0x5a
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8164dcf8>] rtnetlink_rcv_msg+0x176/0x185
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff816493ca>] ? rtnl_lock+0x12/0x14
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8112eb5c>] ? lock_release+0x1bb/0x3bd
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8164db82>] ? rtnl_newlink+0x6c2/0x6c2
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81669293>] netlink_rcv_skb+0x45/0x89
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81649fe0>] rtnetlink_rcv+0x1e/0x25
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81668c0a>] netlink_unicast+0xdc/0x154
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8166913d>] netlink_sendmsg+0x4bb/0x4d2
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8162477d>] sock_sendmsg+0x2e/0x3f
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81625095>] ___sys_sendmsg+0x1bb/0x253
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81152de0>] ? current_kernel_time64+0xb/0x31
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8112eb5c>] ? lock_release+0x1bb/0x3bd
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8112eb5c>] ? lock_release+0x1bb/0x3bd
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8112e908>] ? lock_acquire+0x132/0x1cb
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81152a9c>] ? read_seqcount_begin.constprop.23+0x6b/0x87
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8112d490>] ? trace_hardirqs_on_caller+0x16f/0x18b
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81225af1>] ? __fget_light+0x48/0x6c


Later, the station cannot be re-added because it at least partially exists in the
stack.  That ath10k splat seems to be because there is no channel-req associated
with the station.

Mar 25 17:02:05 ath10k.candelatech.com kernel: WARNING: CPU: 3 PID: 6 at /home/greearb/git/linux-4.4.dev.y/drivers/net/wireless/ath/ath10k/mac.c:6119 
ath10k_sta_rc_update_wk+0x3e/0x2d1 [ath10k_core]()
Mar 25 17:02:05 ath10k.candelatech.com kernel: Modules linked in: nf_conntrack_netlink nf_conntrack nfnetlink nf_defrag_ipv4 8021q garp mrp stp llc bnep 
bluetooth fuse macvlan wanlink(O) pktgen rpcsec_gss_krb5 nfsv4 nfs fscache iTCO_wdt iTCO_vendor_support coretemp hwmon ath9k intel_rapl iosf_mbi ath10k_pci 
ath9k_common ath10k_core ath9k_hw x86_pkg_temp_thermal intel_powerclamp kvm_intel ath kvm mac80211 joydev irqbypass serio_raw snd_hda_codec_hdmi pcspkr 
snd_hda_codec_realtek cfg80211 snd_hda_codec_generic i2c_i801 lpc_ich snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm 
8250_fintek snd_timer snd shpchp soundcore tpm_tis tpm nfsd auth_rpcgss nfs_acl lockd grace sunrpc ata_generic pata_acpi i915 i2c_algo_bit drm_kms_helper e1000e 
ptp pps_core drm i2c_core fjes video ipv6 [last unloaded: nf_conntrack]
Mar 25 17:02:05 ath10k.candelatech.com kernel:
Mar 25 17:02:05 ath10k.candelatech.com kernel: CPU: 3 PID: 6 Comm: kworker/u8:0 Tainted: G        W  O    4.4.6+ #21
Mar 25 17:02:05 ath10k.candelatech.com kernel: Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
Mar 25 17:02:05 ath10k.candelatech.com kernel: Workqueue: phy2 ath10k_sta_rc_update_wk [ath10k_core]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  0000000000000000 ffff880215093cf0 ffffffff8137086d 0000000000000000
Mar 25 17:02:05 ath10k.candelatech.com kernel:  0000000000000009 ffff880215093d28 ffffffff810ee1eb ffffffffa0e7ae8d
Mar 25 17:02:05 ath10k.candelatech.com kernel:  ffff880213774340 ffff8800cadf9be0 ffff88020447a2e0 ffff88021557cb80
Mar 25 17:02:05 ath10k.candelatech.com kernel: Call Trace:
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8137086d>] dump_stack+0x81/0xb6
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff810ee1eb>] warn_slowpath_common+0x94/0xad
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa0e7ae8d>] ? ath10k_sta_rc_update_wk+0x3e/0x2d1 [ath10k_core]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff810ee2a8>] warn_slowpath_null+0x15/0x17
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffffa0e7ae8d>] ath10k_sta_rc_update_wk+0x3e/0x2d1 [ath10k_core]
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8112b2a9>] ? __lock_is_held+0x3c/0x57
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff8110471a>] process_one_work+0x260/0x4db
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81104e50>] worker_thread+0x1e9/0x29b
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81104c67>] ? rescuer_thread+0x2a8/0x2a8
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81109bfb>] kthread+0xcf/0xd7
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81109b2c>] ? kthread_parkme+0x1f/0x1f
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff816faaef>] ret_from_fork+0x3f/0x70
Mar 25 17:02:05 ath10k.candelatech.com kernel:  [<ffffffff81109b2c>] ? kthread_parkme+0x1f/0x1f
Mar 25 17:02:05 ath10k.candelatech.com kernel: ---[ end trace e474c50f3cdc951c ]---
Mar 25 17:02:05 ath10k.candelatech.com kernel: sta28: 04:f0:21:99:9e:d1 authenticate with 04:f0:21:f6:85:1c at: 1458950525.415842
Mar 25 17:02:05 ath10k.candelatech.com kernel: sta28: failed to insert STA entry for the AP (error -17)

There seems to be no good way to recover from this.

There is a bunch more craziness in the logs too.  I've uploaded them here in case someone
wants to take a look.

http://www.candelatech.com/~greearb/misc/sta_insert_bug.txt

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

