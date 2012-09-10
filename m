Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2622 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab2IJNbW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 09:31:22 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/10] brcmfmac: add e-scan support.
Date: Mon, 10 Sep 2012 15:16:58 +0200
Message-ID: <1347283018-24223-11-git-send-email-arend@broadcom.com> (sfid-20120910_153133_308729_75B7F8C3)
In-Reply-To: <1347283018-24223-1-git-send-email-arend@broadcom.com>
References: <1347283018-24223-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

This patch adds e-scan support (currently i-scan is in use). E-scan
is a more powerful and memory efficient method for scanning. E-scan
will be the default scan method and eventually, i-scan support will
be removed. The scan methods do not make any difference to the end-user.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/Kconfig             |    8 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   22 +
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    8 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  522 +++++++++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   25 +
 5 files changed, 583 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index b480088..c9d811e 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -55,6 +55,14 @@ config BRCMFMAC_USB
 	  IEEE802.11n embedded FullMAC WLAN driver. Say Y if you want to
 	  use the driver for an USB wireless card.
 
+config BRCMISCAN
+	bool "Broadcom I-Scan (OBSOLETE)"
+	depends on BRCMFMAC
+	---help---
+	  This option enables the I-Scan method. By default fullmac uses the
+	  new E-Scan method which uses less memory in firmware and gives no
+	  limitation on the number of scan results.
+
 config BRCMDBG
 	bool "Broadcom driver debug functions"
 	depends on BRCMSMAC || BRCMFMAC
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 9e2fb5b..4766d9f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -130,6 +130,10 @@
 #define BRCMF_EVENT_MSG_FLUSHTXQ	0x02
 #define BRCMF_EVENT_MSG_GROUP		0x04
 
+#define BRCMF_ESCAN_REQ_VERSION 1
+
+#define WLC_BSS_RSSI_ON_CHANNEL		0x0002
+
 struct brcmf_event_msg {
 	__be16 version;
 	__be16 flags;
@@ -456,6 +460,24 @@ struct brcmf_scan_results_le {
 	__le32 count;
 };
 
+struct brcmf_escan_params_le {
+	__le32 version;
+	__le16 action;
+	__le16 sync_id;
+	struct brcmf_scan_params_le params_le;
+};
+
+struct brcmf_escan_result_le {
+	__le32 buflen;
+	__le32 version;
+	__le16 sync_id;
+	__le16 bss_count;
+	struct brcmf_bss_info_le bss_info_le;
+};
+
+#define WL_ESCAN_RESULTS_FIXED_SIZE (sizeof(struct brcmf_escan_result_le) - \
+	sizeof(struct brcmf_bss_info_le))
+
 /* used for association with a specific BSSID and chanspec list */
 struct brcmf_assoc_params_le {
 	/* 00:00:00:00:00:00: broadcast scan */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 6f70953..8121dba 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -205,7 +205,8 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 		BRCMF_E_ACTION_FRAME_COMPLETE, "ACTION FRAME TX COMPLETE"}, {
 		BRCMF_E_IF, "IF"}, {
 		BRCMF_E_RSSI, "RSSI"}, {
-		BRCMF_E_PFN_SCAN_COMPLETE, "SCAN_COMPLETE"}
+		BRCMF_E_PFN_SCAN_COMPLETE, "SCAN_COMPLETE"}, {
+		BRCMF_E_ESCAN_RESULT, "ESCAN_RESULT"}
 	};
 	uint event_type, flags, auth_type, datalen;
 	static u32 seqnum_prev;
@@ -350,6 +351,11 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 		brcmf_dbg(EVENT, "MACEVENT: %s\n", event_name);
 		break;
 
+	case BRCMF_E_ESCAN_RESULT:
+		brcmf_dbg(EVENT, "MACEVENT: %s\n", event_name);
+		datalen = 0;
+		break;
+
 	case BRCMF_E_PFN_NET_FOUND:
 	case BRCMF_E_PFN_NET_LOST:
 	case BRCMF_E_PFN_SCAN_COMPLETE:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6623f48..32ee052 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -693,11 +693,342 @@ scan_out:
 	return err;
 }
 
+static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
+			     struct cfg80211_scan_request *request)
+{
+	u32 n_ssids;
+	u32 n_channels;
+	s32 i;
+	s32 offset;
+	__le16 chanspec;
+	u16 channel;
+	struct ieee80211_channel *req_channel;
+	char *ptr;
+	struct brcmf_ssid ssid;
+
+	memcpy(params_le->bssid, ether_bcast, ETH_ALEN);
+	params_le->bss_type = DOT11_BSSTYPE_ANY;
+	params_le->scan_type = 0;
+	params_le->channel_num = 0;
+	params_le->nprobes = cpu_to_le32(-1);
+	params_le->active_time = cpu_to_le32(-1);
+	params_le->passive_time = cpu_to_le32(-1);
+	params_le->home_time = cpu_to_le32(-1);
+	memset(&params_le->ssid_le, 0, sizeof(params_le->ssid_le));
+
+	/* if request is null exit so it will be all channel broadcast scan */
+	if (!request)
+		return;
+
+	n_ssids = request->n_ssids;
+	n_channels = request->n_channels;
+	/* Copy channel array if applicable */
+	WL_SCAN("### List of channelspecs to scan ### %d\n", n_channels);
+	if (n_channels > 0) {
+		for (i = 0; i < n_channels; i++) {
+			chanspec = 0;
+			req_channel = request->channels[i];
+			channel = ieee80211_frequency_to_channel(
+					req_channel->center_freq);
+			if (req_channel->band == IEEE80211_BAND_2GHZ)
+				chanspec |= WL_CHANSPEC_BAND_2G;
+			else
+				chanspec |= WL_CHANSPEC_BAND_5G;
+
+			if (req_channel->flags & IEEE80211_CHAN_NO_HT40) {
+				chanspec |= WL_CHANSPEC_BW_20;
+				chanspec |= WL_CHANSPEC_CTL_SB_NONE;
+			} else {
+				chanspec |= WL_CHANSPEC_BW_40;
+				if (req_channel->flags &
+						IEEE80211_CHAN_NO_HT40PLUS)
+					chanspec |= WL_CHANSPEC_CTL_SB_LOWER;
+				else
+					chanspec |= WL_CHANSPEC_CTL_SB_UPPER;
+			}
+
+			params_le->channel_list[i] =
+				(channel & WL_CHANSPEC_CHAN_MASK) |
+				chanspec;
+			WL_SCAN("Chan : %d, Channel spec: %x\n",
+				channel, params_le->channel_list[i]);
+			params_le->channel_list[i] =
+				cpu_to_le16(params_le->channel_list[i]);
+		}
+	} else {
+		WL_SCAN("Scanning all channels\n");
+	}
+	/* Copy ssid array if applicable */
+	WL_SCAN("### List of SSIDs to scan ### %d\n", n_ssids);
+	if (n_ssids > 0) {
+		offset = offsetof(struct brcmf_scan_params_le, channel_list) +
+				n_channels * sizeof(u16);
+		offset = roundup(offset, sizeof(u32));
+		ptr = (char *)params_le + offset;
+		for (i = 0; i < n_ssids; i++) {
+			memset(&ssid, 0, sizeof(ssid));
+			ssid.SSID_len = cpu_to_le32(request->ssids[i].ssid_len);
+			memcpy(ssid.SSID, request->ssids[i].ssid,
+					request->ssids[i].ssid_len);
+			if (!ssid.SSID_len)
+				WL_SCAN("%d: Broadcast scan\n", i);
+			else
+				WL_SCAN("%d: scan for  %s size =%d\n", i,
+				ssid.SSID, ssid.SSID_len);
+			memcpy(ptr, &ssid, sizeof(ssid));
+			ptr += sizeof(ssid);
+		}
+	} else {
+		WL_SCAN("Broadcast scan %p\n", request->ssids);
+		if ((request->ssids) && request->ssids->ssid_len) {
+			WL_SCAN("SSID %s len=%d\n", params_le->ssid_le.SSID,
+				request->ssids->ssid_len);
+			params_le->ssid_le.SSID_len =
+				cpu_to_le32(request->ssids->ssid_len);
+			memcpy(&params_le->ssid_le.SSID, request->ssids->ssid,
+				request->ssids->ssid_len);
+		}
+	}
+	/* Adding mask to channel numbers */
+	params_le->channel_num =
+		cpu_to_le32((n_ssids << BRCMF_SCAN_PARAMS_NSSID_SHIFT) |
+			(n_channels & BRCMF_SCAN_PARAMS_COUNT_MASK));
+}
+
+static s32
+brcmf_notify_escan_complete(struct brcmf_cfg80211_priv *cfg_priv,
+			    struct net_device *ndev,
+			    bool aborted, bool fw_abort)
+{
+	struct brcmf_scan_params_le params_le;
+	struct cfg80211_scan_request *scan_request;
+	s32 err = 0;
+
+	WL_SCAN("Enter\n");
+
+	/* clear scan request, because the FW abort can cause a second call */
+	/* to this functon and might cause a double cfg80211_scan_done      */
+	scan_request = cfg_priv->scan_request;
+	cfg_priv->scan_request = NULL;
+
+	if (timer_pending(&cfg_priv->escan_timeout))
+		del_timer_sync(&cfg_priv->escan_timeout);
+
+	if (fw_abort) {
+		/* Do a scan abort to stop the driver's scan engine */
+		WL_SCAN("ABORT scan in firmware\n");
+		memset(&params_le, 0, sizeof(params_le));
+		memcpy(params_le.bssid, ether_bcast, ETH_ALEN);
+		params_le.bss_type = DOT11_BSSTYPE_ANY;
+		params_le.scan_type = 0;
+		params_le.channel_num = cpu_to_le32(1);
+		params_le.nprobes = cpu_to_le32(1);
+		params_le.active_time = cpu_to_le32(-1);
+		params_le.passive_time = cpu_to_le32(-1);
+		params_le.home_time = cpu_to_le32(-1);
+		/* Scan is aborted by setting channel_list[0] to -1 */
+		params_le.channel_list[0] = cpu_to_le16(-1);
+		/* E-Scan (or anyother type) can be aborted by SCAN */
+		err = brcmf_exec_dcmd(ndev, BRCMF_C_SCAN, &params_le,
+			sizeof(params_le));
+		if (err)
+			WL_ERR("Scan abort  failed\n");
+	}
+	if (scan_request) {
+		WL_SCAN("ESCAN Completed scan: %s\n",
+				aborted ? "Aborted" : "Done");
+		cfg80211_scan_done(scan_request, aborted);
+		brcmf_set_mpc(ndev, 1);
+	}
+	if (!test_and_clear_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
+		WL_ERR("Scan complete while device not scanning\n");
+		return -EPERM;
+	}
+
+	return err;
+}
+
+static s32
+brcmf_run_escan(struct brcmf_cfg80211_priv *cfg_priv, struct net_device *ndev,
+		struct cfg80211_scan_request *request, u16 action)
+{
+	s32 params_size = BRCMF_SCAN_PARAMS_FIXED_SIZE +
+			  offsetof(struct brcmf_escan_params_le, params_le);
+	struct brcmf_escan_params_le *params;
+	s32 err = 0;
+
+	WL_SCAN("E-SCAN START\n");
+
+	if (request != NULL) {
+		/* Allocate space for populating ssids in struct */
+		params_size += sizeof(u32) * ((request->n_channels + 1) / 2);
+
+		/* Allocate space for populating ssids in struct */
+		params_size += sizeof(struct brcmf_ssid) * request->n_ssids;
+	}
+
+	params = kzalloc(params_size, GFP_KERNEL);
+	if (!params) {
+		err = -ENOMEM;
+		goto exit;
+	}
+	BUG_ON(params_size + sizeof("escan") >= BRCMF_DCMD_MEDLEN);
+	brcmf_escan_prep(&params->params_le, request);
+	params->version = cpu_to_le32(BRCMF_ESCAN_REQ_VERSION);
+	params->action = cpu_to_le16(action);
+	params->sync_id = cpu_to_le16(0x1234);
+
+	err = brcmf_dev_iovar_setbuf(ndev, "escan", params, params_size,
+			cfg_priv->escan_ioctl_buf, BRCMF_DCMD_MEDLEN);
+	if (err) {
+		if (err == -EBUSY)
+			WL_INFO("system busy : escan canceled\n");
+		else
+			WL_ERR("error (%d)\n", err);
+	}
+
+	kfree(params);
+exit:
+	return err;
+}
+
+static s32
+brcmf_do_escan(struct brcmf_cfg80211_priv *cfg_priv, struct wiphy *wiphy,
+	       struct net_device *ndev, struct cfg80211_scan_request *request)
+{
+	s32 err;
+	__le32 passive_scan;
+	struct brcmf_scan_results *results;
+
+	WL_SCAN("Enter\n");
+	cfg_priv->escan_info.ndev = ndev;
+	cfg_priv->escan_info.wiphy = wiphy;
+	cfg_priv->escan_info.escan_state = WL_ESCAN_STATE_SCANNING;
+	passive_scan = cfg_priv->active_scan ? 0 : cpu_to_le32(1);
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_PASSIVE_SCAN,
+			&passive_scan, sizeof(passive_scan));
+	if (err) {
+		WL_ERR("error (%d)\n", err);
+		return err;
+	}
+	brcmf_set_mpc(ndev, 0);
+	results = (struct brcmf_scan_results *)cfg_priv->escan_info.escan_buf;
+	results->version = 0;
+	results->count = 0;
+	results->buflen = WL_ESCAN_RESULTS_FIXED_SIZE;
+
+	err = brcmf_run_escan(cfg_priv, ndev, request, WL_ESCAN_ACTION_START);
+	if (err)
+		brcmf_set_mpc(ndev, 1);
+	return err;
+}
+
+static s32
+brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
+		     struct cfg80211_scan_request *request,
+		     struct cfg80211_ssid *this_ssid)
+{
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+	struct cfg80211_ssid *ssids;
+	struct brcmf_cfg80211_scan_req *sr = cfg_priv->scan_req_int;
+	__le32 passive_scan;
+	bool escan_req;
+	bool spec_scan;
+	s32 err;
+	u32 SSID_len;
+
+	WL_SCAN("START ESCAN\n");
+
+	if (test_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
+		WL_ERR("Scanning already : status (%lu)\n", cfg_priv->status);
+		return -EAGAIN;
+	}
+	if (test_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status)) {
+		WL_ERR("Scanning being aborted : status (%lu)\n",
+		       cfg_priv->status);
+		return -EAGAIN;
+	}
+	if (test_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) {
+		WL_ERR("Connecting : status (%lu)\n",
+		       cfg_priv->status);
+		return -EAGAIN;
+	}
+
+	/* Arm scan timeout timer */
+	mod_timer(&cfg_priv->escan_timeout, jiffies +
+			WL_ESCAN_TIMER_INTERVAL_MS * HZ / 1000);
+
+	escan_req = false;
+	if (request) {
+		/* scan bss */
+		ssids = request->ssids;
+		escan_req = true;
+	} else {
+		/* scan in ibss */
+		/* we don't do escan in ibss */
+		ssids = this_ssid;
+	}
+
+	cfg_priv->scan_request = request;
+	set_bit(WL_STATUS_SCANNING, &cfg_priv->status);
+	if (escan_req) {
+		err = brcmf_do_escan(cfg_priv, wiphy, ndev, request);
+		if (!err)
+			return err;
+		else
+			goto scan_out;
+	} else {
+		WL_SCAN("ssid \"%s\", ssid_len (%d)\n",
+		       ssids->ssid, ssids->ssid_len);
+		memset(&sr->ssid_le, 0, sizeof(sr->ssid_le));
+		SSID_len = min_t(u8, sizeof(sr->ssid_le.SSID), ssids->ssid_len);
+		sr->ssid_le.SSID_len = cpu_to_le32(0);
+		spec_scan = false;
+		if (SSID_len) {
+			memcpy(sr->ssid_le.SSID, ssids->ssid, SSID_len);
+			sr->ssid_le.SSID_len = cpu_to_le32(SSID_len);
+			spec_scan = true;
+		} else
+			WL_SCAN("Broadcast scan\n");
+
+		passive_scan = cfg_priv->active_scan ? 0 : cpu_to_le32(1);
+		err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_PASSIVE_SCAN,
+				&passive_scan, sizeof(passive_scan));
+		if (err) {
+			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
+			goto scan_out;
+		}
+		brcmf_set_mpc(ndev, 0);
+		err = brcmf_exec_dcmd(ndev, BRCMF_C_SCAN, &sr->ssid_le,
+				      sizeof(sr->ssid_le));
+		if (err) {
+			if (err == -EBUSY)
+				WL_INFO("BUSY: scan for \"%s\" canceled\n",
+					sr->ssid_le.SSID);
+			else
+				WL_ERR("WLC_SCAN error (%d)\n", err);
+
+			brcmf_set_mpc(ndev, 1);
+			goto scan_out;
+		}
+	}
+
+	return 0;
+
+scan_out:
+	clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
+	if (timer_pending(&cfg_priv->escan_timeout))
+		del_timer_sync(&cfg_priv->escan_timeout);
+	cfg_priv->scan_request = NULL;
+	return err;
+}
+
 static s32
 brcmf_cfg80211_scan(struct wiphy *wiphy,
 		 struct cfg80211_scan_request *request)
 {
 	struct net_device *ndev = request->wdev->netdev;
+	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
@@ -705,7 +1036,11 @@ brcmf_cfg80211_scan(struct wiphy *wiphy,
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	err = brcmf_cfg80211_iscan(wiphy, ndev, request, NULL);
+	if (cfg_priv->iscan_on)
+		err = brcmf_cfg80211_iscan(wiphy, ndev, request, NULL);
+	else if (cfg_priv->escan_on)
+		err = brcmf_cfg80211_escan(wiphy, ndev, request, NULL);
+
 	if (err)
 		WL_ERR("scan error (%d)\n", err);
 
@@ -2474,6 +2809,175 @@ static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 	return err;
 }
 
+static void brcmf_cfg80211_escan_timeout_worker(struct work_struct *work)
+{
+	struct brcmf_cfg80211_priv *cfg_priv =
+			container_of(work, struct brcmf_cfg80211_priv,
+				     escan_timeout_work);
+
+	brcmf_notify_escan_complete(cfg_priv,
+		cfg_priv->escan_info.ndev, true, true);
+}
+
+static void brcmf_escan_timeout(unsigned long data)
+{
+	struct brcmf_cfg80211_priv *cfg_priv =
+			(struct brcmf_cfg80211_priv *)data;
+
+	if (cfg_priv->scan_request) {
+		WL_ERR("timer expired\n");
+		if (cfg_priv->escan_on)
+			schedule_work(&cfg_priv->escan_timeout_work);
+	}
+}
+
+static s32
+brcmf_compare_update_same_bss(struct brcmf_bss_info_le *bss,
+			      struct brcmf_bss_info_le *bss_info_le)
+{
+	if (!memcmp(&bss_info_le->BSSID, &bss->BSSID, ETH_ALEN) &&
+		(CHSPEC_BAND(le16_to_cpu(bss_info_le->chanspec)) ==
+		CHSPEC_BAND(le16_to_cpu(bss->chanspec))) &&
+		bss_info_le->SSID_len == bss->SSID_len &&
+		!memcmp(bss_info_le->SSID, bss->SSID, bss_info_le->SSID_len)) {
+		if ((bss->flags & WLC_BSS_RSSI_ON_CHANNEL) ==
+			(bss_info_le->flags & WLC_BSS_RSSI_ON_CHANNEL)) {
+			/* preserve max RSSI if the measurements are
+			* both on-channel or both off-channel
+			*/
+			if (bss_info_le->RSSI > bss->RSSI)
+				bss->RSSI = bss_info_le->RSSI;
+		} else if ((bss->flags & WLC_BSS_RSSI_ON_CHANNEL) &&
+			(bss_info_le->flags & WLC_BSS_RSSI_ON_CHANNEL) == 0) {
+			/* preserve the on-channel rssi measurement
+			* if the new measurement is off channel
+			*/
+			bss->RSSI = bss_info_le->RSSI;
+			bss->flags |= WLC_BSS_RSSI_ON_CHANNEL;
+		}
+		return 1;
+	}
+	return 0;
+}
+
+static s32
+brcmf_cfg80211_escan_handler(struct brcmf_cfg80211_priv *cfg_priv,
+			     struct net_device *ndev,
+			     const struct brcmf_event_msg *e, void *data)
+{
+	s32 status;
+	s32 err = 0;
+	struct brcmf_escan_result_le *escan_result_le;
+	struct brcmf_bss_info_le *bss_info_le;
+	struct brcmf_bss_info_le *bss = NULL;
+	u32 bi_length;
+	struct brcmf_scan_results *list;
+	u32 i;
+
+	status = be32_to_cpu(e->status);
+
+	if (!ndev || !cfg_priv->escan_on ||
+			!test_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
+		WL_ERR("scan not ready ndev %p wl->escan_on %d drv_status %x\n",
+			ndev, cfg_priv->escan_on,
+			!test_bit(WL_STATUS_SCANNING, &cfg_priv->status));
+		return -EPERM;
+	}
+
+	if (status == BRCMF_E_STATUS_PARTIAL) {
+		WL_SCAN("ESCAN Partial result\n");
+		escan_result_le = (struct brcmf_escan_result_le *) data;
+		if (!escan_result_le) {
+			WL_ERR("Invalid escan result (NULL pointer)\n");
+			goto exit;
+		}
+		if (!cfg_priv->scan_request) {
+			WL_SCAN("result without cfg80211 request\n");
+			goto exit;
+		}
+
+		if (le16_to_cpu(escan_result_le->bss_count) != 1) {
+			WL_ERR("Invalid bss_count %d: ignoring\n",
+				escan_result_le->bss_count);
+			goto exit;
+		}
+		bss_info_le = &escan_result_le->bss_info_le;
+
+		bi_length = le32_to_cpu(bss_info_le->length);
+		if (bi_length != (le32_to_cpu(escan_result_le->buflen) -
+					WL_ESCAN_RESULTS_FIXED_SIZE)) {
+			WL_ERR("Invalid bss_info length %d: ignoring\n",
+				bi_length);
+			goto exit;
+		}
+
+		if (!(cfg_to_wiphy(cfg_priv)->interface_modes &
+					BIT(NL80211_IFTYPE_ADHOC))) {
+			if (le16_to_cpu(bss_info_le->capability) &
+						WLAN_CAPABILITY_IBSS) {
+				WL_ERR("Ignoring IBSS result\n");
+				goto exit;
+			}
+		}
+
+		list = (struct brcmf_scan_results *)
+				cfg_priv->escan_info.escan_buf;
+		if (bi_length > WL_ESCAN_BUF_SIZE - list->buflen) {
+			WL_ERR("Buffer is too small: ignoring\n");
+			goto exit;
+		}
+
+		for (i = 0; i < list->count; i++) {
+			bss = bss ? (struct brcmf_bss_info_le *)
+				((unsigned char *)bss +
+				le32_to_cpu(bss->length)) : list->bss_info_le;
+			if (brcmf_compare_update_same_bss(bss, bss_info_le))
+				goto exit;
+		}
+		memcpy(&(cfg_priv->escan_info.escan_buf[list->buflen]),
+			bss_info_le, bi_length);
+		list->version = le32_to_cpu(bss_info_le->version);
+		list->buflen += bi_length;
+		list->count++;
+	} else {
+		cfg_priv->escan_info.escan_state = WL_ESCAN_STATE_IDLE;
+		if (cfg_priv->scan_request) {
+			cfg_priv->bss_list = (struct brcmf_scan_results *)
+				cfg_priv->escan_info.escan_buf;
+			brcmf_inform_bss(cfg_priv);
+			if (status == BRCMF_E_STATUS_SUCCESS) {
+				WL_SCAN("ESCAN Completed\n");
+				brcmf_notify_escan_complete(cfg_priv, ndev,
+					false, false);
+			} else {
+				WL_ERR("ESCAN Aborted, Event 0x%x\n", status);
+				brcmf_notify_escan_complete(cfg_priv, ndev,
+					true, false);
+			}
+			brcmf_set_mpc(ndev, 1);
+		} else
+			WL_ERR("Unexpected scan result 0x%x\n", status);
+	}
+exit:
+	return err;
+}
+
+static void brcmf_init_escan(struct brcmf_cfg80211_priv *cfg_priv)
+{
+
+	if (cfg_priv->escan_on) {
+		cfg_priv->el.handler[BRCMF_E_ESCAN_RESULT] =
+			brcmf_cfg80211_escan_handler;
+		cfg_priv->escan_info.escan_state = WL_ESCAN_STATE_IDLE;
+		/* Init scan_timeout timer */
+		init_timer(&cfg_priv->escan_timeout);
+		cfg_priv->escan_timeout.data = (unsigned long) cfg_priv;
+		cfg_priv->escan_timeout.function = brcmf_escan_timeout;
+		INIT_WORK(&cfg_priv->escan_timeout_work,
+			brcmf_cfg80211_escan_timeout_worker);
+	}
+}
+
 static __always_inline void brcmf_delay(u32 ms)
 {
 	if (ms < 1000 / HZ) {
@@ -3242,6 +3746,8 @@ static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 	cfg_priv->profile = NULL;
 	kfree(cfg_priv->scan_req_int);
 	cfg_priv->scan_req_int = NULL;
+	kfree(cfg_priv->escan_ioctl_buf);
+	cfg_priv->escan_ioctl_buf = NULL;
 	kfree(cfg_priv->dcmd_buf);
 	cfg_priv->dcmd_buf = NULL;
 	kfree(cfg_priv->extra_buf);
@@ -3270,6 +3776,9 @@ static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 					 GFP_KERNEL);
 	if (!cfg_priv->scan_req_int)
 		goto init_priv_mem_out;
+	cfg_priv->escan_ioctl_buf = kzalloc(BRCMF_DCMD_MEDLEN, GFP_KERNEL);
+	if (!cfg_priv->escan_ioctl_buf)
+		goto init_priv_mem_out;
 	cfg_priv->dcmd_buf = kzalloc(WL_DCMD_LEN_MAX, GFP_KERNEL);
 	if (!cfg_priv->dcmd_buf)
 		goto init_priv_mem_out;
@@ -3406,8 +3915,17 @@ static s32 wl_init_priv(struct brcmf_cfg80211_priv *cfg_priv)
 
 	cfg_priv->scan_request = NULL;
 	cfg_priv->pwr_save = true;
+#ifdef CONFIG_BRCMISCAN
 	cfg_priv->iscan_on = true;	/* iscan on & off switch.
 				 we enable iscan per default */
+	cfg_priv->escan_on = false;	/* escan on & off switch.
+				 we disable escan per default */
+#else
+	cfg_priv->iscan_on = false;	/* iscan on & off switch.
+				 we disable iscan per default */
+	cfg_priv->escan_on = true;	/* escan on & off switch.
+				 we enable escan per default */
+#endif
 	cfg_priv->roam_on = true;	/* roam on & off switch.
 				 we enable roam per default */
 
@@ -3425,6 +3943,7 @@ static s32 wl_init_priv(struct brcmf_cfg80211_priv *cfg_priv)
 	err = brcmf_init_iscan(cfg_priv);
 	if (err)
 		return err;
+	brcmf_init_escan(cfg_priv);
 	brcmf_init_conf(cfg_priv->conf);
 	brcmf_init_prof(cfg_priv->profile);
 	brcmf_link_down(cfg_priv);
@@ -3583,6 +4102,7 @@ static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 	setbit(eventmask, BRCMF_E_TXFAIL);
 	setbit(eventmask, BRCMF_E_JOIN_START);
 	setbit(eventmask, BRCMF_E_SCAN_COMPLETE);
+	setbit(eventmask, BRCMF_E_ESCAN_RESULT);
 
 	brcmf_c_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN,
 			iovbuf, sizeof(iovbuf));
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index b5d9b36..3b21297 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -123,6 +123,13 @@ do {								\
 #define WL_SCAN_UNASSOC_TIME		40
 #define WL_SCAN_PASSIVE_TIME		120
 
+#define WL_ESCAN_BUF_SIZE		(1024 * 64)
+#define WL_ESCAN_TIMER_INTERVAL_MS	8000 /* E-Scan timeout */
+
+#define WL_ESCAN_ACTION_START		1
+#define WL_ESCAN_ACTION_CONTINUE	2
+#define WL_ESCAN_ACTION_ABORT		3
+
 /* dongle status */
 enum wl_status {
 	WL_STATUS_READY,
@@ -275,6 +282,19 @@ struct brcmf_cfg80211_pmk_list {
 	struct pmkid foo[MAXPMKID - 1];
 };
 
+/* dongle escan state */
+enum wl_escan_state {
+	WL_ESCAN_STATE_IDLE,
+	WL_ESCAN_STATE_SCANNING
+};
+
+struct escan_info {
+	u32 escan_state;
+	u8 escan_buf[WL_ESCAN_BUF_SIZE];
+	struct wiphy *wiphy;
+	struct net_device *ndev;
+};
+
 /* dongle private data of cfg80211 interface */
 struct brcmf_cfg80211_priv {
 	struct wireless_dev *wdev;	/* representing wl cfg80211 device */
@@ -315,6 +335,11 @@ struct brcmf_cfg80211_priv {
 	u8 *dcmd_buf;		/* dcmd buffer */
 	u8 *extra_buf;		/* maily to grab assoc information */
 	struct dentry *debugfsdir;
+	bool escan_on;		/* escan on/off switch */
+	struct escan_info escan_info;   /* escan information */
+	struct timer_list escan_timeout;   /* Timer for catch scan timeout */
+	struct work_struct escan_timeout_work;	/* scan timeout worker */
+	u8 *escan_ioctl_buf;
 	u8 ci[0] __aligned(NETDEV_ALIGN);
 };
 
-- 
1.7.9.5


