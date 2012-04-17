Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kingswood-consulting.co.uk ([88.97.16.53]:44375 "EHLO
	andromeda.kingswood-consulting.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755911Ab2DQMYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 08:24:41 -0400
Message-ID: <4F8D60FC.2090301@kingswood-consulting.co.uk> (sfid-20120417_142444_863320_2FA2B86C)
Date: Tue, 17 Apr 2012 13:24:28 +0100
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Kernel panic with brcm4313 (kernel 3.2.2)
References: <jgjoab$l54$1@dough.gmane.org> <4F2E6C34.6060903@broadcom.com> <4F2E9651.5020601@kingswood-consulting.co.uk> <4F8D471F.5070901@broadcom.com>
In-Reply-To: <4F8D471F.5070901@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,
> I noticed in some log you sent that your regulatory domain is set to GB, 
> which makes sense. I submitted a patch [1] last week so could you try that 
> and let me know the results.
[re-sending as plain text]

Thanks for the update. Yes, my AP is on channel 13 so might be affected by this.

But there is the other issue where the driver only shows one AP (seems to be 
the one with highest received power) when I do iw dev wlan0 scan (or the same 
with NetworkManager). Your patch does not touch this area and this still occurs.

I've applied your tx dma resume patch on top of 3.3.1 and tried to connect 
with NM.
No luck connecting, and also got a kernel WARNING:

Apr 17 13:10:24 ceres kernel: ------------[ cut here ]------------
Apr 17 13:10:24 ceres kernel: WARNING: at 
drivers/net/wireless/brcm80211/brcmsmac/main.c:8006 
brcms_c_wait_for_tx_completion+0x91/0xa0 [brcmsmac]()
Apr 17 13:10:24 ceres kernel: Hardware name: 305U1A
Apr 17 13:10:24 ceres kernel: Modules linked in: powernow_k8 mperf 
cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_conservative 
xt_recent nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp 
iptable_filter ip_tables x_tables fuse arc4 brcmsmac brcmutil bcma mac80211 
cfg80211 loop video battery ac processor thermal_sys button sd_mod ahci 
libahci libata scsi_mod
Apr 17 13:10:24 ceres kernel: Pid: 3938, comm: wpa_supplicant Not tainted 
3.3.1+ #20
Apr 17 13:10:24 ceres kernel: Call Trace:
Apr 17 13:10:24 ceres kernel: [<ffffffff8102c87b>] ? 
warn_slowpath_common+0x7b/0xc0
Apr 17 13:10:24 ceres kernel: [<ffffffffa0121c01>] ? 
brcms_c_wait_for_tx_completion+0x91/0xa0 [brcmsmac]
Apr 17 13:10:24 ceres kernel: [<ffffffffa0114212>] ? 
brcms_ops_flush+0x32/0x50 [brcmsmac]
Apr 17 13:10:24 ceres kernel: [<ffffffffa00ebec5>] ? 
__ieee80211_recalc_idle+0x1f5/0x230 [mac80211]
Apr 17 13:10:24 ceres kernel: [<ffffffffa00ece6c>] ? 
ieee80211_recalc_idle+0x2c/0x70 [mac80211]
Apr 17 13:10:24 ceres kernel: [<ffffffffa00e8e4c>] ? 
ieee80211_mgd_disassoc+0xec/0x110 [mac80211]
Apr 17 13:10:24 ceres kernel: [<ffffffffa00b907d>] ? 
cfg80211_mlme_disassoc+0xfd/0x150 [cfg80211]
Apr 17 13:10:24 ceres kernel: [<ffffffffa00a89b5>] ? 
nl80211_disassociate+0xc5/0x100 [cfg80211]
Apr 17 13:10:24 ceres kernel: [<ffffffff81372bbc>] ? genl_rcv_msg+0x1cc/0x240
Apr 17 13:10:24 ceres kernel: [<ffffffff813729f0>] ? genl_rcv+0x30/0x30
Apr 17 13:10:24 ceres kernel: [<ffffffff81372551>] ? netlink_rcv_skb+0x91/0xb0
Apr 17 13:10:24 ceres kernel: [<ffffffff813729df>] ? genl_rcv+0x1f/0x30
Apr 17 13:10:24 ceres kernel: [<ffffffff81371ef1>] ? netlink_unicast+0x1a1/0x1f0
Apr 17 13:10:24 ceres kernel: [<ffffffff813721f9>] ? netlink_sendmsg+0x2b9/0x310
Apr 17 13:10:24 ceres kernel: [<ffffffff8134206e>] ? sock_sendmsg+0xde/0x110
Apr 17 13:10:24 ceres kernel: [<ffffffff8134206e>] ? sock_sendmsg+0xde/0x110
Apr 17 13:10:24 ceres kernel: [<ffffffff813447bd>] ? 
move_addr_to_kernel+0x3d/0x50
Apr 17 13:10:24 ceres kernel: [<ffffffff8134f0ae>] ? verify_iovec+0x4e/0xd0
Apr 17 13:10:24 ceres kernel: [<ffffffff81343a36>] ? __sys_sendmsg+0x366/0x370
Apr 17 13:10:24 ceres kernel: [<ffffffff81007013>] ? emulate_vsyscall+0x213/0x2d0
Apr 17 13:10:24 ceres kernel: [<ffffffff810ae42c>] ? handle_mm_fault+0x4c/0x260
Apr 17 13:10:24 ceres kernel: [<ffffffff813450ee>] ? sys_sendto+0x13e/0x1a0
Apr 17 13:10:24 ceres kernel: [<ffffffff810606ed>] ? ktime_get_ts+0x6d/0xe0
Apr 17 13:10:24 ceres kernel: [<ffffffff810e8e1f>] ? 
poll_select_copy_remaining+0xff/0x150
Apr 17 13:10:24 ceres kernel: [<ffffffff81345534>] ? sys_sendmsg+0x44/0x80
Apr 17 13:10:24 ceres kernel: [<ffffffff81401d62>] ? 
system_call_fastpath+0x16/0x1b
Apr 17 13:10:24 ceres kernel: ---[ end trace 420dd744f04101fd ]---
Apr 17 13:10:24 ceres kernel: cfg80211: Calling CRDA for country: US
Apr 17 13:10:24 ceres kernel: cfg80211: Regulatory domain changed to country: US
Apr 17 13:10:24 ceres kernel: cfg80211:   (start_freq - end_freq @ 
bandwidth), (max_antenna_gain, max_eirp)
Apr 17 13:10:24 ceres kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 
KHz), (300 mBi, 2700 mBm)
Apr 17 13:10:24 ceres kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 
KHz), (300 mBi, 1700 mBm)
Apr 17 13:10:24 ceres kernel: cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 
KHz), (300 mBi, 2000 mBm)
Apr 17 13:10:24 ceres kernel: cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 
KHz), (300 mBi, 2000 mBm)
Apr 17 13:10:24 ceres kernel: cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 
KHz), (300 mBi, 2000 mBm)
Apr 17 13:10:24 ceres kernel: cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 
KHz), (300 mBi, 3000 mBm)
Apr 17 13:10:24 ceres kernel: cfg80211: Calling CRDA for country: GB
Apr 17 13:10:24 ceres kernel: cfg80211: Regulatory domain changed to country: GB
Apr 17 13:10:24 ceres kernel: cfg80211:   (start_freq - end_freq @ 
bandwidth), (max_antenna_gain, max_eirp)
Apr 17 13:10:24 ceres kernel: cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 
KHz), (N/A, 2000 mBm)
Apr 17 13:10:24 ceres kernel: cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 
KHz), (N/A, 2000 mBm)
Apr 17 13:10:24 ceres kernel: cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 
KHz), (N/A, 2000 mBm)
Apr 17 13:10:24 ceres kernel: cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 
KHz), (N/A, 2700 mBm)
Apr 17 13:10:24 ceres kernel: cfg80211: Calling CRDA to update world 
regulatory domain
Apr 17 13:10:24 ceres kernel: cfg80211: World regulatory domain updated:
Apr 17 13:10:24 ceres kernel: cfg80211:   (start_freq - end_freq @ 
bandwidth), (max_antenna_gain, max_eirp)
Apr 17 13:10:24 ceres kernel: cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 
KHz), (300 mBi, 2000 mBm)
Apr 17 13:10:24 ceres kernel: cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 
KHz), (300 mBi, 2000 mBm)
Apr 17 13:10:24 ceres kernel: cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 
KHz), (300 mBi, 2000 mBm)

That line is in brcms_c_wait_for_tx_completion()

main.c,8006         WARN_ON_ONCE(timeout == 0);

Would using another channel be any different for this?

Thanks,

Frank

