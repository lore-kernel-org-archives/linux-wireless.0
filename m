Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:44965 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0ALIoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 03:44:06 -0500
Subject: [PATCH PATCH v6 7/7] wl1251: add U-APSD support
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	a.young.jason@gmail.com
Date: Tue, 12 Jan 2010 10:43:15 +0200
Message-ID: <20100112084314.27492.54040.stgit@tikku>
In-Reply-To: <20100112084059.27492.86738.stgit@tikku>
References: <20100112084059.27492.86738.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

wl1251 firmware supports U-APSD just with a simple queue configuration
change so enable it.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 4cf3545..6be50aa 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1307,6 +1307,7 @@ static struct ieee80211_channel wl1251_channels[] = {
 static int wl1251_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			     const struct ieee80211_tx_queue_params *params)
 {
+	enum wl1251_acx_ps_scheme ps_scheme;
 	struct wl1251 *wl = hw->priv;
 	int ret;
 
@@ -1324,10 +1325,14 @@ static int wl1251_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	if (ret < 0)
 		goto out_sleep;
 
+	if (params->uapsd)
+		ps_scheme = WL1251_ACX_PS_SCHEME_UPSD_TRIGGER;
+	else
+		ps_scheme = WL1251_ACX_PS_SCHEME_LEGACY;
+
 	ret = wl1251_acx_tid_cfg(wl, wl1251_tx_get_queue(queue),
 				 CHANNEL_TYPE_EDCF,
-				 wl1251_tx_get_queue(queue),
-				 WL1251_ACX_PS_SCHEME_LEGACY,
+				 wl1251_tx_get_queue(queue), ps_scheme,
 				 WL1251_ACX_ACK_POLICY_LEGACY);
 	if (ret < 0)
 		goto out_sleep;
@@ -1401,7 +1406,8 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_NOISE_DBM |
 		IEEE80211_HW_SUPPORTS_PS |
-		IEEE80211_HW_BEACON_FILTER;
+		IEEE80211_HW_BEACON_FILTER |
+		IEEE80211_HW_SUPPORTS_UAPSD;
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	wl->hw->wiphy->max_scan_ssids = 1;

