Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4649 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab1IPT2a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:30 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 16/19] staging: brcm80211: remove for_each_bss() macro
 from brcmfmac driver
Date: Fri, 16 Sep 2011 12:28:05 -0700
Message-ID: <1316201288-29635-17-git-send-email-frankyl@broadcom.com> (sfid-20110916_212837_625855_C44D58EE)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The macro was only used once in the code and has been removed for
clarity reading the code.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    4 ++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    4 ----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 6ac4cc7..4f3e8b8 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1993,8 +1993,8 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
 		return -EOPNOTSUPP;
 	}
 	WL_SCAN("scanned AP count (%d)\n", bss_list->count);
-	bi = next_bss(bss_list, bi);
-	for_each_bss(bss_list, bi, i) {
+	for (i = 0; i < bss_list->count && i < WL_AP_MAX; i++) {
+		bi = next_bss(bss_list, bi);
 		err = brcmf_inform_single_bss(cfg_priv, bi);
 		if (unlikely(err))
 			break;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 7a8c671..d27d4e6 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -362,10 +362,6 @@ static inline struct brcmf_bss_info *next_bss(struct brcmf_scan_results *list,
 		list->bss_info;
 }
 
-#define for_each_bss(list, bss, __i)	\
-	for (__i = 0; __i < list->count && __i < WL_AP_MAX; __i++, \
-		bss = next_bss(list, bss))
-
 extern struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
 							struct device *busdev,
 							void *data);
-- 
1.7.1


