Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50712 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2KPMws (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 07:52:48 -0500
To: <ath6kl-devel@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 4/8] ath6kl: Fix kernel panic on continuous driver load/unload
Date: Fri, 16 Nov 2012 18:22:40 +0530
Message-ID: <1353070360-6008-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121116_135251_367983_E0B9D1C1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

On continuous loading and unloading of AR6004 ath6kl USB
driver it triggers a panic due to NULL pointer dereference of
'target' pointer.

while true; do sudo modprobe -v ath6kl_core;
sudo modprobe -v ath6kl_usb; sudo modprobe -r usb;
sudo modprobe -r ath6kl_core; done

ar->htc_target can be NULL due to a race condition that can occur
during driver initialization(we do 'ath6kl_hif_power_on' before
initializing 'ar->htc_target' via 'ath6kl_htc_create').
'ath6kl_hif_power_on' assigns 'ath6kl_recv_complete' as
usb_complete_t/callback function for 'usb_fill_bulk_urb'.
Thus the possibility of ar->htc_target being NULL
via ath6kl_recv_complete -> ath6kl_usb_io_comp_work
before even 'ath6kl_htc_create' is finished to initialize
ar->htc_create.

Worth noting is the obvious solution  of doing 'ath6kl_hif_power_on'
later(i.e after we are done with 'ath6kl_htc_create', causes a
h/w bring up failure in AR6003 SDIO, as 'ath6kl_hif_power_on' is a
pre-requisite to get the target version 'ath6kl_bmi_get_target_info'.
So simply check for NULL pointer for 'ar->htc_target' and bail out.

[23614.518282] BUG: unable to handle kernel NULL pointer dereference at
00000904
[23614.518463] IP: [<c012e7a6>] __ticket_spin_trylock+0x6/0x30
[23614.518570] *pde = 00000000
[23614.518664] Oops: 0000 [#1] SMP
[23614.518795] Modules linked in: ath6kl_usb(O+) ath6kl_core(O)
[23614.520012] EIP: 0060:[<c012e7a6>] EFLAGS: 00010286 CPU: 0
[23614.520012] EIP is at __ticket_spin_trylock+0x6/0x30
Call Trace:
	[<c03f2a44>] do_raw_spin_trylock+0x14/0x40
	[<c06daa12>] _raw_spin_lock_bh+0x52/0x80
	[<f85464b4>] ? ath6kl_htc_pipe_rx_complete+0x3b4/0x4c0 [ath6kl_core]
	[<f85464b4>] ath6kl_htc_pipe_rx_complete+0x3b4/0x4c0 [ath6kl_core]
	[<c05bc272>] ? skb_dequeue+0x22/0x70
	[<c05bc272>] ? skb_dequeue+0x22/0x70
	[<f855bb32>] ath6kl_core_rx_complete+0x12/0x20 [ath6kl_core]
	[<f848771a>] ath6kl_usb_io_comp_work+0xaa/0xb0 [ath6kl_usb]
	[<c015b863>] process_one_work+0x1a3/0x5e0
	[<c015b7e7>] ? process_one_work+0x127/0x5e0
	[<f8487670>] ? ath6kl_usb_reset_resume+0x30/0x30 [ath6kl_usb]
	[<c015bfde>] worker_thread+0x11e/0x3f0
	Kernel panic - not syncing: Fatal exception in interrupt

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index 73a38f9..2813901 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -967,6 +967,22 @@ static int ath6kl_htc_pipe_rx_complete(struct ath6kl *ar, struct sk_buff *skb,
 	u16 payload_len;
 	int status = 0;
 
+	/*
+	 * ar->htc_target can be NULL due to a race condition that can occur
+	 * during driver initialization(we do 'ath6kl_hif_power_on' before
+	 * initializing 'ar->htc_target' via 'ath6kl_htc_create').
+	 * 'ath6kl_hif_power_on' assigns 'ath6kl_recv_complete' as
+	 * usb_complete_t/callback function for 'usb_fill_bulk_urb'.
+	 * Thus the possibility of ar->htc_target being NULL
+	 * via ath6kl_recv_complete -> ath6kl_usb_io_comp_work.
+	 */
+	if (WARN_ON_ONCE(!target)) {
+		ath6kl_err("Target not yet initialized\n");
+		status = -EINVAL;
+		goto free_skb;
+	}
+
+
 	netdata = skb->data;
 	netlen = skb->len;
 
-- 
1.7.0.4

