Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49884 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760743Ab3DCXR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 19:17:56 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r33NHtvF022698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 3 Apr 2013 16:17:55 -0700
Message-ID: <515CB8A3.50805@candelatech.com> (sfid-20130404_011800_128781_8C70A056)
Date: Wed, 03 Apr 2013 16:17:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: sta_info_flush_defer:  Splat in 3.9.0-rc5+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm getting started on testing 3.9.0-rc5+ a bit more seriously.  This is on
a tree with some additional patches:

http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.9.dev.y/.git;a=summary


The splat below comes from this.  I see lots of these on both station and AP system when
bouncing 50 or so stations.

int sta_info_flush_defer(struct ieee80211_sub_if_data *sdata)
{
	struct ieee80211_local *local = sdata->local;
	struct sta_info *sta, *tmp;
	int ret = 0;

	might_sleep();

	mutex_lock(&local->sta_mtx);
	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
		if (sdata == sta->sdata) {
			WARN_ON(__sta_info_destroy(sta));
			ret++;
		}
	}
	mutex_unlock(&local->sta_mtx);

	return ret;
}



[  549.134242] ------------[ cut here ]------------
[  549.134291] WARNING: at /home/greearb/git/linux-3.9.dev.y/net/mac80211/sta_info.c:986 sta_info_flush_defer+0x86/0x90 [mac80211]()
[  549.134294] Hardware name: To Be Filled By O.E.M.
[  549.134368] Modules linked in: iptable_raw xt_CT bridge nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_gre gre 8021q mrp garp stp llc 
macvlan wanlink(O) pktgen fuse nfsv3 nfs_acl nfsv4 auth_rpcgss nfs fscache lockd sunrpc binfmt_misc uinput arc4 coretemp iTCO_wdt iTCO_vendor_support gpio_ich 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq ath9k snd_seq_device cdc_acm mac80211 snd_pcm microcode ath9k_common ath9k_hw ath lpc_ich 
snd_timer pcspkr cfg80211 i2c_i801 serio_raw snd r8169 soundcore rfkill snd_page_alloc mii i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: 
iptable_nat]
[  549.134374] Pid: 4822, comm: hostapd Tainted: G        WC O 3.9.0-rc5+ #3
[  549.134376] Call Trace:
[  549.134392]  [<c0444f6d>] warn_slowpath_common+0x6d/0xa0
[  549.134420]  [<f8b8f236>] ? sta_info_flush_defer+0x86/0x90 [mac80211]
[  549.134448]  [<f8b8f236>] ? sta_info_flush_defer+0x86/0x90 [mac80211]
[  549.134455]  [<c0444fbd>] warn_slowpath_null+0x1d/0x20
[  549.134482]  [<f8b8f236>] sta_info_flush_defer+0x86/0x90 [mac80211]
[  549.134514]  [<f8b9eac7>] ieee80211_del_station+0x27/0x40 [mac80211]
[  549.134545]  [<f8b9eaa0>] ? ieee80211_send_layer2_update+0xc0/0xc0 [mac80211]
[  549.134569]  [<f8a89ce0>] nl80211_del_station+0x70/0x80 [cfg80211]
[  549.134579]  [<c0877df6>] genl_rcv_msg+0x236/0x290
[  549.134594]  [<c08492e6>] ? __alloc_skb+0x66/0x170
[  549.134600]  [<c0877bc0>] ? genl_rcv+0x20/0x20
[  549.134605]  [<c0876996>] netlink_rcv_skb+0x86/0xb0
[  549.134611]  [<c0877bb7>] genl_rcv+0x17/0x20
[  549.134616]  [<c08766df>] netlink_unicast+0x16f/0x1f0
[  549.134622]  [<c087735c>] netlink_sendmsg+0x1fc/0x300
[  549.134630]  [<c0842005>] sock_sendmsg+0xb5/0xf0
[  549.134639]  [<c08403a8>] ? copy_from_user+0x8/0x10
[  549.134645]  [<c084bd83>] ? verify_iovec+0x53/0xb0
[  549.134652]  [<c0842e05>] __sys_sendmsg+0x2c5/0x2e0
[  549.134659]  [<c0865b59>] ? dev_ioctl+0x99/0x690
[  549.134666]  [<c084862b>] ? skb_dequeue+0x4b/0x70
[  549.134672]  [<c083ffd3>] ? sock_destroy_inode+0x23/0x30
[  549.134678]  [<c083ffd3>] ? sock_destroy_inode+0x23/0x30
[  549.134685]  [<c052d97c>] ? destroy_inode+0x2c/0x50
[  549.134691]  [<c052da8a>] ? evict+0xea/0x180
[  549.134697]  [<c052dbef>] ? iput+0xcf/0x160
[  549.134702]  [<c052a6e9>] ? __d_free+0x29/0x40
[  549.134709]  [<c0842f86>] sys_sendmsg+0x36/0x60
[  549.134716]  [<c0843297>] sys_socketcall+0x107/0x2d0
[  549.134723]  [<c0519588>] ? ____fput+0x8/0x10
[  549.134731]  [<c094184d>] sysenter_do_call+0x12/0x28
[  549.134735] ---[ end trace 7aa6620d94bfffc5 ]---
[  549.138470] ------------[ cut here ]------------

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

