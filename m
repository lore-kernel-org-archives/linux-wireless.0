Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39703 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1EWQWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 12:22:03 -0400
Received: by bwz15 with SMTP id 15so4854436bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 09:22:01 -0700 (PDT)
Message-ID: <4DDA89A4.5040101@googlemail.com> (sfid-20110523_182215_244668_2912DC9B)
Date: Mon, 23 May 2011 18:21:56 +0200
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [ath5k] kernel panic while using compat-wireless-2.6.38.2-2
References: <4DCA672E.2080906@googlemail.com>
In-Reply-To: <4DCA672E.2080906@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello linux-wireless list!

Is there really no one with an idea? Is there no one among the 
developers, who is interested in this bug, if it is a bug?

I'm starting to lose my hope...

Dennis

Am 11.05.2011 12:38, schrieb Dennis Borgmann:
> Hello linux-wireless list!
>
> I am using a Sparklan WPEA-166G/W with Chipset AR5BXB63 Rev. 11 (it's 
> a MiniPCI-card) in an embedded X86-System (Pipal 2140U, Intel ATOM 
> processor). It's running voyage-0.6.5, which essentially is a Debian 
> Lenny System.
>
> I am running kernel 2.6.33.9-rt31:
>
> demo00000001:~# uname -a
> Linux SSB_wlan-demo00000001 2.6.33.9-rt31-atom-ssb #1 PREEMPT RT Mon 
> May 9 18:25:28 CEST 2011 i686 GNU/Linux
>
> I installed the compat-wireless drivers version 2.6.38.2-2 ( 
> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.38/compat-wireless-2.6.38.2-2.tar.bz2 
> ) and installed everything I need according to this webpage: 
> http://acx100.erley.org/stable.html
>
> Once issueing modprobe ath5k, putting the interface up and waiting for 
> ~30sec, I get a kernel panic. Could this be a bug or am I doing 
> something wrong?
>
> The error only occurrs after putting the interface up. If I don't do 
> so, the error won't be there.
>
> Here is some output from the machine:
>
> demo00000001:~# modprobe ath5k && ifconfig wlan0 up
> [   48.363894] Compat-wireless backport release: 
> compat-wireless-2.6.38.2-2
> [   48.372351] Backport based on linux-2.6-allstable.git v2.6.38.2
> [   48.411748] cfg80211: Calling CRDA to update world regulatory domain
> [   48.517969] ath5k 0000:09:00.0: using bridge 0000:00:1c.2 INT A to 
> get IRQ 17
> [   48.526919] ath5k 0000:09:00.0: PCI->APIC IRQ transform: INT A -> 
> IRQ 17
> [   48.534315] ath5k 0000:09:00.0: registered as 'phy0'
> [   49.162919] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 
> 0x70)
> demo00000001:~# [   77.953752] ------------[ cut here ]------------
> [   77.958711] WARNING: at 
> /home/dborgmann/downloads/compat-wireless-2.6.38.2-2/net/mac80211/rx.c:2827 
> ieee80211_rx+0x38/0x6fe [mac80211]()
> [   77.971856] Hardware name: Luna Pier CRB
> [   77.976049] Modules linked in: [last unloaded: scsi_wait_scan]
> [   77.982354] Pid: 9, comm: sirq-tasklet/0 Not tainted 
> 2.6.33.9-rt31-atom-ssb #1
> [   77.990090] Call Trace:
> [   77.992732]  [<c011852f>] warn_slowpath_common+0x65/0x7c
> [   77.998419]  [<e0024ad1>] ? ieee80211_rx+0x38/0x6fe [mac80211]
> [   78.004672]  [<c0118553>] warn_slowpath_null+0xd/0x10
> [   78.010119]  [<e0024ad1>] ieee80211_rx+0x38/0x6fe [mac80211]
> [   78.016157]  [<c022d6e8>] ? __alloc_skb+0x4c/0x110
> [   78.021296]  [<c0106297>] ? nommu_map_page+0x3c/0x51
> [   78.026648]  [<e00992c9>] ? ath5k_rx_skb_alloc+0x99/0x10a [ath5k]
> [   78.033190]  [<e009b989>] ath5k_tasklet_rx+0x59f/0x60b [ath5k]
> [   78.039454]  [<c011c486>] __tasklet_action.clone.8+0x76/0xd1
> [   78.045502]  [<c011c529>] tasklet_action+0x23/0x25
> [   78.050640]  [<c011c285>] run_ksoftirqd+0xf0/0x19b
> [   78.055788]  [<c011c195>] ? run_ksoftirqd+0x0/0x19b
> [   78.061032]  [<c0127829>] kthread+0x5e/0x63
> [   78.065538]  [<c01277cb>] ? kthread+0x0/0x63
> [   78.070107]  [<c0102bb6>] kernel_thread_helper+0x6/0x10
> [   78.075695] ---[ end trace 6b864a3c0aa1a8eb ]---
>
>
> Best regards,
> Dennis

