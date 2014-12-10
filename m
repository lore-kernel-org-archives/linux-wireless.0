Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:57365 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbaLJMoZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 07:44:25 -0500
Received: by mail-wg0-f54.google.com with SMTP id l2so3495519wgh.13
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2014 04:44:24 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/5] ath10k: advertise p2p dev support
Date: Wed, 10 Dec 2014 13:31:54 +0100
Message-Id: <1418214714-29689-6-git-send-email-michal.kazior@tieto.com> (sfid-20141210_134432_448144_D870BCEB)
In-Reply-To: <1418214714-29689-1-git-send-email-michal.kazior@tieto.com>
References: <1418214714-29689-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware doesn't allow precise tx rate control so
P2P wasn't entirely spec compliant (it was using
CCK rates in some cases).

The only way to make sure firmware doesn't use CCK
rates is to have a vdev with P2P subtype used for
scanning and tx. This can be done via a special
dedicated P2P device interface support.

This also removes the ancient hack from ath10k in
favor of p2pdev.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  6 ------
 drivers/net/wireless/ath/ath10k/mac.c  | 12 +++++++++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 577a3d7..c83f1e7 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -32,17 +32,14 @@
 
 unsigned int ath10k_debug_mask;
 static bool uart_print;
-static unsigned int ath10k_p2p;
 static bool skip_otp;
 
 module_param_named(debug_mask, ath10k_debug_mask, uint, 0644);
 module_param(uart_print, bool, 0644);
-module_param_named(p2p, ath10k_p2p, uint, 0644);
 module_param(skip_otp, bool, 0644);
 
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 MODULE_PARM_DESC(uart_print, "Uart target debugging");
-MODULE_PARM_DESC(p2p, "Enable ath10k P2P support");
 MODULE_PARM_DESC(skip_otp, "Skip otp failure for calibration in testmode");
 
 static const struct ath10k_hw_params ath10k_hw_params_list[] = {
@@ -1290,10 +1287,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 
 	ar->ath_common.priv = ar;
 	ar->ath_common.hw = ar->hw;
-
-	ar->p2p = !!ath10k_p2p;
 	ar->dev = dev;
-
 	ar->hif.ops = hif_ops;
 	ar->hif.bus = bus;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e84397d..22d2046 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2935,10 +2935,11 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	arvif->vdev_id = bit;
 	arvif->vdev_subtype = WMI_VDEV_SUBTYPE_NONE;
 
-	if (ar->p2p)
-		arvif->vdev_subtype = WMI_VDEV_SUBTYPE_P2P_DEVICE;
-
 	switch (vif->type) {
+	case NL80211_IFTYPE_P2P_DEVICE:
+		arvif->vdev_type = WMI_VDEV_TYPE_STA;
+		arvif->vdev_subtype = WMI_VDEV_SUBTYPE_P2P_DEVICE;
+		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NL80211_IFTYPE_STATION:
 		arvif->vdev_type = WMI_VDEV_TYPE_STA;
@@ -4830,6 +4831,10 @@ static const struct ieee80211_iface_limit ath10k_if_limits[] = {
 	.types	= BIT(NL80211_IFTYPE_P2P_GO)
 	},
 	{
+	.max	= 1,
+	.types	= BIT(NL80211_IFTYPE_P2P_DEVICE)
+	},
+	{
 	.max	= 7,
 	.types	= BIT(NL80211_IFTYPE_AP)
 	},
@@ -5049,6 +5054,7 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	if (!test_bit(ATH10K_FW_FEATURE_NO_P2P, ar->fw_features))
 		ar->hw->wiphy->interface_modes |=
+			BIT(NL80211_IFTYPE_P2P_DEVICE) |
 			BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			BIT(NL80211_IFTYPE_P2P_GO);
 
-- 
1.8.5.3

