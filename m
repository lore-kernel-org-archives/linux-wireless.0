Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:10683 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbbLJMnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 07:43:22 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 12/13] brcmfmac: Move scheduled scan related interface layer structs
Date: Thu, 10 Dec 2015 13:43:11 +0100
Message-ID: <1449751392-32569-13-git-send-email-arend@broadcom.com> (sfid-20151210_134341_249214_14DA4A20)
In-Reply-To: <1449751392-32569-1-git-send-email-arend@broadcom.com>
References: <1449751392-32569-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

All interface layer related to scheduled scan are moved in
fwil_types.h

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         | 81 ----------------------
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 81 ++++++++++++++++++++++
 2 files changed, 81 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 397d41b..c17b6d5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -211,87 +211,6 @@ struct escan_info {
 };
 
 /**
- * struct brcmf_pno_param_le - PNO scan configuration parameters
- *
- * @version: PNO parameters version.
- * @scan_freq: scan frequency.
- * @lost_network_timeout: #sec. to declare discovered network as lost.
- * @flags: Bit field to control features of PFN such as sort criteria auto
- *	enable switch and background scan.
- * @rssi_margin: Margin to avoid jitter for choosing a PFN based on RSSI sort
- *	criteria.
- * @bestn: number of best networks in each scan.
- * @mscan: number of scans recorded.
- * @repeat: minimum number of scan intervals before scan frequency changes
- *	in adaptive scan.
- * @exp: exponent of 2 for maximum scan interval.
- * @slow_freq: slow scan period.
- */
-struct brcmf_pno_param_le {
-	__le32 version;
-	__le32 scan_freq;
-	__le32 lost_network_timeout;
-	__le16 flags;
-	__le16 rssi_margin;
-	u8 bestn;
-	u8 mscan;
-	u8 repeat;
-	u8 exp;
-	__le32 slow_freq;
-};
-
-/**
- * struct brcmf_pno_net_param_le - scan parameters per preferred network.
- *
- * @ssid: ssid name and its length.
- * @flags: bit2: hidden.
- * @infra: BSS vs IBSS.
- * @auth: Open vs Closed.
- * @wpa_auth: WPA type.
- * @wsec: wsec value.
- */
-struct brcmf_pno_net_param_le {
-	struct brcmf_ssid_le ssid;
-	__le32 flags;
-	__le32 infra;
-	__le32 auth;
-	__le32 wpa_auth;
-	__le32 wsec;
-};
-
-/**
- * struct brcmf_pno_net_info_le - information per found network.
- *
- * @bssid: BSS network identifier.
- * @channel: channel number only.
- * @SSID_len: length of ssid.
- * @SSID: ssid characters.
- * @RSSI: receive signal strength (in dBm).
- * @timestamp: age in seconds.
- */
-struct brcmf_pno_net_info_le {
-	u8 bssid[ETH_ALEN];
-	u8 channel;
-	u8 SSID_len;
-	u8 SSID[32];
-	__le16	RSSI;
-	__le16	timestamp;
-};
-
-/**
- * struct brcmf_pno_scanresults_le - result returned in PNO NET FOUND event.
- *
- * @version: PNO version identifier.
- * @status: indicates completion status of PNO scan.
- * @count: amount of brcmf_pno_net_info_le entries appended.
- */
-struct brcmf_pno_scanresults_le {
-	__le32 version;
-	__le32 status;
-	__le32 count;
-};
-
-/**
  * struct brcmf_cfg80211_vif_event - virtual interface event information.
  *
  * @vif_wq: waitqueue awaiting interface event from firmware.
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index e56eabc..94d34ad 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -670,4 +670,85 @@ struct brcmf_pmk_list_le {
 	struct brcmf_pmksa pmk[BRCMF_MAXPMKID];
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
 #endif /* FWIL_TYPES_H_ */
-- 
1.9.1

