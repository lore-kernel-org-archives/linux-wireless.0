Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2394 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 33/61] staging: brcm80211: remove retrieval function for
 tsf in wlc_main.c
Date: Tue, 3 May 2011 11:35:33 +0200
Message-ID: <1304415361-7813-34-git-send-email-arend@broadcom.com> (sfid-20110503_113833_064354_C6611F47)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wlc_main.c provides a function to read the tsf, but it is not used.
Consequently, it is removed.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |    5 -----
 drivers/staging/brcm80211/brcmsmac/wlc_main.h |    2 --
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 0213844..b56d613 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -7868,11 +7868,6 @@ void wlc_set_rcmta(struct wlc_info *wlc, int idx, const u8 *addr)
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
index 4f0db6c..23130bb 100644
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
1.7.4.1


