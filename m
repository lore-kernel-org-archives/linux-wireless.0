Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:58263 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756672Ab3AYK4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:56:38 -0500
Date: Fri, 25 Jan 2013 16:19:55 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 1/7] mwl8k: Announce simultaneous AP-STA support on AP fw
Message-ID: <20130125104955.GA9382@markyou.marvell.com> (sfid-20130125_115839_641981_2B2228C9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Specify the STA support in iface_limit and
in wihpy->interface_modes

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b53f9fc..6c727be 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5799,6 +5799,7 @@ fail:
 
 static const struct ieee80211_iface_limit ap_if_limits[] = {
 	{ .max = 8,	.types = BIT(NL80211_IFTYPE_AP) },
+	{ .max = 1,	.types = BIT(NL80211_IFTYPE_STATION) },
 };
 
 static const struct ieee80211_iface_combination ap_if_comb = {
@@ -5891,6 +5892,7 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 
 	if (priv->ap_macids_supported || priv->device_info->fw_image_ap) {
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP);
+		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_STATION);
 		hw->wiphy->iface_combinations = &ap_if_comb;
 		hw->wiphy->n_iface_combinations = 1;
 	}
-- 
1.8.0.3

