Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33050 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab0CRK1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:17 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 13/21] wl1271: enable U-APSD
Date: Thu, 18 Mar 2010 12:26:38 +0200
Message-Id: <1268908006-16992-14-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

wl1271 supports U-APSD similarly as wl1251, so let's enable it.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 2a2e584..037a4f4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1781,6 +1781,7 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			     const struct ieee80211_tx_queue_params *params)
 {
 	struct wl1271 *wl = hw->priv;
+	u8 ps_scheme;
 	int ret;
 
 	mutex_lock(&wl->mutex);
@@ -1798,11 +1799,15 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	if (ret < 0)
 		goto out_sleep;
 
+	if (params->uapsd)
+		ps_scheme = CONF_PS_SCHEME_UPSD_TRIGGER;
+	else
+		ps_scheme = CONF_PS_SCHEME_LEGACY;
+
 	ret = wl1271_acx_tid_cfg(wl, wl1271_tx_get_queue(queue),
 				 CONF_CHANNEL_TYPE_EDCF,
 				 wl1271_tx_get_queue(queue),
-				 CONF_PS_SCHEME_LEGACY,
-				 CONF_ACK_POLICY_LEGACY, 0, 0);
+				 ps_scheme, CONF_ACK_POLICY_LEGACY, 0, 0);
 	if (ret < 0)
 		goto out_sleep;
 
@@ -2083,6 +2088,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_NOISE_DBM |
 		IEEE80211_HW_BEACON_FILTER |
 		IEEE80211_HW_SUPPORTS_PS |
+		IEEE80211_HW_SUPPORTS_UAPSD |
 		IEEE80211_HW_HAS_RATE_CONTROL;
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-- 
1.6.3.3

