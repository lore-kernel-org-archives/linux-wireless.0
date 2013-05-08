Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50951 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301Ab3EHRi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 13:38:58 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r48HcvLF002092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 8 May 2013 10:38:57 -0700
Message-ID: <518A8DB1.7080904@candelatech.com> (sfid-20130508_193902_610347_FF7CDB2D)
Date: Wed, 08 May 2013 10:38:57 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: mac80211 warning in 3.9.0+ when unloading ath9k driver.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I saw the WARN_ON_ONCE hit below on 3.9.0+ (+ hacks)
on a system with ath9k and ath9k_htc driver.

I'll be happy to add more debugging if someone has suggestions.

static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
					      struct ieee80211_chanctx *ctx)
{
	struct ieee80211_chanctx_conf *conf = &ctx->conf;
	struct ieee80211_sub_if_data *sdata;
	const struct cfg80211_chan_def *compat = NULL;

	lockdep_assert_held(&local->chanctx_mtx);

	rcu_read_lock();
	list_for_each_entry_rcu(sdata, &local->interfaces, list) {

		if (!ieee80211_sdata_running(sdata))
			continue;
		if (rcu_access_pointer(sdata->vif.chanctx_conf) != conf)
			continue;

		if (!compat)
			compat = &sdata->vif.bss_conf.chandef;

		compat = cfg80211_chandef_compatible(
				&sdata->vif.bss_conf.chandef, compat);
		if (!compat)
			break;
	}
	rcu_read_unlock();

	if (WARN_ON_ONCE(!compat))
		return;

	ieee80211_change_chanctx(local, ctx, compat);
}


May  8 09:39:16 localhost kernel: [412775.378116] wlan0: deauthenticating from 80:01:02:03:04:05 by local choice (reason=3)
May  8 09:39:17 localhost kernel: [412776.206878] ------------[ cut here ]------------
May  8 09:39:17 localhost kernel: [412776.219968] WARNING: at /home/greearb/git/linux-3.9.dev.y/net/mac80211/chan.c:186 
ieee80211_recalc_chanctx_chantype+0x9f/0xe0 [mac80211]()
May  8 09:39:17 localhost kernel: [412776.246245] Hardware name: To Be Filled By O.E.M.
May  8 09:39:17 localhost kernel: [412776.254609] Modules linked in: iptable_raw xt_CT nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
bluetooth 8021q mrp garp stp llc fuse macvlan wanlink(O) pktgen w83627ehf hwmon_vid nfsv3 nfs_acl nfsv4 auth_rpcgss nfs fscache lockd sunrpc binfmt_misc uinput 
arc4 ath9k(-) ath9k_htc mac80211 coretemp gpio_ich iTCO_wdt snd_hda_codec_realtek iTCO_vendor_support ath9k_common snd_hda_intel ath9k_hw snd_hda_codec ath 
snd_hwdep snd_seq snd_seq_device microcode lpc_ich i2c_i801 pcspkr serio_raw snd_pcm cfg80211 snd_timer rfkill snd r8169 soundcore snd_page_alloc mii i915 
drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: iptable_nat]
May  8 09:39:17 localhost kernel: [412776.339435] Pid: 11945, comm: rmmod Tainted: G        WC O 3.9.0+ #25
May  8 09:39:17 localhost kernel: [412776.350098] Call Trace:
May  8 09:39:17 localhost kernel: [412776.356658]  [<c0450fc2>] warn_slowpath_common+0x72/0xa0
May  8 09:39:17 localhost kernel: [412776.366123]  [<f99fd14f>] ? ieee80211_recalc_chanctx_chantype+0x9f/0xe0 [mac80211]
May  8 09:39:17 localhost kernel: [412776.377810]  [<f99fd14f>] ? ieee80211_recalc_chanctx_chantype+0x9f/0xe0 [mac80211]
May  8 09:39:17 localhost kernel: [412776.389318]  [<c0451012>] warn_slowpath_null+0x22/0x30
May  8 09:39:17 localhost kernel: [412776.398267]  [<f99fd14f>] ieee80211_recalc_chanctx_chantype+0x9f/0xe0 [mac80211]
May  8 09:39:17 localhost kernel: [412776.409563]  [<f99fd85c>] __ieee80211_vif_release_channel+0xac/0x220 [mac80211]
May  8 09:39:17 localhost kernel: [412776.421161]  [<f99fda12>] ieee80211_vif_release_channel+0x42/0x60 [mac80211]
May  8 09:39:17 localhost kernel: [412776.432570]  [<f9a15a3e>] ieee80211_set_disassoc+0x21e/0x460 [mac80211]
May  8 09:39:17 localhost kernel: [412776.443246]  [<f9a15fa4>] ieee80211_mgd_deauth+0x234/0x2a0 [mac80211]
May  8 09:39:17 localhost kernel: [412776.453685]  [<f99e91f5>] ieee80211_deauth+0x15/0x20 [mac80211]
May  8 09:39:17 localhost kernel: [412776.463615]  [<f861df37>] cfg80211_mlme_down+0x97/0x1b0 [cfg80211]
May  8 09:39:17 localhost kernel: [412776.473670]  [<f862188d>] __cfg80211_disconnect+0x22d/0x280 [cfg80211]
May  8 09:39:17 localhost kernel: [412776.484487]  [<c0412ade>] ? __switch_to+0xee/0x390
May  8 09:39:17 localhost kernel: [412776.493283]  [<f86017b6>] cfg80211_netdev_notifier_call+0x576/0x6a0 [cfg80211]
May  8 09:39:17 localhost kernel: [412776.504497]  [<c092d7a9>] ? inetdev_event+0x29/0x4f0
May  8 09:39:17 localhost kernel: [412776.513376]  [<c08e2d3d>] ? fib_rules_event+0x1d/0x180
May  8 09:39:17 localhost kernel: [412776.522437]  [<c099b06d>] ? packet_notifier+0x9d/0x170
May  8 09:39:17 localhost kernel: [412776.531532]  [<c09bd443>] notifier_call_chain+0x43/0x60
May  8 09:39:17 localhost kernel: [412776.540791]  [<c047773f>] raw_notifier_call_chain+0x1f/0x30
May  8 09:39:17 localhost kernel: [412776.550452]  [<c08c9c8c>] call_netdevice_notifiers+0x2c/0x60
May  8 09:39:17 localhost kernel: [412776.560253]  [<c09b6d85>] ? schedule_timeout+0x185/0x1c0
May  8 09:39:17 localhost kernel: [412776.569707]  [<c077e5c3>] ? device_release+0x33/0x90
May  8 09:39:17 localhost kernel: [412776.578886]  [<c077e5c3>] ? device_release+0x33/0x90
May  8 09:39:17 localhost kernel: [412776.588098]  [<c08c9cf4>] __dev_close_many+0x34/0xb0
May  8 09:39:17 localhost kernel: [412776.597330]  [<c0549450>] ? kfree+0x100/0x130
May  8 09:39:17 localhost kernel: [412776.605808]  [<c0691428>] ? kobject_release+0x98/0x1c0
May  8 09:39:17 localhost kernel: [412776.615088]  [<c08c9e5c>] dev_close_many+0x6c/0xc0
May  8 09:39:17 localhost kernel: [412776.624071]  [<c08c9fef>] rollback_registered_many+0xaf/0x1f0
May  8 09:39:17 localhost kernel: [412776.634068]  [<c08ca1aa>] ? unregister_netdevice_queue+0x1a/0xc0
May  8 09:39:17 localhost kernel: [412776.644431]  [<c04d3ff0>] ? call_rcu_bh+0x20/0x20
May  8 09:39:17 localhost kernel: [412776.653502]  [<c08ca144>] unregister_netdevice_many+0x14/0x60
May  8 09:39:17 localhost kernel: [412776.663814]  [<f99e3383>] ieee80211_remove_interfaces+0xb3/0x140 [mac80211]
May  8 09:39:17 localhost kernel: [412776.675363]  [<f99d3156>] ieee80211_unregister_hw+0x56/0x100 [mac80211]
May  8 09:39:17 localhost kernel: [412776.686637]  [<f987d69a>] ath9k_deinit_device+0x3a/0x60 [ath9k]
May  8 09:39:17 localhost kernel: [412776.697266]  [<f988d4a1>] ath_pci_remove+0x31/0x50 [ath9k]
May  8 09:39:17 localhost kernel: [412776.707386]  [<c06c1d68>] pci_device_remove+0x38/0xc0
May  8 09:39:17 localhost kernel: [412776.717151]  [<c07819cf>] __device_release_driver+0x5f/0xb0
May  8 09:39:17 localhost kernel: [412776.727339]  [<c0781aaf>] driver_detach+0x8f/0xa0
May  8 09:39:17 localhost kernel: [412776.736509]  [<c0780abc>] bus_remove_driver+0x6c/0xe0
May  8 09:39:17 localhost kernel: [412776.746057]  [<c07801c7>] ? bus_put+0x17/0x20
May  8 09:39:17 localhost kernel: [412776.754775]  [<c0780ad3>] ? bus_remove_driver+0x83/0xe0
May  8 09:39:17 localhost kernel: [412776.764283]  [<c07825f9>] driver_unregister+0x49/0x80
May  8 09:39:17 localhost kernel: [412776.773412]  [<c06c1ea8>] pci_unregister_driver+0x18/0x70
May  8 09:39:17 localhost kernel: [412776.782780]  [<f988d2b2>] ath_pci_exit+0x12/0x20 [ath9k]
May  8 09:39:17 localhost kernel: [412776.791971]  [<f98968c0>] ath9k_exit+0x17/0x757 [ath9k]
May  8 09:39:17 localhost kernel: [412776.800982]  [<c04b0fca>] sys_delete_module+0x17a/0x250
May  8 09:39:17 localhost kernel: [412776.809871]  [<c0532848>] ? do_munmap+0x238/0x2c0
May  8 09:39:17 localhost kernel: [412776.818268]  [<c04c7ff6>] ? __audit_syscall_exit+0x1f6/0x280
May  8 09:39:17 localhost kernel: [412776.827617]  [<c09c06cd>] sysenter_do_call+0x12/0x28
May  8 09:39:17 localhost kernel: [412776.836150] ---[ end trace aff91972ce67584d ]---
May  8 09:39:17 localhost dhcpd: receive_packet failed on vap0: Network is down
May  8 09:39:18 localhost kernel: [412777.276473] ath9k: ath9k: Driver unloaded


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

