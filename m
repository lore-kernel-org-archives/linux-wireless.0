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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6676FC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 06:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C72C20651
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 06:22:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qXG/YhRg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbfAOGUH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 01:20:07 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46296 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbfAOGUH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 01:20:07 -0500
Received: by mail-lj1-f195.google.com with SMTP id v15-v6so1251807ljh.13
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 22:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t+3E6P08s2LRMSTKSXqb4kokFW9RoadZlEZaN/puleA=;
        b=qXG/YhRgL21jxUb2At9kBF7HLF/g0VO08bicsWuWCeL/PeWNzLzh2e1LYNSLPeGKsS
         aJi8vSFuvOlctKaOq9dgtJjU1WTHdGLQuOnhZ8jYC7hhulZDbYb/YM/VLsUSg/Wv82jt
         BvnzWxsInGC49y5YxshBZ/bV0BODYBK2MzaU3NDyYZITbiY8d8LkgQ05fZ/mawrH93IG
         /OSdXaaHY8g0Ez4O0iclPPAgK06RmtyqNFnkWq8aEx3OHiTbPw+yKN2eFQZzJpa75OqS
         fZz0O7mOk/pD7N5gQGmwMEEO6ZoUWKHgsAtRywo/788zNEnFDNP5dSb04j1eW11tHZix
         sk0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t+3E6P08s2LRMSTKSXqb4kokFW9RoadZlEZaN/puleA=;
        b=n2ClpmQgyygcXGliHCV2zLjr8MSoMEf6POBTS2sHPlrEZQYg9lmS7KMV0NgjuYoSdz
         2rC3e9znH+3+lmV0OEHLCaRGPar/adsbzMKix9ZF3bzD3fZbA+EuQoL5Uf8hP+RzUEXH
         dwsG7uILTpHVWLvzzydJ/3jL03a5lZ+E4Yz7orQ4/ZJHRU1UBpaIctEoWXjd8jT69Uyt
         HB3I5RKrYBkFVPJ8hJK8O4vh8MrZU7GGNMBCLJEYCYnsMAz98Ts6EyxgRy2IqJKPiTlW
         r0r05sHaPimpP7COuAWhNhB0aw6OBzVIf1RJ24leTdIOE3FzhWbSK5G1SBI0beuhRylm
         M0RQ==
X-Gm-Message-State: AJcUukdCCKnnZoFmKxW9pMXYRXyyaxL8TXTwLtbVC/8g7k4WoJ0+kcMY
        KNJmFDyUi0w09VtOTtS9z22WmfLt
X-Google-Smtp-Source: ALg8bN6j6XQyzm0h4bH3jY0FBVCUhxtVNKXafQly7m7V4+Si7RYETmrD22HZs5mbRDPZRrgrrcghZw==
X-Received: by 2002:a2e:5854:: with SMTP id x20-v6mr1496625ljd.31.1547533204665;
        Mon, 14 Jan 2019 22:20:04 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id y9sm443351lfe.75.2019.01.14.22.20.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 22:20:03 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 1/2] brcmfmac: modify __brcmf_err() to take bus as a parameter
Date:   Tue, 15 Jan 2019 07:19:48 +0100
Message-Id: <20190115061949.27260-1-zajec5@gmail.com>
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
---
This is my another try on improving brcmf_err after the failure from 2
years ago:
[PATCH V3 4/9] brcmfmac: add struct brcmf_pub parameter to the __brcmf_err
https://patchwork.kernel.org/patch/9553255/

Back then my change has been rejected due to miscommunication and late
realisation that struct brcmf_pub (a previous choice instead of struct
brcmf_bus) was a bad idea. Back then Arend wrote:
> So I would think using struct brcmf_bus in brcmf_err() would be best
> fit.

So this patch follows that suggestion & updates __brcmf_err()
accordingly.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 7 +++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h  | 8 +++++---
 .../net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c | 7 +++++--
 3 files changed, 15 insertions(+), 7 deletions(-)

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
index fe6755944b7b..f9359ea9cb13 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
@@ -21,7 +21,7 @@
 #include "tracepoint.h"
 #include "debug.h"
 
-void __brcmf_err(const char *func, const char *fmt, ...)
+void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...)
 {
 	struct va_format vaf = {
 		.fmt = fmt,
@@ -30,7 +30,10 @@ void __brcmf_err(const char *func, const char *fmt, ...)
 
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

