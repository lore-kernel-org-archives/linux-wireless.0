Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:56240 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab3IZPrf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 11:47:35 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v3 05/13] ath10k: split ath10k_wmi_service_ready_event_rx
Date: Thu, 26 Sep 2013 17:47:09 +0200
Message-ID: <1380210437-4391-6-git-send-email-bartosz.markowski@tieto.com> (sfid-20130926_174801_817377_3CBEE5A0)
In-Reply-To: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the both firmwares we are going to support,
have significantly different APIs (WMI and shared
structures), it's easier to actually split the whole
event handling functions, instead cutting them inside.

The fork starts now on ath10k_wmi_process_rx().

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |   65 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h |   40 ++++++++++++++++++++
 2 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ef80291..ed79d32 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1301,6 +1301,69 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 	complete(&ar->wmi.service_ready);
 }
 
+static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
+						  struct sk_buff *skb)
+{
+	struct wmi_service_ready_event_10x *ev = (void *)skb->data;
+
+	if (skb->len < sizeof(*ev)) {
+		ath10k_warn("Service ready event was %d B but expected %zu B. Wrong firmware version?\n",
+			    skb->len, sizeof(*ev));
+		return;
+	}
+
+	ar->hw_min_tx_power = __le32_to_cpu(ev->hw_min_tx_power);
+	ar->hw_max_tx_power = __le32_to_cpu(ev->hw_max_tx_power);
+	ar->ht_cap_info = __le32_to_cpu(ev->ht_cap_info);
+	ar->vht_cap_info = __le32_to_cpu(ev->vht_cap_info);
+	ar->fw_version_major =
+		(__le32_to_cpu(ev->sw_version) & 0xff000000) >> 24;
+	ar->fw_version_minor = (__le32_to_cpu(ev->sw_version) & 0x00ffffff);
+	ar->phy_capability = __le32_to_cpu(ev->phy_capability);
+	ar->num_rf_chains = __le32_to_cpu(ev->num_rf_chains);
+
+	if (ar->num_rf_chains > WMI_MAX_SPATIAL_STREAM) {
+		ath10k_warn("hardware advertises support for more spatial streams than it should (%d > %d)\n",
+			    ar->num_rf_chains, WMI_MAX_SPATIAL_STREAM);
+		ar->num_rf_chains = WMI_MAX_SPATIAL_STREAM;
+	}
+
+	ar->ath_common.regulatory.current_rd =
+		__le32_to_cpu(ev->hal_reg_capabilities.eeprom_rd);
+
+	ath10k_debug_read_service_map(ar, ev->wmi_service_bitmap,
+				      sizeof(ev->wmi_service_bitmap));
+
+	if (strlen(ar->hw->wiphy->fw_version) == 0) {
+		snprintf(ar->hw->wiphy->fw_version,
+			 sizeof(ar->hw->wiphy->fw_version),
+			 "%u.%u",
+			 ar->fw_version_major,
+			 ar->fw_version_minor);
+	}
+
+	/* FIXME: it probably should be better to support this.
+	   TODO: Next patch introduce memory chunks. It's a must for 10.x FW */
+	if (__le32_to_cpu(ev->num_mem_reqs) > 0) {
+		ath10k_warn("target requested %d memory chunks; ignoring\n",
+			    __le32_to_cpu(ev->num_mem_reqs));
+	}
+
+	ath10k_dbg(ATH10K_DBG_WMI,
+		   "wmi event service ready sw_ver 0x%08x abi_ver %u phy_cap 0x%08x ht_cap 0x%08x vht_cap 0x%08x vht_supp_msc 0x%08x sys_cap_info 0x%08x mem_reqs %u num_rf_chains %u\n",
+		   __le32_to_cpu(ev->sw_version),
+		   __le32_to_cpu(ev->abi_version),
+		   __le32_to_cpu(ev->phy_capability),
+		   __le32_to_cpu(ev->ht_cap_info),
+		   __le32_to_cpu(ev->vht_cap_info),
+		   __le32_to_cpu(ev->vht_supp_mcs),
+		   __le32_to_cpu(ev->sys_cap_info),
+		   __le32_to_cpu(ev->num_mem_reqs),
+		   __le32_to_cpu(ev->num_rf_chains));
+
+	complete(&ar->wmi.service_ready);
+}
+
 static int ath10k_wmi_ready_event_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_ready_event *ev = (struct wmi_ready_event *)skb->data;
@@ -1537,7 +1600,7 @@ static void ath10k_wmi_10x_process_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_event_vdev_resume_req(ar, skb);
 		break;
 	case WMI_10X_SERVICE_READY_EVENTID:
-		ath10k_wmi_service_ready_event_rx(ar, skb);
+		ath10k_wmi_10x_service_ready_event_rx(ar, skb);
 		break;
 	case WMI_10X_READY_EVENTID:
 		ath10k_wmi_ready_event_rx(ar, skb);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index d8414ab..a0cfdfd 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1130,6 +1130,46 @@ struct wmi_service_ready_event {
 	struct wlan_host_mem_req mem_reqs[1];
 } __packed;
 
+/* This is the definition from 10.X firmware branch */
+struct wmi_service_ready_event_10x {
+	__le32 sw_version;
+	__le32 abi_version;
+
+	/* WMI_PHY_CAPABILITY */
+	__le32 phy_capability;
+
+	/* Maximum number of frag table entries that SW will populate less 1 */
+	__le32 max_frag_entry;
+	__le32 wmi_service_bitmap[WMI_SERVICE_BM_SIZE];
+	__le32 num_rf_chains;
+
+	/*
+	 * The following field is only valid for service type
+	 * WMI_SERVICE_11AC
+	 */
+	__le32 ht_cap_info; /* WMI HT Capability */
+	__le32 vht_cap_info; /* VHT capability info field of 802.11ac */
+	__le32 vht_supp_mcs; /* VHT Supported MCS Set field Rx/Tx same */
+	__le32 hw_min_tx_power;
+	__le32 hw_max_tx_power;
+
+	struct hal_reg_capabilities hal_reg_capabilities;
+
+	__le32 sys_cap_info;
+	__le32 min_pkt_size_enable; /* Enterprise mode short pkt enable */
+
+	/*
+	 * request to host to allocate a chuck of memory and pss it down to FW
+	 * via WM_INIT. FW uses this as FW extesnsion memory for saving its
+	 * data structures. Only valid for low latency interfaces like PCIE
+	 * where FW can access this memory directly (or) by DMA.
+	 */
+	__le32 num_mem_reqs;
+
+	struct wlan_host_mem_req mem_reqs[1];
+} __packed;
+
+
 #define WMI_SERVICE_READY_TIMEOUT_HZ (5*HZ)
 #define WMI_UNIFIED_READY_TIMEOUT_HZ (5*HZ)
 
-- 
1.7.10

