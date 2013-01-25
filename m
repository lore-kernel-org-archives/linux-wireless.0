Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:48441 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755220Ab3AYK7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:59:32 -0500
Date: Fri, 25 Jan 2013 16:21:21 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Announcing AP_VLAN suport
Message-ID: <20130125105121.GA9541@markyou.marvell.com> (sfid-20130125_115935_719740_CF04E836)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP_VLAN support is needed in order to support
wds_sta in the hostapd. This will allow us
adding support for 4-address for AP and client
mode

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ee5c7ea..8788157 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5920,6 +5920,7 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 
 	if (priv->ap_macids_supported || priv->device_info->fw_image_ap) {
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP);
+		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_STATION);
 		hw->wiphy->iface_combinations = &ap_if_comb;
 		hw->wiphy->n_iface_combinations = 1;
-- 
1.8.0.3

