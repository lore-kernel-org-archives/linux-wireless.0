Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:59292 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2GSNAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 09:00:53 -0400
Subject: [PATCH v2 2/3] ath6kl: refactor wmi scan command
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 19 Jul 2012 16:00:48 +0300
Message-ID: <20120719130048.22047.69322.stgit@x201> (sfid-20120719_150055_679889_43AD9771)
In-Reply-To: <20120719125937.22047.91375.stgit@x201>
References: <20120719125937.22047.91375.stgit@x201>
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
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   31 +++++++---------------------
 drivers/net/wireless/ath/ath6kl/wmi.c      |   25 ++++++++++++++++++-----
 drivers/net/wireless/ath/ath6kl/wmi.h      |    5 -----
 3 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 4eeb066..0c3e65e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1031,30 +1031,15 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy,
 
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
index a9d7e00..05cc871 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1899,11 +1899,12 @@ int ath6kl_wmi_disconnect_cmd(struct wmi *wmi, u8 if_idx)
  * ath6kl_wmi_begin_scan_cmd instead. The new function supports P2P
  * mgmt operations using station interface.
  */
-int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
-			     enum wmi_scan_type scan_type,
-			     u32 force_fgscan, u32 is_legacy,
-			     u32 home_dwell_time, u32 force_scan_interval,
-			     s8 num_chan, u16 *ch_list)
+static int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
+				    enum wmi_scan_type scan_type,
+				    u32 force_fgscan, u32 is_legacy,
+				    u32 home_dwell_time,
+				    u32 force_scan_interval,
+				    s8 num_chan, u16 *ch_list)
 {
 	struct sk_buff *skb;
 	struct wmi_start_scan_cmd *sc;
@@ -1942,6 +1943,11 @@ int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
 	return ret;
 }
 
+/*
+ * beginscan supports (compared to old startscan) P2P mgmt operations using
+ * station interface, send additional information like supported rates to
+ * advertise and xmit rates for probe requests
+ */
 int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
 			     enum wmi_scan_type scan_type,
 			     u32 force_fgscan, u32 is_legacy,
@@ -1957,6 +1963,15 @@ int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
 	int num_rates;
 	u32 ratemask;
 
+	if (!test_bit(ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
+		      ar->fw_capabilities)) {
+		return ath6kl_wmi_startscan_cmd(wmi, if_idx,
+						scan_type, force_fgscan,
+						is_legacy, home_dwell_time,
+						force_scan_interval,
+						num_chan, ch_list);
+	}
+
 	size = sizeof(struct wmi_begin_scan_cmd);
 
 	if ((scan_type != WMI_LONG_SCAN) && (scan_type != WMI_SHORT_SCAN))
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 8e8846f..5166a8e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2547,11 +2547,6 @@ int ath6kl_wmi_connect_cmd(struct wmi *wmi, u8 if_idx,
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

