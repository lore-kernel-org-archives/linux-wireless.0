Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:49365 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab1CFUZp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 15:25:45 -0500
Subject: WARN_ON in ieee80211_scan_completed_finish triggered
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Mar 2011 21:25:42 +0100
Message-ID: <1299443142.1292.6.camel@marge>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just noticed the following warning on my p54spi device
with compat-wireless-2011-02-25 (OpenWrt):

[ 1182.077880] cfg80211: Calling CRDA to update world regulatory domain
[ 1182.205261] cfg80211: World regulatory domain updated:
[ 1182.211517] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1182.222381] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1182.232482] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1182.241577] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1182.251129] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1182.260528] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1182.269927] cfg80211: Calling CRDA for country: DE
[ 1182.369659] cfg80211: Regulatory domain changed to country: DE
[ 1182.376586] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 1182.386138] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1182.395385] cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1182.404449] cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 1182.413146] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[ 1182.821472] ------------[ cut here ]------------
[ 1182.826599] WARNING: at /home/mb/develop/svn/openwrt_n810/trunk/build_dir/linux-omap24xx/compat-wireless-2011-02-25/net/mac80211/scan.c:310 ieee80211_rx_bss_free+0x20c/0x4b8 [mac80211]()
[ 1182.845275] Modules linked in: leds_gpio musb_hdrc tahvo_usb nop_usb_xceiv ip6t_REJECT ip6t_LOG ip6t_rt ip6t_hbh ip6t_mh ip6t_ipv6header ip6t_frag ip6t_eui64 ip6t_ah ip6table_raw ip6_queue ip6table_mangle ip6table_filter ip6_tables nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE iptable_nat nf_nat xt_recent xt_helper xt_conntrack xt_connmark xt_connbytes xt_NOTRACK iptable_raw xt_state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack pppoe pppox ipt_REJECT xt_TCPMSS ipt_LOG xt_comment xt_multiport xt_mac xt_limit iptable_mangle iptable_filter ip_tables xt_tcpudp x_tables p54spi tun snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_rawmidi snd_seq_device snd_hwdep snd_page_alloc snd soundcore ppp_async ppp_generic slhc p54common lockd sunrpc mac80211 usbcore exportfs cfg80211 compat arc4 n810bm ecb
[ 1182.929046] [<c0033edc>] (unwind_backtrace+0x0/0xe0) from [<c004f2a4>] (warn_slowpath_common+0x4c/0x64)
[ 1182.939788] [<c004f2a4>] (warn_slowpath_common+0x4c/0x64) from [<c004f2d4>] (warn_slowpath_null+0x18/0x1c)
[ 1182.951171] [<c004f2d4>] (warn_slowpath_null+0x18/0x1c) from [<bf06e700>] (ieee80211_rx_bss_free+0x20c/0x4b8 [mac80211])
[ 1182.963623] [<bf06e700>] (ieee80211_rx_bss_free+0x20c/0x4b8 [mac80211]) from [<c0060fd0>] (process_one_work+0x220/0x374)
[ 1182.975891] [<c0060fd0>] (process_one_work+0x220/0x374) from [<c0063320>] (worker_thread+0x1e4/0x310)
[ 1182.986663] [<c0063320>] (worker_thread+0x1e4/0x310) from [<c0066b54>] (kthread+0x80/0x88)
[ 1182.996154] [<c0066b54>] (kthread+0x80/0x88) from [<c002ffe4>] (kernel_thread_exit+0x0/0x8)
[ 1183.005676] ---[ end trace 9161f9fa8f376438 ]---
[ 1184.886108] wlan0: authenticate with 00:1d:0f:b9:df:2d (try 1)
[ 1184.902191] wlan0: authenticated
[ 1184.903198] wlan0: associate with 00:1d:0f:b9:df:2d (try 1)
[ 1184.909210] wlan0: RX ReassocResp from 00:1d:0f:b9:df:2d (capab=0x411 status=0 aid=3)
[ 1184.909271] wlan0: associated


This is
WARN_ON(local->scanning & (SCAN_SW_SCANNING | SCAN_HW_SCANNING));

-- 
Greetings, Michael.

