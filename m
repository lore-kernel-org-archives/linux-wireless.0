Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33269 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbdBBMRS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 07:17:18 -0500
Received: by mail-lf0-f65.google.com with SMTP id x1so1239079lff.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2017 04:17:17 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 2/7] brcmfmac: add struct brcmf_pub parameter to the __brcmf_err
Date: Thu,  2 Feb 2017 13:16:54 +0100
Message-Id: <20170202121659.21130-2-zajec5@gmail.com> (sfid-20170202_131726_201488_3C180D08)
In-Reply-To: <20170202121659.21130-1-zajec5@gmail.com>
References: <20170202121659.21130-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This will allow getting struct device reference from the passed
brcmf_pub for the needs of dev_err. More detailed messages are really
important for home routers which frequently have 2 (or even 3) wireless
cards supported by brcmfmac.

Note that all calls are yet to be updated as for now brcmf_err macro
always passes NULL. This will be handled in following patch to make this
change easier to review.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Add missing include
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h        | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c     | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h      | 9 +++++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c | 4 +++-
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 76693df34742..35d4801a62e6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -17,6 +17,8 @@
 #ifndef BRCMFMAC_BUS_H
 #define BRCMFMAC_BUS_H
 
+#include <linux/device.h>
+
 #include "debug.h"
 
 /* IDs of the 6 default common rings of msgbuf protocol */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 05fb778ddd0f..0978fb4c9066 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -219,7 +219,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 }
 
 #ifndef CONFIG_BRCM_TRACING
-void __brcmf_err(const char *func, const char *fmt, ...)
+void __brcmf_err(struct brcmf_pub *pub, const char *func, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 5fef79473c87..012401e6be74 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -19,6 +19,8 @@
 
 #include <linux/net.h>	/* net_ratelimit() */
 
+struct brcmf_pub;
+
 /* message levels */
 #define BRCMF_TRACE_VAL		0x00000002
 #define BRCMF_INFO_VAL		0x00000004
@@ -45,10 +47,10 @@
 #undef pr_fmt
 #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
 
-__printf(2, 3)
-void __brcmf_err(const char *func, const char *fmt, ...);
+__printf(3, 4)
+void __brcmf_err(struct brcmf_pub *pub, const char *func, const char *fmt, ...);
 #define brcmf_err(fmt, ...) \
-	__brcmf_err(__func__, fmt, ##__VA_ARGS__)
+	__brcmf_err(NULL, __func__, fmt, ##__VA_ARGS__)
 
 #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
 __printf(3, 4)
@@ -91,7 +93,6 @@ do {									\
 
 extern int brcmf_msg_level;
 
-struct brcmf_pub;
 #ifdef DEBUG
 void brcmf_debugfs_init(void);
 void brcmf_debugfs_exit(void);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
index fe6755944b7b..329cb65eb78b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
@@ -18,10 +18,12 @@
 
 #ifndef __CHECKER__
 #define CREATE_TRACE_POINTS
+#include "bus.h"
+#include "core.h"
 #include "tracepoint.h"
 #include "debug.h"
 
-void __brcmf_err(const char *func, const char *fmt, ...)
+void __brcmf_err(struct brcmf_pub *pub, const char *func, const char *fmt, ...)
 {
 	struct va_format vaf = {
 		.fmt = fmt,
-- 
2.11.0
