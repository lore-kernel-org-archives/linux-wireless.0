Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40886 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753290AbdCHOBD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 09:01:03 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v3 1/3] brcmfmac: Do not print the firmware version as an error
Date: Wed,  8 Mar 2017 14:50:15 +0100
Message-Id: <20170308135017.29867-1-hdegoede@redhat.com> (sfid-20170308_150136_643223_347CCE06)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using pr_err for things which are not errors is a bad idea. E.g. it
will cause the plymouth bootsplash screen to drop back to the text
console so that the user can see the error, which is not what we
normally want to happen.

Instead add a new brcmf_info macro and use that.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Fix brcm_err typo (should be brcmf_err) in CONFIG_BRCM_TRACING case
Changes in v3:
-Use do { } while (0) around macro
-Rebase on top of v4.11-rc1
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h  | 9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 33b133f..7a2b495 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -161,7 +161,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	strsep(&ptr, "\n");
 
 	/* Print fw version info */
-	brcmf_err("Firmware version = %s\n", buf);
+	brcmf_info("Firmware version = %s\n", buf);
 
 	/* locate firmware version number for ethtool */
 	ptr = strrchr(buf, ' ') + 1;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 0661261..afb2436 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -59,6 +59,10 @@ void __brcmf_err(const char *func, const char *fmt, ...);
 	} while (0)
 
 #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
+
+/* For debug/tracing purposes treat info messages as errors */
+#define brcmf_info brcmf_err
+
 __printf(3, 4)
 void __brcmf_dbg(u32 level, const char *func, const char *fmt, ...);
 #define brcmf_dbg(level, fmt, ...)				\
@@ -77,6 +81,11 @@ do {								\
 
 #else /* defined(DEBUG) || defined(CONFIG_BRCM_TRACING) */
 
+#define brcmf_info(fmt, ...)						\
+	do {								\
+		pr_info("%s: " fmt, __func__, ##__VA_ARGS__);		\
+	} while (0)
+
 #define brcmf_dbg(level, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 
 #define BRCMF_DATA_ON()		0
-- 
2.9.3
