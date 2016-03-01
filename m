Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31443 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbcCARSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 12:18:40 -0500
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>,
	Lior David <qca_liord@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 09/15] wil6210: p2p initial support
Date: Tue,  1 Mar 2016 19:18:12 +0200
Message-Id: <1456852698-26808-10-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160301_181845_377272_309C202A)
In-Reply-To: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

supporting p2p_find, p2p_listen and p2p_connect
Use updated cfg80211_get_bss API (additional argument)

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Makefile   |   1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c |  67 +++++++--
 drivers/net/wireless/ath/wil6210/main.c     |   6 +
 drivers/net/wireless/ath/wil6210/p2p.c      | 220 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  31 +++-
 drivers/net/wireless/ath/wil6210/wmi.c      |  80 +++++++++-
 6 files changed, 389 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/p2p.c

diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index fdf63d5..11b544b 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -18,6 +18,7 @@ wil6210-$(CONFIG_WIL6210_TRACING) += trace.o
 wil6210-y += wil_platform.o
 wil6210-y += ethtool.o
 wil6210-y += wil_crash_dump.o
+wil6210-y += p2p.o
 
 # for tracing framework to find trace.h
 CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 4a95e1c..80e1482f 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -18,6 +18,8 @@
 #include "wil6210.h"
 #include "wmi.h"
 
+#define WIL_MAX_ROC_DURATION_MS 5000
+
 #define CHAN60G(_channel, _flags) {				\
 	.band			= IEEE80211_BAND_60GHZ,		\
 	.center_freq		= 56160 + (2160 * (_channel)),	\
@@ -239,6 +241,20 @@ static int wil_cfg80211_change_iface(struct wiphy *wiphy,
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	struct wireless_dev *wdev = wil->wdev;
+	int rc;
+
+	wil_dbg_misc(wil, "%s() type=%d\n", __func__, type);
+
+	if (netif_running(wil_to_ndev(wil))) {
+		wil_dbg_misc(wil, "interface is up. resetting...\n");
+		mutex_lock(&wil->mutex);
+		__wil_down(wil);
+		rc = __wil_up(wil);
+		mutex_unlock(&wil->mutex);
+
+		if (rc)
+			return rc;
+	}
 
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
@@ -274,6 +290,8 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	uint i, n;
 	int rc;
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
 	if (wil->scan_request) {
 		wil_err(wil, "Already scanning\n");
 		return -EAGAIN;
@@ -294,6 +312,14 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 		return -EBUSY;
 	}
 
+	/* check if scan request is a P2P search request */
+	if (wil_scan_is_p2p_search(wil, request)) {
+		wil->scan_request = request;
+		return wil_p2p_search(wil, request);
+	}
+
+	wil_p2p_stop_discovery(wil);
+
 	wil_dbg_misc(wil, "Start scan_request 0x%p\n", request);
 	wil_dbg_misc(wil, "SSID count: %d", request->n_ssids);
 
@@ -419,6 +445,7 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	int rc = 0;
 	enum ieee80211_bss_type bss_type = IEEE80211_BSS_TYPE_ESS;
 
+	wil_dbg_misc(wil, "%s()\n", __func__);
 	wil_print_connect_params(wil, sme);
 
 	if (test_bit(wil_status_fwconnecting, wil->status) ||
@@ -584,6 +611,16 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		struct wmi_sw_tx_complete_event evt;
 	} __packed evt;
 
+	/* Note, currently we do not support the "wait" parameter, user-space
+	 * must call remain_on_channel before mgmt_tx or listen on a channel
+	 * another way (AP/PCP or connected station)
+	 * in addition we need to check if specified "chan" argument is
+	 * different from currently "listened" channel and fail if it is.
+	 */
+
+	wil_dbg_misc(wil, "%s()\n", __func__);
+	print_hex_dump_bytes("mgmt tx frame ", DUMP_PREFIX_OFFSET, buf, len);
+
 	cmd = kmalloc(sizeof(*cmd) + len, GFP_KERNEL);
 	if (!cmd) {
 		rc = -ENOMEM;
@@ -628,9 +665,11 @@ static enum wmi_key_usage wil_detect_key_usage(struct wil6210_priv *wil,
 	} else {
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_P2P_CLIENT:
 			rc = WMI_KEY_USE_RX_GROUP;
 			break;
 		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_P2P_GO:
 			rc = WMI_KEY_USE_TX_GROUP;
 			break;
 		default:
@@ -770,16 +809,17 @@ static int wil_remain_on_channel(struct wiphy *wiphy,
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	int rc;
 
-	/* TODO: handle duration */
-	wil_info(wil, "%s(%d, %d ms)\n", __func__, chan->center_freq, duration);
+	wil_dbg_misc(wil, "%s() center_freq=%d, duration=%d\n", __func__,
+		     chan->center_freq, duration);
 
-	rc = wmi_set_channel(wil, chan->hw_value);
+	rc = wil_p2p_listen(wil, duration, chan, cookie);
 	if (rc)
 		return rc;
 
-	rc = wmi_rxon(wil, true);
+	cfg80211_ready_on_channel(wil->wdev, *cookie, chan, duration,
+				  GFP_KERNEL);
 
-	return rc;
+	return 0;
 }
 
 static int wil_cancel_remain_on_channel(struct wiphy *wiphy,
@@ -787,13 +827,12 @@ static int wil_cancel_remain_on_channel(struct wiphy *wiphy,
 					u64 cookie)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
-	int rc;
 
-	wil_info(wil, "%s()\n", __func__);
+	wil_dbg_misc(wil, "%s()\n", __func__);
 
-	rc = wmi_rxon(wil, false);
+	wil_p2p_cancel_listen(wil, cookie);
 
-	return rc;
+	return 0;
 }
 
 /**
@@ -1251,14 +1290,18 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 {
 	wiphy->max_scan_ssids = 1;
 	wiphy->max_scan_ie_len = WMI_MAX_IE_LEN;
+	wiphy->max_remain_on_channel_duration = WIL_MAX_ROC_DURATION_MS;
 	wiphy->max_num_pmkids = 0 /* TODO: */;
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				 BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				 BIT(NL80211_IFTYPE_P2P_GO) |
+				 /* enable this when supporting multi vif
+				  * BIT(NL80211_IFTYPE_P2P_DEVICE) |
+				  */
 				 BIT(NL80211_IFTYPE_MONITOR);
-	/* TODO: enable P2P when integrated with supplicant:
-	 * BIT(NL80211_IFTYPE_P2P_CLIENT) | BIT(NL80211_IFTYPE_P2P_GO)
-	 */
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
+			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
 	dev_dbg(wiphy_dev(wiphy), "%s : flags = 0x%08x\n",
 		__func__, wiphy->flags);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 1472978..025751e 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -453,6 +453,8 @@ int wil_priv_init(struct wil6210_priv *wil)
 	wil->bcast_vring = -1;
 	setup_timer(&wil->connect_timer, wil_connect_timer_fn, (ulong)wil);
 	setup_timer(&wil->scan_timer, wil_scan_timer_fn, (ulong)wil);
+	setup_timer(&wil->p2p.discovery_timer, wil_p2p_discovery_timer_fn,
+		    (ulong)wil);
 
 	INIT_WORK(&wil->disconnect_worker, wil_disconnect_worker);
 	INIT_WORK(&wil->wmi_event_worker, wmi_event_worker);
@@ -513,8 +515,10 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 
 	wil_set_recovery_state(wil, fw_recovery_idle);
 	del_timer_sync(&wil->scan_timer);
+	del_timer_sync(&wil->p2p.discovery_timer);
 	cancel_work_sync(&wil->disconnect_worker);
 	cancel_work_sync(&wil->fw_error_worker);
+	cancel_work_sync(&wil->p2p.discovery_expired_work);
 	mutex_lock(&wil->mutex);
 	wil6210_disconnect(wil, NULL, WLAN_REASON_DEAUTH_LEAVING, false);
 	mutex_unlock(&wil->mutex);
@@ -979,6 +983,8 @@ int __wil_down(struct wil6210_priv *wil)
 	}
 	wil_enable_irq(wil);
 
+	wil_p2p_stop_discovery(wil);
+
 	if (wil->scan_request) {
 		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
 			     wil->scan_request);
diff --git a/drivers/net/wireless/ath/wil6210/p2p.c b/drivers/net/wireless/ath/wil6210/p2p.c
new file mode 100644
index 0000000..974bf84
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/p2p.c
@@ -0,0 +1,220 @@
+/*
+ * Copyright (c) 2014-2016 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "wil6210.h"
+#include "wmi.h"
+
+#define P2P_WILDCARD_SSID "DIRECT-"
+#define P2P_DMG_SOCIAL_CHANNEL 2
+#define P2P_SEARCH_DURATION_MS 500
+#define P2P_DEFAULT_BI 100
+
+int wil_scan_is_p2p_search(struct wil6210_priv *wil,
+			   struct cfg80211_scan_request *request)
+{
+	/* need P2P_DEVICE changes to make this work */
+	return 0;
+}
+
+void wil_p2p_discovery_timer_fn(ulong x)
+{
+	struct wil6210_priv *wil = (void *)x;
+
+	wil_dbg_misc(wil, "%s\n", __func__);
+
+	schedule_work(&wil->p2p.discovery_expired_work);
+}
+
+int wil_p2p_search(struct wil6210_priv *wil,
+		   struct cfg80211_scan_request *request)
+{
+	int rc;
+	struct wil_p2p_info *p2p = &wil->p2p;
+
+	wil_dbg_misc(wil, "%s: channel %d\n",
+		     __func__, P2P_DMG_SOCIAL_CHANNEL);
+
+	mutex_lock(&wil->mutex);
+
+	if (p2p->discovery_started) {
+		wil_err(wil, "%s: search failed. discovery already ongoing\n",
+			__func__);
+		rc = -EBUSY;
+		goto out;
+	}
+
+	rc = wmi_p2p_cfg(wil, P2P_DMG_SOCIAL_CHANNEL, P2P_DEFAULT_BI);
+	if (rc) {
+		wil_err(wil, "%s: wmi_p2p_cfg failed\n", __func__);
+		goto out;
+	}
+
+	rc = wmi_set_ssid(wil, strlen(P2P_WILDCARD_SSID), P2P_WILDCARD_SSID);
+	if (rc) {
+		wil_err(wil, "%s: wmi_set_ssid failed\n", __func__);
+		goto out_stop;
+	}
+
+	/* Set application IE to probe request and probe response */
+	rc = wmi_set_ie(wil, WMI_FRAME_PROBE_REQ,
+			request->ie_len, request->ie);
+	if (rc) {
+		wil_err(wil, "%s: wmi_set_ie(WMI_FRAME_PROBE_REQ) failed\n",
+			__func__);
+		goto out_stop;
+	}
+
+	/* supplicant doesn't provide Probe Response IEs. As a workaround -
+	 * re-use Probe Request IEs
+	 */
+	rc = wmi_set_ie(wil, WMI_FRAME_PROBE_RESP,
+			request->ie_len, request->ie);
+	if (rc) {
+		wil_err(wil, "%s: wmi_set_ie(WMI_FRAME_PROBE_RESP) failed\n",
+			__func__);
+		goto out_stop;
+	}
+
+	rc = wmi_start_search(wil);
+	if (rc) {
+		wil_err(wil, "%s: wmi_start_search failed\n", __func__);
+		goto out_stop;
+	}
+
+	p2p->discovery_started = 1;
+	INIT_WORK(&p2p->discovery_expired_work, wil_p2p_search_expired);
+	mod_timer(&p2p->discovery_timer,
+		  jiffies + msecs_to_jiffies(P2P_SEARCH_DURATION_MS));
+
+out_stop:
+	if (rc)
+		wmi_stop_discovery(wil);
+
+out:
+	mutex_unlock(&wil->mutex);
+	return rc;
+}
+
+int wil_p2p_listen(struct wil6210_priv *wil, unsigned int duration,
+		   struct ieee80211_channel *chan, u64 *cookie)
+{
+	struct wil_p2p_info *p2p = &wil->p2p;
+	u8 channel = P2P_DMG_SOCIAL_CHANNEL;
+	int rc;
+
+	if (chan)
+		channel = chan->hw_value;
+
+	wil_dbg_misc(wil, "%s: duration %d\n", __func__, duration);
+
+	mutex_lock(&wil->mutex);
+
+	if (p2p->discovery_started) {
+		wil_err(wil, "%s: discovery already ongoing\n", __func__);
+		rc = -EBUSY;
+		goto out;
+	}
+
+	rc = wmi_p2p_cfg(wil, channel, P2P_DEFAULT_BI);
+	if (rc) {
+		wil_err(wil, "%s: wmi_p2p_cfg failed\n", __func__);
+		goto out;
+	}
+
+	rc = wmi_set_ssid(wil, strlen(P2P_WILDCARD_SSID), P2P_WILDCARD_SSID);
+	if (rc) {
+		wil_err(wil, "%s: wmi_set_ssid failed\n", __func__);
+		goto out_stop;
+	}
+
+	rc = wmi_start_listen(wil);
+	if (rc) {
+		wil_err(wil, "%s: wmi_start_listen failed\n", __func__);
+		goto out_stop;
+	}
+
+	memcpy(&p2p->listen_chan, chan, sizeof(*chan));
+	*cookie = ++p2p->cookie;
+
+	p2p->discovery_started = 1;
+	INIT_WORK(&p2p->discovery_expired_work, wil_p2p_listen_expired);
+	mod_timer(&p2p->discovery_timer,
+		  jiffies + msecs_to_jiffies(duration));
+
+out_stop:
+	if (rc)
+		wmi_stop_discovery(wil);
+
+out:
+	mutex_unlock(&wil->mutex);
+	return rc;
+}
+
+void wil_p2p_stop_discovery(struct wil6210_priv *wil)
+{
+	struct wil_p2p_info *p2p = &wil->p2p;
+
+	if (p2p->discovery_started) {
+		del_timer_sync(&p2p->discovery_timer);
+		p2p->discovery_started = 0;
+		wmi_stop_discovery(wil);
+	}
+}
+
+void wil_p2p_cancel_listen(struct wil6210_priv *wil, u64 cookie)
+{
+	struct wil_p2p_info *p2p = &wil->p2p;
+
+	if (cookie != p2p->cookie)
+		wil_info(wil, "%s: Cookie mismatch: 0x%016llx vs. 0x%016llx\n",
+			 __func__, p2p->cookie, cookie);
+
+	wil_p2p_stop_discovery(wil);
+	cfg80211_remain_on_channel_expired(wil->wdev,
+					   p2p->cookie,
+					   &p2p->listen_chan,
+					   GFP_KERNEL);
+}
+
+void wil_p2p_listen_expired(struct work_struct *work)
+{
+	struct wil_p2p_info *p2p = container_of(work,
+			struct wil_p2p_info, discovery_expired_work);
+	struct wil6210_priv *wil = container_of(p2p,
+			struct wil6210_priv, p2p);
+
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
+	wil_p2p_stop_discovery(wil);
+	cfg80211_remain_on_channel_expired(wil->wdev,
+					   p2p->cookie,
+					   &p2p->listen_chan,
+					   GFP_KERNEL);
+}
+
+void wil_p2p_search_expired(struct work_struct *work)
+{
+	struct wil_p2p_info *p2p = container_of(work,
+			struct wil_p2p_info, discovery_expired_work);
+	struct wil6210_priv *wil = container_of(p2p,
+			struct wil6210_priv, p2p);
+
+	wil_dbg_misc(wil, "%s()\n", __func__);
+
+	wil_p2p_stop_discovery(wil);
+	cfg80211_scan_done(wil->scan_request, 0);
+	wil->scan_request = NULL;
+}
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 69d970a..0aba86c 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -453,6 +453,14 @@ struct wil_tid_crypto_rx {
 	struct wil_tid_crypto_rx_single key_id[4];
 };
 
+struct wil_p2p_info {
+	struct ieee80211_channel listen_chan;
+	u8 discovery_started;
+	u64 cookie;
+	struct timer_list discovery_timer; /* listen/search duration */
+	struct work_struct discovery_expired_work; /* listen/search expire */
+};
+
 enum wil_sta_status {
 	wil_sta_unused = 0,
 	wil_sta_conn_pending = 1,
@@ -606,6 +614,8 @@ struct wil6210_priv {
 	struct pmc_ctx pmc;
 
 	bool pbss;
+
+	struct wil_p2p_info p2p;
 };
 
 #define wil_to_wiphy(i) (i->wdev->wiphy)
@@ -731,7 +741,6 @@ int wmi_add_cipher_key(struct wil6210_priv *wil, u8 key_index,
 int wmi_echo(struct wil6210_priv *wil);
 int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie);
 int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring);
-int wmi_p2p_cfg(struct wil6210_priv *wil, int channel);
 int wmi_rxon(struct wil6210_priv *wil, bool on);
 int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r);
 int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac, u16 reason,
@@ -754,6 +763,26 @@ void wil_unmask_irq(struct wil6210_priv *wil);
 void wil_configure_interrupt_moderation(struct wil6210_priv *wil);
 void wil_disable_irq(struct wil6210_priv *wil);
 void wil_enable_irq(struct wil6210_priv *wil);
+
+/* P2P */
+int wil_scan_is_p2p_search(struct wil6210_priv *wil,
+			   struct cfg80211_scan_request *request);
+void wil_p2p_discovery_timer_fn(ulong x);
+int wil_p2p_search(struct wil6210_priv *wil,
+		   struct cfg80211_scan_request *request);
+int wil_p2p_listen(struct wil6210_priv *wil, unsigned int duration,
+		   struct ieee80211_channel *chan, u64 *cookie);
+void wil_p2p_stop_discovery(struct wil6210_priv *wil);
+void wil_p2p_cancel_listen(struct wil6210_priv *wil, u64 cookie);
+void wil_p2p_listen_expired(struct work_struct *work);
+void wil_p2p_search_expired(struct work_struct *work);
+
+/* WMI for P2P */
+int wmi_p2p_cfg(struct wil6210_priv *wil, int channel, int bi);
+int wmi_start_listen(struct wil6210_priv *wil);
+int wmi_start_search(struct wil6210_priv *wil);
+int wmi_stop_discovery(struct wil6210_priv *wil);
+
 int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct cfg80211_mgmt_tx_params *params,
 			 u64 *cookie);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index db7d2b6..4a1cdd2 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -368,6 +368,8 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 		wil_hex_dump_wmi("IE ", DUMP_PREFIX_OFFSET, 16, 1, ie_buf,
 				 ie_len, true);
 
+		wil_dbg_wmi(wil, "Capability info : 0x%04x\n", cap);
+
 		bss = cfg80211_inform_bss_frame(wiphy, channel, rx_mgmt_frame,
 						d_len, signal, GFP_KERNEL);
 		if (bss) {
@@ -1072,14 +1074,86 @@ int wmi_get_channel(struct wil6210_priv *wil, int *channel)
 	return 0;
 }
 
-int wmi_p2p_cfg(struct wil6210_priv *wil, int channel)
+int wmi_p2p_cfg(struct wil6210_priv *wil, int channel, int bi)
 {
+	int rc;
 	struct wmi_p2p_cfg_cmd cmd = {
-		.discovery_mode = WMI_DISCOVERY_MODE_NON_OFFLOAD,
+		.discovery_mode = WMI_DISCOVERY_MODE_PEER2PEER,
+		.bcon_interval = cpu_to_le16(bi),
 		.channel = channel - 1,
 	};
+	struct {
+		struct wmi_cmd_hdr wmi;
+		struct wmi_p2p_cfg_done_event evt;
+	} __packed reply;
+
+	wil_dbg_wmi(wil, "sending WMI_P2P_CFG_CMDID\n");
+
+	rc = wmi_call(wil, WMI_P2P_CFG_CMDID, &cmd, sizeof(cmd),
+		      WMI_P2P_CFG_DONE_EVENTID, &reply, sizeof(reply), 300);
+	if (!rc && reply.evt.status != WMI_FW_STATUS_SUCCESS) {
+		wil_err(wil, "P2P_CFG failed. status %d\n", reply.evt.status);
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
+int wmi_start_listen(struct wil6210_priv *wil)
+{
+	int rc;
+	struct {
+		struct wmi_cmd_hdr wmi;
+		struct wmi_listen_started_event evt;
+	} __packed reply;
+
+	wil_dbg_wmi(wil, "sending WMI_START_LISTEN_CMDID\n");
+
+	rc = wmi_call(wil, WMI_START_LISTEN_CMDID, NULL, 0,
+		      WMI_LISTEN_STARTED_EVENTID, &reply, sizeof(reply), 300);
+	if (!rc && reply.evt.status != WMI_FW_STATUS_SUCCESS) {
+		wil_err(wil, "device failed to start listen. status %d\n",
+			reply.evt.status);
+		rc = -EINVAL;
+	}
 
-	return wmi_send(wil, WMI_P2P_CFG_CMDID, &cmd, sizeof(cmd));
+	return rc;
+}
+
+int wmi_start_search(struct wil6210_priv *wil)
+{
+	int rc;
+	struct {
+		struct wmi_cmd_hdr wmi;
+		struct wmi_search_started_event evt;
+	} __packed reply;
+
+	wil_dbg_wmi(wil, "sending WMI_START_SEARCH_CMDID\n");
+
+	rc = wmi_call(wil, WMI_START_SEARCH_CMDID, NULL, 0,
+		      WMI_SEARCH_STARTED_EVENTID, &reply, sizeof(reply), 300);
+	if (!rc && reply.evt.status != WMI_FW_STATUS_SUCCESS) {
+		wil_err(wil, "device failed to start search. status %d\n",
+			reply.evt.status);
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
+int wmi_stop_discovery(struct wil6210_priv *wil)
+{
+	int rc;
+
+	wil_dbg_wmi(wil, "sending WMI_DISCOVERY_STOP_CMDID\n");
+
+	rc = wmi_call(wil, WMI_DISCOVERY_STOP_CMDID, NULL, 0,
+		      WMI_DISCOVERY_STOPPED_EVENTID, NULL, 0, 100);
+
+	if (rc)
+		wil_err(wil, "Failed to stop discovery\n");
+
+	return rc;
 }
 
 int wmi_del_cipher_key(struct wil6210_priv *wil, u8 key_index,
-- 
1.8.5.2

