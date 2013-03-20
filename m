Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11243 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab3CTNeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 09:34:37 -0400
From: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qca.qualcomm.com>
To: Julien Massot <jmassot@aldebaran-robotics.com>,
	ath6kl-devel <ath6kl-devel@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: ath6kl: null pointer dereference in do_recv_completion
Date: Wed, 20 Mar 2013 13:34:31 +0000
Message-ID: <D106CD05FEFBA74BA17F929FD27C8AB326963919@aphydexd01a> (sfid-20130320_143441_869039_ACFEBAAA)
References: <CADGp=Qe9NB9EAS=hpTKbDE-JhHqXY=sc1CaumiPaP384Bijb6g@mail.gmail.com>
In-Reply-To: <CADGp=Qe9NB9EAS=hpTKbDE-JhHqXY=sc1CaumiPaP384Bijb6g@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julien/Kalle,

Did you find this issue in AR6004 USB ?
It could be a kind of race condition . since ep_cb.rx callback
should be initialized in the driver's init time itself.
Probably we are gettting recv_complete called even before
ath6kl_init_service_ep is called , which registers the ep_cb.rx callback.

ath6kl_hif_power_on ->ath6kl_usb_post_recv_transfers
which registers usb_fill_bulk_urb (ath6kl_usb_recv_complete)
and later ath6kl_init_service_ep.

Probably we should have a flag to check to by pass 
ath6kl_usb_recv_complete until init_service_ep is done ?

any thoughts ?

regards,
shafi
________________________________________
From: Julien Massot [jmassot@aldebaran-robotics.com]
Sent: 19 March 2013 18:12:38
To: ath6kl-devel
Cc: linux-wireless@vger.kernel.org
Subject: ath6kl: null pointer dereference in do_recv_completion

Hi,
I just found a segfault in the ath6kl driver.

I succeed in triggering it when I'm doing scp on a slow storage. ( ~
1Mbit/s slow SDIO bus)
I doesn't succeed in reproducing it using iperf, which gives slightly
better throughput (100 Mbit/s tcp).

I'm using a preempt rt Linux 2.6.33 + wireless compat-3.6.6-1.

[ 2937.469910] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 2937.470826] IP: [<(null)>] (null)
[ 2937.470826] *pde = 00000000
[ 2937.470826] Oops: 0000 [#1] PREEMPT SMP
[ 2937.470826] last sysfs file: /sys/devices/platform/regulatory.0/uevent
[ 2937.470826] Modules linked in: cdc_acm bridge stp rfcomm l2cap
bluetooth cgosdrv ov5640 ath6kl_usb ath6kl_core snd_hda_codec_analog
cfg80211 mmc_block mt9m114 unicorn(C) v4l2_common videodev
snd_hda_intel v4l1_compat snd_hda_codec videobuf_dma_contig sdhci_pci
compat videobuf_core i2c_isch snd_hwdep serio_raw sdhci [last
unloaded: i2c_serial]
[ 2937.470826]
[ 2937.470826] Pid: 1841, comm: events/0 Tainted: G         C
2.6.33.9-rt31-aldebaran-rt #1 /
[ 2937.470826] EIP: 0060:[<00000000>] EFLAGS: 00010293 CPU: 0
[ 2937.470826] EIP is at 0x0
[ 2937.470826] EAX: f3068000 EBX: f5a3bf2c ECX: f5a3bf2c EDX: f30502c0
[ 2937.470826] ESI: f30687c0 EDI: f30502c0 EBP: f5a3bef4 ESP: f5a3bee8
[ 2937.470826]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 preempt:00000000
[ 2937.470826] Process events/0 (pid: 1841, ti=f5a3a000 task=f512a4b0
task.ti=f5a3a000)
[ 2937.470826] Stack:
[ 2937.470826]  f8d05215 f3992020 f3068000 f5a3bf40 f8d05f11 c1024e18
00000002 f5dc3c40
[ 2937.470826] <0> f5dc3c40 00000246 08a3bf24 0000064a 008d2424
f55f2418 00000000 f30688f8
[ 2937.470826] <0> f5c8de00 f5a3bf2c f5a3bf2c f8d13838 f55f2000
f55f2418 f5a3bf4c f8d131d0
[ 2937.470826] Call Trace:
[ 2937.470826]  [<f8d05215>] ? do_recv_completion+0x2f/0x39 [ath6kl_core]
[ 2937.470826]  [<f8d05f11>] ? ath6kl_htc_pipe_rx_complete+0x2cc/0x31a
[ath6kl_core]
[ 2937.470826]  [<c1024e18>] ? finish_task_switch+0x51/0x67
[ 2937.470826]  [<f8d131d0>] ? ath6kl_core_rx_complete+0xd/0x10 [ath6kl_core]
[ 2937.470826]  [<f8d933a9>] ? ath6kl_usb_io_comp_work+0x2d/0x3f [ath6kl_usb]
[ 2937.470826]  [<c103da3b>] ? worker_thread+0x105/0x17c
[ 2937.470826]  [<f8d9337c>] ? ath6kl_usb_io_comp_work+0x0/0x3f [ath6kl_usb]
[ 2937.470826]  [<c104096d>] ? autoremove_wake_function+0x0/0x2f
[ 2937.470826]  [<c103d936>] ? worker_thread+0x0/0x17c
[ 2937.470826]  [<c104069b>] ? kthread+0x5f/0x64
[ 2937.470826]  [<c104063c>] ? kthread+0x0/0x64
[ 2937.470826]  [<c1002db6>] ? kernel_thread_helper+0x6/0x10
[ 2937.470826] Code:  Bad EIP value.
[ 2937.470826] EIP: [<00000000>] 0x0 SS:ESP 0068:f5a3bee8
[ 2937.470826] CR2: 0000000000000000
[ 2937.681695] hda-intel: IRQ timing workaround is activated for card
#0. Suggest a bigger bdl_pos_adj.
[ 2937.684124] ---[ end trace 65e5f4c37e647fa3 ]---

http://pastebin.com/KEGQRjzu
http://pastebin.com/cngx9q1e
http://pastebin.com/GfCdJDUt

 I found that in the file htc_pipe.c line 940 in function do_recv_completion
the ep->ep_cb.rx function pointer is null.

On Kalle's request, I add a debug line when the bug occurs.

 ath6kl_dbg(ATH6KL_DBG_HTC,
                        "SVC Ready: 0x%4.4X: ULpipe:%d DLpipe:%d id:%d\n",
                        ep->svc_id, ep->pipe.pipeid_ul,
                        ep->pipe.pipeid_dl, ep->eid);

and the log when the bugs occurs:
SVC Ready: 0x0000: ULpipe:0 DLpipe:0 id:6

So I add a check for null pointer, the communication no longer hang.

here is the patch:

>From 9565f0ab6aa5e739c8ceac6eef9e19b6dba71a07 Mon Sep 17 00:00:00 2001
From: Julien Massot <jmassot@aldebaran-robotics.com>
Date: Mon, 18 Mar 2013 17:32:26 +0100
Subject: [PATCH] ath6kl: check for null rx hanldler of htc_ep_callbacks struct

---
 drivers/net/wireless/ath/ath6kl/htc_pipe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index 9adb567..969eb2a 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -937,6 +937,10 @@ static void do_recv_completion(struct htc_endpoint *ep,
                packet = list_first_entry(queue_to_indicate,
                                          struct htc_packet, list);
                list_del(&packet->list);
+                if (ep->ep_cb.rx == NULL) {
+                  ath6kl_warn("ep->ep_cb.rx is null .. continue ..\n");
+                  continue;
+                }
                ep->ep_cb.rx(ep->target, packet);
        }

--

Best Regards

Julien
