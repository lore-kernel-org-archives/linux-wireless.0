Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52725 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab1BPPAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 10:00:39 -0500
Date: Wed, 16 Feb 2011 09:52:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Takashi Kawamoto <tkawamoto@silex.jp>
Cc: linux-wireless@vger.kernel.org, Yoshitaka Imura <imura@silex.jp>,
	Yasuo Bato <bato@silex.jp>, Yuji Sasaki <sasaki@silex.jp>,
	Ryou Matsuura <matsuura@silex.jp>, ath9k-devel@atheros.com
Subject: Re: BUG: AR9271 cause a Kernel Panic on ARM11 SMP environment
Message-ID: <20110216145201.GB10287@tuxdriver.com>
References: <20110216141657.9270.9AD4E5EB@silex.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110216141657.9270.9AD4E5EB@silex.jp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 16, 2011 at 02:17:07PM +0900, Takashi Kawamoto wrote:
> Dear all,
> 
> 
> When I make an AR9271 to perform as an iperf client with 
> compat-wireless-2011-01-30, a Kernel Panic occurs.
> 
> [log]
> =======================================================================
> BUG: spinlock lockup on CPU#1, iperf/552, 9f9aade4
> [<80030ca4>] (unwind_backtrace+0x0/0xdc) from [<801835ac>] (do_raw_spin_lock+0x14c/0x168)
> [<801835ac>] (do_raw_spin_lock+0x14c/0x168) from [<802e47c0>] (_raw_spin_lock_irqsave+0x10/0x18)
> [<802e47c0>] (_raw_spin_lock_irqsave+0x10/0x18) from [<7f17218c>] (hif_usb_send+0x34/0x26c [ath9k_htc])
> [<7f17218c>] (hif_usb_send+0x34/0x26c [ath9k_htc]) from [<7f17153c>] (htc_issue_send+0x64/0x6c [ath9k_htc])
> [<7f17153c>] (htc_issue_send+0x64/0x6c [ath9k_htc]) from [<7f171564>] (htc_send+0x20/0x24 [ath9k_htc])
> [<7f171564>] (htc_send+0x20/0x24 [ath9k_htc]) from [<7f1746d4>] (ath9k_htc_tx_start+0x23c/0x244 [ath9k_htc])
> [<7f1746d4>] (ath9k_htc_tx_start+0x23c/0x244 [ath9k_htc]) from [<7f1751c8>] (ath9k_htc_tx+0x7c/0xcc [ath9k_htc])
> [<7f1751c8>] (ath9k_htc_tx+0x7c/0xcc [ath9k_htc]) from [<7f0c50d4>] (__ieee80211_tx+0x124/0x194 [mac80211])
> [<7f0c50d4>] (__ieee80211_tx+0x124/0x194 [mac80211]) from [<7f0c51e4>] (ieee80211_tx+0xa0/0x1e0 [mac80211])
> [<7f0c51e4>] (ieee80211_tx+0xa0/0x1e0 [mac80211]) from [<7f0c6590>] (ieee80211_subif_start_xmit+0x6c0/0x6f8 [mac80211])
> [<7f0c6590>] (ieee80211_subif_start_xmit+0x6c0/0x6f8 [mac80211]) from [<80269220>] (dev_hard_start_xmit+0x1f8/0x2e0)
> [<80269220>] (dev_hard_start_xmit+0x1f8/0x2e0) from [<8027878c>] (sch_direct_xmit+0x70/0x1c8)
> [<8027878c>] (sch_direct_xmit+0x70/0x1c8) from [<802696e0>] (dev_queue_xmit+0x290/0x428)
> [<802696e0>] (dev_queue_xmit+0x290/0x428) from [<80287320>] (ip_finish_output+0x250/0x2a8)
> [<80287320>] (ip_finish_output+0x250/0x2a8) from [<80285178>] (ip_local_out+0x24/0x28)
> [<80285178>] (ip_local_out+0x24/0x28) from [<80286cac>] (ip_queue_xmit+0x2f4/0x35c)
> [<80286cac>] (ip_queue_xmit+0x2f4/0x35c) from [<80299010>] (tcp_transmit_skb+0x74c/0x7b8)
> [<80299010>] (tcp_transmit_skb+0x74c/0x7b8) from [<8029b5dc>] (tcp_write_xmit+0x860/0x978)
> [<8029b5dc>] (tcp_write_xmit+0x860/0x978) from [<8029b730>] (tcp_push_one+0x3c/0x48)
> [<8029b730>] (tcp_push_one+0x3c/0x48) from [<8028f840>] (tcp_sendmsg+0x864/0xaa4)
> [<8028f840>] (tcp_sendmsg+0x864/0xaa4) from [<80258ecc>] (sock_aio_write+0xe0/0xe8)
> [<80258ecc>] (sock_aio_write+0xe0/0xe8) from [<800bba20>] (do_sync_write+0x94/0xe0)
> [<800bba20>] (do_sync_write+0x94/0xe0) from [<800bc460>] (vfs_write+0xc4/0x154)
> [<800bc460>] (vfs_write+0xc4/0x154) from [<800bc59c>] (sys_write+0x3c/0x68)
> [<800bc59c>] (sys_write+0x3c/0x68) from [<8002a220>] (ret_fast_syscall+0x0/0x2c)
> =======================================================================

My guess would be that somehow you are leaking hif_dev->tx.tx_lock,
and then hanging when trying to retake it in hif_usb_send_tx.
Unfortunately, it is not obvious to me how that might happen...

> An environment of AR9271's host is as follows.
> 
> [Host Environment]
> =======================================================================
> CPU         : ARM11MP
> Kernel      : 2.6.33 (SMP enabled)
> Distribution: Zoran Quatro inferno
> =======================================================================
> 
> As long as I see, this panic happens under the following conditions.
> 
> (1) When sending a data frame
>     When AR9271 performs as an iperf server, this panic appears less 
>     frequently than as a client.
> 
> (1) When transmission throughput is relatively high
>     For example, this panic never seems to appear when Ping 
>     communication is performed.
> 
> (2) When multi processor mode is enabled
>     When SMP option of the kernel is disabled (CONFIG_SMP=m), this 
>     panic doesn't occur.
> 
> I've not duplicated the same on a x86 environment yet.
> 
> I suspect that spinlock usage in Tx routines of ath9k/hif_usb.c must 
> have something to do with this panic.
> 
> Have anyone come across the similar crash as this?
> 
> 
> 
> Best Regards,
> Takashi Kawamoto
> 
> ==================================================
>  Takashi Kawamoto (E-Mail : tkawamoto@silex.jp)
>  silex technology,Inc. 
>  Software Engineering Division
>  Phone:+81-774-98-3877 FAX:+81-774-98-3678
> ==================================================
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
