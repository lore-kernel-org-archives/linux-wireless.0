Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs18.mail.saunalahti.fi ([62.142.117.199]:37687 "EHLO
	vs18.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbBNIfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2015 03:35:14 -0500
Message-ID: <54DF08BA.6070907@elisanet.fi> (sfid-20150214_093545_450837_BC0C6BEA)
Date: Sat, 14 Feb 2015 10:35:06 +0200
From: Matti Laakso <malaakso@elisanet.fi>
MIME-Version: 1.0
To: ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	michal.kazior@tieto.com
Subject: Re: [RFT] ath10k: restart fw on tx-credit timeout
References: <DUB122-DS107601B4556EAFBD994B738C250@phx.gbl>
In-Reply-To: <DUB122-DS107601B4556EAFBD994B738C250@phx.gbl>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Afterwards everything seems to be working normally. There was also an
> unexpected router reboot yesterday, but I didn't get any logs from that and
> don't know if it's related. I'll keep testing.
>
> Matti

Turns out the reboots were due to a "Data bus error", which were caused
by cold restarts, as far as I can tell (this is a QCA9558-based router).
I added reset_mode=1 to ath10k_pci parameters, but then this workaround
didn't seem to work anymore (in the log below 20:a9:9b:9e:7c:b0 and
bc:c6:db:14:83:cc are mobile phones and 00:03:7f:48:da:c9 is the ath10k
access point):

Fri Feb 13 14:19:56 2015 daemon.info hostapd: wlan0: STA
20:a9:9b:9e:7c:b0 IEEE 802.11: disassociated due to inactivity
Fri Feb 13 14:19:57 2015 daemon.info hostapd: wlan0: STA
20:a9:9b:9e:7c:b0 IEEE 802.11: deauthenticated due to inactivity (timer
DEAUTH/REMOVE)
Fri Feb 13 14:19:57 2015 kern.warn kernel: [68482.510000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 14:19:57 2015 kern.warn kernel: [68482.610000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 14:19:57 2015 kern.warn kernel: [68482.710000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 14:19:57 2015 kern.warn kernel: [68482.810000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 14:19:57 2015 kern.warn kernel: [68482.920000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 14:19:57 2015 kern.warn kernel: [68483.020000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 14:19:57 2015 kern.warn kernel: [68483.120000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 14:19:58 2015 kern.warn kernel: [68483.220000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 14:19:58 2015 kern.warn kernel: [68483.330000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 14:19:58 2015 kern.warn kernel: [68483.430000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.390000] ------------[
cut here ]------------
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.390000] WARNING: CPU:
0 PID: 2550 at
/home/matti/Projects/openwrt/trunk/openwrt/build_dir/target-mips_34kc_uClibc-0.9.33.2/linux-ar71xx_generic/compat-wir
eless-2014-11-04/net/mac80211/sta_info.c:916
sta_info_move_state+0x580/0x604 [mac80211]()
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.410000] Modules linked
in: ifb pppoe ppp_async iptable_nat ath9k pppox ppp_generic nf_nat_ipv4
nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_MASQUERADE ath9k_co
mmon xt_time xt_tcpudp xt_tcpmss xt_string xt_statistic xt_state
xt_recent xt_nat xt_multiport xt_mark xt_mac xt_limit xt_length xt_id
xt_hl xt_helper xt_ecn xt_dscp xt_conntrack xt_connmark xt_connlimit
xt_connbytes xt_comment xt_TCPMSS xt_REDIRECT xt_LOG xt_HL xt_DSCP xt_CT
xt_CLASSIFY ts_kmp ts_fsm ts_bFri Feb 13 14:20:00 2015 kern.warn kernel:
[68485.510000] CPU: 0 PID: 2550 Comm: hostapd Not tainted
3.14.30 #1
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.520000] Stack :
00000006 00000000 00000000 00000000 00000000 00000000 803bc98e 00000035
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.520000]       85fd7ba0
00000000 802fcad8 80347623 000009f6 803b3b5c 85fd7ba0 00000000
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.520000]       00000004
00000000 00000008 8029e880 00000003 8020040c 00000394 00000000
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.520000]       802ffc9c
85f9dabc 00000000 00000000 00000000 00000000 00000000 00000000
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.520000]       00000000
00000000 00000000 00000000 00000000 00000000 00000000 00000000
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.520000]       ...
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.560000] Call Trace:
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.560000] [<80242644>]
show_stack+0x48/0x70
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.560000] [<802aee18>]
warn_slowpath_common+0x84/0xb4
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.570000] [<802aeed0>]
warn_slowpath_null+0x18/0x24
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.570000] [<872851e0>]
sta_info_move_state+0x580/0x604 [mac80211]
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.580000]
Fri Feb 13 14:20:00 2015 kern.warn kernel: [68485.580000] ---[ end trace
830537c24c03b27c ]---
Fri Feb 13 14:20:00 2015 kern.info kernel: [68485.890000] ieee80211
phy0: Hardware restart was requested
Fri Feb 13 14:20:03 2015 kern.warn kernel: [68488.890000] ath10k_warn:
23 callbacks suppressed
Fri Feb 13 14:20:03 2015 kern.warn kernel: [68488.890000] ath10k_pci
0000:01:00.0: firmware unresponsive, restarting..
Fri Feb 13 14:20:03 2015 kern.warn kernel: [68488.900000] ath10k_pci
0000:01:00.0: failed to put down monitor vdev 1: -11
Fri Feb 13 14:20:06 2015 kern.warn kernel: [68491.900000] ath10k_pci
0000:01:00.0: firmware unresponsive, restarting..
Fri Feb 13 14:20:06 2015 kern.warn kernel: [68491.900000] ath10k_pci
0000:01:00.0: failed to to request monitor vdev 1 stop: -11
Fri Feb 13 14:20:11 2015 kern.warn kernel: [68496.910000] ath10k_pci
0000:01:00.0: failed to synchronise monitor vdev 1: -145
Fri Feb 13 14:20:11 2015 kern.warn kernel: [68496.910000] ath10k_pci
0000:01:00.0: failed to stop monitor vdev: -145
Fri Feb 13 14:20:14 2015 kern.warn kernel: [68499.920000] ath10k_pci
0000:01:00.0: firmware unresponsive, restarting..
Fri Feb 13 14:20:17 2015 kern.info kernel: [68503.020000] ath10k_pci
0000:01:00.0: device successfully recovered
Fri Feb 13 14:20:18 2015 kern.info kernel: [68503.320000] ieee80211
phy0: Hardware restart was requested
Fri Feb 13 14:20:21 2015 kern.warn kernel: [68506.320000] ath10k_pci
0000:01:00.0: firmware unresponsive, restarting..
Fri Feb 13 14:20:21 2015 kern.warn kernel: [68506.320000] ath10k_pci
0000:01:00.0: failed to install key for vdev 0 peer 00:03:7f:48:da:c9: -11
Fri Feb 13 14:20:21 2015 kern.err kernel: [68506.330000] wlan0: failed
to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-11)
Fri Feb 13 14:20:24 2015 kern.warn kernel: [68509.340000] ath10k_pci
0000:01:00.0: firmware unresponsive, restarting..
Fri Feb 13 14:20:24 2015 kern.warn kernel: [68509.340000] ath10k_pci
0000:01:00.0: failed to install key for vdev 0 peer 00:03:7f:48:da:c9: -11
Fri Feb 13 14:20:24 2015 kern.err kernel: [68509.350000] wlan0: failed
to set key (1, ff:ff:ff:ff:ff:ff) to hardware (-11)
Fri Feb 13 14:20:27 2015 kern.warn kernel: [68512.360000] ath10k_pci
0000:01:00.0: firmware unresponsive, restarting..
Fri Feb 13 14:20:30 2015 kern.info kernel: [68515.470000] ath10k_pci
0000:01:00.0: device successfully recovered
Fri Feb 13 14:20:30 2015 kern.info kernel: [68515.770000] ieee80211
phy0: Hardware restart was requested
Fri Feb 13 14:20:33 2015 kern.warn kernel: [68518.770000] ath10k_pci
0000:01:00.0: firmware unresponsive, restarting..
Fri Feb 13 14:20:36 2015 kern.warn kernel: [68521.880000] ath10k_pci
0000:01:00.0: device is wedged, will not restart
Fri Feb 13 14:20:36 2015 kern.warn kernel: [68521.890000] ath10k_pci
0000:01:00.0: failed to install key for vdev 0 peer bc:c6:db:14:83:cc: -70
Fri Feb 13 14:20:36 2015 kern.err kernel: [68521.890000] wlan0: failed
to set key (0, bc:c6:db:14:83:cc) to hardware (-70)
Fri Feb 13 14:20:36 2015 kern.warn kernel: [68521.900000] ath10k_pci
0000:01:00.0: failed to install key for vdev 0 peer 00:03:7f:48:da:c9: -70
Fri Feb 13 14:20:36 2015 kern.err kernel: [68521.910000] wlan0: failed
to set key (2, ff:ff:ff:ff:ff:ff) to hardware (-70)
Fri Feb 13 14:20:36 2015 kern.warn kernel: [68521.920000] ath10k_pci
0000:01:00.0: failed to install key for vdev 0 peer 00:03:7f:48:da:c9: -70
Fri Feb 13 14:20:36 2015 kern.err kernel: [68521.930000] wlan0: failed
to set key (1, ff:ff:ff:ff:ff:ff) to hardware (-70)
Fri Feb 13 14:20:36 2015 kern.warn kernel: [68521.940000] ath10k_pci
0000:01:00.0: failed to install key for vdev 0 peer bc:c6:db:14:83:cc: -70
Fri Feb 13 14:20:36 2015 kern.err kernel: [68521.940000] wlan0: failed
to remove key (0, bc:c6:db:14:83:cc) from hardware (-70)
Fri Feb 13 14:20:36 2015 kern.warn kernel: [68521.950000] ath10k_pci
0000:01:00.0: failed to delete peer bc:c6:db:14:83:cc for vdev 0: -70
Fri Feb 13 14:20:36 2015 daemon.info hostapd: wlan0: STA
bc:c6:db:14:83:cc IEEE 802.11: deauthenticated due to local deauth request
Fri Feb 13 14:20:36 2015 kern.warn kernel: [68521.960000] ath10k_pci
0000:01:00.0: failed to set beacon mode for vdev 0: -70
Fri Feb 13 14:20:36 2015 kern.warn kernel: [68521.970000] ath10k_pci
0000:01:00.0: failed to recalculate rts/cts prot for vdev 0: -70
Fri Feb 13 14:20:38 2015 kern.warn kernel: [68523.820000] ath10k_warn:
17 callbacks suppressed
Fri Feb 13 14:20:38 2015 kern.warn kernel: [68523.830000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 14:20:38 2015 kern.warn kernel: [68523.920000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 14:20:38 2015 kern.warn kernel: [68524.030000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
...

this goes on and on, and the wireless network is not even visible
anymore until I tear down wlan0 and put it back up:

...
Fri Feb 13 16:32:17 2015 kern.warn kernel: [76422.940000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 16:32:22 2015 kern.warn kernel: [76427.240000] ath10k_warn:
45 callbacks suppressed
Fri Feb 13 16:32:22 2015 kern.warn kernel: [76427.240000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 16:32:22 2015 kern.warn kernel: [76427.300000] ath10k_pci
0000:01:00.0: Spurious quick kickout for STA bc:c6:db:14:83:cc
Fri Feb 13 16:32:22 2015 kern.warn kernel: [76427.340000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 16:32:22 2015 kern.warn kernel: [76427.440000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 16:32:22 2015 kern.warn kernel: [76427.550000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 16:32:22 2015 kern.warn kernel: [76427.650000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 16:32:22 2015 kern.warn kernel: [76427.750000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 16:32:22 2015 kern.warn kernel: [76427.850000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 16:32:22 2015 kern.warn kernel: [76427.960000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 16:32:22 2015 kern.warn kernel: [76428.060000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0
Fri Feb 13 16:32:27 2015 kern.info kernel: [76432.210000] device wlan0
left promiscuous mode
Fri Feb 13 16:32:27 2015 kern.info kernel: [76432.220000] br-lan: port
2(wlan0) entered disabled state
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.230000] ------------[
cut here ]------------
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.230000] WARNING: CPU:
0 PID: 2550 at
/home/matti/Projects/openwrt/trunk/openwrt/build_dir/target-mips_34kc_uClibc-0.9.33.2/linux-ar71xx_generic/compat-wir
eless-2014-11-04/net/mac80211/key.c:642 ieee80211_free_keys+0x118/0x1b8
[mac80211]()
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.250000] Modules linked
in: ifb pppoe ppp_async iptable_nat ath9k pppox ppp_generic nf_nat_ipv4
nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_MASQUERADE ath9k_co
mmon xt_time xt_tcpudp xt_tcpmss xt_string xt_statistic xt_state
xt_recent xt_nat xt_multiport xt_mark xt_mac xt_limit xt_length xt_id
xt_hl xt_helper xt_ecn xt_dscp xt_conntrack xt_connmark xt_connlimit
xt_connbytes xt_comment xt_TCPMSS xt_REDIRECT xt_LOG xt_HL xt_DSCP xt_CT
xt_CLASSIFY ts_kmp ts_fsm ts_bFri Feb 13 16:32:27 2015 kern.warn kernel:
[76432.350000] CPU: 0 PID: 2550 Comm: hostapd Tainted: G 
      W    3.14.30 #1
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.360000] Stack :
00000006 00000000 00000000
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.370000] ath10k_warn:
49 callbacks suppressed
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.370000] ath10k_pci
0000:01:00.0: No VIF found for vdev 0
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.380000] ath10k_pci
0000:01:00.0: no vif for vdev_id 0 found
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.380000]  00000000
00000000 00000000 803bc98e 00000040
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.380000]       85fd7ba0
866bb8a4 802fcad8 80347623 000009f6 803b3b5c 85fd7ba0 866bb8a4
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.380000]       872cfe2c
00000000 00000001 8029e880 00000003 80200398 00000282 866bb8a4
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.380000]       802ffc9c
85f9dc44 00000000 00000000 00000000 00000000 00000000 00000000
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.380000]       00000000
00000000 00000000 00000000 00000000 00000000 00000000 00000000
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.380000]       ...
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.420000] Call Trace:
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.420000] [<80242644>]
show_stack+0x48/0x70
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.420000] [<802aee18>]
warn_slowpath_common+0x84/0xb4
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.430000] [<802aeed0>]
warn_slowpath_null+0x18/0x24
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.430000] [<872a69e4>]
ieee80211_free_keys+0x118/0x1b8 [mac80211]
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.440000] [<872921c4>]
ieee80211_del_virtual_monitor+0x67c/0x8fc [mac80211]
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.450000] [<80067a04>]
_cond_resched+0x2c/0x3c
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.450000]
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.450000] ---[ end trace
830537c24c03b27d ]---
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.460000] ath10k_pci
0000:01:00.0: failed to remove peer for AP vdev 0: -70
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.460000] ath10k_pci
0000:01:00.0: No VIF found for vdev 0
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.470000] ath10k_pci
0000:01:00.0: no vif for vdev_id 0 found
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.480000] ath10k_pci
0000:01:00.0: failed to delete WMI vdev 0: -70
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.480000] ath10k_pci
0000:01:00.0: removing stale peer bc:c6:db:14:83:cc from vdev_id 0
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.490000] ath10k_pci
0000:01:00.0: removing stale peer 00:03:7f:48:da:c9 from vdev_id 0
Fri Feb 13 16:32:27 2015 kern.warn kernel: [76432.500000] ath10k_pci
0000:01:00.0: could not suspend target (-70)
Fri Feb 13 16:32:27 2015 daemon.notice netifd: Network device 'wlan0'
link is down
Fri Feb 13 16:32:55 2015 kern.info kernel: [76460.490000] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Fri Feb 13 16:32:55 2015 kern.info kernel: [76460.490000] device wlan0
entered promiscuous mode
Fri Feb 13 16:32:58 2015 kern.info kernel: [76463.170000] br-lan: port
2(wlan0) entered forwarding state
Fri Feb 13 16:32:58 2015 kern.info kernel: [76463.180000] br-lan: port
2(wlan0) entered forwarding state
Fri Feb 13 16:32:58 2015 kern.info kernel: [76463.180000] IPv6:
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Fri Feb 13 16:32:58 2015 daemon.notice netifd: Network device 'wlan0'
link is up
Fri Feb 13 16:32:59 2015 kern.info kernel: [76465.180000] br-lan: port
2(wlan0) entered forwarding state

Matti
