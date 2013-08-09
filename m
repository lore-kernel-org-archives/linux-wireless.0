Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:44235 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030544Ab3HIINo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 04:13:44 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: add support for firmware newer than 636
Date: Fri, 9 Aug 2013 10:13:33 +0200
Message-ID: <1376036014-29707-3-git-send-email-michal.kazior@tieto.com> (sfid-20130809_101352_374722_4681D350)
In-Reply-To: <1376036014-29707-1-git-send-email-michal.kazior@tieto.com>
References: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
 <1376036014-29707-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mgmt_rx event structure has been expanded.
Since the structure header is expanded the payload
(i.e. mgmt frame) is shifted by a few bytes. This
needs to be taken into account in order to support
both old and new firmware.

This introduces a fw_features to keep track of any
FW-related ABI/behaviour changes.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
patch:
 * add/use fw_features instead of direct build
   version probing (Kalle)
 * use _v1/_v2 instead of _abi1/_abi2 (Kalle)

 drivers/net/wireless/ath/ath10k/core.h |   10 ++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  |   32 ++++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath10k/wmi.h  |   16 +++++++++++++---
 3 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index e4bba56..ab05c4c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -270,6 +270,14 @@ enum ath10k_state {
 	ATH10K_STATE_WEDGED,
 };
 
+enum ath10k_fw_features {
+	/* wmi_mgmt_rx_hdr contains extra RSSI information */
+	ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX = 0,
+
+	/* keep last */
+	ATH10K_FW_FEATURE_COUNT,
+};
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -288,6 +296,8 @@ struct ath10k {
 	u32 vht_cap_info;
 	u32 num_rf_chains;
 
+	DECLARE_BITMAP(fw_features, ATH10K_FW_FEATURE_COUNT);
+
 	struct targetdef *targetdef;
 	struct hostdef *hostdef;
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 55f90c7..d606fef 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -315,7 +315,9 @@ static inline u8 get_rate_idx(u32 rate, enum ieee80211_band band)
 
 static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct wmi_mgmt_rx_event *event = (struct wmi_mgmt_rx_event *)skb->data;
+	struct wmi_mgmt_rx_event_v1 *ev_v1;
+	struct wmi_mgmt_rx_event_v2 *ev_v2;
+	struct wmi_mgmt_rx_hdr_v1 *ev_hdr;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr;
 	u32 rx_status;
@@ -325,13 +327,24 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	u32 rate;
 	u32 buf_len;
 	u16 fc;
+	int pull_len;
+
+	if (test_bit(ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX, ar->fw_features)) {
+		ev_v2 = (struct wmi_mgmt_rx_event_v2 *)skb->data;
+		ev_hdr = &ev_v2->hdr.v1;
+		pull_len = sizeof(*ev_v2);
+	} else {
+		ev_v1 = (struct wmi_mgmt_rx_event_v1 *)skb->data;
+		ev_hdr = &ev_v1->hdr;
+		pull_len = sizeof(*ev_v1);
+	}
 
-	channel   = __le32_to_cpu(event->hdr.channel);
-	buf_len   = __le32_to_cpu(event->hdr.buf_len);
-	rx_status = __le32_to_cpu(event->hdr.status);
-	snr       = __le32_to_cpu(event->hdr.snr);
-	phy_mode  = __le32_to_cpu(event->hdr.phy_mode);
-	rate	  = __le32_to_cpu(event->hdr.rate);
+	channel   = __le32_to_cpu(ev_hdr->channel);
+	buf_len   = __le32_to_cpu(ev_hdr->buf_len);
+	rx_status = __le32_to_cpu(ev_hdr->status);
+	snr       = __le32_to_cpu(ev_hdr->snr);
+	phy_mode  = __le32_to_cpu(ev_hdr->phy_mode);
+	rate	  = __le32_to_cpu(ev_hdr->rate);
 
 	memset(status, 0, sizeof(*status));
 
@@ -358,7 +371,7 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	status->signal = snr + ATH10K_DEFAULT_NOISE_FLOOR;
 	status->rate_idx = get_rate_idx(rate, status->band);
 
-	skb_pull(skb, sizeof(event->hdr));
+	skb_pull(skb, pull_len);
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = le16_to_cpu(hdr->frame_control);
@@ -943,6 +956,9 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 	ar->phy_capability = __le32_to_cpu(ev->phy_capability);
 	ar->num_rf_chains = __le32_to_cpu(ev->num_rf_chains);
 
+	if (ar->fw_version_build > 636)
+		set_bit(ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX, ar->fw_features);
+
 	if (ar->num_rf_chains > WMI_MAX_SPATIAL_STREAM) {
 		ath10k_warn("hardware advertises support for more spatial streams than it should (%d > %d)\n",
 			    ar->num_rf_chains, WMI_MAX_SPATIAL_STREAM);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 2c5a4f8..08860c4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1268,7 +1268,7 @@ struct wmi_scan_event {
  * good idea to pass all the fields in the RX status
  * descriptor up to the host.
  */
-struct wmi_mgmt_rx_hdr {
+struct wmi_mgmt_rx_hdr_v1 {
 	__le32 channel;
 	__le32 snr;
 	__le32 rate;
@@ -1277,8 +1277,18 @@ struct wmi_mgmt_rx_hdr {
 	__le32 status; /* %WMI_RX_STATUS_ */
 } __packed;
 
-struct wmi_mgmt_rx_event {
-	struct wmi_mgmt_rx_hdr hdr;
+struct wmi_mgmt_rx_hdr_v2 {
+	struct wmi_mgmt_rx_hdr_v1 v1;
+	__le32 rssi_ctl[4];
+} __packed;
+
+struct wmi_mgmt_rx_event_v1 {
+	struct wmi_mgmt_rx_hdr_v1 hdr;
+	u8 buf[0];
+} __packed;
+
+struct wmi_mgmt_rx_event_v2 {
+	struct wmi_mgmt_rx_hdr_v2 hdr;
 	u8 buf[0];
 } __packed;
 
-- 
1.7.9.5

