Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40722 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750922AbcEJU3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:29:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:17 +0300
Message-Id: <1462910797-20303-21-git-send-email-luca@coelho.fi> (sfid-20160510_222928_209578_18EFCBAF)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 21/41] iwlwifi: mvm: add a new mvm reference type for RX data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

When a data packet is received, we need to make sure that we stay
awake until it can be processed and wait a while before trying to
enter runtime_suspend os system_suspend again.  To do so, add a new
reference type for RX data and take the reference when sending the
packet to mac80211.  We only do this for data packets, all the other
RX packets sent by the firmware (e.g. notifications) are not a reason
to prevent suspend.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c      | 15 +++++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 513a8540..406cf1c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1310,6 +1310,7 @@ static ssize_t iwl_dbgfs_d0i3_refs_read(struct file *file,
 	PRINT_MVM_REF(IWL_MVM_REF_FW_DBG_COLLECT);
 	PRINT_MVM_REF(IWL_MVM_REF_INIT_UCODE);
 	PRINT_MVM_REF(IWL_MVM_REF_SENDING_CMD);
+	PRINT_MVM_REF(IWL_MVM_REF_RX);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 23d7539..820f8d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -302,6 +302,7 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_FW_DBG_COLLECT,
 	IWL_MVM_REF_INIT_UCODE,
 	IWL_MVM_REF_SENDING_CMD,
+	IWL_MVM_REF_RX,
 
 	/* update debugfs.c when changing this */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 58e7e4f..ab7f7ed 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -272,6 +272,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	u32 rate_n_flags;
 	u32 rx_pkt_status;
 	u8 crypt_len = 0;
+	bool take_ref;
 
 	phy_info = &mvm->last_phy_info;
 	rx_res = (struct iwl_rx_mpdu_res_start *)pkt->data;
@@ -458,8 +459,22 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 		     ieee80211_is_probe_resp(hdr->frame_control)))
 		rx_status->boottime_ns = ktime_get_boot_ns();
 
+	/* Take a reference briefly to kick off a d0i3 entry delay so
+	 * we can handle bursts of RX packets without toggling the
+	 * state too often.  But don't do this for beacons if we are
+	 * going to idle because the beacon filtering changes we make
+	 * cause the firmware to send us collateral beacons. */
+	take_ref = !(test_bit(STATUS_TRANS_GOING_IDLE, &mvm->trans->status) &&
+		     ieee80211_is_beacon(hdr->frame_control));
+
+	if (take_ref)
+		iwl_mvm_ref(mvm, IWL_MVM_REF_RX);
+
 	iwl_mvm_pass_packet_to_mac80211(mvm, sta, napi, skb, hdr, len,
 					ampdu_status, crypt_len, rxb);
+
+	if (take_ref)
+		iwl_mvm_unref(mvm, IWL_MVM_REF_RX);
 }
 
 static void iwl_mvm_update_rx_statistics(struct iwl_mvm *mvm,
-- 
2.8.1

