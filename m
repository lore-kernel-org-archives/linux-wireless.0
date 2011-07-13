Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:42081 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab1GMBdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 21:33:51 -0400
Subject: [PATCH 05/24] ath6kl: add common.h
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, gregkh@suse.de, error27@gmail.com
Date: Wed, 13 Jul 2011 04:33:45 +0300
Message-ID: <20110713013345.8517.40718.stgit@localhost6.localdomain6> (sfid-20110713_033359_660650_15BCBF4B)
In-Reply-To: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/common.h |  163 ++++++++++++++++++++++++++++++
 1 files changed, 163 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/common.h

diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
new file mode 100644
index 0000000..cd201c5
--- /dev/null
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -0,0 +1,163 @@
+/*
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
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
+#ifndef COMMON_H
+#define COMMON_H
+
+#include <linux/netdevice.h>
+
+#define IEEE80211_MAX_IE        256
+
+extern int ath6kl_printk(const char *level, const char *fmt, ...);
+
+#define A_CACHE_LINE_PAD            128
+
+/*
+ * Reflects the version of binary interface exposed by ATH6KL target
+ * firmware. Needs to be incremented by 1 for any change in the firmware
+ * that requires upgrade of the driver on the host side for the change to
+ * work correctly
+ */
+#define ATH6KL_ABI_VERSION        1
+
+#define SIGNAL_QUALITY_METRICS_NUM_MAX    2
+
+enum {
+	SIGNAL_QUALITY_METRICS_SNR = 0,
+	SIGNAL_QUALITY_METRICS_RSSI,
+	SIGNAL_QUALITY_METRICS_ALL,
+};
+
+/*
+ * Data Path
+ */
+
+#define WMI_MAX_TX_DATA_FRAME_LENGTH	      \
+	(1500 + sizeof(struct wmi_data_hdr) + \
+	 sizeof(struct ethhdr) +      \
+	 sizeof(struct ath6kl_llc_snap_hdr))
+
+/* An AMSDU frame */ /* The MAX AMSDU length of AR6003 is 3839 */
+#define WMI_MAX_AMSDU_RX_DATA_FRAME_LENGTH    \
+	(3840 + sizeof(struct wmi_data_hdr) + \
+	 sizeof(struct ethhdr) +      \
+	 sizeof(struct ath6kl_llc_snap_hdr))
+
+#define EPPING_ALIGNMENT_PAD			       \
+	(((sizeof(struct htc_frame_hdr) + 3) & (~0x3)) \
+	 - sizeof(struct htc_frame_hdr))
+
+struct ath6kl_llc_snap_hdr {
+	u8 dsap;
+	u8 ssap;
+	u8 cntl;
+	u8 org_code[3];
+	__be16 eth_type;
+} __packed;
+
+enum crypto_type {
+	NONE_CRYPT          = 0x01,
+	WEP_CRYPT           = 0x02,
+	TKIP_CRYPT          = 0x04,
+	AES_CRYPT           = 0x08,
+};
+
+struct ieee80211_node_table;
+struct ieee80211_frame;
+
+struct ieee80211_common_ie {
+	u16 ie_chan;
+	u8 *ie_tstamp;
+	u8 *ie_ssid;
+	u8 *ie_rates;
+	u8 *ie_xrates;
+	u8 *ie_country;
+	u8 *ie_wpa;
+	u8 *ie_rsn;
+	u8 *ie_wmm;
+	u8 *ie_ath;
+	u16 ie_capInfo;
+	u16 ie_beaconInt;
+	u8 *ie_tim;
+	u8 *ie_chswitch;
+	u8 ie_erp;
+	u8 *ie_wsc;
+	u8 *ie_htcap;
+	u8 *ie_htop;
+};
+
+struct bss {
+	u8 ni_macaddr[ETH_ALEN];
+	u8 ni_snr;
+	s16 ni_rssi;
+	struct bss *ni_list_next;
+	struct bss *ni_list_prev;
+	struct bss *ni_hash_next;
+	struct bss *ni_hash_prev;
+	struct ieee80211_common_ie ni_cie;
+	u8 *ni_buf;
+	u16 ni_framelen;
+	struct ieee80211_node_table *ni_table;
+	u32 ni_refcnt;
+
+	u32 ni_tstamp;
+	u32 ni_actcnt;
+};
+
+struct htc_endpoint_credit_dist;
+struct ath6kl;
+enum htc_credit_dist_reason;
+struct htc_credit_state_info;
+
+int wmi_dot3_2_dix(struct sk_buff *skb);
+
+struct bss *wlan_node_alloc(int wh_size);
+void wlan_node_free(struct bss *ni);
+void wlan_setup_node(struct ieee80211_node_table *nt, struct bss *ni,
+		     const u8 *mac_addr);
+struct bss *wlan_find_node(struct ieee80211_node_table *nt,
+			   const u8 *mac_addr);
+void wlan_node_reclaim(struct ieee80211_node_table *nt, struct bss *ni);
+void wlan_free_allnodes(struct ieee80211_node_table *nt);
+void wlan_iterate_nodes(struct ieee80211_node_table *nt,
+			void (*f) (void *arg, struct bss *),
+			void *arg);
+
+void wlan_node_table_init(void *wmip, struct ieee80211_node_table *nt);
+void wlan_node_table_cleanup(struct ieee80211_node_table *nt);
+
+void wlan_refresh_inactive_nodes(struct ieee80211_node_table *nt);
+
+struct bss *wlan_find_ssid_node(struct ieee80211_node_table *nt, u8 *ssid,
+				  u32 ssid_len, bool is_wpa2, bool match_ssid);
+
+void wlan_node_return(struct ieee80211_node_table *nt, struct bss *ni);
+
+int ath6k_setup_credit_dist(void *htc_handle,
+			    struct htc_credit_state_info *cred_info);
+void ath6k_credit_distribute(struct htc_credit_state_info *cred_inf,
+			     struct list_head *epdist_list,
+			     enum htc_credit_dist_reason reason);
+void ath6k_credit_init(struct htc_credit_state_info *cred_inf,
+		       struct list_head *ep_list,
+		       int tot_credits);
+void ath6k_seek_credits(struct htc_credit_state_info *cred_inf,
+			struct htc_endpoint_credit_dist *ep_dist);
+struct ath6kl *ath6kl_core_alloc(struct device *sdev);
+int ath6kl_core_init(struct ath6kl *ar);
+int ath6kl_unavail_ev(struct ath6kl *ar);
+struct sk_buff *ath6kl_buf_alloc(int size);
+#endif /* COMMON_H */

