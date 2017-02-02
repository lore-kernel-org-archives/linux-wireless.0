Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34455 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbdBBVdw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 16:33:52 -0500
Received: by mail-lf0-f65.google.com with SMTP id q89so47020lfi.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2017 13:33:51 -0800 (PST)
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
Subject: [PATCH V3 9/9] brcmfmac: use dev_err to print errors
Date: Thu,  2 Feb 2017 22:33:21 +0100
Message-Id: <20170202213321.11591-9-zajec5@gmail.com> (sfid-20170202_223400_032278_BB14B875)
In-Reply-To: <20170202213321.11591-1-zajec5@gmail.com>
References: <20170202213321.11591-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This adds a nice prefix to all error messages making it possible to
identify device they are related to. It's really useful for e.g. home
routers commonly having 2 or even 3 wireless devices.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c     | 3 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index c0ac7979c9ea..5845a3e5150a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -223,6 +223,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 #ifndef CONFIG_BRCM_TRACING
 void __brcmf_err(struct brcmf_pub *pub, const char *func, const char *fmt, ...)
 {
+	struct device *dev = pub && pub->bus_if ? pub->bus_if->dev : NULL;
 	struct va_format vaf;
 	va_list args;
 
@@ -230,7 +231,7 @@ void __brcmf_err(struct brcmf_pub *pub, const char *func, const char *fmt, ...)
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	pr_err("%s: %pV", func, &vaf);
+	dev_err(dev, "%s: %pV", func, &vaf);
 
 	va_end(args);
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
index 329cb65eb78b..393c1b31ed28 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c
@@ -25,6 +25,7 @@
 
 void __brcmf_err(struct brcmf_pub *pub, const char *func, const char *fmt, ...)
 {
+	struct device *dev = pub && pub->bus_if ? pub->bus_if->dev : NULL;
 	struct va_format vaf = {
 		.fmt = fmt,
 	};
@@ -32,7 +33,7 @@ void __brcmf_err(struct brcmf_pub *pub, const char *func, const char *fmt, ...)
 
 	va_start(args, fmt);
 	vaf.va = &args;
-	pr_err("%s: %pV", func, &vaf);
+	dev_err(dev, "%s: %pV", func, &vaf);
 	trace_brcmf_err(func, &vaf);
 	va_end(args);
 }
-- 
2.11.0
