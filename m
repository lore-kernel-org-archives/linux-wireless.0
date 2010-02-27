Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f182.google.com ([209.85.223.182]:56970 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030205Ab0B0R0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 12:26:11 -0500
Received: by iwn12 with SMTP id 12so1182009iwn.21
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 09:26:10 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 27 Feb 2010 18:26:10 +0100
Message-ID: <133e8d7e1002270926p64cfd2b5uc4017bf0187c53c2@mail.gmail.com>
Subject: [RFC] ath9k: Make AR_SREV_5416() macro evaluate to true for AR9100
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AR_SREV_5416() macro evaluates to false for AR9100 while the
definitions for AR_SREV_5416_20_OR_LATER() and
AR_SREV_5416_22_OR_LATER() seem to assume AR9100 based chips fall
under this category. For example the last line of

#define AR_SREV_5416_20_OR_LATER(_ah) \
        (((AR_SREV_5416(_ah)) && \
         ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20)) || \
         ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))

makes no sense if AR_SREV_5416(_ah) is false when
(_ah)->hw_version.macVersion == AR_SREV_VERSION_9100.

The patch below changes AR_SREV_5416() to evaluate to true also for
AR9100. I've tested on an AR9100 based router with this patch and
haven't noticed any more problems than usual. Many code paths are
affected though so please comment.

/Björn
---
diff --git a/drivers/net/wireless/ath/ath9k/reg.h
b/drivers/net/wireless/ath/ath9k/reg.h
index 72cfa8e..39f7d66 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -762,7 +762,8 @@

 #define AR_SREV_5416(_ah) \
        (((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
-        ((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE))
+        ((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE) || \
+        ((_ah)->hw_version.macVersion == AR_SREV_VERSION_9100))
 #define AR_SREV_5416_20_OR_LATER(_ah) \
        (((AR_SREV_5416(_ah)) && \
         ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20)) || \
