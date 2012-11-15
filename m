Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58894 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767951Ab2KOOIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:36 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 10/22] brcm80211: Convert log message levels to debug levels
Date: Thu, 15 Nov 2012 08:08:00 -0600
Message-Id: <1352988492-21340-11-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150842_930535_BA365471)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for enhancements to debug and trace support, convert the
message levels to debug levels which will be used for enabling
categories of debug messages. The two message levels are little-used
anyway and are combined into the BRCM_DL_INFO debug level.

Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c  |    4 ++--
 drivers/net/wireless/brcm80211/brcmsmac/types.h |    2 +-
 drivers/net/wireless/brcm80211/include/defs.h   |    5 ++---
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index c62fd3d..93d4ecd 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -926,7 +926,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			wiphy_err(wiphy, "%s: ampdu tx phy error (0x%x)\n",
 				  __func__, txs->phyerr);
 
-			if (brcm_msg_level & LOG_ERROR_VAL) {
+			if (brcm_msg_level & BRCM_DL_INFO) {
 				brcmu_prpkt("txpkt (AMPDU)", p);
 				brcms_c_print_txdesc((struct d11txh *) p->data);
 			}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index ca93214..a5bf3b6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -281,7 +281,7 @@ struct edcf_acparam {
 /* debug/trace */
 uint brcm_msg_level =
 #if defined(DEBUG)
-	LOG_ERROR_VAL;
+	BRCM_DL_INFO;
 #else
 	0;
 #endif				/* DEBUG */
@@ -902,7 +902,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	mcl = le16_to_cpu(txh->MacTxControlLow);
 
 	if (txs->phyerr) {
-		if (brcm_msg_level & LOG_ERROR_VAL) {
+		if (brcm_msg_level & BRCM_DL_INFO) {
 			wiphy_err(wlc->wiphy, "phyerr 0x%x, rate 0x%x\n",
 				  txs->phyerr, txh->MainRates);
 			brcms_c_print_txdesc(txh);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/types.h b/drivers/net/wireless/brcm80211/brcmsmac/types.h
index e3abc0e..ae1f3ad 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/types.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/types.h
@@ -246,7 +246,7 @@
 
 #define BCMMSG(dev, fmt, args...)		\
 do {						\
-	if (brcm_msg_level & LOG_TRACE_VAL)	\
+	if (brcm_msg_level & BRCM_DL_INFO)	\
 		wiphy_err(dev, "%s: " fmt, __func__, ##args);	\
 } while (0)
 
diff --git a/drivers/net/wireless/brcm80211/include/defs.h b/drivers/net/wireless/brcm80211/include/defs.h
index f0d8c04..223eb2b 100644
--- a/drivers/net/wireless/brcm80211/include/defs.h
+++ b/drivers/net/wireless/brcm80211/include/defs.h
@@ -78,9 +78,8 @@
 #define PM_OFF	0
 #define PM_MAX	1
 
-/* Message levels */
-#define LOG_ERROR_VAL		0x00000001
-#define LOG_TRACE_VAL		0x00000002
+/* Debug levels */
+#define BRCM_DL_INFO		0x00000001
 
 #define PM_OFF	0
 #define PM_MAX	1
-- 
1.7.9.5

