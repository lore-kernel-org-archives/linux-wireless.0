Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEF0C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 12:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3733E20651
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 12:12:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JfPc4k+V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbfAOMMa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 07:12:30 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34788 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbfAOMMa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 07:12:30 -0500
Received: by mail-lj1-f196.google.com with SMTP id u89-v6so2128694lje.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 04:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cAnkh2iAjyQpMD926Txlu5FSN0h5bbGClZmi2OIBiz0=;
        b=JfPc4k+VmbqgJo7J0eMW7AsfByGTACOEhQgVgCf+MPLcKjaCHqMoz/IHAFRfyJ0xAc
         6L/qZkk3aNchPNzZsU7MixhaP6wj/3Z/EpsaQPLKfd1uECdq99UqMiuQuvtsRtWVJxlv
         e/m98Q/Yv51cHgZWeFRsgA6zV+eYn4LY3KAlff4tmjoJXQtcVoWqQYFQMJkTTJuU9D1R
         BROpD+OhV9B0BoEsMp597PSXTPBVsPLNkXiEOHohnwcFp2LD12QBRG0uDHPdU1PguKYl
         jvAsj14QnjgbPW+cCsuWJ3BvPyZxPtBPuBGhHqIcSpCHLl/B46BIsvaIP7bThFG61FDW
         wvzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cAnkh2iAjyQpMD926Txlu5FSN0h5bbGClZmi2OIBiz0=;
        b=aP+imV5dIo2U5KHOSXlQ55YrNgW4uC5wmXMBHtGXg6XYqB3V31BFQmGsTRq7oYZ4EX
         q96cEZnu63tqLh5jXnUPoJHQ/JvMDhTQK9gA2nPePPYQRYTJ6ZFo9i1UfLoT6AidiGEB
         86pd3TdAnGn1jaZtefSAisbma5FzJ1+Z4+q/DSn4PaWGyO/yN3+e9xoZQ40z0Rady4Kc
         dx4m43BEo/SHz/3HmfpGSt2bDt/X/UadCUpJSLNXOIdVB6Ff6cGEsPc7I3vFigfvDF/C
         bBgMEuFPBq7XZtlvGwHRvgbd8P61cd4WzxMTG6DhRQggYW9mtOlWJk0Puh3rNQz7D7Cw
         1x8A==
X-Gm-Message-State: AJcUukdcEdU22IrUgAse8peLZpdNYTGGq4KS7drwv6QEvBTvjf91h1Sa
        eq6JsjyuiP9BFABGj+AQiic=
X-Google-Smtp-Source: ALg8bN74R6ymhM5MA2DDYXg/d2vu69lf7nBZCUbgK288dB9ZmNs2WqQ7HC0LW0tSpgq3UndUyF0qWg==
X-Received: by 2002:a2e:6595:: with SMTP id e21-v6mr2703145ljf.123.1547554347585;
        Tue, 15 Jan 2019 04:12:27 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id d15-v6sm535282lja.38.2019.01.15.04.12.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 04:12:26 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 1/2] brcmfmac: modify __brcmf_err() to take bus as a parameter
Date:   Tue, 15 Jan 2019 13:12:17 +0100
Message-Id: <20190115121217.18276-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190115061949.27260-1-zajec5@gmail.com>
References: <20190115061949.27260-1-zajec5@gmail.com>
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
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 7 +++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h  | 8 +++++---
 .../net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c | 8 ++++++--
 3 files changed, 16 insertions(+), 7 deletions(-)

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
index fe6755944b7b..9c440a5e1c5f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
@@ -14,6 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/device.h>
 #include <linux/module.h> /* bug in tracepoint.h, it should include this */
 
 #ifndef __CHECKER__
@@ -21,7 +22,7 @@
 #include "tracepoint.h"
 #include "debug.h"
 
-void __brcmf_err(const char *func, const char *fmt, ...)
+void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...)
 {
 	struct va_format vaf = {
 		.fmt = fmt,
@@ -30,7 +31,10 @@ void __brcmf_err(const char *func, const char *fmt, ...)
 
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

