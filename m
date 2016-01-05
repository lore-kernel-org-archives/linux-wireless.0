Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:24637 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbcAEKF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:05:58 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/6] brcmfmac: Reshuffle functions to avoid forward declarations
Date: Tue, 5 Jan 2016 11:05:46 +0100
Message-ID: <1451988350-2197-3-git-send-email-arend@broadcom.com> (sfid-20160105_110612_160787_C9722D47)
In-Reply-To: <1451988350-2197-1-git-send-email-arend@broadcom.com>
References: <1451988350-2197-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Function prototype forward declarations are to be avoided. This
patch shuffles some of the functions so the forward declarations
can be removed.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 1090 ++++++++++----------
 1 file changed, 537 insertions(+), 553 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index fd54ad1..c9657be 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -238,18 +238,6 @@ struct parsed_vndr_ies {
 	struct parsed_vndr_ie_info ie_info[VNDR_IE_PARSE_LIMIT];
 };
 
-/* Function prototype forward declarations */
-static int
-brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
-				struct net_device *ndev,
-				struct cfg80211_sched_scan_request *request);
-static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
-					  struct net_device *ndev);
-static s32
-brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
-				const struct brcmf_event_msg *e, void *data);
-
-
 static u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
 			       struct cfg80211_chan_def *ch)
 {
@@ -3081,183 +3069,473 @@ static void brcmf_init_escan(struct brcmf_cfg80211_info *cfg)
 		  brcmf_cfg80211_escan_timeout_worker);
 }
 
-static __always_inline void brcmf_delay(u32 ms)
-{
-	if (ms < 1000 / HZ) {
-		cond_resched();
-		mdelay(ms);
-	} else {
-		msleep(ms);
-	}
-}
-
-static s32 brcmf_config_wowl_pattern(struct brcmf_if *ifp, u8 cmd[4],
-				     u8 *pattern, u32 patternsize, u8 *mask,
-				     u32 packet_offset)
-{
-	struct brcmf_fil_wowl_pattern_le *filter;
-	u32 masksize;
-	u32 patternoffset;
-	u8 *buf;
-	u32 bufsize;
-	s32 ret;
-
-	masksize = (patternsize + 7) / 8;
-	patternoffset = sizeof(*filter) - sizeof(filter->cmd) + masksize;
-
-	bufsize = sizeof(*filter) + patternsize + masksize;
-	buf = kzalloc(bufsize, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-	filter = (struct brcmf_fil_wowl_pattern_le *)buf;
-
-	memcpy(filter->cmd, cmd, 4);
-	filter->masksize = cpu_to_le32(masksize);
-	filter->offset = cpu_to_le32(packet_offset);
-	filter->patternoffset = cpu_to_le32(patternoffset);
-	filter->patternsize = cpu_to_le32(patternsize);
-	filter->type = cpu_to_le32(BRCMF_WOWL_PATTERN_TYPE_BITMAP);
-
-	if ((mask) && (masksize))
-		memcpy(buf + sizeof(*filter), mask, masksize);
-	if ((pattern) && (patternsize))
-		memcpy(buf + sizeof(*filter) + masksize, pattern, patternsize);
-
-	ret = brcmf_fil_iovar_data_set(ifp, "wowl_pattern", buf, bufsize);
-
-	kfree(buf);
-	return ret;
-}
-
+/* PFN result doesn't have all the info which are required by the supplicant
+ * (For e.g IEs) Do a target Escan so that sched scan results are reported
+ * via wl_inform_single_bss in the required format. Escan does require the
+ * scan request in the form of cfg80211_scan_request. For timebeing, create
+ * cfg80211_scan_request one out of the received PNO event.
+ */
 static s32
-brcmf_wowl_nd_results(struct brcmf_if *ifp, const struct brcmf_event_msg *e,
-		      void *data)
+brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
+				const struct brcmf_event_msg *e, void *data)
 {
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_pno_net_info_le *netinfo, *netinfo_start;
+	struct cfg80211_scan_request *request = NULL;
+	struct cfg80211_ssid *ssid = NULL;
+	struct ieee80211_channel *channel = NULL;
+	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	int err = 0;
+	int channel_req = 0;
+	int band = 0;
 	struct brcmf_pno_scanresults_le *pfn_result;
-	struct brcmf_pno_net_info_le *netinfo;
+	u32 result_count;
+	u32 status;
 
 	brcmf_dbg(SCAN, "Enter\n");
 
-	pfn_result = (struct brcmf_pno_scanresults_le *)data;
-
 	if (e->event_code == BRCMF_E_PFN_NET_LOST) {
-		brcmf_dbg(SCAN, "PFN NET LOST event. Ignore\n");
+		brcmf_dbg(SCAN, "PFN NET LOST event. Do Nothing\n");
 		return 0;
 	}
 
-	if (le32_to_cpu(pfn_result->count) < 1) {
-		brcmf_err("Invalid result count, expected 1 (%d)\n",
-			  le32_to_cpu(pfn_result->count));
-		return -EINVAL;
-	}
+	pfn_result = (struct brcmf_pno_scanresults_le *)data;
+	result_count = le32_to_cpu(pfn_result->count);
+	status = le32_to_cpu(pfn_result->status);
 
-	data += sizeof(struct brcmf_pno_scanresults_le);
-	netinfo = (struct brcmf_pno_net_info_le *)data;
-	memcpy(cfg->wowl.nd->ssid.ssid, netinfo->SSID, netinfo->SSID_len);
-	cfg->wowl.nd->ssid.ssid_len = netinfo->SSID_len;
-	cfg->wowl.nd->n_channels = 1;
-	cfg->wowl.nd->channels[0] =
-		ieee80211_channel_to_frequency(netinfo->channel,
-			netinfo->channel <= CH_MAX_2G_CHANNEL ?
-					NL80211_BAND_2GHZ : NL80211_BAND_5GHZ);
-	cfg->wowl.nd_info->n_matches = 1;
-	cfg->wowl.nd_info->matches[0] = cfg->wowl.nd;
+	/* PFN event is limited to fit 512 bytes so we may get
+	 * multiple NET_FOUND events. For now place a warning here.
+	 */
+	WARN_ON(status != BRCMF_PNO_SCAN_COMPLETE);
+	brcmf_dbg(SCAN, "PFN NET FOUND event. count: %d\n", result_count);
+	if (result_count > 0) {
+		int i;
 
-	/* Inform (the resume task) that the net detect information was recvd */
-	cfg->wowl.nd_data_completed = true;
-	wake_up(&cfg->wowl.nd_data_wait);
+		request = kzalloc(sizeof(*request), GFP_KERNEL);
+		ssid = kcalloc(result_count, sizeof(*ssid), GFP_KERNEL);
+		channel = kcalloc(result_count, sizeof(*channel), GFP_KERNEL);
+		if (!request || !ssid || !channel) {
+			err = -ENOMEM;
+			goto out_err;
+		}
 
-	return 0;
-}
+		request->wiphy = wiphy;
+		data += sizeof(struct brcmf_pno_scanresults_le);
+		netinfo_start = (struct brcmf_pno_net_info_le *)data;
 
-#ifdef CONFIG_PM
+		for (i = 0; i < result_count; i++) {
+			netinfo = &netinfo_start[i];
+			if (!netinfo) {
+				brcmf_err("Invalid netinfo ptr. index: %d\n",
+					  i);
+				err = -EINVAL;
+				goto out_err;
+			}
 
-static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
-{
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_wowl_wakeind_le wake_ind_le;
-	struct cfg80211_wowlan_wakeup wakeup_data;
-	struct cfg80211_wowlan_wakeup *wakeup;
-	u32 wakeind;
-	s32 err;
-	int timeout;
+			brcmf_dbg(SCAN, "SSID:%s Channel:%d\n",
+				  netinfo->SSID, netinfo->channel);
+			memcpy(ssid[i].ssid, netinfo->SSID, netinfo->SSID_len);
+			ssid[i].ssid_len = netinfo->SSID_len;
+			request->n_ssids++;
 
-	err = brcmf_fil_iovar_data_get(ifp, "wowl_wakeind", &wake_ind_le,
-				       sizeof(wake_ind_le));
-	if (err) {
-		brcmf_err("Get wowl_wakeind failed, err = %d\n", err);
-		return;
-	}
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
 
-	wakeind = le32_to_cpu(wake_ind_le.ucode_wakeind);
-	if (wakeind & (BRCMF_WOWL_MAGIC | BRCMF_WOWL_DIS | BRCMF_WOWL_BCN |
-		       BRCMF_WOWL_RETR | BRCMF_WOWL_NET |
-		       BRCMF_WOWL_PFN_FOUND)) {
-		wakeup = &wakeup_data;
-		memset(&wakeup_data, 0, sizeof(wakeup_data));
-		wakeup_data.pattern_idx = -1;
+		/* assign parsed ssid array */
+		if (request->n_ssids)
+			request->ssids = &ssid[0];
 
-		if (wakeind & BRCMF_WOWL_MAGIC) {
-			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_MAGIC\n");
-			wakeup_data.magic_pkt = true;
-		}
-		if (wakeind & BRCMF_WOWL_DIS) {
-			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_DIS\n");
-			wakeup_data.disconnect = true;
-		}
-		if (wakeind & BRCMF_WOWL_BCN) {
-			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_BCN\n");
-			wakeup_data.disconnect = true;
-		}
-		if (wakeind & BRCMF_WOWL_RETR) {
-			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_RETR\n");
-			wakeup_data.disconnect = true;
-		}
-		if (wakeind & BRCMF_WOWL_NET) {
-			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_NET\n");
-			/* For now always map to pattern 0, no API to get
-			 * correct information available at the moment.
-			 */
-			wakeup_data.pattern_idx = 0;
+		if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
+			/* Abort any on-going scan */
+			brcmf_abort_scanning(cfg);
 		}
-		if (wakeind & BRCMF_WOWL_PFN_FOUND) {
-			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_PFN_FOUND\n");
-			timeout = wait_event_timeout(cfg->wowl.nd_data_wait,
-				cfg->wowl.nd_data_completed,
-				BRCMF_ND_INFO_TIMEOUT);
-			if (!timeout)
-				brcmf_err("No result for wowl net detect\n");
-			else
-				wakeup_data.net_detect = cfg->wowl.nd_info;
+
+		set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
+		cfg->escan_info.run = brcmf_run_escan;
+		err = brcmf_do_escan(cfg, wiphy, ifp, request);
+		if (err) {
+			clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
+			goto out_err;
 		}
+		cfg->sched_escan = true;
+		cfg->scan_request = request;
 	} else {
-		wakeup = NULL;
+		brcmf_err("FALSE PNO Event. (pfn_count == 0)\n");
+		goto out_err;
 	}
-	cfg80211_report_wowlan_wakeup(&ifp->vif->wdev, wakeup, GFP_KERNEL);
-}
 
-#else
+	kfree(ssid);
+	kfree(channel);
+	kfree(request);
+	return 0;
 
-static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
-{
+out_err:
+	kfree(ssid);
+	kfree(channel);
+	kfree(request);
+	cfg80211_sched_scan_stopped(wiphy);
+	return err;
 }
 
-#endif /* CONFIG_PM */
-
-static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
+static int brcmf_dev_pno_clean(struct net_device *ndev)
 {
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct net_device *ndev = cfg_to_ndev(cfg);
-	struct brcmf_if *ifp = netdev_priv(ndev);
+	int ret;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	/* Disable pfn */
+	ret = brcmf_fil_iovar_int_set(netdev_priv(ndev), "pfn", 0);
+	if (ret == 0) {
+		/* clear pfn */
+		ret = brcmf_fil_iovar_data_set(netdev_priv(ndev), "pfnclear",
+					       NULL, 0);
+	}
+	if (ret < 0)
+		brcmf_err("failed code %d\n", ret);
 
-	if (cfg->wowl.active) {
-		brcmf_report_wowl_wakeind(wiphy, ifp);
-		brcmf_fil_iovar_int_set(ifp, "wowl_clear", 0);
-		brcmf_config_wowl_pattern(ifp, "clr", NULL, 0, NULL, 0);
-		brcmf_configure_arp_offload(ifp, true);
+	return ret;
+}
+
+static int brcmf_dev_pno_config(struct brcmf_if *ifp,
+				struct cfg80211_sched_scan_request *request)
+{
+	struct brcmf_pno_param_le pfn_param;
+	struct brcmf_pno_macaddr_le pfn_mac;
+	s32 err;
+	u8 *mac_mask;
+	int i;
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
+	err = brcmf_fil_iovar_data_set(ifp, "pfn_set", &pfn_param,
+				       sizeof(pfn_param));
+	if (err) {
+		brcmf_err("pfn_set failed, err=%d\n", err);
+		return err;
+	}
+
+	/* Find out if mac randomization should be turned on */
+	if (!(request->flags & NL80211_SCAN_FLAG_RANDOM_ADDR))
+		return 0;
+
+	pfn_mac.version = BRCMF_PFN_MACADDR_CFG_VER;
+	pfn_mac.flags = BRCMF_PFN_MAC_OUI_ONLY | BRCMF_PFN_SET_MAC_UNASSOC;
+
+	memcpy(pfn_mac.mac, request->mac_addr, ETH_ALEN);
+	mac_mask = request->mac_addr_mask;
+	for (i = 0; i < ETH_ALEN; i++) {
+		pfn_mac.mac[i] &= mac_mask[i];
+		pfn_mac.mac[i] |= get_random_int() & ~(mac_mask[i]);
+	}
+	/* Clear multi bit */
+	pfn_mac.mac[0] &= 0xFE;
+	/* Set locally administered */
+	pfn_mac.mac[0] |= 0x02;
+
+	err = brcmf_fil_iovar_data_set(ifp, "pfn_macaddr", &pfn_mac,
+				       sizeof(pfn_mac));
+	if (err)
+		brcmf_err("pfn_macaddr failed, err=%d\n", err);
+
+	return err;
+}
+
+static int
+brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
+				struct net_device *ndev,
+				struct cfg80211_sched_scan_request *request)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
+	struct brcmf_pno_net_param_le pfn;
+	int i;
+	int ret = 0;
+
+	brcmf_dbg(SCAN, "Enter n_match_sets:%d n_ssids:%d\n",
+		  request->n_match_sets, request->n_ssids);
+	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
+		brcmf_err("Scanning already: status (%lu)\n", cfg->scan_status);
+		return -EAGAIN;
+	}
+	if (test_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status)) {
+		brcmf_err("Scanning suppressed: status (%lu)\n",
+			  cfg->scan_status);
+		return -EAGAIN;
+	}
+
+	if (!request->n_ssids || !request->n_match_sets) {
+		brcmf_dbg(SCAN, "Invalid sched scan req!! n_ssids:%d\n",
+			  request->n_ssids);
+		return -EINVAL;
+	}
+
+	if (request->n_ssids > 0) {
+		for (i = 0; i < request->n_ssids; i++) {
+			/* Active scan req for ssids */
+			brcmf_dbg(SCAN, ">>> Active scan req for ssid (%s)\n",
+				  request->ssids[i].ssid);
+
+			/* match_set ssids is a supert set of n_ssid list,
+			 * so we need not add these set separately.
+			 */
+		}
+	}
+
+	if (request->n_match_sets > 0) {
+		/* clean up everything */
+		ret = brcmf_dev_pno_clean(ndev);
+		if  (ret < 0) {
+			brcmf_err("failed error=%d\n", ret);
+			return ret;
+		}
+
+		/* configure pno */
+		if (brcmf_dev_pno_config(ifp, request))
+			return -EINVAL;
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
+				brcmf_err("skip broadcast ssid\n");
+				continue;
+			}
+			pfn.auth = cpu_to_le32(WLAN_AUTH_OPEN);
+			pfn.wpa_auth = cpu_to_le32(BRCMF_PNO_WPA_AUTH_ANY);
+			pfn.wsec = cpu_to_le32(0);
+			pfn.infra = cpu_to_le32(1);
+			pfn.flags = cpu_to_le32(1 << BRCMF_PNO_HIDDEN_BIT);
+			pfn.ssid.SSID_len = cpu_to_le32(ssid_len);
+			memcpy(pfn.ssid.SSID, ssid->ssid, ssid_len);
+			ret = brcmf_fil_iovar_data_set(ifp, "pfn_add", &pfn,
+						       sizeof(pfn));
+			brcmf_dbg(SCAN, ">>> PNO filter %s for ssid (%s)\n",
+				  ret == 0 ? "set" : "failed", ssid->ssid);
+		}
+		/* Enable the PNO */
+		if (brcmf_fil_iovar_int_set(ifp, "pfn", 1) < 0) {
+			brcmf_err("PNO enable failed!! ret=%d\n", ret);
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
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+
+	brcmf_dbg(SCAN, "enter\n");
+	brcmf_dev_pno_clean(ndev);
+	if (cfg->sched_escan)
+		brcmf_notify_escan_complete(cfg, netdev_priv(ndev), true, true);
+	return 0;
+}
+
+static __always_inline void brcmf_delay(u32 ms)
+{
+	if (ms < 1000 / HZ) {
+		cond_resched();
+		mdelay(ms);
+	} else {
+		msleep(ms);
+	}
+}
+
+static s32 brcmf_config_wowl_pattern(struct brcmf_if *ifp, u8 cmd[4],
+				     u8 *pattern, u32 patternsize, u8 *mask,
+				     u32 packet_offset)
+{
+	struct brcmf_fil_wowl_pattern_le *filter;
+	u32 masksize;
+	u32 patternoffset;
+	u8 *buf;
+	u32 bufsize;
+	s32 ret;
+
+	masksize = (patternsize + 7) / 8;
+	patternoffset = sizeof(*filter) - sizeof(filter->cmd) + masksize;
+
+	bufsize = sizeof(*filter) + patternsize + masksize;
+	buf = kzalloc(bufsize, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	filter = (struct brcmf_fil_wowl_pattern_le *)buf;
+
+	memcpy(filter->cmd, cmd, 4);
+	filter->masksize = cpu_to_le32(masksize);
+	filter->offset = cpu_to_le32(packet_offset);
+	filter->patternoffset = cpu_to_le32(patternoffset);
+	filter->patternsize = cpu_to_le32(patternsize);
+	filter->type = cpu_to_le32(BRCMF_WOWL_PATTERN_TYPE_BITMAP);
+
+	if ((mask) && (masksize))
+		memcpy(buf + sizeof(*filter), mask, masksize);
+	if ((pattern) && (patternsize))
+		memcpy(buf + sizeof(*filter) + masksize, pattern, patternsize);
+
+	ret = brcmf_fil_iovar_data_set(ifp, "wowl_pattern", buf, bufsize);
+
+	kfree(buf);
+	return ret;
+}
+
+static s32
+brcmf_wowl_nd_results(struct brcmf_if *ifp, const struct brcmf_event_msg *e,
+		      void *data)
+{
+	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_pno_scanresults_le *pfn_result;
+	struct brcmf_pno_net_info_le *netinfo;
+
+	brcmf_dbg(SCAN, "Enter\n");
+
+	pfn_result = (struct brcmf_pno_scanresults_le *)data;
+
+	if (e->event_code == BRCMF_E_PFN_NET_LOST) {
+		brcmf_dbg(SCAN, "PFN NET LOST event. Ignore\n");
+		return 0;
+	}
+
+	if (le32_to_cpu(pfn_result->count) < 1) {
+		brcmf_err("Invalid result count, expected 1 (%d)\n",
+			  le32_to_cpu(pfn_result->count));
+		return -EINVAL;
+	}
+
+	data += sizeof(struct brcmf_pno_scanresults_le);
+	netinfo = (struct brcmf_pno_net_info_le *)data;
+	memcpy(cfg->wowl.nd->ssid.ssid, netinfo->SSID, netinfo->SSID_len);
+	cfg->wowl.nd->ssid.ssid_len = netinfo->SSID_len;
+	cfg->wowl.nd->n_channels = 1;
+	cfg->wowl.nd->channels[0] =
+		ieee80211_channel_to_frequency(netinfo->channel,
+			netinfo->channel <= CH_MAX_2G_CHANNEL ?
+					NL80211_BAND_2GHZ : NL80211_BAND_5GHZ);
+	cfg->wowl.nd_info->n_matches = 1;
+	cfg->wowl.nd_info->matches[0] = cfg->wowl.nd;
+
+	/* Inform (the resume task) that the net detect information was recvd */
+	cfg->wowl.nd_data_completed = true;
+	wake_up(&cfg->wowl.nd_data_wait);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+
+static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_wowl_wakeind_le wake_ind_le;
+	struct cfg80211_wowlan_wakeup wakeup_data;
+	struct cfg80211_wowlan_wakeup *wakeup;
+	u32 wakeind;
+	s32 err;
+	int timeout;
+
+	err = brcmf_fil_iovar_data_get(ifp, "wowl_wakeind", &wake_ind_le,
+				       sizeof(wake_ind_le));
+	if (err) {
+		brcmf_err("Get wowl_wakeind failed, err = %d\n", err);
+		return;
+	}
+
+	wakeind = le32_to_cpu(wake_ind_le.ucode_wakeind);
+	if (wakeind & (BRCMF_WOWL_MAGIC | BRCMF_WOWL_DIS | BRCMF_WOWL_BCN |
+		       BRCMF_WOWL_RETR | BRCMF_WOWL_NET |
+		       BRCMF_WOWL_PFN_FOUND)) {
+		wakeup = &wakeup_data;
+		memset(&wakeup_data, 0, sizeof(wakeup_data));
+		wakeup_data.pattern_idx = -1;
+
+		if (wakeind & BRCMF_WOWL_MAGIC) {
+			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_MAGIC\n");
+			wakeup_data.magic_pkt = true;
+		}
+		if (wakeind & BRCMF_WOWL_DIS) {
+			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_DIS\n");
+			wakeup_data.disconnect = true;
+		}
+		if (wakeind & BRCMF_WOWL_BCN) {
+			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_BCN\n");
+			wakeup_data.disconnect = true;
+		}
+		if (wakeind & BRCMF_WOWL_RETR) {
+			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_RETR\n");
+			wakeup_data.disconnect = true;
+		}
+		if (wakeind & BRCMF_WOWL_NET) {
+			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_NET\n");
+			/* For now always map to pattern 0, no API to get
+			 * correct information available at the moment.
+			 */
+			wakeup_data.pattern_idx = 0;
+		}
+		if (wakeind & BRCMF_WOWL_PFN_FOUND) {
+			brcmf_dbg(INFO, "WOWL Wake indicator: BRCMF_WOWL_PFN_FOUND\n");
+			timeout = wait_event_timeout(cfg->wowl.nd_data_wait,
+				cfg->wowl.nd_data_completed,
+				BRCMF_ND_INFO_TIMEOUT);
+			if (!timeout)
+				brcmf_err("No result for wowl net detect\n");
+			else
+				wakeup_data.net_detect = cfg->wowl.nd_info;
+		}
+	} else {
+		wakeup = NULL;
+	}
+	cfg80211_report_wowlan_wakeup(&ifp->vif->wdev, wakeup, GFP_KERNEL);
+}
+
+#else
+
+static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
+{
+}
+
+#endif /* CONFIG_PM */
+
+static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg_to_ndev(cfg);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	if (cfg->wowl.active) {
+		brcmf_report_wowl_wakeind(wiphy, ifp);
+		brcmf_fil_iovar_int_set(ifp, "wowl_clear", 0);
+		brcmf_config_wowl_pattern(ifp, "clr", NULL, 0, NULL, 0);
+		brcmf_configure_arp_offload(ifp, true);
 		brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM,
 				      cfg->wowl.pre_pmmode);
 		cfg->wowl.active = false;
@@ -3358,440 +3636,146 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 			brcmf_link_down(vif, WLAN_REASON_UNSPECIFIED);
 			/* Make sure WPA_Supplicant receives all the event
 			 * generated due to DISASSOC call to the fw to keep
-			 * the state fw and WPA_Supplicant state consistent
-			 */
-			brcmf_delay(500);
-		}
-		/* Configure MPC */
-		brcmf_set_mpc(ifp, 1);
-
-	} else {
-		/* Configure WOWL paramaters */
-		brcmf_configure_wowl(cfg, ifp, wowl);
-	}
-
-exit:
-	brcmf_dbg(TRACE, "Exit\n");
-	/* clear any scanning activity */
-	cfg->scan_status = 0;
-	return 0;
-}
-
-static __used s32
-brcmf_update_pmklist(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp)
-{
-	struct brcmf_pmk_list_le *pmk_list;
-	int i;
-	u32 npmk;
-	s32 err;
-
-	pmk_list = &cfg->pmk_list;
-	npmk = le32_to_cpu(pmk_list->npmk);
-
-	brcmf_dbg(CONN, "No of elements %d\n", npmk);
-	for (i = 0; i < npmk; i++)
-		brcmf_dbg(CONN, "PMK[%d]: %pM\n", i, &pmk_list->pmk[i].bssid);
-
-	err = brcmf_fil_iovar_data_set(ifp, "pmkid_info", pmk_list,
-				       sizeof(*pmk_list));
-
-	return err;
-}
-
-static s32
-brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
-			 struct cfg80211_pmksa *pmksa)
-{
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_pmksa *pmk = &cfg->pmk_list.pmk[0];
-	s32 err;
-	u32 npmk, i;
-
-	brcmf_dbg(TRACE, "Enter\n");
-	if (!check_vif_up(ifp->vif))
-		return -EIO;
-
-	npmk = le32_to_cpu(cfg->pmk_list.npmk);
-	for (i = 0; i < npmk; i++)
-		if (!memcmp(pmksa->bssid, pmk[i].bssid, ETH_ALEN))
-			break;
-	if (i < BRCMF_MAXPMKID) {
-		memcpy(pmk[i].bssid, pmksa->bssid, ETH_ALEN);
-		memcpy(pmk[i].pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
-		if (i == npmk) {
-			npmk++;
-			cfg->pmk_list.npmk = cpu_to_le32(npmk);
-		}
-	} else {
-		brcmf_err("Too many PMKSA entries cached %d\n", npmk);
-		return -EINVAL;
-	}
-
-	brcmf_dbg(CONN, "set_pmksa - PMK bssid: %pM =\n", pmk[npmk].bssid);
-	for (i = 0; i < WLAN_PMKID_LEN; i += 4)
-		brcmf_dbg(CONN, "%02x %02x %02x %02x\n", pmk[npmk].pmkid[i],
-			  pmk[npmk].pmkid[i + 1], pmk[npmk].pmkid[i + 2],
-			  pmk[npmk].pmkid[i + 3]);
-
-	err = brcmf_update_pmklist(cfg, ifp);
-
-	brcmf_dbg(TRACE, "Exit\n");
-	return err;
-}
-
-static s32
-brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
-			 struct cfg80211_pmksa *pmksa)
-{
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_pmksa *pmk = &cfg->pmk_list.pmk[0];
-	s32 err;
-	u32 npmk, i;
-
-	brcmf_dbg(TRACE, "Enter\n");
-	if (!check_vif_up(ifp->vif))
-		return -EIO;
-
-	brcmf_dbg(CONN, "del_pmksa - PMK bssid = %pM\n", &pmksa->bssid);
-
-	npmk = le32_to_cpu(cfg->pmk_list.npmk);
-	for (i = 0; i < npmk; i++)
-		if (!memcmp(&pmksa->bssid, &pmk[i].bssid, ETH_ALEN))
-			break;
-
-	if ((npmk > 0) && (i < npmk)) {
-		for (; i < (npmk - 1); i++) {
-			memcpy(&pmk[i].bssid, &pmk[i + 1].bssid, ETH_ALEN);
-			memcpy(&pmk[i].pmkid, &pmk[i + 1].pmkid,
-			       WLAN_PMKID_LEN);
-		}
-		memset(&pmk[i], 0, sizeof(*pmk));
-		cfg->pmk_list.npmk = cpu_to_le32(npmk - 1);
-	} else {
-		brcmf_err("Cache entry not found\n");
-		return -EINVAL;
-	}
-
-	err = brcmf_update_pmklist(cfg, ifp);
-
-	brcmf_dbg(TRACE, "Exit\n");
-	return err;
-
-}
-
-static s32
-brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
-{
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_if *ifp = netdev_priv(ndev);
-	s32 err;
-
-	brcmf_dbg(TRACE, "Enter\n");
-	if (!check_vif_up(ifp->vif))
-		return -EIO;
-
-	memset(&cfg->pmk_list, 0, sizeof(cfg->pmk_list));
-	err = brcmf_update_pmklist(cfg, ifp);
-
-	brcmf_dbg(TRACE, "Exit\n");
-	return err;
-
-}
-
-/*
- * PFN result doesn't have all the info which are
- * required by the supplicant
- * (For e.g IEs) Do a target Escan so that sched scan results are reported
- * via wl_inform_single_bss in the required format. Escan does require the
- * scan request in the form of cfg80211_scan_request. For timebeing, create
- * cfg80211_scan_request one out of the received PNO event.
- */
-static s32
-brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
-				const struct brcmf_event_msg *e, void *data)
-{
-	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
-	struct brcmf_pno_net_info_le *netinfo, *netinfo_start;
-	struct cfg80211_scan_request *request = NULL;
-	struct cfg80211_ssid *ssid = NULL;
-	struct ieee80211_channel *channel = NULL;
-	struct wiphy *wiphy = cfg_to_wiphy(cfg);
-	int err = 0;
-	int channel_req = 0;
-	int band = 0;
-	struct brcmf_pno_scanresults_le *pfn_result;
-	u32 result_count;
-	u32 status;
-
-	brcmf_dbg(SCAN, "Enter\n");
-
-	if (e->event_code == BRCMF_E_PFN_NET_LOST) {
-		brcmf_dbg(SCAN, "PFN NET LOST event. Do Nothing\n");
-		return 0;
-	}
-
-	pfn_result = (struct brcmf_pno_scanresults_le *)data;
-	result_count = le32_to_cpu(pfn_result->count);
-	status = le32_to_cpu(pfn_result->status);
-
-	/*
-	 * PFN event is limited to fit 512 bytes so we may get
-	 * multiple NET_FOUND events. For now place a warning here.
-	 */
-	WARN_ON(status != BRCMF_PNO_SCAN_COMPLETE);
-	brcmf_dbg(SCAN, "PFN NET FOUND event. count: %d\n", result_count);
-	if (result_count > 0) {
-		int i;
-
-		request = kzalloc(sizeof(*request), GFP_KERNEL);
-		ssid = kcalloc(result_count, sizeof(*ssid), GFP_KERNEL);
-		channel = kcalloc(result_count, sizeof(*channel), GFP_KERNEL);
-		if (!request || !ssid || !channel) {
-			err = -ENOMEM;
-			goto out_err;
-		}
-
-		request->wiphy = wiphy;
-		data += sizeof(struct brcmf_pno_scanresults_le);
-		netinfo_start = (struct brcmf_pno_net_info_le *)data;
-
-		for (i = 0; i < result_count; i++) {
-			netinfo = &netinfo_start[i];
-			if (!netinfo) {
-				brcmf_err("Invalid netinfo ptr. index: %d\n",
-					  i);
-				err = -EINVAL;
-				goto out_err;
-			}
-
-			brcmf_dbg(SCAN, "SSID:%s Channel:%d\n",
-				  netinfo->SSID, netinfo->channel);
-			memcpy(ssid[i].ssid, netinfo->SSID, netinfo->SSID_len);
-			ssid[i].ssid_len = netinfo->SSID_len;
-			request->n_ssids++;
-
-			channel_req = netinfo->channel;
-			if (channel_req <= CH_MAX_2G_CHANNEL)
-				band = NL80211_BAND_2GHZ;
-			else
-				band = NL80211_BAND_5GHZ;
-			channel[i].center_freq =
-				ieee80211_channel_to_frequency(channel_req,
-							       band);
-			channel[i].band = band;
-			channel[i].flags |= IEEE80211_CHAN_NO_HT40;
-			request->channels[i] = &channel[i];
-			request->n_channels++;
-		}
-
-		/* assign parsed ssid array */
-		if (request->n_ssids)
-			request->ssids = &ssid[0];
-
-		if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-			/* Abort any on-going scan */
-			brcmf_abort_scanning(cfg);
+			 * the state fw and WPA_Supplicant state consistent
+			 */
+			brcmf_delay(500);
 		}
+		/* Configure MPC */
+		brcmf_set_mpc(ifp, 1);
 
-		set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
-		cfg->escan_info.run = brcmf_run_escan;
-		err = brcmf_do_escan(cfg, wiphy, ifp, request);
-		if (err) {
-			clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
-			goto out_err;
-		}
-		cfg->sched_escan = true;
-		cfg->scan_request = request;
 	} else {
-		brcmf_err("FALSE PNO Event. (pfn_count == 0)\n");
-		goto out_err;
+		/* Configure WOWL paramaters */
+		brcmf_configure_wowl(cfg, ifp, wowl);
 	}
 
-	kfree(ssid);
-	kfree(channel);
-	kfree(request);
+exit:
+	brcmf_dbg(TRACE, "Exit\n");
+	/* clear any scanning activity */
+	cfg->scan_status = 0;
 	return 0;
-
-out_err:
-	kfree(ssid);
-	kfree(channel);
-	kfree(request);
-	cfg80211_sched_scan_stopped(wiphy);
-	return err;
 }
 
-static int brcmf_dev_pno_clean(struct net_device *ndev)
-{
-	int ret;
-
-	/* Disable pfn */
-	ret = brcmf_fil_iovar_int_set(netdev_priv(ndev), "pfn", 0);
-	if (ret == 0) {
-		/* clear pfn */
-		ret = brcmf_fil_iovar_data_set(netdev_priv(ndev), "pfnclear",
-					       NULL, 0);
-	}
-	if (ret < 0)
-		brcmf_err("failed code %d\n", ret);
-
-	return ret;
-}
-
-static int brcmf_dev_pno_config(struct brcmf_if *ifp,
-				struct cfg80211_sched_scan_request *request)
+static __used s32
+brcmf_update_pmklist(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp)
 {
-	struct brcmf_pno_param_le pfn_param;
-	struct brcmf_pno_macaddr_le pfn_mac;
-	s32 err;
-	u8 *mac_mask;
+	struct brcmf_pmk_list_le *pmk_list;
 	int i;
+	u32 npmk;
+	s32 err;
 
-	memset(&pfn_param, 0, sizeof(pfn_param));
-	pfn_param.version = cpu_to_le32(BRCMF_PNO_VERSION);
-
-	/* set extra pno params */
-	pfn_param.flags = cpu_to_le16(1 << BRCMF_PNO_ENABLE_ADAPTSCAN_BIT);
-	pfn_param.repeat = BRCMF_PNO_REPEAT;
-	pfn_param.exp = BRCMF_PNO_FREQ_EXPO_MAX;
-
-	/* set up pno scan fr */
-	pfn_param.scan_freq = cpu_to_le32(BRCMF_PNO_TIME);
-
-	err = brcmf_fil_iovar_data_set(ifp, "pfn_set", &pfn_param,
-				       sizeof(pfn_param));
-	if (err) {
-		brcmf_err("pfn_set failed, err=%d\n", err);
-		return err;
-	}
-
-	/* Find out if mac randomization should be turned on */
-	if (!(request->flags & NL80211_SCAN_FLAG_RANDOM_ADDR))
-		return 0;
-
-	pfn_mac.version = BRCMF_PFN_MACADDR_CFG_VER;
-	pfn_mac.flags = BRCMF_PFN_MAC_OUI_ONLY | BRCMF_PFN_SET_MAC_UNASSOC;
+	pmk_list = &cfg->pmk_list;
+	npmk = le32_to_cpu(pmk_list->npmk);
 
-	memcpy(pfn_mac.mac, request->mac_addr, ETH_ALEN);
-	mac_mask = request->mac_addr_mask;
-	for (i = 0; i < ETH_ALEN; i++) {
-		pfn_mac.mac[i] &= mac_mask[i];
-		pfn_mac.mac[i] |= get_random_int() & ~(mac_mask[i]);
-	}
-	/* Clear multi bit */
-	pfn_mac.mac[0] &= 0xFE;
-	/* Set locally administered */
-	pfn_mac.mac[0] |= 0x02;
+	brcmf_dbg(CONN, "No of elements %d\n", npmk);
+	for (i = 0; i < npmk; i++)
+		brcmf_dbg(CONN, "PMK[%d]: %pM\n", i, &pmk_list->pmk[i].bssid);
 
-	err = brcmf_fil_iovar_data_set(ifp, "pfn_macaddr", &pfn_mac,
-				       sizeof(pfn_mac));
-	if (err)
-		brcmf_err("pfn_macaddr failed, err=%d\n", err);
+	err = brcmf_fil_iovar_data_set(ifp, "pmkid_info", pmk_list,
+				       sizeof(*pmk_list));
 
 	return err;
 }
 
-static int
-brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
-				struct net_device *ndev,
-				struct cfg80211_sched_scan_request *request)
+static s32
+brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
+			 struct cfg80211_pmksa *pmksa)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
-	struct brcmf_pno_net_param_le pfn;
-	int i;
-	int ret = 0;
+	struct brcmf_pmksa *pmk = &cfg->pmk_list.pmk[0];
+	s32 err;
+	u32 npmk, i;
 
-	brcmf_dbg(SCAN, "Enter n_match_sets:%d n_ssids:%d\n",
-		  request->n_match_sets, request->n_ssids);
-	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		brcmf_err("Scanning already: status (%lu)\n", cfg->scan_status);
-		return -EAGAIN;
-	}
-	if (test_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status)) {
-		brcmf_err("Scanning suppressed: status (%lu)\n",
-			  cfg->scan_status);
-		return -EAGAIN;
-	}
+	brcmf_dbg(TRACE, "Enter\n");
+	if (!check_vif_up(ifp->vif))
+		return -EIO;
 
-	if (!request->n_ssids || !request->n_match_sets) {
-		brcmf_dbg(SCAN, "Invalid sched scan req!! n_ssids:%d\n",
-			  request->n_ssids);
+	npmk = le32_to_cpu(cfg->pmk_list.npmk);
+	for (i = 0; i < npmk; i++)
+		if (!memcmp(pmksa->bssid, pmk[i].bssid, ETH_ALEN))
+			break;
+	if (i < BRCMF_MAXPMKID) {
+		memcpy(pmk[i].bssid, pmksa->bssid, ETH_ALEN);
+		memcpy(pmk[i].pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
+		if (i == npmk) {
+			npmk++;
+			cfg->pmk_list.npmk = cpu_to_le32(npmk);
+		}
+	} else {
+		brcmf_err("Too many PMKSA entries cached %d\n", npmk);
 		return -EINVAL;
 	}
 
-	if (request->n_ssids > 0) {
-		for (i = 0; i < request->n_ssids; i++) {
-			/* Active scan req for ssids */
-			brcmf_dbg(SCAN, ">>> Active scan req for ssid (%s)\n",
-				  request->ssids[i].ssid);
+	brcmf_dbg(CONN, "set_pmksa - PMK bssid: %pM =\n", pmk[npmk].bssid);
+	for (i = 0; i < WLAN_PMKID_LEN; i += 4)
+		brcmf_dbg(CONN, "%02x %02x %02x %02x\n", pmk[npmk].pmkid[i],
+			  pmk[npmk].pmkid[i + 1], pmk[npmk].pmkid[i + 2],
+			  pmk[npmk].pmkid[i + 3]);
 
-			/*
-			 * match_set ssids is a supert set of n_ssid list,
-			 * so we need not add these set seperately.
-			 */
-		}
-	}
+	err = brcmf_update_pmklist(cfg, ifp);
 
-	if (request->n_match_sets > 0) {
-		/* clean up everything */
-		ret = brcmf_dev_pno_clean(ndev);
-		if  (ret < 0) {
-			brcmf_err("failed error=%d\n", ret);
-			return ret;
-		}
+	brcmf_dbg(TRACE, "Exit\n");
+	return err;
+}
 
-		/* configure pno */
-		if (brcmf_dev_pno_config(ifp, request))
-			return -EINVAL;
+static s32
+brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
+			 struct cfg80211_pmksa *pmksa)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pmksa *pmk = &cfg->pmk_list.pmk[0];
+	s32 err;
+	u32 npmk, i;
 
-		/* configure each match set */
-		for (i = 0; i < request->n_match_sets; i++) {
-			struct cfg80211_ssid *ssid;
-			u32 ssid_len;
+	brcmf_dbg(TRACE, "Enter\n");
+	if (!check_vif_up(ifp->vif))
+		return -EIO;
 
-			ssid = &request->match_sets[i].ssid;
-			ssid_len = ssid->ssid_len;
+	brcmf_dbg(CONN, "del_pmksa - PMK bssid = %pM\n", &pmksa->bssid);
 
-			if (!ssid_len) {
-				brcmf_err("skip broadcast ssid\n");
-				continue;
-			}
-			pfn.auth = cpu_to_le32(WLAN_AUTH_OPEN);
-			pfn.wpa_auth = cpu_to_le32(BRCMF_PNO_WPA_AUTH_ANY);
-			pfn.wsec = cpu_to_le32(0);
-			pfn.infra = cpu_to_le32(1);
-			pfn.flags = cpu_to_le32(1 << BRCMF_PNO_HIDDEN_BIT);
-			pfn.ssid.SSID_len = cpu_to_le32(ssid_len);
-			memcpy(pfn.ssid.SSID, ssid->ssid, ssid_len);
-			ret = brcmf_fil_iovar_data_set(ifp, "pfn_add", &pfn,
-						       sizeof(pfn));
-			brcmf_dbg(SCAN, ">>> PNO filter %s for ssid (%s)\n",
-				  ret == 0 ? "set" : "failed", ssid->ssid);
-		}
-		/* Enable the PNO */
-		if (brcmf_fil_iovar_int_set(ifp, "pfn", 1) < 0) {
-			brcmf_err("PNO enable failed!! ret=%d\n", ret);
-			return -EINVAL;
+	npmk = le32_to_cpu(cfg->pmk_list.npmk);
+	for (i = 0; i < npmk; i++)
+		if (!memcmp(&pmksa->bssid, &pmk[i].bssid, ETH_ALEN))
+			break;
+
+	if ((npmk > 0) && (i < npmk)) {
+		for (; i < (npmk - 1); i++) {
+			memcpy(&pmk[i].bssid, &pmk[i + 1].bssid, ETH_ALEN);
+			memcpy(&pmk[i].pmkid, &pmk[i + 1].pmkid,
+			       WLAN_PMKID_LEN);
 		}
+		memset(&pmk[i], 0, sizeof(*pmk));
+		cfg->pmk_list.npmk = cpu_to_le32(npmk - 1);
 	} else {
+		brcmf_err("Cache entry not found\n");
 		return -EINVAL;
 	}
 
-	return 0;
+	err = brcmf_update_pmklist(cfg, ifp);
+
+	brcmf_dbg(TRACE, "Exit\n");
+	return err;
+
 }
 
-static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
-					  struct net_device *ndev)
+static s32
+brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	s32 err;
+
+	brcmf_dbg(TRACE, "Enter\n");
+	if (!check_vif_up(ifp->vif))
+		return -EIO;
+
+	memset(&cfg->pmk_list, 0, sizeof(cfg->pmk_list));
+	err = brcmf_update_pmklist(cfg, ifp);
+
+	brcmf_dbg(TRACE, "Exit\n");
+	return err;
 
-	brcmf_dbg(SCAN, "enter\n");
-	brcmf_dev_pno_clean(ndev);
-	if (cfg->sched_escan)
-		brcmf_notify_escan_complete(cfg, netdev_priv(ndev), true, true);
-	return 0;
 }
 
 static s32 brcmf_configure_opensecurity(struct brcmf_if *ifp)
-- 
1.9.1

