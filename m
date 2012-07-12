Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:40971 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab2GLJjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 05:39:49 -0400
Subject: [PATCH 1/2] ath6kl: refactor wmi scan command
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 12 Jul 2012 12:39:44 +0300
Message-ID: <20120712093944.9976.84585.stgit@localhost6.localdomain6> (sfid-20120712_113953_747997_3054A784)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX was checked in cfg80211.c which is
a bit awkward when adding more callsites to the scan functions. Refactor
the code to wmi.c so that it's transparent to the callers.

Even though the patch looks scary there are no functional changes. I
just had to move ath6kl_wmi_startscan_cmd() before
ath6kl_wmi_beginscan_cmd() which confuses patch.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   31 ++------
 drivers/net/wireless/ath/ath6kl/wmi.c      |  107 ++++++++++++++++------------
 drivers/net/wireless/ath/ath6kl/wmi.h      |    5 -
 3 files changed, 69 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index ca54154..991c7c5 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1031,30 +1031,15 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 
 	vif->scan_req = request;
 
-	if (test_bit(ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
-		     ar->fw_capabilities)) {
-		/*
-		 * If capable of doing P2P mgmt operations using
-		 * station interface, send additional information like
-		 * supported rates to advertise and xmit rates for
-		 * probe requests
-		 */
-		ret = ath6kl_wmi_beginscan_cmd(ar->wmi, vif->fw_vif_idx,
-						WMI_LONG_SCAN, force_fg_scan,
-						false, 0,
-						ATH6KL_FG_SCAN_INTERVAL,
-						n_channels, channels,
-						request->no_cck,
-						request->rates);
-	} else {
-		ret = ath6kl_wmi_startscan_cmd(ar->wmi, vif->fw_vif_idx,
-						WMI_LONG_SCAN, force_fg_scan,
-						false, 0,
-						ATH6KL_FG_SCAN_INTERVAL,
-						n_channels, channels);
-	}
+	ret = ath6kl_wmi_beginscan_cmd(ar->wmi, vif->fw_vif_idx,
+				       WMI_LONG_SCAN, force_fg_scan,
+				       false, 0,
+				       ATH6KL_FG_SCAN_INTERVAL,
+				       n_channels, channels,
+				       request->no_cck,
+				       request->rates);
 	if (ret) {
-		ath6kl_err("wmi_startscan_cmd failed\n");
+		ath6kl_err("failed to start scan: %d\n", ret);
 		vif->scan_req = NULL;
 	}
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 3629e86..675a38d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1851,22 +1851,23 @@ int ath6kl_wmi_disconnect_cmd(struct wmi *wmi, u8 if_idx)
 	return ret;
 }
 
-int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
-			     enum wmi_scan_type scan_type,
-			     u32 force_fgscan, u32 is_legacy,
-			     u32 home_dwell_time, u32 force_scan_interval,
-			     s8 num_chan, u16 *ch_list, u32 no_cck, u32 *rates)
+/* ath6kl_wmi_start_scan_cmd is to be deprecated. Use
+ * ath6kl_wmi_begin_scan_cmd instead. The new function supports P2P
+ * mgmt operations using station interface.
+ */
+static int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
+				    enum wmi_scan_type scan_type,
+				    u32 force_fgscan, u32 is_legacy,
+				    u32 home_dwell_time,
+				    u32 force_scan_interval,
+				    s8 num_chan, u16 *ch_list)
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
@@ -1881,59 +1882,53 @@ int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
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
+/*
+ * beginscan supports (compared to old startscan) P2P mgmt operations using
+ * station interface, send additional information like supported rates to
+ * advertise and xmit rates for probe requests
  */
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
+	if (!test_bit(ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
+		      ar->fw_capabilities)) {
+		return ath6kl_wmi_startscan_cmd(wmi, if_idx,
+						scan_type, force_fgscan,
+						is_legacy, home_dwell_time,
+						force_scan_interval,
+						num_chan, ch_list);
+	}
+
+	size = sizeof(struct wmi_begin_scan_cmd);
 
 	if ((scan_type != WMI_LONG_SCAN) && (scan_type != WMI_SHORT_SCAN))
 		return -EINVAL;
@@ -1948,18 +1943,38 @@ int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
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
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index b5deaff..2491436 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2514,11 +2514,6 @@ int ath6kl_wmi_connect_cmd(struct wmi *wmi, u8 if_idx,
 int ath6kl_wmi_reconnect_cmd(struct wmi *wmi, u8 if_idx, u8 *bssid,
 			     u16 channel);
 int ath6kl_wmi_disconnect_cmd(struct wmi *wmi, u8 if_idx);
-int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
-			     enum wmi_scan_type scan_type,
-			     u32 force_fgscan, u32 is_legacy,
-			     u32 home_dwell_time, u32 force_scan_interval,
-			     s8 num_chan, u16 *ch_list);
 
 int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
 			     enum wmi_scan_type scan_type,

