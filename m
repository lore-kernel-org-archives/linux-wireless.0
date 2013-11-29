Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4235 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab3K2LZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/19] brcmfmac: move firmware command code definitions
Date: Fri, 29 Nov 2013 12:25:20 +0100
Message-ID: <1385724324-6361-16-git-send-email-arend@broadcom.com> (sfid-20131129_123808_481745_51D69742)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the command codes to the firmware interface module as
that makes a bit more sense.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h  |   61 ------------------------
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h |   61 ++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 7806155..a85f9db 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -25,67 +25,6 @@
 
 #include "fweh.h"
 
-/*******************************************************************************
- * IO codes that are interpreted by dongle firmware
- ******************************************************************************/
-#define BRCMF_C_GET_VERSION			1
-#define BRCMF_C_UP				2
-#define BRCMF_C_DOWN				3
-#define BRCMF_C_SET_PROMISC			10
-#define BRCMF_C_GET_RATE			12
-#define BRCMF_C_GET_INFRA			19
-#define BRCMF_C_SET_INFRA			20
-#define BRCMF_C_GET_AUTH			21
-#define BRCMF_C_SET_AUTH			22
-#define BRCMF_C_GET_BSSID			23
-#define BRCMF_C_GET_SSID			25
-#define BRCMF_C_SET_SSID			26
-#define BRCMF_C_TERMINATED			28
-#define BRCMF_C_GET_CHANNEL			29
-#define BRCMF_C_SET_CHANNEL			30
-#define BRCMF_C_GET_SRL				31
-#define BRCMF_C_SET_SRL				32
-#define BRCMF_C_GET_LRL				33
-#define BRCMF_C_SET_LRL				34
-#define BRCMF_C_GET_RADIO			37
-#define BRCMF_C_SET_RADIO			38
-#define BRCMF_C_GET_PHYTYPE			39
-#define BRCMF_C_SET_KEY				45
-#define BRCMF_C_SET_PASSIVE_SCAN		49
-#define BRCMF_C_SCAN				50
-#define BRCMF_C_SCAN_RESULTS			51
-#define BRCMF_C_DISASSOC			52
-#define BRCMF_C_REASSOC				53
-#define BRCMF_C_SET_ROAM_TRIGGER		55
-#define BRCMF_C_SET_ROAM_DELTA			57
-#define BRCMF_C_GET_BCNPRD			75
-#define BRCMF_C_SET_BCNPRD			76
-#define BRCMF_C_GET_DTIMPRD			77
-#define BRCMF_C_SET_DTIMPRD			78
-#define BRCMF_C_SET_COUNTRY			84
-#define BRCMF_C_GET_PM				85
-#define BRCMF_C_SET_PM				86
-#define BRCMF_C_GET_CURR_RATESET		114
-#define BRCMF_C_GET_AP				117
-#define BRCMF_C_SET_AP				118
-#define BRCMF_C_GET_RSSI			127
-#define BRCMF_C_GET_WSEC			133
-#define BRCMF_C_SET_WSEC			134
-#define BRCMF_C_GET_PHY_NOISE			135
-#define BRCMF_C_GET_BSS_INFO			136
-#define BRCMF_C_GET_BANDLIST			140
-#define BRCMF_C_SET_SCB_TIMEOUT			158
-#define BRCMF_C_GET_PHYLIST			180
-#define BRCMF_C_SET_SCAN_CHANNEL_TIME		185
-#define BRCMF_C_SET_SCAN_UNASSOC_TIME		187
-#define BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON	201
-#define BRCMF_C_GET_VALID_CHANNELS		217
-#define BRCMF_C_GET_KEY_PRIMARY			235
-#define BRCMF_C_SET_KEY_PRIMARY			236
-#define BRCMF_C_SET_SCAN_PASSIVE_TIME		258
-#define BRCMF_C_GET_VAR				262
-#define BRCMF_C_SET_VAR				263
-
 /* phy types (returned by WLC_GET_PHYTPE) */
 #define	WLC_PHY_TYPE_A		0
 #define	WLC_PHY_TYPE_B		1
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
index 16eb820..77eae86 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
@@ -17,6 +17,67 @@
 #ifndef _fwil_h_
 #define _fwil_h_
 
+/*******************************************************************************
+ * Dongle command codes that are interpreted by firmware
+ ******************************************************************************/
+#define BRCMF_C_GET_VERSION			1
+#define BRCMF_C_UP				2
+#define BRCMF_C_DOWN				3
+#define BRCMF_C_SET_PROMISC			10
+#define BRCMF_C_GET_RATE			12
+#define BRCMF_C_GET_INFRA			19
+#define BRCMF_C_SET_INFRA			20
+#define BRCMF_C_GET_AUTH			21
+#define BRCMF_C_SET_AUTH			22
+#define BRCMF_C_GET_BSSID			23
+#define BRCMF_C_GET_SSID			25
+#define BRCMF_C_SET_SSID			26
+#define BRCMF_C_TERMINATED			28
+#define BRCMF_C_GET_CHANNEL			29
+#define BRCMF_C_SET_CHANNEL			30
+#define BRCMF_C_GET_SRL				31
+#define BRCMF_C_SET_SRL				32
+#define BRCMF_C_GET_LRL				33
+#define BRCMF_C_SET_LRL				34
+#define BRCMF_C_GET_RADIO			37
+#define BRCMF_C_SET_RADIO			38
+#define BRCMF_C_GET_PHYTYPE			39
+#define BRCMF_C_SET_KEY				45
+#define BRCMF_C_SET_PASSIVE_SCAN		49
+#define BRCMF_C_SCAN				50
+#define BRCMF_C_SCAN_RESULTS			51
+#define BRCMF_C_DISASSOC			52
+#define BRCMF_C_REASSOC				53
+#define BRCMF_C_SET_ROAM_TRIGGER		55
+#define BRCMF_C_SET_ROAM_DELTA			57
+#define BRCMF_C_GET_BCNPRD			75
+#define BRCMF_C_SET_BCNPRD			76
+#define BRCMF_C_GET_DTIMPRD			77
+#define BRCMF_C_SET_DTIMPRD			78
+#define BRCMF_C_SET_COUNTRY			84
+#define BRCMF_C_GET_PM				85
+#define BRCMF_C_SET_PM				86
+#define BRCMF_C_GET_CURR_RATESET		114
+#define BRCMF_C_GET_AP				117
+#define BRCMF_C_SET_AP				118
+#define BRCMF_C_GET_RSSI			127
+#define BRCMF_C_GET_WSEC			133
+#define BRCMF_C_SET_WSEC			134
+#define BRCMF_C_GET_PHY_NOISE			135
+#define BRCMF_C_GET_BSS_INFO			136
+#define BRCMF_C_GET_BANDLIST			140
+#define BRCMF_C_SET_SCB_TIMEOUT			158
+#define BRCMF_C_GET_PHYLIST			180
+#define BRCMF_C_SET_SCAN_CHANNEL_TIME		185
+#define BRCMF_C_SET_SCAN_UNASSOC_TIME		187
+#define BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON	201
+#define BRCMF_C_GET_VALID_CHANNELS		217
+#define BRCMF_C_GET_KEY_PRIMARY			235
+#define BRCMF_C_SET_KEY_PRIMARY			236
+#define BRCMF_C_SET_SCAN_PASSIVE_TIME		258
+#define BRCMF_C_GET_VAR				262
+#define BRCMF_C_SET_VAR				263
+
 s32 brcmf_fil_cmd_data_set(struct brcmf_if *ifp, u32 cmd, void *data, u32 len);
 s32 brcmf_fil_cmd_data_get(struct brcmf_if *ifp, u32 cmd, void *data, u32 len);
 s32 brcmf_fil_cmd_int_set(struct brcmf_if *ifp, u32 cmd, u32 data);
-- 
1.7.10.4


