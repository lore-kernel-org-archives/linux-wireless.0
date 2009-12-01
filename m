Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32555 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbZLAMHF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 07:07:05 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nB1C74vc011327
	for <linux-wireless@vger.kernel.org>; Tue, 1 Dec 2009 14:07:09 +0200
Received: from [127.0.1.1] (essapo-nirac253175.europe.nokia.com [10.162.253.175])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nB1C6lep010060
	for <linux-wireless@vger.kernel.org>; Tue, 1 Dec 2009 14:06:48 +0200
Subject: [PATCH v3 2/2] wl1251: add U-APSD support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 01 Dec 2009 14:06:42 +0200
Message-ID: <20091201120642.4264.24605.stgit@tikku>
In-Reply-To: <20091201120508.4264.25010.stgit@tikku>
References: <20091201120508.4264.25010.stgit@tikku>
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
index 6aeffbe..f35c012 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1282,6 +1282,7 @@ static struct ieee80211_channel wl1251_channels[] = {
 static int wl1251_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			     const struct ieee80211_tx_queue_params *params)
 {
+	enum wl1251_acx_ps_scheme ps_scheme;
 	struct wl1251 *wl = hw->priv;
 	int ret;
 
@@ -1299,10 +1300,14 @@ static int wl1251_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
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
@@ -1376,7 +1381,8 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_NOISE_DBM |
 		IEEE80211_HW_SUPPORTS_PS |
-		IEEE80211_HW_BEACON_FILTER;
+		IEEE80211_HW_BEACON_FILTER |
+		IEEE80211_HW_UAPSD;
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	wl->hw->wiphy->max_scan_ssids = 1;

