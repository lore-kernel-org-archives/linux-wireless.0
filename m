Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34539 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290Ab2JZOX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:23:59 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 05/18] brcm80211: Add macro for checking if debug log levels are enabled
Date: Fri, 26 Oct 2012 09:23:20 -0500
Message-Id: <1351261413-20821-6-git-send-email-seth.forshee@canonical.com> (sfid-20121026_162403_985492_7E99BB87)
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c  |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/types.h |    4 +++-
 drivers/net/wireless/brcm80211/include/defs.h   |    4 ++--
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index bfb04ec..ba6dbf4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -926,7 +926,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			wiphy_err(wiphy, "%s: ampdu tx phy error (0x%x)\n",
 				  __func__, txs->phyerr);
 
-			if (brcm_msg_level & LOG_ERROR_VAL) {
+			if (brcm_have_debug_level(LOG_ERROR_VAL)) {
 				brcmu_prpkt("txpkt (AMPDU)", p);
 				brcms_c_print_txdesc((struct d11txh *) p->data);
 			}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 9b6b1e7..5edd84b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -908,7 +908,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	mcl = le16_to_cpu(txh->MacTxControlLow);
 
 	if (txs->phyerr) {
-		if (brcm_msg_level & LOG_ERROR_VAL) {
+		if (brcm_have_debug_level(LOG_ERROR_VAL)) {
 			wiphy_err(wlc->wiphy, "phyerr 0x%x, rate 0x%x\n",
 				  txs->phyerr, txh->MainRates);
 			brcms_c_print_txdesc(txh);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/types.h b/drivers/net/wireless/brcm80211/brcmsmac/types.h
index e3abc0e..a6c91f3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/types.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/types.h
@@ -244,9 +244,11 @@
  * ********************************************************************
  */
 
+#define brcm_have_debug_level(l) (brcm_msg_level & (l))
+
 #define BCMMSG(dev, fmt, args...)		\
 do {						\
-	if (brcm_msg_level & LOG_TRACE_VAL)	\
+	if (brcm_have_debug_level(LOG_TRACE_VAL))		\
 		wiphy_err(dev, "%s: " fmt, __func__, ##args);	\
 } while (0)
 
diff --git a/drivers/net/wireless/brcm80211/include/defs.h b/drivers/net/wireless/brcm80211/include/defs.h
index f0d8c04..4652d3c 100644
--- a/drivers/net/wireless/brcm80211/include/defs.h
+++ b/drivers/net/wireless/brcm80211/include/defs.h
@@ -79,8 +79,8 @@
 #define PM_MAX	1
 
 /* Message levels */
-#define LOG_ERROR_VAL		0x00000001
-#define LOG_TRACE_VAL		0x00000002
+#define LOG_ERROR_VAL	0x00000001
+#define LOG_TRACE_VAL	0x00000002
 
 #define PM_OFF	0
 #define PM_MAX	1
-- 
1.7.9.5

