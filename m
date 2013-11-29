Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2263 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931Ab3K2LZl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:41 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 18/19] brcmfmac: move firmware event related defines to
 fweh.h
Date: Fri, 29 Nov 2013 12:25:23 +0100
Message-ID: <1385724324-6361-19-git-send-email-arend@broadcom.com> (sfid-20131129_122552_513499_DB493694)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The dhd.h file contained a number of definitions that are
related to events received from the firmware. Those are
processed and dispatched in the driver by fweh. Hence the
definitions are moved to its include file.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h  |   49 ---------------------
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h |   54 ++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index da5cf00..252024b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -33,47 +33,6 @@
 
 #define DOT11_MAX_DEFAULT_KEYS	4
 
-#define BRCMF_E_STATUS_SUCCESS			0
-#define BRCMF_E_STATUS_FAIL			1
-#define BRCMF_E_STATUS_TIMEOUT			2
-#define BRCMF_E_STATUS_NO_NETWORKS		3
-#define BRCMF_E_STATUS_ABORT			4
-#define BRCMF_E_STATUS_NO_ACK			5
-#define BRCMF_E_STATUS_UNSOLICITED		6
-#define BRCMF_E_STATUS_ATTEMPT			7
-#define BRCMF_E_STATUS_PARTIAL			8
-#define BRCMF_E_STATUS_NEWSCAN			9
-#define BRCMF_E_STATUS_NEWASSOC			10
-#define BRCMF_E_STATUS_11HQUIET			11
-#define BRCMF_E_STATUS_SUPPRESS			12
-#define BRCMF_E_STATUS_NOCHANS			13
-#define BRCMF_E_STATUS_CS_ABORT			15
-#define BRCMF_E_STATUS_ERROR			16
-
-#define BRCMF_E_REASON_INITIAL_ASSOC		0
-#define BRCMF_E_REASON_LOW_RSSI			1
-#define BRCMF_E_REASON_DEAUTH			2
-#define BRCMF_E_REASON_DISASSOC			3
-#define BRCMF_E_REASON_BCNS_LOST		4
-#define BRCMF_E_REASON_MINTXRATE		9
-#define BRCMF_E_REASON_TXFAIL			10
-
-#define BRCMF_E_REASON_LINK_BSSCFG_DIS		4
-#define BRCMF_E_REASON_FAST_ROAM_FAILED		5
-#define BRCMF_E_REASON_DIRECTED_ROAM		6
-#define BRCMF_E_REASON_TSPEC_REJECTED		7
-#define BRCMF_E_REASON_BETTER_AP		8
-
-#define BRCMF_E_IF_ADD				1
-#define BRCMF_E_IF_DEL				2
-#define BRCMF_E_IF_CHANGE			3
-
-#define BRCMF_E_IF_FLAG_NOIF			1
-
-#define BRCMF_E_IF_ROLE_STA			0
-#define BRCMF_E_IF_ROLE_AP			1
-#define BRCMF_E_IF_ROLE_WDS			2
-
 /* Small, medium and maximum buffer size for dcmd
  */
 #define BRCMF_DCMD_SMLEN	256
@@ -156,14 +115,6 @@ struct brcmf_pub {
 #endif
 };
 
-struct brcmf_if_event {
-	u8 ifidx;
-	u8 action;
-	u8 flags;
-	u8 bssidx;
-	u8 role;
-};
-
 /* forward declarations */
 struct brcmf_cfg80211_vif;
 struct brcmf_fws_mac_descriptor;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
index 14bc24d..51b53a7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -122,6 +122,52 @@ enum brcmf_fweh_event_code {
 #define BRCMF_EVENT_MSG_FLUSHTXQ	0x02
 #define BRCMF_EVENT_MSG_GROUP		0x04
 
+/* status field values in struct brcmf_event_msg */
+#define BRCMF_E_STATUS_SUCCESS			0
+#define BRCMF_E_STATUS_FAIL			1
+#define BRCMF_E_STATUS_TIMEOUT			2
+#define BRCMF_E_STATUS_NO_NETWORKS		3
+#define BRCMF_E_STATUS_ABORT			4
+#define BRCMF_E_STATUS_NO_ACK			5
+#define BRCMF_E_STATUS_UNSOLICITED		6
+#define BRCMF_E_STATUS_ATTEMPT			7
+#define BRCMF_E_STATUS_PARTIAL			8
+#define BRCMF_E_STATUS_NEWSCAN			9
+#define BRCMF_E_STATUS_NEWASSOC			10
+#define BRCMF_E_STATUS_11HQUIET			11
+#define BRCMF_E_STATUS_SUPPRESS			12
+#define BRCMF_E_STATUS_NOCHANS			13
+#define BRCMF_E_STATUS_CS_ABORT			15
+#define BRCMF_E_STATUS_ERROR			16
+
+/* reason field values in struct brcmf_event_msg */
+#define BRCMF_E_REASON_INITIAL_ASSOC		0
+#define BRCMF_E_REASON_LOW_RSSI			1
+#define BRCMF_E_REASON_DEAUTH			2
+#define BRCMF_E_REASON_DISASSOC			3
+#define BRCMF_E_REASON_BCNS_LOST		4
+#define BRCMF_E_REASON_MINTXRATE		9
+#define BRCMF_E_REASON_TXFAIL			10
+
+#define BRCMF_E_REASON_LINK_BSSCFG_DIS		4
+#define BRCMF_E_REASON_FAST_ROAM_FAILED		5
+#define BRCMF_E_REASON_DIRECTED_ROAM		6
+#define BRCMF_E_REASON_TSPEC_REJECTED		7
+#define BRCMF_E_REASON_BETTER_AP		8
+
+/* action field values for brcmf_ifevent */
+#define BRCMF_E_IF_ADD				1
+#define BRCMF_E_IF_DEL				2
+#define BRCMF_E_IF_CHANGE			3
+
+/* flag field values for brcmf_ifevent */
+#define BRCMF_E_IF_FLAG_NOIF			1
+
+/* role field values for brcmf_ifevent */
+#define BRCMF_E_IF_ROLE_STA			0
+#define BRCMF_E_IF_ROLE_AP			1
+#define BRCMF_E_IF_ROLE_WDS			2
+
 /**
  * definitions for event packet validation.
  */
@@ -160,6 +206,14 @@ struct brcmf_event_msg {
 	u8 bsscfgidx;
 };
 
+struct brcmf_if_event {
+	u8 ifidx;
+	u8 action;
+	u8 flags;
+	u8 bssidx;
+	u8 role;
+};
+
 typedef int (*brcmf_fweh_handler_t)(struct brcmf_if *ifp,
 				    const struct brcmf_event_msg *evtmsg,
 				    void *data);
-- 
1.7.10.4


