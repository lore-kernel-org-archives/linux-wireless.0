Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2044 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab1FIOp2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:28 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 07/21] staging: brcm80211: remove d11regs_t parameter
 from wlc_tbtt function
Date: Thu, 9 Jun 2011 16:44:47 +0200
Message-ID: <1307630701-9170-8-git-send-email-rvossen@broadcom.com> (sfid-20110609_164534_912111_5610D764)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function wlc_tbtt() has variable regs as parameter, but it is
not used. Parameter has been removed from the function.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/bmac.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index e501e06..68bf242 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -327,7 +327,7 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 	}
 
 	if (macintstatus & (MI_TBTT | MI_DTIM_TBTT))
-		wlc_tbtt(wlc, regs);
+		wlc_tbtt(wlc);
 
 	/* ATIM window end */
 	if (macintstatus & MI_ATIMWINEND) {
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 28ae741..3244751 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -4243,7 +4243,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	return 0;
 }
 
-void wlc_tbtt(struct wlc_info *wlc, d11regs_t *regs)
+void wlc_tbtt(struct wlc_info *wlc)
 {
 	struct wlc_bsscfg *cfg = wlc->cfg;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 1d28b76..cc0772e 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -932,7 +932,7 @@ extern u16 wlc_compute_rtscts_dur(struct wlc_info *wlc, bool cts_only,
 				     u8 frame_preamble_type, uint frame_len,
 				     bool ba);
 
-extern void wlc_tbtt(struct wlc_info *wlc, d11regs_t *regs);
+extern void wlc_tbtt(struct wlc_info *wlc);
 extern void wlc_inval_dma_pkts(struct wlc_hw_info *hw,
 			       struct ieee80211_sta *sta,
 			       void (*dma_callback_fn));
-- 
1.7.4.1


