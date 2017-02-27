Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42128 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751564AbdB0KJ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 05:09:29 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH 1/4] brcmfmac: Do not print the firmware version as an error
Date: Mon, 27 Feb 2017 11:01:37 +0100
Message-Id: <20170227100140.5190-2-hdegoede@redhat.com> (sfid-20170227_111006_348368_3916AB27)
In-Reply-To: <20170227100140.5190-1-hdegoede@redhat.com>
References: <20170227100140.5190-1-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using pr_err for things which are not errors is a bad idea. E.g. it
will cause the plymouth bootsplash screen to drop back to the text
console so that the user can see the error, which is not what we
normally want to happen.

Instead add a new brcmf_info macro and use that.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h  | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 3e15d64..6d565f1 100644
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
index 6687812..d0d8180 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -59,11 +59,14 @@
 			pr_err("%s: " fmt, __func__, ##__VA_ARGS__);	\
 	} while (0)
 #endif
+#define brcmf_info(fmt, ...)	pr_info("%s: " fmt, __func__, ##__VA_ARGS__)
 #else
 __printf(2, 3)
 void __brcmf_err(const char *func, const char *fmt, ...);
 #define brcmf_err(fmt, ...) \
 	__brcmf_err(__func__, fmt, ##__VA_ARGS__)
+/* For tracing purposes treat info messages as errors */
+#define brcmf_info brcm_err
 #endif
 
 #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
-- 
2.9.3
