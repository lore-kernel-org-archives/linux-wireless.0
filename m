Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:53647 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbbKYKcx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 05:32:53 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/11] brcmfmac: Make 5G join preference configurable.
Date: Wed, 25 Nov 2015 11:32:44 +0100
Message-ID: <1448447567-12189-9-git-send-email-arend@broadcom.com> (sfid-20151125_113309_671311_0B12771F)
In-Reply-To: <1448447567-12189-1-git-send-email-arend@broadcom.com>
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

By default the 5G band has an advantage of 8 dBm on the RSSI when
it comes to selection during join and roam. This patch adds a
module param to make this value configurable. Using the value 99
results in configuration that 5G has always preference over 2.4G.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 31 +++++++++++++++++-----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 474de11..6bc0ae9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/netdevice.h>
 #include <brcmu_wifi.h>
@@ -32,8 +33,18 @@ const u8 ALLFFMAC[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 #define BRCMF_DEFAULT_SCAN_CHANNEL_TIME	40
 #define BRCMF_DEFAULT_SCAN_UNASSOC_TIME	40
 
-/* boost value for RSSI_DELTA in preferred join selection */
+/* default boost value for RSSI_DELTA in preferred join selection */
 #define BRCMF_JOIN_PREF_RSSI_BOOST	8
+#define BRCMF_RSSI_BOOST_IS_5G		99
+
+/* Module param joinboost_5g used for preferred join selection.
+ * Use value 99 to configure preferred join to choose 5G always over 2.4G, any
+ * other value configures the advantage of 5G signal strength over 2.4G signal
+ * strength.
+ */
+static int brcmf_joinboost_5g_rssi = BRCMF_JOIN_PREF_RSSI_BOOST;
+module_param_named(joinboost_5g, brcmf_joinboost_5g_rssi, int, 0);
+MODULE_PARM_DESC(joinboost_5g, "Join preference 5G RSSI boost");
 
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 {
@@ -106,11 +117,19 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		goto done;
 	}
 
-	/* Setup join_pref to select target by RSSI(with boost on 5GHz) */
-	join_pref_params[0].type = BRCMF_JOIN_PREF_RSSI_DELTA;
-	join_pref_params[0].len = 2;
-	join_pref_params[0].rssi_gain = BRCMF_JOIN_PREF_RSSI_BOOST;
-	join_pref_params[0].band = WLC_BAND_5G;
+	if (brcmf_joinboost_5g_rssi == BRCMF_RSSI_BOOST_IS_5G) {
+		/* Setup join_pref to select 5GHz over 2.4Ghz */
+		join_pref_params[0].type = BRCMF_JOIN_PREF_BAND;
+		join_pref_params[0].len = 2;
+		join_pref_params[0].rssi_gain = 0;
+		join_pref_params[0].band = WLC_BAND_5G;
+	} else {
+		/* Setup join_pref to select target by RSSI (boost on 5GHz) */
+		join_pref_params[0].type = BRCMF_JOIN_PREF_RSSI_DELTA;
+		join_pref_params[0].len = 2;
+		join_pref_params[0].rssi_gain = brcmf_joinboost_5g_rssi;
+		join_pref_params[0].band = WLC_BAND_5G;
+	}
 	join_pref_params[1].type = BRCMF_JOIN_PREF_RSSI;
 	join_pref_params[1].len = 2;
 	join_pref_params[1].rssi_gain = 0;
-- 
1.9.1

