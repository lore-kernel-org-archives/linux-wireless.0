Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40473 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3AaUpe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 15:45:34 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r0VKjXJ8022569
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2013 12:45:33 -0800
Message-ID: <510AD7ED.3060308@candelatech.com> (sfid-20130131_214538_199637_92BFF9CC)
Date: Thu, 31 Jan 2013 12:45:33 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 3.7.5+:  mlme splats
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've got lots of mlme splats, but this one appears to have useful info.
I'm instrumenting the rest before I post...

Test case it two VAPs, one under maximum load by two stations on another machine
sending/receiving UDP frames at max speed.

The local system also has 10 virtual stations, which are not doing much, but
they are quite often bouncing because they cannot get or keep a connection to
their AP on the peer machine (probably due to the excessive traffic on the
local AP).  Getting lots of beacon-loss events on these stations.

I'll be happy to add more debugging if you have suggestions.


Jan 31 12:22:59 localhost dhclient[3584]: DHCPDISCOVER on rddVR15 to 255.255.255.255 port 67 interval 13
Jan 31 12:22:59 localhost dhclient[2193]: DHCPDISCOVER on sta6 to 255.255.255.255 port 67 interval 7
Jan 31 12:23:03 localhost kernel: [ 8009.386786] sta5: deauthenticating from 00:ab:87:60:10:10 by local choice (reason=3)
Jan 31 12:23:03 localhost dhclient[1908]: receive_packet failed on sta5: Network is down
Jan 31 12:23:04 localhost dhclient[1908]: DHCPDISCOVER on sta5 to 255.255.255.255 port 67 interval 7
Jan 31 12:23:04 localhost dhclient[1908]: send_packet: Network is down
Jan 31 12:23:05 localhost ntpd[1263]: Deleting interface #104 sta5, fe80::62b7:38ff:feea:177c#123, interface stats: received=0, sent=0, dropped=0, 
active_time=333 secs
Jan 31 12:23:05 localhost dhclient[2024]: DHCPDISCOVER on sta7 to 255.255.255.255 port 67 interval 8
Jan 31 12:23:06 localhost dhclient[2193]: DHCPDISCOVER on sta6 to 255.255.255.255 port 67 interval 13
Jan 31 12:23:09 localhost kernel: [ 8014.765778] IPv6: ADDRCONF(NETDEV_UP): sta5: link is not ready
Jan 31 12:23:09 localhost kernel: [ 8014.784152] wiphy0: start_sw_scan: running-other-vifs: 2  running-station-vifs: 8, associated-stations: 7 scanning current 
channel: 5180 MHz
Jan 31 12:23:09 localhost kernel: [ 8014.869896] sta5: authenticate with 00:ab:87:60:10:10
Jan 31 12:23:09 localhost kernel: [ 8014.926923] sta5: send auth to 00:ab:87:60:10:10 (try 1/3)
Jan 31 12:23:09 localhost kernel: [ 8015.009639] sta5: authenticated
Jan 31 12:23:09 localhost kernel: [ 8015.026417] ------------[ cut here ]------------
Jan 31 12:23:09 localhost kernel: [ 8015.037577] WARNING: at /home/greearb/git/linux-3.7.dev.y/net/mac80211/mlme.c:1898 ieee80211_sta_rx_queued_mgmt+0x6c5/0x6e0 
[mac80211]()
Jan 31 12:23:09 localhost kernel: [ 8015.062646] Hardware name: To Be Filled By O.E.M.
Jan 31 12:23:09 localhost kernel: [ 8015.073684] sta5: STA 00:ab:87:60:10:10 not found
Jan 31 12:23:09 localhost kernel: [ 8015.078421] Modules linked in: iptable_raw xt_CT nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack bridge 
veth ip_gre gre 8021q garp stp llc fuse macvlan wanlink(O) pktgen nfsv3 nfs_acl nfsv4 auth_rpcgss nfs fscache lockd sunrpc binfmt_misc uinput arc4 ath9k 
mac80211 snd_hda_codec_realtek snd_hda_intel snd_hda_codec iTCO_wdt ath9k_common ath9k_hw snd_hwdep gpio_ich coretemp iTCO_vendor_support snd_seq snd_seq_device 
lpc_ich microcode ath i2c_i801 snd_pcm pcspkr serio_raw cfg80211 snd_timer r8169 snd mii soundcore snd_page_alloc rfkill i915 drm_kms_helper drm i2c_algo_bit 
i2c_core video [last unloaded: iptable_nat]
Jan 31 12:23:09 localhost kernel: [ 8015.246745] Pid: 30271, comm: kworker/u:2 Tainted: G        WC O 3.7.5+ #42
Jan 31 12:23:09 localhost kernel: [ 8015.264002] Call Trace:
Jan 31 12:23:09 localhost kernel: [ 8015.272627]  [<c044411d>] warn_slowpath_common+0x6d/0xa0
Jan 31 12:23:09 localhost kernel: [ 8015.284794]  [<f8b3f3c5>] ? ieee80211_sta_rx_queued_mgmt+0x6c5/0x6e0 [mac80211]
Jan 31 12:23:09 localhost kernel: [ 8015.298691]  [<f8b3f3c5>] ? ieee80211_sta_rx_queued_mgmt+0x6c5/0x6e0 [mac80211]
Jan 31 12:23:09 localhost kernel: [ 8015.312535]  [<c04441ce>] warn_slowpath_fmt+0x2e/0x30
Jan 31 12:23:09 localhost kernel: [ 8015.323785]  [<f8b3f3c5>] ieee80211_sta_rx_queued_mgmt+0x6c5/0x6e0 [mac80211]
Jan 31 12:23:09 localhost kernel: [ 8015.338167]  [<c0830acd>] ? skb_dequeue+0x1d/0x70
Jan 31 12:23:09 localhost kernel: [ 8015.353191]  [<c0933812>] ? _raw_spin_unlock_irqrestore+0x32/0x50
Jan 31 12:23:09 localhost kernel: [ 8015.365995]  [<f8b24b71>] ieee80211_iface_work+0x221/0x310 [mac80211]
Jan 31 12:23:09 localhost kernel: [ 8015.378827]  [<c0459f76>] process_one_work+0x1a6/0x3d0
Jan 31 12:23:09 localhost kernel: [ 8015.390486]  [<c0459f09>] ? process_one_work+0x139/0x3d0
Jan 31 12:23:09 localhost kernel: [ 8015.402080]  [<c045ce58>] ? worker_thread+0x198/0x380
Jan 31 12:23:09 localhost kernel: [ 8015.413327]  [<f8b24950>] ? ieee80211_netdev_select_queue+0x10/0x10 [mac80211]
Jan 31 12:23:09 localhost kernel: [ 8015.426746]  [<c045cdc2>] worker_thread+0x102/0x380
Jan 31 12:23:09 localhost kernel: [ 8015.438404]  [<c046139c>] kthread+0xac/0xb0
Jan 31 12:23:09 localhost kernel: [ 8015.448648]  [<c045ccc0>] ? manage_workers+0x2b0/0x2b0
Jan 31 12:23:09 localhost kernel: [ 8015.459413]  [<c0938977>] ret_from_kernel_thread+0x1b/0x28
Jan 31 12:23:09 localhost kernel: [ 8015.470757]  [<c04612f0>] ? __init_kthread_worker+0x60/0x60
Jan 31 12:23:09 localhost kernel: [ 8015.482155] ---[ end trace c1c50292a57e7ebf ]---
Jan 31 12:23:09 localhost dhclient[1908]: receive_packet failed on sta5: Network is down

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

