Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14745 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab1ISQQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:16:07 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 5/9] ath6kl: Replace internal node table with cfg80211 BSS table
Date: Mon, 19 Sep 2011 19:15:03 +0300
Message-ID: <1316448907-10166-6-git-send-email-jouni@qca.qualcomm.com> (sfid-20110919_181612_539625_C1EFD217)
In-Reply-To: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
References: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The internal node table in ath6kl was not really used for any useful
purpose. It was just used to collect scan results during a scan and then
provide them in a burst to cfg80211 at the completion of the scan. There
is no point in doing this since cfg80211 is perfectly capable of
maintaining the BSS table and the BSS inform messages are sent in
separate function calls anyway.

This provides more complete information in the cfg80211 BSS table since
this allows Beacon and Probe Response frames to be distinguished and IEs
from them reported separately.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |  296 +++++----------------------------
 1 files changed, 45 insertions(+), 251 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 24f0e3e..ff13e0b 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -910,277 +910,74 @@ static int ath6kl_wmi_tkip_micerr_event_rx(struct wmi *wmi, u8 *datap, int len)
 	return 0;
 }
 
-static int ath6kl_wlan_parse_beacon(u8 *buf, int frame_len,
-				    struct ath6kl_common_ie *cie)
-{
-	u8 *frm, *efrm;
-	u8 elemid_ssid = false;
-
-	frm = buf;
-	efrm = (u8 *) (frm + frame_len);
-
-	/*
-	 * beacon/probe response frame format
-	 *  [8] time stamp
-	 *  [2] beacon interval
-	 *  [2] capability information
-	 *  [tlv] ssid
-	 *  [tlv] supported rates
-	 *  [tlv] country information
-	 *  [tlv] parameter set (FH/DS)
-	 *  [tlv] erp information
-	 *  [tlv] extended supported rates
-	 *  [tlv] WMM
-	 *  [tlv] WPA or RSN
-	 *  [tlv] Atheros Advanced Capabilities
-	 */
-	if ((efrm - frm) < 12)
-		return -EINVAL;
-
-	memset(cie, 0, sizeof(*cie));
-
-	cie->ie_tstamp = frm;
-	frm += 8;
-	cie->ie_beaconInt = *(u16 *) frm;
-	frm += 2;
-	cie->ie_capInfo = *(u16 *) frm;
-	frm += 2;
-	cie->ie_chan = 0;
-
-	while (frm < efrm) {
-		switch (*frm) {
-		case WLAN_EID_SSID:
-			if (!elemid_ssid) {
-				cie->ie_ssid = frm;
-				elemid_ssid = true;
-			}
-			break;
-		case WLAN_EID_SUPP_RATES:
-			cie->ie_rates = frm;
-			break;
-		case WLAN_EID_COUNTRY:
-			cie->ie_country = frm;
-			break;
-		case WLAN_EID_FH_PARAMS:
-			break;
-		case WLAN_EID_DS_PARAMS:
-			cie->ie_chan = frm[2];
-			break;
-		case WLAN_EID_TIM:
-			cie->ie_tim = frm;
-			break;
-		case WLAN_EID_IBSS_PARAMS:
-			break;
-		case WLAN_EID_EXT_SUPP_RATES:
-			cie->ie_xrates = frm;
-			break;
-		case WLAN_EID_ERP_INFO:
-			if (frm[1] != 1)
-				return -EINVAL;
-
-			cie->ie_erp = frm[2];
-			break;
-		case WLAN_EID_RSN:
-			cie->ie_rsn = frm;
-			break;
-		case WLAN_EID_HT_CAPABILITY:
-			cie->ie_htcap = frm;
-			break;
-		case WLAN_EID_HT_INFORMATION:
-			cie->ie_htop = frm;
-			break;
-		case WLAN_EID_VENDOR_SPECIFIC:
-			if (frm[1] > 3 && frm[2] == 0x00 && frm[3] == 0x50 &&
-			    frm[4] == 0xf2) {
-				/* OUT Type (00:50:F2) */
-
-				if (frm[5] == WPA_OUI_TYPE) {
-					/* WPA OUT */
-					cie->ie_wpa = frm;
-				} else if (frm[5] == WMM_OUI_TYPE) {
-					/* WMM OUT */
-					cie->ie_wmm = frm;
-				} else if (frm[5] == WSC_OUT_TYPE) {
-					/* WSC OUT */
-					cie->ie_wsc = frm;
-				}
-
-			} else if (frm[1] > 3 && frm[2] == 0x00
-				   && frm[3] == 0x03 && frm[4] == 0x7f
-				   && frm[5] == ATH_OUI_TYPE) {
-				/* Atheros OUI (00:03:7f) */
-				cie->ie_ath = frm;
-			}
-			break;
-		default:
-			break;
-		}
-		frm += frm[1] + 2;
-	}
-
-	if ((cie->ie_rates == NULL)
-	    || (cie->ie_rates[1] > ATH6KL_RATE_MAXSIZE))
-		return -EINVAL;
-
-	if ((cie->ie_ssid == NULL)
-	    || (cie->ie_ssid[1] > IEEE80211_MAX_SSID_LEN))
-		return -EINVAL;
-
-	return 0;
-}
-
 static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len)
 {
-	struct bss *bss = NULL;
 	struct wmi_bss_info_hdr *bih;
-	u8 cached_ssid_len = 0;
-	u8 cached_ssid[IEEE80211_MAX_SSID_LEN] = { 0 };
-	u8 beacon_ssid_len = 0;
-	u8 *buf, *ie_ssid;
-	u8 *ni_buf;
-	int buf_len;
-
-	int ret;
+	u8 *buf;
+	struct ieee80211_channel *channel;
+	struct ath6kl *ar = wmi->parent_dev;
+	struct ieee80211_mgmt *mgmt;
+	struct cfg80211_bss *bss;
 
 	if (len <= sizeof(struct wmi_bss_info_hdr))
 		return -EINVAL;
 
 	bih = (struct wmi_bss_info_hdr *) datap;
-	bss = wlan_find_node(&wmi->parent_dev->scan_table, bih->bssid);
-
-	if (a_sle16_to_cpu(bih->rssi) > 0) {
-		if (bss == NULL)
-			return 0;
-		else
-			bih->rssi = a_cpu_to_sle16(bss->ni_rssi);
-	}
-
 	buf = datap + sizeof(struct wmi_bss_info_hdr);
 	len -= sizeof(struct wmi_bss_info_hdr);
 
 	ath6kl_dbg(ATH6KL_DBG_WMI,
-		   "bss info evt - ch %u, rssi %02x, bssid \"%pM\"\n",
-		   bih->ch, a_sle16_to_cpu(bih->rssi), bih->bssid);
-
-	if (bss != NULL) {
-		/*
-		 * Free up the node. We are about to allocate a new node.
-		 * In case of hidden AP, beacon will not have ssid,
-		 * but a directed probe response will have it,
-		 * so cache the probe-resp-ssid if already present.
-		 */
-		if (wmi->is_probe_ssid && (bih->frame_type == BEACON_FTYPE)) {
-			ie_ssid = bss->ni_cie.ie_ssid;
-			if (ie_ssid && (ie_ssid[1] <= IEEE80211_MAX_SSID_LEN) &&
-			    (ie_ssid[2] != 0)) {
-				cached_ssid_len = ie_ssid[1];
-				memcpy(cached_ssid, ie_ssid + 2,
-				       cached_ssid_len);
-			}
-		}
-
-		/*
-		 * Use the current average rssi of associated AP base on
-		 * assumption
-		 *   1. Most os with GUI will update RSSI by
-		 *      ath6kl_wmi_get_stats_cmd() periodically.
-		 *   2. ath6kl_wmi_get_stats_cmd(..) will be called when calling
-		 *      ath6kl_wmi_startscan_cmd(...)
-		 * The average value of RSSI give end-user better feeling for
-		 * instance value of scan result. It also sync up RSSI info
-		 * in GUI between scan result and RSSI signal icon.
-		 */
-		if (memcmp(wmi->parent_dev->bssid, bih->bssid, ETH_ALEN) == 0) {
-			bih->rssi = a_cpu_to_sle16(bss->ni_rssi);
-			bih->snr = bss->ni_snr;
-		}
-
-		wlan_node_reclaim(&wmi->parent_dev->scan_table, bss);
-	}
-
-	/*
-	 * beacon/probe response frame format
-	 *  [8] time stamp
-	 *  [2] beacon interval
-	 *  [2] capability information
-	 *  [tlv] ssid
-	 */
-	beacon_ssid_len = buf[SSID_IE_LEN_INDEX];
-
-	/*
-	 * If ssid is cached for this hidden AP, then change
-	 * buffer len accordingly.
-	 */
-	if (wmi->is_probe_ssid && (bih->frame_type == BEACON_FTYPE) &&
-	    (cached_ssid_len != 0) &&
-	    (beacon_ssid_len == 0 || (cached_ssid_len > beacon_ssid_len &&
-				      buf[SSID_IE_LEN_INDEX + 1] == 0))) {
-
-		len += (cached_ssid_len - beacon_ssid_len);
-	}
+		   "bss info evt - ch %u, snr %d, rssi %d, bssid \"%pM\" "
+		   "frame_type=%d\n",
+		   bih->ch, bih->snr, a_sle16_to_cpu(bih->rssi), bih->bssid,
+		   bih->frame_type);
 
-	bss = wlan_node_alloc(len);
-	if (!bss)
-		return -ENOMEM;
+	if (bih->frame_type != BEACON_FTYPE &&
+	    bih->frame_type != PROBERESP_FTYPE)
+		return 0; /* Only update BSS table for now */
 
-	bss->ni_snr = bih->snr;
-	bss->ni_rssi = a_sle16_to_cpu(bih->rssi);
+	channel = ieee80211_get_channel(ar->wdev->wiphy, le16_to_cpu(bih->ch));
+	if (channel == NULL)
+		return -EINVAL;
 
-	if (WARN_ON(!bss->ni_buf))
+	if (len < 8 + 2 + 2)
 		return -EINVAL;
 
 	/*
-	 * In case of hidden AP, beacon will not have ssid,
-	 * but a directed probe response will have it,
-	 * so place the cached-ssid(probe-resp) in the bss info.
+	 * In theory, use of cfg80211_inform_bss() would be more natural here
+	 * since we do not have the full frame. However, at least for now,
+	 * cfg80211 can only distinguish Beacon and Probe Response frames from
+	 * each other when using cfg80211_inform_bss_frame(), so let's build a
+	 * fake IEEE 802.11 header to be able to take benefit of this.
 	 */
-	if (wmi->is_probe_ssid && (bih->frame_type == BEACON_FTYPE) &&
-	    (cached_ssid_len != 0) &&
-	    (beacon_ssid_len == 0 || (beacon_ssid_len &&
-				      buf[SSID_IE_LEN_INDEX + 1] == 0))) {
-		ni_buf = bss->ni_buf;
-		buf_len = len;
-
-		/*
-		 * Copy the first 14 bytes:
-		 * time-stamp(8), beacon-interval(2),
-		 * cap-info(2), ssid-id(1), ssid-len(1).
-		 */
-		memcpy(ni_buf, buf, SSID_IE_LEN_INDEX + 1);
-
-		ni_buf[SSID_IE_LEN_INDEX] = cached_ssid_len;
-		ni_buf += (SSID_IE_LEN_INDEX + 1);
-
-		buf += (SSID_IE_LEN_INDEX + 1);
-		buf_len -= (SSID_IE_LEN_INDEX + 1);
-
-		memcpy(ni_buf, cached_ssid, cached_ssid_len);
-		ni_buf += cached_ssid_len;
-
-		buf += beacon_ssid_len;
-		buf_len -= beacon_ssid_len;
-
-		if (cached_ssid_len > beacon_ssid_len)
-			buf_len -= (cached_ssid_len - beacon_ssid_len);
-
-		memcpy(ni_buf, buf, buf_len);
-	} else
-		memcpy(bss->ni_buf, buf, len);
+	mgmt = kmalloc(24 + len, GFP_ATOMIC);
+	if (mgmt == NULL)
+		return -EINVAL;
 
-	bss->ni_framelen = len;
+	if (bih->frame_type == BEACON_FTYPE) {
+		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						  IEEE80211_STYPE_BEACON);
+		memset(mgmt->da, 0xff, ETH_ALEN);
+	} else {
+		struct net_device *dev = ar->net_dev;
 
-	ret = ath6kl_wlan_parse_beacon(bss->ni_buf, len, &bss->ni_cie);
-	if (ret) {
-		wlan_node_free(bss);
-		return -EINVAL;
+		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						  IEEE80211_STYPE_PROBE_RESP);
+		memcpy(mgmt->da, dev->dev_addr, ETH_ALEN);
 	}
+	mgmt->duration = cpu_to_le16(0);
+	memcpy(mgmt->sa, bih->bssid, ETH_ALEN);
+	memcpy(mgmt->bssid, bih->bssid, ETH_ALEN);
+	mgmt->seq_ctrl = cpu_to_le16(0);
 
-	/*
-	 * Update the frequency in ie_chan, overwriting of channel number
-	 * which is done in ath6kl_wlan_parse_beacon
-	 */
-	bss->ni_cie.ie_chan = le16_to_cpu(bih->ch);
-	wlan_setup_node(&wmi->parent_dev->scan_table, bss, bih->bssid);
+	memcpy(&mgmt->u.beacon, buf, len);
+
+	bss = cfg80211_inform_bss_frame(ar->wdev->wiphy, channel, mgmt,
+					24 + len, bih->snr * 100, GFP_ATOMIC);
+	kfree(mgmt);
+	if (bss == NULL)
+		return -ENOMEM;
+	cfg80211_put_bss(bss);
 
 	return 0;
 }
@@ -1295,9 +1092,6 @@ static int ath6kl_wmi_scan_complete_rx(struct wmi *wmi, u8 *datap, int len)
 
 	ev = (struct wmi_scan_complete_event *) datap;
 
-	if (a_sle32_to_cpu(ev->status) == 0)
-		wlan_refresh_inactive_nodes(wmi->parent_dev);
-
 	ath6kl_scan_complete_evt(wmi->parent_dev, a_sle32_to_cpu(ev->status));
 	wmi->is_probe_ssid = false;
 
-- 
1.7.4.1

