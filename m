Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:53167 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692Ab2KFN5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 08:57:12 -0500
Date: Tue, 6 Nov 2012 19:22:16 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: defining interface combinations
Message-ID: <20121106135212.GA8439@markyou.marvell.com> (sfid-20121106_145727_849596_A3ED9FF6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP mode support upto 8 interfaces.
Defining it using iface_combinations

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 5099e53..cb5594d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5617,6 +5617,18 @@ fail:
 	return rc;
 }
 
+static const struct ieee80211_iface_limit ap_if_limits[] = {
+	{ .max = 8,	.types = BIT(NL80211_IFTYPE_AP) },
+};
+
+static const struct ieee80211_iface_combination ap_if_comb = {
+	.limits = ap_if_limits,
+	.n_limits = ARRAY_SIZE(ap_if_limits),
+	.max_interfaces = 8,
+	.num_different_channels = 1,
+};
+
+
 static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 {
 	struct ieee80211_hw *hw = priv->hw;
@@ -5696,8 +5708,13 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 		goto err_free_cookie;
 
 	hw->wiphy->interface_modes = 0;
-	if (priv->ap_macids_supported || priv->device_info->fw_image_ap)
+
+	if (priv->ap_macids_supported || priv->device_info->fw_image_ap) {
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP);
+		hw->wiphy->iface_combinations = &ap_if_comb;
+		hw->wiphy->n_iface_combinations = 1;
+	}
+
 	if (priv->sta_macids_supported || priv->device_info->fw_image_sta)
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_STATION);
 
-- 
1.7.9.2

