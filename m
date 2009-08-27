Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:33270 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbZH0VAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:00:37 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, juuso.oikarinen@nokia.com,
	kalle.valo@nokia.com
Subject: [PATCH 08/13] wl1271: Configure rate policies based on AP rates
Date: Fri, 28 Aug 2009 00:00:02 +0300
Message-Id: <1251406807-31495-9-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Configure the rate policies to the firmware based on the rates given by
the AP.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    3 ++
 drivers/net/wireless/wl12xx/wl1271_acx.c  |    4 +-
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_init.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   31 +++++++++++++++++++++++++++++
 5 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 957da8c..671dc5a 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -369,6 +369,9 @@ struct wl1271 {
 	/* Our association ID */
 	u16 aid;
 
+	/* The current band */
+	enum ieee80211_band band;
+
 	/* Default key (for WEP) */
 	u32 default_key;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index f622a40..2ae1081 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -703,7 +703,7 @@ int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats)
 	return 0;
 }
 
-int wl1271_acx_rate_policies(struct wl1271 *wl)
+int wl1271_acx_rate_policies(struct wl1271 *wl, u32 enabled_rates)
 {
 	struct acx_rate_policy *acx;
 	int ret = 0;
@@ -719,7 +719,7 @@ int wl1271_acx_rate_policies(struct wl1271 *wl)
 
 	/* configure one default (one-size-fits-all) rate class */
 	acx->rate_class_cnt = 1;
-	acx->rate_class[0].enabled_rates = ACX_RATE_MASK_ALL;
+	acx->rate_class[0].enabled_rates = enabled_rates;
 	acx->rate_class[0].short_retry_limit = ACX_RATE_RETRY_LIMIT;
 	acx->rate_class[0].long_retry_limit = ACX_RATE_RETRY_LIMIT;
 	acx->rate_class[0].aflags = 0;
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 9068daa..55850eb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -1209,7 +1209,7 @@ int wl1271_acx_set_preamble(struct wl1271 *wl, enum acx_preamble_type preamble);
 int wl1271_acx_cts_protect(struct wl1271 *wl,
 			    enum acx_ctsprotect_type ctsprotect);
 int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats);
-int wl1271_acx_rate_policies(struct wl1271 *wl);
+int wl1271_acx_rate_policies(struct wl1271 *wl, u32 enabled_rates);
 int wl1271_acx_ac_cfg(struct wl1271 *wl);
 int wl1271_acx_tid_cfg(struct wl1271 *wl);
 int wl1271_acx_frag_threshold(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 490df21..eb6b91a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -369,7 +369,7 @@ int wl1271_hw_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Configure TX rate classes */
-	ret = wl1271_acx_rate_policies(wl);
+	ret = wl1271_acx_rate_policies(wl, ACX_RATE_MASK_ALL);
 	if (ret < 0)
 		goto out_free_memmap;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 1a5e575..0f5958d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -583,6 +583,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->ssid_len = 0;
 	wl->listen_int = 1;
 	wl->bss_type = MAX_BSS_TYPE;
+	wl->band = IEEE80211_BAND_2GHZ;
 
 	wl->rx_counter = 0;
 	wl->elp = false;
@@ -728,6 +729,8 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&wl->mutex);
 
+	wl->band = conf->channel->band;
+
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
 		goto out;
@@ -979,6 +982,22 @@ out:
 	return ret;
 }
 
+static u32 wl1271_enabled_rates_get(struct wl1271 *wl, u64 basic_rate_set)
+{
+	struct ieee80211_supported_band *band;
+	u32 enabled_rates = 0;
+	int bit;
+
+	band = wl->hw->wiphy->bands[wl->band];
+	for (bit = 0; bit < band->n_bitrates; bit++) {
+		if (basic_rate_set & 0x1)
+			enabled_rates |= band->bitrates[bit].hw_value;
+		basic_rate_set >>= 1;
+	}
+
+	return enabled_rates;
+}
+
 static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_bss_conf *bss_conf,
@@ -1017,6 +1036,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			}
 		}
 	}
+
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		if (bss_conf->use_short_slot)
 			ret = wl1271_acx_slot(wl, SLOT_TIME_SHORT);
@@ -1046,6 +1066,16 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (changed & BSS_CHANGED_BASIC_RATES) {
+		u32 enabled_rates = wl1271_enabled_rates_get(
+			wl, bss_conf->basic_rates);
+		ret = wl1271_acx_rate_policies(wl, enabled_rates);
+		if (ret < 0) {
+			wl1271_warning("Set rate policies failed %d", ret);
+			goto out_sleep;
+		}
+	}
+
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
@@ -1240,6 +1270,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->psm_requested = false;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
+	wl->band = IEEE80211_BAND_2GHZ;
 
 	/* We use the default power on sleep time until we know which chip
 	 * we're using */
-- 
1.5.6.5

