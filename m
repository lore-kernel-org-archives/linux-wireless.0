Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:50243 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaEZIBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 04:01:34 -0400
Date: Mon, 26 May 2014 18:01:10 +1000
From: James Cameron <quozl@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mwifiex: block work queue while suspended
Message-ID: <20140526080110.GJ6118@us.netrek.org> (sfid-20140526_100138_470862_ED62A037)
References: <20140516012439.GI15430@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5D8ED@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F70F5D8ED@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2014 at 08:50:02PM -0700, Bing Zhao wrote:
> Hi James,
> 
> > The work queue may execute after the device is suspended, leading to
> > SDIO register I/O over a suspend and resume of the system.  With a
> > WARN_ON in mwifiex_write_data_to_card we see:
> > 
> > [ 2115.351137] PM: suspend of devices complete after 15.989 msecs
> > [ 2115.366047] mwifiex_sdio mmc0:0001:1: mwifiex_write_data_sync: not allowed while suspended
> > [ 2115.366067] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (1) failed: -1
> > [ 2115.386023] PM: late suspend of devices complete after 34.845 msecs
> > [ 2115.386303] PM: noirq suspend of devices complete after 0.272 msecs
> > [ 2115.386388] before suspend
> > [ 2115.387824] after resume
> > [ 2115.388618] PM: noirq resume of devices complete after 0.745 msecs
> > [ 2115.407641] PM: early resume of devices complete after 18.849 msecs
> > [ 2125.397532] mmc0: Timeout waiting for hardware interrupt.
> > [ 2125.397559] mwifiex_sdio mmc0:0001:1: write CFG reg failed
> > [ 2125.397575] ------------[ cut here ]------------
> > [ 2125.397575] WARNING: at drivers/net/wireless/mwifiex/sdio.c:485
> > mwifiex_write_data_to_card+0x98/0xc4 [mwifiex_sdio]()
> > [ 2125.397746] [<bf0eb34c>] (mwifiex_host_to_card_mp_aggr+0x354/0x46c [mwifiex_sdio])
> > [ 2125.397746] [<bf0eb5f4>] (mwifiex_sdio_host_to_card+0x190/0x234 [mwifiex_sdio])
> > [ 2125.397788] [<bf0bed00>] (mwifiex_process_tx+0x90/0x1a0 [mwifiex])
> > [ 2125.397823] [<bf0bf8a0>] (mwifiex_send_single_packet+0x134/0x2b0 [mwifiex])
> > [ 2125.397857] [<bf0c074c>] (mwifiex_wmm_process_tx+0x76c/0x800 [mwifiex])
> > [ 2125.397887] [<bf0ba3f8>] (mwifiex_main_process+0x344/0x504 [mwifiex])
> > [ 2125.397913] [<bf0ba5e0>] (mwifiex_main_work_queue+0x28/0x2c [mwifiex])
> > [ 2125.397949] [<c00409fc>] (process_one_work+0x260/0x488)
> > [ 2125.397949] [<c0040e40>] (worker_thread+0x1e0/0x32c)
> > [ 2125.397979] [<c00464d0>] (kthread+0x9c/0xac)
> > [ 2125.397979] ---[ end trace 86d7b628a6c8ddd0 ]---
> > ---
> > 
> > Test environment is an OLPC XO-4 doing one sleep every few seconds,
> > with the device configured to wake the system, with constant ping by
> > another host.  Kernel is 3.5 with many backported mwifiex patches.
> > 
> > We also see that an SDIO interrupt from the device may occur after all
> > devices are suspended, leading to a similar symptom:
> 
> To understand what is happening here could you apply attached debug
> patch to generate logs, or enable dynamic_debug for that?

Here's a dynamic_debug log.

Note the point of failure is the "mmc0: Timeout waiting for hardware
interrupt." message, which occurs in the driver SDIO interrupt
function, which began execution in a critical time period after driver
suspend but before platform suspend.

We use a GPIO to wake from WLAN.

May 26 07:44:33 xo-96-6d-f4 kernel: [  188.090061] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.113049] Suspending console(s) (use no_console_suspend to debug)
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.119533] usb 1-1: usb auto-resume
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133318] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133332] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0080
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133339] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133347] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0080
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133353] mwifiex_sdio mmc0:0001:1: data: port=7 mp_rd_bitmap=0x0080 -> 0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133366] mwifiex_sdio mmc0:0001:1: info: RX: port=7 rx_len=1508
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133375] mwifiex_sdio mmc0:0001:1: info: rx_len = 1536 skb->len = 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133381] mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: last packet
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133381] mwifiex_sdio mmc0:0001:1: info: RX: port: 7, rx_len: 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133474] mwifiex_sdio mmc0:0001:1: info: --- Rx: Data packet ---
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133529] mwifiex_sdio mmc0:0001:1: data: 4294956098 BSS(0-0): Data <= kernel
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133548] mwifiex: data: packet type ETH_P_IP: 0008, tid=0x0 prio=0x0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133567] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133572] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133581] mwifiex_sdio mmc0:0001:1: data: tid=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133589] mwifiex_sdio mmc0:0001:1: data: dequeuing the packet cc7f0400 cc3cf840
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133598] mwifiex_sdio mmc0:0001:1: data: WMM: Pkt Delay: 0 ms, 0 ms sent to FW
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133604] mwifiex_sdio mmc0:0001:1: data: mp_wr_bitmap=0x3f81
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133611] mwifiex_sdio mmc0:0001:1: data: port=7 mp_wr_bitmap=0x3f81 -> 0x3f01
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133611] mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.133624] mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 7
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.150049] pxau2o-ehci d4208000.usb: GetStatus port:1 status 8001205 4  ACK POWER sig=se0 LPM PE CONNECT
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155165] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155165] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0100
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155172] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155178] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0100
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155184] mwifiex_sdio mmc0:0001:1: data: port=8 mp_rd_bitmap=0x0100 -> 0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155191] mwifiex_sdio mmc0:0001:1: info: RX: port=8 rx_len=1508
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155197] mwifiex_sdio mmc0:0001:1: info: rx_len = 1536 skb->len = 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155210] mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: last packet
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155216] mwifiex_sdio mmc0:0001:1: info: RX: port: 8, rx_len: 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155309] mwifiex_sdio mmc0:0001:1: info: --- Rx: Data packet ---
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155349] mwifiex_sdio mmc0:0001:1: data: 4294956100 BSS(0-0): Data <= kernel
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155361] mwifiex: data: packet type ETH_P_IP: 0008, tid=0x0 prio=0x0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155383] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155383] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155388] mwifiex_sdio mmc0:0001:1: data: tid=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155395] mwifiex_sdio mmc0:0001:1: data: dequeuing the packet cc7f0400 cc612540
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155405] mwifiex_sdio mmc0:0001:1: data: WMM: Pkt Delay: 0 ms, 0 ms sent to FW
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155418] mwifiex_sdio mmc0:0001:1: data: mp_wr_bitmap=0x3f01
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155418] mwifiex_sdio mmc0:0001:1: data: port=8 mp_wr_bitmap=0x3f01 -> 0x3e01
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155431] mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.155431] mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 8
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.170038] usb 1-1: finish resume
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.170530] hub 1-1:1.0: hub_resume
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.171655] pxau2o-ehci d4208000.usb: reused qh cc319280 schedule
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.171677] usb 1-1: link qh256-0001/cc319280 start 23 [1/0 us]
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.171687] hub 1-1:1.0: hub_suspend
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.171719] usb 1-1: unlink qh256-0001/cc319280 start 23 [1/0 us]
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.171719] usb 1-1: usb suspend, wakeup 0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.176965] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.176965] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0200
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.176979] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.176979] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0200
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.176985] mwifiex_sdio mmc0:0001:1: data: port=9 mp_rd_bitmap=0x0200 -> 0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.176992] mwifiex_sdio mmc0:0001:1: info: RX: port=9 rx_len=1508
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.176998] mwifiex_sdio mmc0:0001:1: info: rx_len = 1536 skb->len = 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177006] mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: last packet
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177013] mwifiex_sdio mmc0:0001:1: info: RX: port: 9, rx_len: 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177105] mwifiex_sdio mmc0:0001:1: info: --- Rx: Data packet ---
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177148] mwifiex_sdio mmc0:0001:1: data: 4294956102 BSS(0-0): Data <= kernel
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177160] mwifiex: data: packet type ETH_P_IP: 0008, tid=0x0 prio=0x0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177182] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177182] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177187] mwifiex_sdio mmc0:0001:1: data: tid=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177195] mwifiex_sdio mmc0:0001:1: data: dequeuing the packet cc7f0400 cc3cf840
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177204] mwifiex_sdio mmc0:0001:1: data: WMM: Pkt Delay: 0 ms, 0 ms sent to FW
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177211] mwifiex_sdio mmc0:0001:1: data: mp_wr_bitmap=0x3e01
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177217] mwifiex_sdio mmc0:0001:1: data: port=9 mp_wr_bitmap=0x3e01 -> 0x3c01
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177225] mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.177237] mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 9
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.190362] hub 1-0:1.0: hub_suspend
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.190394] usb usb1: bus suspend, wakeup 0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.190408] pxau2o-ehci d4208000.usb: suspend root hub
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.190865] dcon_source_switch to DCON
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198743] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198757] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0400
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198771] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198771] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0400
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198777] mwifiex_sdio mmc0:0001:1: data: port=10 mp_rd_bitmap=0x0400 -> 0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198784] mwifiex_sdio mmc0:0001:1: info: RX: port=10 rx_len=1508
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198790] mwifiex_sdio mmc0:0001:1: info: rx_len = 1536 skb->len = 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198803] mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: last packet
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198815] mwifiex_sdio mmc0:0001:1: info: RX: port: 10, rx_len: 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198903] mwifiex_sdio mmc0:0001:1: info: --- Rx: Data packet ---
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198952] mwifiex_sdio mmc0:0001:1: data: 4294956104 BSS(0-0): Data <= kernel
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198965] mwifiex: data: packet type ETH_P_IP: 0008, tid=0x0 prio=0x0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198987] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.198987] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.199000] mwifiex_sdio mmc0:0001:1: data: tid=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.199008] mwifiex_sdio mmc0:0001:1: data: dequeuing the packet cc7f0400 cc612540
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.199017] mwifiex_sdio mmc0:0001:1: data: WMM: Pkt Delay: 0 ms, 0 ms sent to FW
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.199017] mwifiex_sdio mmc0:0001:1: data: mp_wr_bitmap=0x3c01
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.199023] mwifiex_sdio mmc0:0001:1: data: port=10 mp_wr_bitmap=0x3c01 -> 0x3801
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.199031] mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.199037] mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 10
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.219356] olpc-dcon: missed loading, retrying
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220537] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220550] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0800
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220557] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220564] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0800
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220570] mwifiex_sdio mmc0:0001:1: data: port=11 mp_rd_bitmap=0x0800 -> 0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220577] mwifiex_sdio mmc0:0001:1: info: RX: port=11 rx_len=1508
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220590] mwifiex_sdio mmc0:0001:1: info: rx_len = 1536 skb->len = 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220596] mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: last packet
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220602] mwifiex_sdio mmc0:0001:1: info: RX: port: 11, rx_len: 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220700] mwifiex_sdio mmc0:0001:1: info: --- Rx: Data packet ---
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220731] mwifiex_sdio mmc0:0001:1: data: 4294956107 BSS(0-0): Data <= kernel
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220742] mwifiex: data: packet type ETH_P_IP: 0008, tid=0x0 prio=0x0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220749] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220760] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220766] mwifiex_sdio mmc0:0001:1: data: tid=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220781] mwifiex_sdio mmc0:0001:1: data: dequeuing the packet cc7f0400 cc3cf840
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220782] mwifiex_sdio mmc0:0001:1: data: WMM: Pkt Delay: 0 ms, 0 ms sent to FW
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220790] mwifiex_sdio mmc0:0001:1: data: mp_wr_bitmap=0x3801
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220796] mwifiex_sdio mmc0:0001:1: data: port=11 mp_wr_bitmap=0x3801 -> 0x3001
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220803] mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.220816] mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 11
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242288] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242301] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x1000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242307] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242320] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x1000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242327] mwifiex_sdio mmc0:0001:1: data: port=12 mp_rd_bitmap=0x1000 -> 0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242333] mwifiex_sdio mmc0:0001:1: info: RX: port=12 rx_len=1508
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242343] mwifiex_sdio mmc0:0001:1: info: rx_len = 1536 skb->len = 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242343] mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: last packet
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242356] mwifiex_sdio mmc0:0001:1: info: RX: port: 12, rx_len: 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242443] mwifiex_sdio mmc0:0001:1: info: --- Rx: Data packet ---
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242481] mwifiex_sdio mmc0:0001:1: data: 4294956109 BSS(0-0): Data <= kernel
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242492] mwifiex: data: packet type ETH_P_IP: 0008, tid=0x0 prio=0x0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242499] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242509] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242515] mwifiex_sdio mmc0:0001:1: data: tid=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242522] mwifiex_sdio mmc0:0001:1: data: dequeuing the packet cc7f0400 cc612540
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242531] mwifiex_sdio mmc0:0001:1: data: WMM: Pkt Delay: 0 ms, 0 ms sent to FW
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242538] mwifiex_sdio mmc0:0001:1: data: mp_wr_bitmap=0x3001
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242544] mwifiex_sdio mmc0:0001:1: data: port=12 mp_wr_bitmap=0x3001 -> 0x2001
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242551] mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.242557] mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 12
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264063] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264070] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x2000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264070] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264082] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x2000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264090] mwifiex_sdio mmc0:0001:1: data: port=13 mp_rd_bitmap=0x2000 -> 0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264096] mwifiex_sdio mmc0:0001:1: info: RX: port=13 rx_len=1508
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264096] mwifiex_sdio mmc0:0001:1: info: rx_len = 1536 skb->len = 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264104] mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: last packet
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264110] mwifiex_sdio mmc0:0001:1: info: RX: port: 13, rx_len: 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264214] mwifiex_sdio mmc0:0001:1: info: --- Rx: Data packet ---
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264241] mwifiex_sdio mmc0:0001:1: data: 4294956111 BSS(0-0): Data <= kernel
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264257] mwifiex: data: packet type ETH_P_IP: 0008, tid=0x0 prio=0x0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264259] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264270] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264275] mwifiex_sdio mmc0:0001:1: data: tid=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264282] mwifiex_sdio mmc0:0001:1: data: dequeuing the packet cc7f0400 cc3cf840
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264298] mwifiex_sdio mmc0:0001:1: data: WMM: Pkt Delay: 0 ms, 0 ms sent to FW
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264298] mwifiex_sdio mmc0:0001:1: data: mp_wr_bitmap=0x2001
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264304] mwifiex_sdio mmc0:0001:1: data: port=13 mp_wr_bitmap=0x2001 -> 0x0001
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264311] mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264317] mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 13
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264595] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x2
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264606] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264613] mwifiex_sdio mmc0:0001:1: int: DNLD: wr_bitmap=0xffff
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264624] mwifiex_sdio mmc0:0001:1: info:  <--- Tx DONE Interrupt --->
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.264624] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.285883] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.285895] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x4000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.285901] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.285908] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x4000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.285914] mwifiex_sdio mmc0:0001:1: data: port=14 mp_rd_bitmap=0x4000 -> 0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.285927] mwifiex_sdio mmc0:0001:1: info: RX: port=14 rx_len=1508
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.285927] mwifiex_sdio mmc0:0001:1: info: rx_len = 1536 skb->len = 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.285944] mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: last packet
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.285950] mwifiex_sdio mmc0:0001:1: info: RX: port: 14, rx_len: 1536
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.286037] mwifiex_sdio mmc0:0001:1: info: --- Rx: Data packet ---
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.286075] mwifiex_sdio mmc0:0001:1: data: 4294956113 BSS(0-0): Data <= kernel
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.286087] mwifiex: data: packet type ETH_P_IP: 0008, tid=0x0 prio=0x0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.286094] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.286105] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.286110] mwifiex_sdio mmc0:0001:1: data: tid=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.286124] mwifiex_sdio mmc0:0001:1: data: dequeuing the packet cc7f0400 cc612540
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.286126] mwifiex_sdio mmc0:0001:1: data: WMM: Pkt Delay: 0 ms, 0 ms sent to FW
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.286139] mwifiex_sdio mmc0:0001:1: data: mp_wr_bitmap=0xffff
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.286139] mwifiex_sdio mmc0:0001:1: data: port=14 mp_wr_bitmap=0xffff -> 0xbfff
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.286152] mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.286152] mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 14
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.302676] olpc-dcon: The DCON has control
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.302876] mmp3_usb_phy_deinit_internal: Deinit usb phy!!!
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.302982] mmc2: dropping power over suspend
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.303013] mmc1: dropping power over suspend
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304049] mwifiex_sdio: cmd: mmc0:0001:1: suspend: PM flag = 0x3
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304049] mwifiex_sdio mmc0:0001:1: cmd: HS_CFG_CMD: condition:0xa gpio:0xff gap:0xff
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304072] mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xe5, cmd_pending=1
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304083] mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1401090251.944017): 0xe5, act 0x1, len 16, seqno 0x5f
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304094] mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304109] mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304257] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304275] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304275] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304282] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304294] mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304294] mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=20
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304300] mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304308] mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304315] mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304350] mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304361] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304367] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304375] mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1401090251.944317): 0x80e5, result 0, len 16, seqno 0x5f
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304385] mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: HS_CFG cmd reply result=0x0, conditions=0xa gpio=0xff gap=0xff
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304401] mwifiex_sdio mmc0:0001:1: cmd completed: status=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304413] mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xe5, cmd_pending=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304473] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304473] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304479] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304486] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304491] mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304497] mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=10
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304503] mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304510] mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304516] mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304552] mwifiex_sdio mmc0:0001:1: info: --- Rx: Event ---
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304563] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304569] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304577] mwifiex_sdio mmc0:0001:1: event: 1401090251.944519: cause: 0x47
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304586] mwifiex_sdio mmc0:0001:1: event: HS_ACT_REQ
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304592] mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xe5, cmd_pending=1
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304607] mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1401090251.944545): 0xe5, act 0x2, len 16, seqno 0x60
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304616] mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304623] mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304764] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304775] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304781] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304788] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304793] mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304805] mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=20
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304805] mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304812] mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304818] mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304853] mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304869] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304869] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304886] mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1401090251.944819): 0x80e5, result 0, len 16, seqno 0x60
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304886] mwifiex_sdio mmc0:0001:1: event: hs_activated
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304903] mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xe5, cmd_pending=0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.304907] mwifiex_sdio: cmd: suspend with MMC_PM_KEEP_POWER|MMC_PM_WAKE_SDIO_IRQ
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307736] mmc0: keeping power over suspend
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307736] sdhci_wakeup_irq
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307749] sdhci_wakeup_irq
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307749] sdhci_wakeup_irq
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307751] sdhci_wakeup_irq
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307753] [galcore] enter gpu_suspend
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307793] [galcore] exit gpu_suspend, return 0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.307859] PM: suspend of devices complete after 194.744 msecs
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.320018] olpc_ec_1_75_suspend: suspend sync 0000001f
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.340038] PM: late suspend of devices complete after 32.172 msecs
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.340307] PM: noirq suspend of devices complete after 0.263 msecs
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.340417] mmp3_pm_enter_d2
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.340417] before suspend
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.340430] after resume
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.372814] PM: noirq resume of devices complete after 0.098 msecs
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.391862] PM: early resume of devices complete after 18.934 msecs
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.391873] [galcore] enter gpu_resume
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396056] [galcore] exit gpu_resume, return 0
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396056] sdhci_wakeup_irq
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396070] sdhci_wakeup_irq
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396072] sdhci_wakeup_irq
May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396074] sdhci_wakeup_irq
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341764] mmc0: Timeout waiting for hardware interrupt.
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341784] mwifiex_sdio mmc0:0001:1: read mp_regs failed
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341909] mwifiex_sdio mmc0:0001:1: cmd: HS_CFG_CMD: condition:0xffffffff gpio:0xff gap:0xff
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341909] mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xe5, cmd_pending=1
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341947] mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1401090261.950120): 0xe5, act 0x1, len 16, seqno 0x61
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341947] mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341955] mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.491758] mmp3_usb_phy_init_internal: Init usb phy!!!
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.492938] pxa9xx_u2o_host_enable: PORTSC 0xc000800 USBMODE 0x3 USBSTS 0x1080 USBCMD 0x80b00
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.512492] dcon_source_switch to CPU
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.540126] olpc-dcon: The CPU has control
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.601954] usb usb1: usb resume
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.601954] pxau2o-ehci d4208000.usb: resume root hub after power loss
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.641757] hub 1-0:1.0: hub_resume
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.641771] hub 1-0:1.0: port 1: status 0507 change 0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.642147] usb 1-1: usb resume
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.701758] usb 1-1: finish reset-resume
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.821799] usb 1-1: reset high-speed USB device number 2 using pxau2o-ehci
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.972898] hub 1-1:1.0: hub_reset_resume
May 26 07:44:33 xo-96-6d-f4 kernel: [  198.972922] hub 1-1:1.0: enabling power on all ports
May 26 07:44:33 xo-96-6d-f4 kernel: [  199.082897] usb 1-1: link qh256-0001/cc319280 start 24 [1/0 us]
May 26 07:44:33 xo-96-6d-f4 kernel: [  199.083174] PM: resume of devices complete after 10691.142 msecs
May 26 07:44:33 xo-96-6d-f4 kernel: [  199.161211] hub 1-1:1.0: state 7 ports 4 chg 0000 evt 0000
May 26 07:44:33 xo-96-6d-f4 kernel: [  199.161230] hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0002
May 26 07:44:33 xo-96-6d-f4 kernel: [  199.174348] mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xa4, cmd_pending=2
May 26 07:44:33 xo-96-6d-f4 kernel: [  199.157314] Restarting tasks ... done.
May 26 07:44:35 xo-96-6d-f4 kernel: [  201.181763] hub 1-1:1.0: hub_suspend
May 26 07:44:35 xo-96-6d-f4 kernel: [  201.181791] usb 1-1: unlink qh256-0001/cc319280 start 24 [1/0 us]
May 26 07:44:35 xo-96-6d-f4 kernel: [  201.182277] usb 1-1: usb auto-suspend, wakeup 1
May 26 07:44:37 xo-96-6d-f4 kernel: [  203.201793] hub 1-0:1.0: hub_suspend
May 26 07:44:37 xo-96-6d-f4 kernel: [  203.201793] usb usb1: bus auto-suspend, wakeup 1
May 26 07:44:37 xo-96-6d-f4 kernel: [  203.201824] pxau2o-ehci d4208000.usb: suspend root hub
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.361763] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id (1401090282.719933) = 0xe5, act = 0x1
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.372259] mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.372259] mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.383751] mwifiex_sdio mmc0:0001:1: num_cmd_timeout = 1
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.383751] mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.394372] mwifiex_sdio mmc0:0001:1: last_cmd_index = 0
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.394380] last_cmd_id: 00000000: e5 00 e5 00 e5                                   .....
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.399655] last_cmd_act: 00000000: 01 00 01 00 02                                   .....
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.399655] mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 4
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.405379] last_cmd_resp_id: 00000000: 16 80 e5 80 e5                                   .....
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.405387] mwifiex_sdio mmc0:0001:1: last_event_index = 4
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.410828] last_event: 00000000: 47 00 47 00 47                                   G.G.G
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.410836] mwifiex_sdio mmc0:0001:1: data_sent=0 cmd_sent=1
May 26 07:44:42 xo-96-6d-f4 kernel: [  208.416453] mwifiex_sdio mmc0:0001:1: ps_mode=0 ps_state=0

-- 
James Cameron
http://quozl.linux.org.au/
