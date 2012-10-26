Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34544 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290Ab2JZOYC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:24:02 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 06/18] brcm80211: Convert log message levels to debug levels
Date: Fri, 26 Oct 2012 09:23:21 -0500
Message-Id: <1351261413-20821-7-git-send-email-seth.forshee@canonical.com> (sfid-20121026_162408_742469_A673480A)
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for enhancements to debug and trace support, convert the
message levels to debug levels which will be used for enabling
categories of debug messages. The two message levels are little-used
anyway and are combined into the BRCM_DL_INFO debug level.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c  |    4 ++--
 drivers/net/wireless/brcm80211/brcmsmac/types.h |    2 +-
 drivers/net/wireless/brcm80211/include/defs.h   |    5 ++---
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index ba6dbf4..a59954f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -926,7 +926,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			wiphy_err(wiphy, "%s: ampdu tx phy error (0x%x)\n",
 				  __func__, txs->phyerr);
 
-			if (brcm_have_debug_level(LOG_ERROR_VAL)) {
+			if (brcm_have_debug_level(BRCM_DL_INFO)) {
 				brcmu_prpkt("txpkt (AMPDU)", p);
 				brcms_c_print_txdesc((struct d11txh *) p->data);
 			}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 5edd84b..0df2d65 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -287,7 +287,7 @@ struct edcf_acparam {
 /* debug/trace */
 uint brcm_msg_level =
 #if defined(DEBUG)
-	LOG_ERROR_VAL;
+	BRCM_DL_INFO;
 #else
 	0;
 #endif				/* DEBUG */
@@ -908,7 +908,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	mcl = le16_to_cpu(txh->MacTxControlLow);
 
 	if (txs->phyerr) {
-		if (brcm_have_debug_level(LOG_ERROR_VAL)) {
+		if (brcm_have_debug_level(BRCM_DL_INFO)) {
 			wiphy_err(wlc->wiphy, "phyerr 0x%x, rate 0x%x\n",
 				  txs->phyerr, txh->MainRates);
 			brcms_c_print_txdesc(txh);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/types.h b/drivers/net/wireless/brcm80211/brcmsmac/types.h
index a6c91f3..079ca73 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/types.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/types.h
@@ -248,7 +248,7 @@
 
 #define BCMMSG(dev, fmt, args...)		\
 do {						\
-	if (brcm_have_debug_level(LOG_TRACE_VAL))		\
+	if (brcm_have_debug_level(BRCM_DL_INFO))		\
 		wiphy_err(dev, "%s: " fmt, __func__, ##args);	\
 } while (0)
 
diff --git a/drivers/net/wireless/brcm80211/include/defs.h b/drivers/net/wireless/brcm80211/include/defs.h
index 4652d3c..223eb2b 100644
--- a/drivers/net/wireless/brcm80211/include/defs.h
+++ b/drivers/net/wireless/brcm80211/include/defs.h
@@ -78,9 +78,8 @@
 #define PM_OFF	0
 #define PM_MAX	1
 
-/* Message levels */
-#define LOG_ERROR_VAL	0x00000001
-#define LOG_TRACE_VAL	0x00000002
+/* Debug levels */
+#define BRCM_DL_INFO		0x00000001
 
 #define PM_OFF	0
 #define PM_MAX	1
-- 
1.7.9.5

