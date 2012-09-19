Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3073 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab2ISUVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:42 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/13] brcmfmac: introduce scheduled scan support
Date: Wed, 19 Sep 2012 22:21:08 +0200
Message-ID: <1348086078-19183-4-git-send-email-arend@broadcom.com> (sfid-20120919_222553_057621_E2BCB834)
In-Reply-To: <1348086078-19183-1-git-send-email-arend@broadcom.com>
References: <1348086078-19183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change add support for NL80211 scheduled scan. This may be used to
offload scanning to the device, which may give the host opportunity to
sleep. The newer versions of wpa_supplicant have support for this
functionality.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  306 +++++++++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   82 ++++++
 2 files changed, 387 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6536656..2f0a103 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -36,6 +36,18 @@
 #include "dhd.h"
 #include "wl_cfg80211.h"
 
+#define BRCMF_SCAN_IE_LEN_MAX		2048
+#define BRCMF_PNO_VERSION		2
+#define BRCMF_PNO_TIME			30
+#define BRCMF_PNO_REPEAT		4
+#define BRCMF_PNO_FREQ_EXPO_MAX		3
+#define BRCMF_PNO_MAX_PFN_COUNT		16
+#define BRCMF_PNO_ENABLE_ADAPTSCAN_BIT	6
+#define BRCMF_PNO_HIDDEN_BIT		2
+#define BRCMF_PNO_WPA_AUTH_ANY		0xFFFFFFFF
+#define BRCMF_PNO_SCAN_COMPLETE		1
+#define BRCMF_PNO_SCAN_INCOMPLETE	0
+
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
 
@@ -832,7 +844,17 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_priv *cfg_priv,
 		if (err)
 			WL_ERR("Scan abort  failed\n");
 	}
-	if (scan_request) {
+	/*
+	 * e-scan can be initiated by scheduled scan
+	 * which takes precedence.
+	 */
+	if (cfg_priv->sched_escan) {
+		WL_SCAN("scheduled scan completed\n");
+		cfg_priv->sched_escan = false;
+		if (!aborted)
+			cfg80211_sched_scan_results(cfg_to_wiphy(cfg_priv));
+		brcmf_set_mpc(ndev, 1);
+	} else if (scan_request) {
 		WL_SCAN("ESCAN Completed scan: %s\n",
 				aborted ? "Aborted" : "Done");
 		cfg80211_scan_done(scan_request, aborted);
@@ -3231,6 +3253,269 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 
 }
 
+/*
+ * PFN result doesn't have all the info which are
+ * required by the supplicant
+ * (For e.g IEs) Do a target Escan so that sched scan results are reported
+ * via wl_inform_single_bss in the required format. Escan does require the
+ * scan request in the form of cfg80211_scan_request. For timebeing, create
+ * cfg80211_scan_request one out of the received PNO event.
+ */
+static s32
+brcmf_notify_sched_scan_results(struct brcmf_cfg80211_priv *cfg_priv,
+				struct net_device *ndev,
+				const struct brcmf_event_msg *e, void *data)
+{
+	struct brcmf_pno_net_info_le *netinfo, *netinfo_start;
+	struct cfg80211_scan_request *request = NULL;
+	struct cfg80211_ssid *ssid = NULL;
+	struct ieee80211_channel *channel = NULL;
+	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
+	int err = 0;
+	int channel_req = 0;
+	int band = 0;
+	struct brcmf_pno_scanresults_le *pfn_result;
+	u32 result_count;
+	u32 status;
+
+	WL_SCAN("Enter\n");
+
+	if (e->event_type == cpu_to_be32(BRCMF_E_PFN_NET_LOST)) {
+		WL_SCAN("PFN NET LOST event. Do Nothing\n");
+		return 0;
+	}
+
+	pfn_result = (struct brcmf_pno_scanresults_le *)data;
+	result_count = le32_to_cpu(pfn_result->count);
+	status = le32_to_cpu(pfn_result->status);
+
+	/*
+	 * PFN event is limited to fit 512 bytes so we may get
+	 * multiple NET_FOUND events. For now place a warning here.
+	 */
+	WARN_ON(status != BRCMF_PNO_SCAN_COMPLETE);
+	WL_SCAN("PFN NET FOUND event. count: %d\n", result_count);
+	if (result_count > 0) {
+		int i;
+
+		request = kzalloc(sizeof(*request), GFP_KERNEL);
+		ssid = kzalloc(sizeof(*ssid) * result_count, GFP_KERNEL);
+		channel = kzalloc(sizeof(*channel) * result_count, GFP_KERNEL);
+		if (!request || !ssid || !channel) {
+			err = -ENOMEM;
+			goto out_err;
+		}
+
+		request->wiphy = wiphy;
+		data += sizeof(struct brcmf_pno_scanresults_le);
+		netinfo_start = (struct brcmf_pno_net_info_le *)data;
+
+		for (i = 0; i < result_count; i++) {
+			netinfo = &netinfo_start[i];
+			if (!netinfo) {
+				WL_ERR("Invalid netinfo ptr. index: %d\n", i);
+				err = -EINVAL;
+				goto out_err;
+			}
+
+			WL_SCAN("SSID:%s Channel:%d\n",
+			netinfo->SSID, netinfo->channel);
+			memcpy(ssid[i].ssid, netinfo->SSID, netinfo->SSID_len);
+			ssid[i].ssid_len = netinfo->SSID_len;
+			request->n_ssids++;
+
+			channel_req = netinfo->channel;
+			if (channel_req <= CH_MAX_2G_CHANNEL)
+				band = NL80211_BAND_2GHZ;
+			else
+				band = NL80211_BAND_5GHZ;
+			channel[i].center_freq =
+				ieee80211_channel_to_frequency(channel_req,
+							       band);
+			channel[i].band = band;
+			channel[i].flags |= IEEE80211_CHAN_NO_HT40;
+			request->channels[i] = &channel[i];
+			request->n_channels++;
+		}
+
+		/* assign parsed ssid array */
+		if (request->n_ssids)
+			request->ssids = &ssid[0];
+
+		if (test_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
+			/* Abort any on-going scan */
+			brcmf_abort_scanning(cfg_priv);
+		}
+
+		set_bit(WL_STATUS_SCANNING, &cfg_priv->status);
+		err = brcmf_do_escan(cfg_priv, wiphy, ndev, request);
+		if (err) {
+			clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
+			goto out_err;
+		}
+		cfg_priv->sched_escan = true;
+		cfg_priv->scan_request = request;
+	} else {
+		WL_ERR("FALSE PNO Event. (pfn_count == 0)\n");
+		goto out_err;
+	}
+
+	kfree(ssid);
+	kfree(channel);
+	kfree(request);
+	return 0;
+
+out_err:
+	kfree(ssid);
+	kfree(channel);
+	kfree(request);
+	cfg80211_sched_scan_stopped(wiphy);
+	return err;
+}
+
+#ifndef CONFIG_BRCMISCAN
+static int brcmf_dev_pno_clean(struct net_device *ndev)
+{
+	char iovbuf[128];
+	int ret;
+
+	/* Disable pfn */
+	ret = brcmf_dev_intvar_set(ndev, "pfn", 0);
+	if (ret == 0) {
+		/* clear pfn */
+		ret = brcmf_dev_iovar_setbuf(ndev, "pfnclear", NULL, 0,
+					     iovbuf, sizeof(iovbuf));
+	}
+	if (ret < 0)
+		WL_ERR("failed code %d\n", ret);
+
+	return ret;
+}
+
+static int brcmf_dev_pno_config(struct net_device *ndev)
+{
+	struct brcmf_pno_param_le pfn_param;
+	char iovbuf[128];
+
+	memset(&pfn_param, 0, sizeof(pfn_param));
+	pfn_param.version = cpu_to_le32(BRCMF_PNO_VERSION);
+
+	/* set extra pno params */
+	pfn_param.flags = cpu_to_le16(1 << BRCMF_PNO_ENABLE_ADAPTSCAN_BIT);
+	pfn_param.repeat = BRCMF_PNO_REPEAT;
+	pfn_param.exp = BRCMF_PNO_FREQ_EXPO_MAX;
+
+	/* set up pno scan fr */
+	pfn_param.scan_freq = cpu_to_le32(BRCMF_PNO_TIME);
+
+	return brcmf_dev_iovar_setbuf(ndev, "pfn_set",
+				      &pfn_param, sizeof(pfn_param),
+				      iovbuf, sizeof(iovbuf));
+}
+
+static int
+brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
+				struct net_device *ndev,
+				struct cfg80211_sched_scan_request *request)
+{
+	char iovbuf[128];
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_priv(wiphy);
+	struct brcmf_pno_net_param_le pfn;
+	int i;
+	int ret = 0;
+
+	WL_SCAN("Enter n_match_sets:%d   n_ssids:%d\n",
+		request->n_match_sets, request->n_ssids);
+	if (test_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
+		WL_ERR("Scanning already : status (%lu)\n", cfg_priv->status);
+		return -EAGAIN;
+	}
+
+	if (!request || !request->n_ssids || !request->n_match_sets) {
+		WL_ERR("Invalid sched scan req!! n_ssids:%d\n",
+		       request->n_ssids);
+		return -EINVAL;
+	}
+
+	if (request->n_ssids > 0) {
+		for (i = 0; i < request->n_ssids; i++) {
+			/* Active scan req for ssids */
+			WL_SCAN(">>> Active scan req for ssid (%s)\n",
+				request->ssids[i].ssid);
+
+			/*
+			 * match_set ssids is a supert set of n_ssid list,
+			 * so we need not add these set seperately.
+			 */
+		}
+	}
+
+	if (request->n_match_sets > 0) {
+		/* clean up everything */
+		ret = brcmf_dev_pno_clean(ndev);
+		if  (ret < 0) {
+			WL_ERR("failed error=%d\n", ret);
+			return ret;
+		}
+
+		/* configure pno */
+		ret = brcmf_dev_pno_config(ndev);
+		if (ret < 0) {
+			WL_ERR("PNO setup failed!! ret=%d\n", ret);
+			return -EINVAL;
+		}
+
+		/* configure each match set */
+		for (i = 0; i < request->n_match_sets; i++) {
+			struct cfg80211_ssid *ssid;
+			u32 ssid_len;
+
+			ssid = &request->match_sets[i].ssid;
+			ssid_len = ssid->ssid_len;
+
+			if (!ssid_len) {
+				WL_ERR("skip broadcast ssid\n");
+				continue;
+			}
+			pfn.auth = cpu_to_le32(WLAN_AUTH_OPEN);
+			pfn.wpa_auth = cpu_to_le32(BRCMF_PNO_WPA_AUTH_ANY);
+			pfn.wsec = cpu_to_le32(0);
+			pfn.infra = cpu_to_le32(1);
+			pfn.flags = cpu_to_le32(1 << BRCMF_PNO_HIDDEN_BIT);
+			pfn.ssid.SSID_len = cpu_to_le32(ssid_len);
+			memcpy(pfn.ssid.SSID, ssid->ssid, ssid_len);
+			ret = brcmf_dev_iovar_setbuf(ndev, "pfn_add",
+						     &pfn, sizeof(pfn),
+						     iovbuf, sizeof(iovbuf));
+			WL_SCAN(">>> PNO filter %s for ssid (%s)\n",
+				ret == 0 ? "set" : "failed",
+				ssid->ssid);
+		}
+		/* Enable the PNO */
+		if (brcmf_dev_intvar_set(ndev, "pfn", 1) < 0) {
+			WL_ERR("PNO enable failed!! ret=%d\n", ret);
+			return -EINVAL;
+		}
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
+					  struct net_device *ndev)
+{
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+
+	WL_SCAN("enter\n");
+	brcmf_dev_pno_clean(ndev);
+	if (cfg_priv->sched_escan)
+		brcmf_notify_escan_complete(cfg_priv, ndev, true, true);
+	return 0;
+}
+#endif /* CONFIG_BRCMISCAN */
+
 #ifdef CONFIG_NL80211_TESTMODE
 static int brcmf_cfg80211_testmode(struct wiphy *wiphy, void *data, int len)
 {
@@ -3273,6 +3558,11 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.set_pmksa = brcmf_cfg80211_set_pmksa,
 	.del_pmksa = brcmf_cfg80211_del_pmksa,
 	.flush_pmksa = brcmf_cfg80211_flush_pmksa,
+#ifndef CONFIG_BRCMISCAN
+	/* scheduled scan need e-scan, which is mutual exclusive with i-scan */
+	.sched_scan_start = brcmf_cfg80211_sched_scan_start,
+	.sched_scan_stop = brcmf_cfg80211_sched_scan_stop,
+#endif
 #ifdef CONFIG_NL80211_TESTMODE
 	.testmode_cmd = brcmf_cfg80211_testmode
 #endif
@@ -3294,6 +3584,17 @@ static s32 brcmf_mode_to_nl80211_iftype(s32 mode)
 	return err;
 }
 
+static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
+{
+#ifndef CONFIG_BRCMFISCAN
+	/* scheduled scan settings */
+	wiphy->max_sched_scan_ssids = BRCMF_PNO_MAX_PFN_COUNT;
+	wiphy->max_match_sets = BRCMF_PNO_MAX_PFN_COUNT;
+	wiphy->max_sched_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
+	wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
+#endif
+}
+
 static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 					  struct device *ndev)
 {
@@ -3332,6 +3633,7 @@ static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 								 * save mode
 								 * by default
 								 */
+	brcmf_wiphy_pno_params(wdev->wiphy);
 	err = wiphy_register(wdev->wiphy);
 	if (err < 0) {
 		WL_ERR("Could not register wiphy device (%d)\n", err);
@@ -3734,6 +4036,7 @@ static void brcmf_init_eloop_handler(struct brcmf_cfg80211_event_loop *el)
 	el->handler[BRCMF_E_ROAM] = brcmf_notify_roaming_status;
 	el->handler[BRCMF_E_MIC_ERROR] = brcmf_notify_mic_status;
 	el->handler[BRCMF_E_SET_SSID] = brcmf_notify_connect_status;
+	el->handler[BRCMF_E_PFN_NET_FOUND] = brcmf_notify_sched_scan_results;
 }
 
 static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
@@ -4105,6 +4408,7 @@ static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 	setbit(eventmask, BRCMF_E_JOIN_START);
 	setbit(eventmask, BRCMF_E_SCAN_COMPLETE);
 	setbit(eventmask, BRCMF_E_ESCAN_RESULT);
+	setbit(eventmask, BRCMF_E_PFN_NET_FOUND);
 
 	brcmf_c_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN,
 			iovbuf, sizeof(iovbuf));
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 3b21297..b5c3fd9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -295,6 +295,87 @@ struct escan_info {
 	struct net_device *ndev;
 };
 
+/**
+ * struct brcmf_pno_param_le - PNO scan configuration parameters
+ *
+ * @version: PNO parameters version.
+ * @scan_freq: scan frequency.
+ * @lost_network_timeout: #sec. to declare discovered network as lost.
+ * @flags: Bit field to control features of PFN such as sort criteria auto
+ *	enable switch and background scan.
+ * @rssi_margin: Margin to avoid jitter for choosing a PFN based on RSSI sort
+ *	criteria.
+ * @bestn: number of best networks in each scan.
+ * @mscan: number of scans recorded.
+ * @repeat: minimum number of scan intervals before scan frequency changes
+ *	in adaptive scan.
+ * @exp: exponent of 2 for maximum scan interval.
+ * @slow_freq: slow scan period.
+ */
+struct brcmf_pno_param_le {
+	__le32 version;
+	__le32 scan_freq;
+	__le32 lost_network_timeout;
+	__le16 flags;
+	__le16 rssi_margin;
+	u8 bestn;
+	u8 mscan;
+	u8 repeat;
+	u8 exp;
+	__le32 slow_freq;
+};
+
+/**
+ * struct brcmf_pno_net_param_le - scan parameters per preferred network.
+ *
+ * @ssid: ssid name and its length.
+ * @flags: bit2: hidden.
+ * @infra: BSS vs IBSS.
+ * @auth: Open vs Closed.
+ * @wpa_auth: WPA type.
+ * @wsec: wsec value.
+ */
+struct brcmf_pno_net_param_le {
+	struct brcmf_ssid_le ssid;
+	__le32 flags;
+	__le32 infra;
+	__le32 auth;
+	__le32 wpa_auth;
+	__le32 wsec;
+};
+
+/**
+ * struct brcmf_pno_net_info_le - information per found network.
+ *
+ * @bssid: BSS network identifier.
+ * @channel: channel number only.
+ * @SSID_len: length of ssid.
+ * @SSID: ssid characters.
+ * @RSSI: receive signal strength (in dBm).
+ * @timestamp: age in seconds.
+ */
+struct brcmf_pno_net_info_le {
+	u8 bssid[ETH_ALEN];
+	u8 channel;
+	u8 SSID_len;
+	u8 SSID[32];
+	__le16	RSSI;
+	__le16	timestamp;
+};
+
+/**
+ * struct brcmf_pno_scanresults_le - result returned in PNO NET FOUND event.
+ *
+ * @version: PNO version identifier.
+ * @status: indicates completion status of PNO scan.
+ * @count: amount of brcmf_pno_net_info_le entries appended.
+ */
+struct brcmf_pno_scanresults_le {
+	__le32 version;
+	__le32 status;
+	__le32 count;
+};
+
 /* dongle private data of cfg80211 interface */
 struct brcmf_cfg80211_priv {
 	struct wireless_dev *wdev;	/* representing wl cfg80211 device */
@@ -325,6 +406,7 @@ struct brcmf_cfg80211_priv {
 	bool iscan_on;		/* iscan on/off switch */
 	bool iscan_kickstart;	/* indicate iscan already started */
 	bool active_scan;	/* current scan mode */
+	bool sched_escan;	/* e-scan for scheduled scan support running */
 	bool ibss_starter;	/* indicates this sta is ibss starter */
 	bool link_up;		/* link/connection up flag */
 	bool pwr_save;		/* indicate whether dongle to support
-- 
1.7.9.5


