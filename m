Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:39769 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbbISKr1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2015 06:47:27 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: kvalo@codeaurora.org
Cc: brudley@broadcom.com, arend@broadcom.com, frankyl@broadcom.com,
	meuleman@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] brcmfmac: include linux/atomic.h
Date: Sat, 19 Sep 2015 12:47:20 +0200
Message-Id: <1442659640-11835-1-git-send-email-hauke@hauke-m.de> (sfid-20150919_124731_518008_CE7B07D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmfmac uses atomic_or() and other atomic_* functions, but does not
include linux/atomic.h. This file gets included by some other header
file so this normally does not cause problems.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index f990e3d..ea9150b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/atomic.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/printk.h>
-- 
2.1.4

