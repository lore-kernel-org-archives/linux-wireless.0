Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:65490 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934Ab3JNLQd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 07:16:33 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: do not warn about unsupported vdev param
Date: Mon, 14 Oct 2013 13:16:21 +0200
Message-ID: <1381749381-15459-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20131014_131637_026709_50CB9688)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.X firmware does not support WMI_VDEV_PARAM_TX_ENCAP_TYPE.
It's a known limitation and we should not warn about this.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 049eca2..9c800f8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2085,7 +2085,9 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	vdev_param = ar->wmi.vdev_param->tx_encap_type;
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 					ATH10K_HW_TXRX_NATIVE_WIFI);
-	if (ret)
+
+	/* 10.X firmware does not support this VDEV parameter. Do not warn */
+	if (ret && !test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
 		ath10k_warn("Failed to set TX encap: %d\n", ret);
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
-- 
1.7.10

