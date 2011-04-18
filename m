Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1886 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab1DRNcL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:32:11 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] staging: brcm80211: remove retrieval function for
 tsf in wlc_main.c
Date: Mon, 18 Apr 2011 15:31:51 +0200
Message-ID: <1303133511-8300-6-git-send-email-arend@broadcom.com>
In-Reply-To: <1303133511-8300-1-git-send-email-arend@broadcom.com>
References: <1303133511-8300-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wlc_main.c provides a function to read the tsf, but it is not used.
Consequently, it is removed.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
---
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |    5 -----
 drivers/staging/brcm80211/brcmsmac/wlc_main.h |    2 --
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 34584be..6fb9d9c 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -7861,11 +7861,6 @@ void wlc_set_rcmta(struct wlc_info *wlc, int idx, const u8 *addr)
 	wlc_bmac_set_rcmta(wlc->hw, idx, addr);
 }
 
-void wlc_read_tsf(struct wlc_info *wlc, u32 *tsf_l_ptr, u32 *tsf_h_ptr)
-{
-	wlc_bmac_read_tsf(wlc->hw, tsf_l_ptr, tsf_h_ptr);
-}
-
 void wlc_set_cwmin(struct wlc_info *wlc, u16 newmin)
 {
 	wlc->band->CWmin = newmin;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index d1114e8..34023fa 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -813,8 +813,6 @@ extern void wlc_get_rcmta(struct wlc_info *wlc, int idx,
 #endif
 extern void wlc_set_rcmta(struct wlc_info *wlc, int idx,
 			  const u8 *addr);
-extern void wlc_read_tsf(struct wlc_info *wlc, u32 *tsf_l_ptr,
-			 u32 *tsf_h_ptr);
 extern void wlc_set_cwmin(struct wlc_info *wlc, u16 newmin);
 extern void wlc_set_cwmax(struct wlc_info *wlc, u16 newmax);
 extern void wlc_fifoerrors(struct wlc_info *wlc);
-- 
1.7.1


