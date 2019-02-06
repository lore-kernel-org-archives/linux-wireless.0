Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA24C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 952F4217F9
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TkZcvPjW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbfBFL20 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:28:26 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45913 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfBFL20 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:28:26 -0500
Received: by mail-lf1-f67.google.com with SMTP id b20so5026540lfa.12
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2019 03:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3cxQBsay+EAxNnBh7AuFelAo74YNlL8RBa+DYXtFgxc=;
        b=TkZcvPjWWlBKExOg5t07Va37hMGCb0tAkK7bXsD1LbEuTFVj/QEIWUMYDICndt55tJ
         fPkH67FuTGIei6vD6eiUG0PoWOuXR4JBMu791zxYW/Wogv34DW7SIF1941uMuLwfW8+k
         80hsM9ZpaBf1Orxe42afiOLT4rZiJdrkE3F6bj8x7yiCI7mAJNdGKHj7yTHe302lDxA3
         cIbi4ndewqouO2CXU0PJFv7RQuzJePbnlKwchBb/MzaNpvXVmMfsnudGmgrVQqsZM64o
         2cckJQkw8C9OjdOSsVPHorHfzfl4rXLEvP+pfZsy9b/l0YlDIG2svFljhVwuRMVQL05m
         V+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3cxQBsay+EAxNnBh7AuFelAo74YNlL8RBa+DYXtFgxc=;
        b=A2JYkEM+jHIIoCNmQyrBUtJHWOcpLyqBaG2jmXYTuLXkWDnM18ia/ggEiSL7dU01rX
         RjAah3JuPSYr3BydDV/A++M/YEXOgWf2VzFPZtTZ9MzcBYQweBCOParmyTAW/YBnoQ2s
         9UvCODiGmGievD7YyAa7I7lR4Fo7eWI5gWLDEeQ/U8E+DO6mjeK03WVBykumqEy7WbeO
         Q8yP/5qvekNVC8Ql+0CUGPjRaAG7yEkUKe4EjpSvmPqX7ltrbNKccH7lk5z8WhCDS8Am
         ryveoDJEUGZwPk0p7G05Jvi26bTiDOtraT20Ff6hFemn2TX+walYt4cIXmdKoiGzPeBs
         8tLw==
X-Gm-Message-State: AHQUAuZu2UdCjJmegtSRIy6DFV86lZem5rjSjdyv8NYHdXIdhW+WL2PN
        2rMKVZf8KDPkkbQx/fIvciI=
X-Google-Smtp-Source: AHgI3IYgcQVizC2m1E+/RdenqXdx/opc2ztPwH5+llryVFhsJ5Ge6oI30nFVLnafsDkI8VE5tU4PEw==
X-Received: by 2002:a19:6806:: with SMTP id d6mr6314586lfc.48.1549452503188;
        Wed, 06 Feb 2019 03:28:23 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id h22-v6sm4111894lji.45.2019.02.06.03.28.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 03:28:22 -0800 (PST)
From:   "=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?=" <rafal.milecki@gmail.com>
X-Google-Original-From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V3 1/2] brcmfmac: modify __brcmf_err() to take bus as a parameter
Date:   Wed,  6 Feb 2019 12:28:15 +0100
Message-Id: <20190206112816.563-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

So far __brcmf_err() was using pr_err() which didn't allow identifying
device that was affected by an error. It's crucial for systems with more
than 1 device supported by brcmfmac (a common case for home routers).

This change allows passing struct brcmf_bus to the __brcmf_err(). That
struct has been agreed to be the most common one. It allows accessing
struct device easily & using dev_err() printing helper.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
V2: Add missing #include <linux/device.h>
V3: Add #include "bus.h" to fix CONFIG_BRCM_TRACING=y compilation error:
    error: dereferencing pointer to incomplete type 'struct brcmf_bus'
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/common.c    | 7 +++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 8 +++++---
 .../wireless/broadcom/brcm80211/brcmfmac/tracepoint.c    | 9 +++++++--
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 0ce1d8174e6d..c62009a06617 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -350,7 +350,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 }
 
 #ifndef CONFIG_BRCM_TRACING
-void __brcmf_err(const char *func, const char *fmt, ...)
+void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -359,7 +359,10 @@ void __brcmf_err(const char *func, const char *fmt, ...)
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	pr_err("%s: %pV", func, &vaf);
+	if (bus)
+		dev_err(bus->dev, "%s: %pV", func, &vaf);
+	else
+		pr_err("%s: %pV", func, &vaf);
 
 	va_end(args);
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index cfed0626bf5a..b499f90d94f6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -45,8 +45,10 @@
 #undef pr_fmt
 #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
 
-__printf(2, 3)
-void __brcmf_err(const char *func, const char *fmt, ...);
+struct brcmf_bus;
+
+__printf(3, 4)
+void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...);
 /* Macro for error messages. When debugging / tracing the driver all error
  * messages are important to us.
  */
@@ -55,7 +57,7 @@ void __brcmf_err(const char *func, const char *fmt, ...);
 		if (IS_ENABLED(CONFIG_BRCMDBG) ||			\
 		    IS_ENABLED(CONFIG_BRCM_TRACING) ||			\
 		    net_ratelimit())					\
-			__brcmf_err(__func__, fmt, ##__VA_ARGS__);	\
+			__brcmf_err(NULL, __func__, fmt, ##__VA_ARGS__);\
 	} while (0)
 
 #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
index fe6755944b7b..a5c271bff446 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
@@ -14,14 +14,16 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/device.h>
 #include <linux/module.h> /* bug in tracepoint.h, it should include this */
 
 #ifndef __CHECKER__
 #define CREATE_TRACE_POINTS
+#include "bus.h"
 #include "tracepoint.h"
 #include "debug.h"
 
-void __brcmf_err(const char *func, const char *fmt, ...)
+void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...)
 {
 	struct va_format vaf = {
 		.fmt = fmt,
@@ -30,7 +32,10 @@ void __brcmf_err(const char *func, const char *fmt, ...)
 
 	va_start(args, fmt);
 	vaf.va = &args;
-	pr_err("%s: %pV", func, &vaf);
+	if (bus)
+		dev_err(bus->dev, "%s: %pV", func, &vaf);
+	else
+		pr_err("%s: %pV", func, &vaf);
 	trace_brcmf_err(func, &vaf);
 	va_end(args);
 }
-- 
2.20.1

