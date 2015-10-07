Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:32426 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbbJGFQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 01:16:08 -0400
From: <c_traja@qti.qualcomm.com>
To: <johannes@sipsolutions.net>, <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>,
	Manikanta pubbisetty <c_mpubbi@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: set peer MFP flag in peer assoc command
Date: Wed, 7 Oct 2015 10:46:01 +0530
Message-ID: <1444194961-12777-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20151007_071727_363598_9184C7B5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

Set peer's management frame protection flag in peer assoc command,
this setting will enable/disable encrytion of management frames in fw.

Setting of this flag is based on whether MFP is enabled/disabled at STA
and a firmware feature flag ATH10K_FW_FEATURE_MFP_SUPPORT. This is because
only firmwares 10.1.561 and above have support for MFP.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
Signed-off-by: Manikanta pubbisetty <c_mpubbi@qti.qualcomm.com>
---
Notes:
	This patch has dependency of following patch.
	Revert "mac80211: remove exposing 'mfp' to drivers"

 drivers/net/wireless/ath/ath10k/core.c   |    1 +
 drivers/net/wireless/ath/ath10k/core.h   |    3 +++
 drivers/net/wireless/ath/ath10k/htt_tx.c |    7 +++++++
 drivers/net/wireless/ath/ath10k/mac.c    |    8 +++++++-
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 879625a..6a2dd34 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -151,6 +151,7 @@ static const char *const ath10k_core_fw_feature_str[] = {
 	[ATH10K_FW_FEATURE_NO_NWIFI_DECAP_4ADDR_PADDING] = "no-4addr-pad",
 	[ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT] = "skip-clock-init",
 	[ATH10K_FW_FEATURE_RAW_MODE_SUPPORT] = "raw-mode",
+	[ATH10K_FW_FEATURE_MFP_SUPPORT] = "mfp",
 };
 
 static unsigned int ath10k_core_get_fw_feature_str(char *buf,
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 3e4668e..0e23400 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -469,6 +469,9 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_RAW_MODE_SUPPORT = 10,
 
+	/* Firmware supports management frame protection */
+	ATH10K_FW_FEATURE_MFP_SUPPORT = 11,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index eb5ba9b..cd72860 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -459,6 +459,13 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	}
 	msdu_id = res;
 
+	if ((ieee80211_is_action(hdr->frame_control) ||
+	     ieee80211_is_deauth(hdr->frame_control) ||
+	     ieee80211_is_disassoc(hdr->frame_control)) &&
+	     ieee80211_has_protected(hdr->frame_control)) {
+		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
+	}
+
 	txdesc = ath10k_htc_alloc_skb(ar, len);
 	if (!txdesc) {
 		res = -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index dc80d0b..71cba8c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1968,6 +1968,7 @@ static void ath10k_peer_assoc_h_basic(struct ath10k *ar,
 
 static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 				       struct ieee80211_vif *vif,
+				       struct ieee80211_sta *sta,
 				       struct wmi_peer_assoc_complete_arg *arg)
 {
 	struct ieee80211_bss_conf *info = &vif->bss_conf;
@@ -2009,6 +2010,11 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
 		ath10k_dbg(ar, ATH10K_DBG_WMI, "%s: wpa ie found\n", __func__);
 		arg->peer_flags |= ar->wmi.peer_flags->need_gtk_2_way;
 	}
+
+	if (sta->mfp &&
+	    test_bit(ATH10K_FW_FEATURE_MFP_SUPPORT, ar->fw_features)) {
+		arg->peer_flags |= ar->wmi.peer_flags->pmf;
+	}
 }
 
 static void ath10k_peer_assoc_h_rates(struct ath10k *ar,
@@ -2479,7 +2485,7 @@ static int ath10k_peer_assoc_prepare(struct ath10k *ar,
 	memset(arg, 0, sizeof(*arg));
 
 	ath10k_peer_assoc_h_basic(ar, vif, sta, arg);
-	ath10k_peer_assoc_h_crypto(ar, vif, arg);
+	ath10k_peer_assoc_h_crypto(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_rates(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_ht(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_vht(ar, vif, sta, arg);
-- 
1.7.9.5

