Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:57445 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbIPHtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 03:49:17 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix ldpc param for fixed rate
Date: Wed, 16 Sep 2015 13:19:00 +0530
Message-ID: <1442389740-29053-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150916_094920_809115_49CDC5EC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ldpc is not configured for fixed rates. This blocks auto rate vs fixed
rate performance comparison. Since firmware is considering ldpc vdev
param for fixed rate selection, it has to be configured to enable ldpc
for fixed rates.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 80fe43fa..b347b60 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5936,7 +5936,7 @@ ath10k_mac_bitrate_mask_get_single_rate(struct ath10k *ar,
 }
 
 static int ath10k_mac_set_fixed_rate_params(struct ath10k_vif *arvif,
-					    u8 rate, u8 nss, u8 sgi)
+					    u8 rate, u8 nss, u8 sgi, u8 ldpc)
 {
 	struct ath10k *ar = arvif->ar;
 	u32 vdev_param;
@@ -5969,6 +5969,13 @@ static int ath10k_mac_set_fixed_rate_params(struct ath10k_vif *arvif,
 		return ret;
 	}
 
+	vdev_param = ar->wmi.vdev_param->ldpc;
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param, ldpc);
+	if (ret) {
+		ath10k_warn(ar, "failed to set ldpc param %d: %d\n", ldpc, ret);
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -6032,6 +6039,7 @@ static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 	u8 rate;
 	u8 nss;
 	u8 sgi;
+	u8 ldpc;
 	int single_nss;
 	int ret;
 
@@ -6041,6 +6049,7 @@ static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 	band = def.chan->band;
 	ht_mcs_mask = mask->control[band].ht_mcs;
 	vht_mcs_mask = mask->control[band].vht_mcs;
+	ldpc = !!(ar->ht_cap_info & WMI_HT_CAP_LDPC);
 
 	sgi = mask->control[band].gi;
 	if (sgi == NL80211_TXRATE_FORCE_LGI)
@@ -6079,7 +6088,7 @@ static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->conf_mutex);
 
-	ret = ath10k_mac_set_fixed_rate_params(arvif, rate, nss, sgi);
+	ret = ath10k_mac_set_fixed_rate_params(arvif, rate, nss, sgi, ldpc);
 	if (ret) {
 		ath10k_warn(ar, "failed to set fixed rate params on vdev %i: %d\n",
 			    arvif->vdev_id, ret);
-- 
2.5.2

