Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:53335 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2GSNAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 09:00:44 -0400
Subject: [PATCH v2 1/3] ath6kl: move ath6kl_wmi_startscan_cmd()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 19 Jul 2012 16:00:40 +0300
Message-ID: <20120719130040.22047.15474.stgit@x201> (sfid-20120719_150047_680960_CB6EE136)
In-Reply-To: <20120719125937.22047.91375.stgit@x201>
References: <20120719125937.22047.91375.stgit@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To make it easier to refactor the scan commands move
ath6kl_wmi_startscan_cmd() before the beginscan function. No functional
changes.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   88 +++++++++++++++++----------------
 1 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 4762fa5..a9d7e00 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1895,22 +1895,22 @@ int ath6kl_wmi_disconnect_cmd(struct wmi *wmi, u8 if_idx)
 	return ret;
 }
 
-int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
+/* ath6kl_wmi_start_scan_cmd is to be deprecated. Use
+ * ath6kl_wmi_begin_scan_cmd instead. The new function supports P2P
+ * mgmt operations using station interface.
+ */
+int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
 			     enum wmi_scan_type scan_type,
 			     u32 force_fgscan, u32 is_legacy,
 			     u32 home_dwell_time, u32 force_scan_interval,
-			     s8 num_chan, u16 *ch_list, u32 no_cck, u32 *rates)
+			     s8 num_chan, u16 *ch_list)
 {
-	struct ieee80211_supported_band *sband;
 	struct sk_buff *skb;
-	struct wmi_begin_scan_cmd *sc;
-	s8 size, *supp_rates;
-	int i, band, ret;
-	struct ath6kl *ar = wmi->parent_dev;
-	int num_rates;
-	u32 ratemask;
+	struct wmi_start_scan_cmd *sc;
+	s8 size;
+	int i, ret;
 
-	size = sizeof(struct wmi_begin_scan_cmd);
+	size = sizeof(struct wmi_start_scan_cmd);
 
 	if ((scan_type != WMI_LONG_SCAN) && (scan_type != WMI_SHORT_SCAN))
 		return -EINVAL;
@@ -1925,59 +1925,39 @@ int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
 	if (!skb)
 		return -ENOMEM;
 
-	sc = (struct wmi_begin_scan_cmd *) skb->data;
+	sc = (struct wmi_start_scan_cmd *) skb->data;
 	sc->scan_type = scan_type;
 	sc->force_fg_scan = cpu_to_le32(force_fgscan);
 	sc->is_legacy = cpu_to_le32(is_legacy);
 	sc->home_dwell_time = cpu_to_le32(home_dwell_time);
 	sc->force_scan_intvl = cpu_to_le32(force_scan_interval);
-	sc->no_cck = cpu_to_le32(no_cck);
 	sc->num_ch = num_chan;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
-		sband = ar->wiphy->bands[band];
-
-		if (!sband)
-			continue;
-
-		ratemask = rates[band];
-		supp_rates = sc->supp_rates[band].rates;
-		num_rates = 0;
-
-		for (i = 0; i < sband->n_bitrates; i++) {
-			if ((BIT(i) & ratemask) == 0)
-				continue; /* skip rate */
-			supp_rates[num_rates++] =
-			    (u8) (sband->bitrates[i].bitrate / 5);
-		}
-		sc->supp_rates[band].nrates = num_rates;
-	}
-
 	for (i = 0; i < num_chan; i++)
 		sc->ch_list[i] = cpu_to_le16(ch_list[i]);
 
-	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_BEGIN_SCAN_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_START_SCAN_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	return ret;
 }
 
-/* ath6kl_wmi_start_scan_cmd is to be deprecated. Use
- * ath6kl_wmi_begin_scan_cmd instead. The new function supports P2P
- * mgmt operations using station interface.
- */
-int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
+int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
 			     enum wmi_scan_type scan_type,
 			     u32 force_fgscan, u32 is_legacy,
 			     u32 home_dwell_time, u32 force_scan_interval,
-			     s8 num_chan, u16 *ch_list)
+			     s8 num_chan, u16 *ch_list, u32 no_cck, u32 *rates)
 {
+	struct ieee80211_supported_band *sband;
 	struct sk_buff *skb;
-	struct wmi_start_scan_cmd *sc;
-	s8 size;
-	int i, ret;
+	struct wmi_begin_scan_cmd *sc;
+	s8 size, *supp_rates;
+	int i, band, ret;
+	struct ath6kl *ar = wmi->parent_dev;
+	int num_rates;
+	u32 ratemask;
 
-	size = sizeof(struct wmi_start_scan_cmd);
+	size = sizeof(struct wmi_begin_scan_cmd);
 
 	if ((scan_type != WMI_LONG_SCAN) && (scan_type != WMI_SHORT_SCAN))
 		return -EINVAL;
@@ -1992,18 +1972,38 @@ int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
 	if (!skb)
 		return -ENOMEM;
 
-	sc = (struct wmi_start_scan_cmd *) skb->data;
+	sc = (struct wmi_begin_scan_cmd *) skb->data;
 	sc->scan_type = scan_type;
 	sc->force_fg_scan = cpu_to_le32(force_fgscan);
 	sc->is_legacy = cpu_to_le32(is_legacy);
 	sc->home_dwell_time = cpu_to_le32(home_dwell_time);
 	sc->force_scan_intvl = cpu_to_le32(force_scan_interval);
+	sc->no_cck = cpu_to_le32(no_cck);
 	sc->num_ch = num_chan;
 
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		sband = ar->wiphy->bands[band];
+
+		if (!sband)
+			continue;
+
+		ratemask = rates[band];
+		supp_rates = sc->supp_rates[band].rates;
+		num_rates = 0;
+
+		for (i = 0; i < sband->n_bitrates; i++) {
+			if ((BIT(i) & ratemask) == 0)
+				continue; /* skip rate */
+			supp_rates[num_rates++] =
+			    (u8) (sband->bitrates[i].bitrate / 5);
+		}
+		sc->supp_rates[band].nrates = num_rates;
+	}
+
 	for (i = 0; i < num_chan; i++)
 		sc->ch_list[i] = cpu_to_le16(ch_list[i]);
 
-	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_START_SCAN_CMDID,
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_BEGIN_SCAN_CMDID,
 				  NO_SYNC_WMIFLAG);
 
 	return ret;

