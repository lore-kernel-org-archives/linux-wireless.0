Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4287 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab1HZNTw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:52 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 06/13] staging: brcm80211: remove brcmf_find_msb()
 function
Date: Fri, 26 Aug 2011 15:19:33 +0200
Message-ID: <1314364780-9462-7-git-send-email-rvossen@broadcom.com> (sfid-20110826_151957_691659_D93A1673)
In-Reply-To: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
References: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

This function is similar to ffs() wihch is provided by the linux
kernel already. This patch replaces brcmf_find_msb() with ffs().

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   39 ++-------------------
 1 files changed, 4 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 8b052b0..4f7b081 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -20,6 +20,7 @@
 #include <linux/kthread.h>
 #include <linux/netdevice.h>
 #include <linux/sched.h>
+#include <linux/bitops.h>
 #include <linux/etherdevice.h>
 #include <linux/ieee80211.h>
 #include <linux/mmc/sdio_func.h>
@@ -294,11 +295,6 @@ static s32 brcmf_iscan_inprogress(struct brcmf_cfg80211_priv *cfg_priv);
 static s32 brcmf_iscan_aborted(struct brcmf_cfg80211_priv *cfg_priv);
 
 /*
-* find most significant bit set
-*/
-static __used u32 brcmf_find_msb(u16 bit16);
-
-/*
 * update pmklist to dongle
 */
 static __used s32 brcmf_update_pmklist(struct net_device *dev,
@@ -2008,33 +2004,6 @@ done:
 	return err;
 }
 
-static __used u32 brcmf_find_msb(u16 bit16)
-{
-	u32 ret = 0;
-
-	if (bit16 & 0xff00) {
-		ret += 8;
-		bit16 >>= 8;
-	}
-
-	if (bit16 & 0xf0) {
-		ret += 4;
-		bit16 >>= 4;
-	}
-
-	if (bit16 & 0xc) {
-		ret += 2;
-		bit16 >>= 2;
-	}
-
-	if (bit16 & 2)
-		ret += bit16 & 2;
-	else if (bit16)
-		ret += bit16;
-
-	return ret;
-}
-
 static s32
 brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 			     const u8 *addr,
@@ -2062,10 +2031,10 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 
 	rateset.count = le32_to_cpu(rateset.count);
 
-	legacy = brcmf_find_msb(mask->control[IEEE80211_BAND_2GHZ].legacy);
+	legacy = ffs(mask->control[IEEE80211_BAND_2GHZ].legacy & 0xFFFF);
 	if (!legacy)
-		legacy = brcmf_find_msb(
-				mask->control[IEEE80211_BAND_5GHZ].legacy);
+		legacy = ffs(mask->control[IEEE80211_BAND_5GHZ].legacy &
+			     0xFFFF);
 
 	val = wl_g_rates[legacy - 1].bitrate * 100000;
 
-- 
1.7.4.1


