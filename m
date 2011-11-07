Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7845 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1KGHTn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 02:19:43 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Fix accessing wrong skb->data in ath6kl_tx_complete()
Date: Mon, 7 Nov 2011 12:50:17 +0530
Message-ID: <1320650417-11954-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111107_081948_419178_F831A391)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When buffer alignmnet is applied, the data pointer of skb taken from
cookie will no longer point to the first byte of the actual data.
But the skb->data pointer is used in ath6kl_tx_complete() to get
the index of the virtual interface which will not give the correct
interface index and sometimes may give the following WARN_ON() message.
Use packet->buf instead of skb->data to fix this.

WARNING: at drivers/net/wireless/ath/ath6kl/wmi.c:88 ath6kl_get_vif_by_index+0x5b/0x60 [ath6kl]()
Hardware name: 2842K3U
Modules linked in: ath6kl mmc_block cfg80211 binfmt_misc ppdev nfs nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel
+snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy thinkpad_acpi snd_seq_oss snd_seq_midi snd_rawmidi joydev fbcon tileblit font bitblit softcursor
+snd_seq_midi_event snd_seq snd_timer snd_seq_device i915 uvcvideo drm_kms_helper drm psmouse serio_raw snd i2c_algo_bit sdhci_pci videodev intel_agp soundcore intel_gtt jmb38x_ms
+memstick sdhci snd_page_alloc nvram lp parport agpgart video ahci r8169 mii libahci [last unloaded: ath6kl]
Pid: 15482, comm: kworker/u:1 Tainted: G        W   3.1.0-rc10-wl+ #2
Call Trace:
 [<c0144d72>] warn_slowpath_common+0x72/0xa0
 [<fb7c94fb>] ? ath6kl_get_vif_by_index+0x5b/0x60 [ath6kl]
 [<fb7c94fb>] ? ath6kl_get_vif_by_index+0x5b/0x60 [ath6kl]
 [<c0144dc2>] warn_slowpath_null+0x22/0x30
 [<fb7c94fb>] ath6kl_get_vif_by_index+0x5b/0x60 [ath6kl]
 [<fb7c7028>] ath6kl_tx_complete+0x128/0x4d0 [ath6kl]
 [<c04df920>] ? mmc_request_done+0x80/0x80
 [<fb7b9e2e>] htc_tx_complete+0x5e/0x70 [ath6kl]
 [<c05e4cf6>] ? _raw_spin_unlock_bh+0x16/0x20
 [<fb7ce588>] ? ath6kl_sdio_scatter_req_add+0x48/0x60 [ath6kl]
 [<fb7b9f42>] htc_async_tx_scat_complete+0xb2/0x120 [ath6kl]
 [<fb7ce9e7>] ath6kl_sdio_scat_rw+0x87/0x370 [ath6kl]
 [<c0101e12>] ? __switch_to+0xd2/0x190
 [<c01397b5>] ? finish_task_switch+0x45/0xd0
 [<c05e272e>] ? __schedule+0x3ae/0x8b0
 [<fb7cf00a>] ath6kl_sdio_write_async_work+0x4a/0xf0 [ath6kl]
 [<c015d266>] process_one_work+0x116/0x3c0
 [<fb7cefc0>] ? ath6kl_sdio_read_write_sync+0xb0/0xb0 [ath6kl]
 [<c015f5b0>] worker_thread+0x140/0x3b0
 [<c015f470>] ? manage_workers+0x1f0/0x1f0
 [<c0163424>] kthread+0x74/0x80
 [<c01633b0>] ? kthread_worker_fn+0x160/0x160
 [<c05ebdc6>] kernel_thread_helper+0x6/0x10

Reported-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 251abf8..938acbf 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -571,8 +571,6 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 		if (!skb || !skb->data)
 			goto fatal;
 
-		packet->buf = skb->data;
-
 		__skb_queue_tail(&skb_queue, skb);
 
 		if (!status && (packet->act_len != skb->len))
@@ -593,10 +591,10 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 
 		if (eid == ar->ctrl_ep) {
 			if_idx = wmi_cmd_hdr_get_if_idx(
-				(struct wmi_cmd_hdr *) skb->data);
+				(struct wmi_cmd_hdr *) packet->buf);
 		} else {
 			if_idx = wmi_data_hdr_get_if_idx(
-				(struct wmi_data_hdr *) skb->data);
+				(struct wmi_data_hdr *) packet->buf);
 		}
 
 		vif = ath6kl_get_vif_by_index(ar, if_idx);
-- 
1.7.0.4

