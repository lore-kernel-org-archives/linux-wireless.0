Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53777 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbbAMMTx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 07:19:53 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/3] iwlwifi: mvm: set the tx cmd tid for BAR frame correctly
Date: Tue, 13 Jan 2015 14:19:47 +0200
Message-Id: <1421151587-10437-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150113_131958_211494_8BC0BF76)
In-Reply-To: <1421151474.2601.10.camel@egrumbacBox>
References: <1421151474.2601.10.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

BAR tx cmd tid was set to non qos (8). This is wrong as BAR
should be sent with the tid of the BA session.
This led to a corruption in the firmware. The visible
effect of this from the driver side is the BA notification
that comes back after the BAR. It was botched and led to the
WARNING below.

------------[ cut here ]------------
WARNING: CPU: 2 PID: 17707 at /home/tester/workspace_hostap/iwlwifi/drivers/net/wireless/iwlwifi/mvm/tx.c:976 iwl_mvm_rx_ba_notif+0x4ba/0x4d0 [iwlmvm]()
Q 4500, tid 8, flow 65535
Modules linked in: iwlmvm(O) mac80211(O) iwlwifi(O) cfg80211(O) compat(O) netconsole configfs ctr ccm arc4 autofs4 microcode bnep rfcomm snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_codec_generic snd_hda_intel joydev snd_hda_codec uvcvideo videobuf2_core snd_hwdep videodev snd_pcm videobuf2_vmalloc videobuf2_memops i915 snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device drm_kms_helper dell_wmi dell_laptop drm btusb bluetooth snd psmouse i2c_algo_bit sparse_keymap wmi soundcore 6lowpan_iphc dcdbas serio_raw video lpc_ich ppdev mac_hid parport_pc nfsd nfs_acl auth_rpcgss nfs fscache binfmt_misc lockd sunrpc lp parport msdos sdhci_pci sdhci mmc_core ahci libahci e1000e ptp pps_core [last unloaded: compat]
CPU: 2 PID: 17707 Comm: irq/46-iwlwifi Tainted: G        W  O 3.14.17-patched #4
Hardware name: Dell Inc. Latitude E6430/0CPWYR, BIOS A09 12/13/2012
 00000000 00000000 ebd49d6c c1616221 f985dbdc ebd49d9c c1044e44 f9861df4
 ebd49dc8 0000452b f985dbdc 000003d0 f98395da f98395da ebd49f10 eaf3d8a4
 0000ffff ebd49db4 c1044f03 00000009 ebd49dac f9861df4 ebd49dc8 ebd49e64
Call Trace:
 [<c1616221>] dump_stack+0x41/0x52
 [<c1044e44>] warn_slowpath_common+0x84/0xa0
 [<f98395da>] ? iwl_mvm_rx_ba_notif+0x4ba/0x4d0 [iwlmvm]
 [<f98395da>] ? iwl_mvm_rx_ba_notif+0x4ba/0x4d0 [iwlmvm]
 [<c1044f03>] warn_slowpath_fmt+0x33/0x40
 [<f98395da>] iwl_mvm_rx_ba_notif+0x4ba/0x4d0 [iwlmvm]
 [<c10e3952>] ? ring_buffer_unlock_commit+0xa2/0xd0
 [<c10e9767>] ? trace_buffer_unlock_commit+0x37/0x50
 [<f98568a3>] ? iwl_tm_mvm_send_rx+0x53/0x90 [iwlmvm]
 [<f98327a8>] iwl_mvm_rx_dispatch+0x108/0x130 [iwlmvm]
 [<f9eac7e7>] iwl_pcie_irq_handler+0xf17/0x15b0 [iwlwifi]
 [<c10994c1>] irq_thread_fn+0x21/0x50
 [<c109926c>] irq_thread+0xec/0x110
 [<c10994a0>] ? irq_thread_dtor+0xb0/0xb0
 [<c10993f0>] ? irq_finalize_oneshot.part.34+0xc0/0xc0
 [<c1099180>] ? wake_threads_waitq+0x40/0x40
 [<c1062fdb>] kthread+0x9b/0xb0
 [<c1627137>] ret_from_kernel_thread+0x1b/0x28
 [<c1062f40>] ? flush_kthread_worker+0x90/0x90
---[ end trace 5e0f67374816db17 ]---

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 4333306..c59d075 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -90,8 +90,6 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	if (ieee80211_is_probe_resp(fc))
 		tx_flags |= TX_CMD_FLG_TSF;
-	else if (ieee80211_is_back_req(fc))
-		tx_flags |= TX_CMD_FLG_ACK | TX_CMD_FLG_BAR;
 
 	if (ieee80211_has_morefrags(fc))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG;
@@ -100,6 +98,15 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
 		tx_cmd->tid_tspec = qc[0] & 0xf;
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL;
+	} else if (ieee80211_is_back_req(fc)) {
+		struct ieee80211_bar *bar = (void *)skb->data;
+		u16 control = le16_to_cpu(bar->control);
+
+		tx_flags |= TX_CMD_FLG_ACK | TX_CMD_FLG_BAR;
+		tx_cmd->tid_tspec = (control &
+				     IEEE80211_BAR_CTRL_TID_INFO_MASK) >>
+			IEEE80211_BAR_CTRL_TID_INFO_SHIFT;
+		WARN_ON_ONCE(tx_cmd->tid_tspec >= IWL_MAX_TID_COUNT);
 	} else {
 		tx_cmd->tid_tspec = IWL_TID_NON_QOS;
 		if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
-- 
1.9.1

