Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1167 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933050Ab1JDVTk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:40 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/26] staging: brcm80211: removed empty
 brcms_c_reset_bmac_done callback function
Date: Tue, 4 Oct 2011 23:19:00 +0200
Message-ID: <1317763152-17607-15-git-send-email-arend@broadcom.com> (sfid-20111004_231947_088105_107FD9BC)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Empty functions are good candidates for removal.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    6 ------
 drivers/staging/brcm80211/brcmsmac/main.h |    1 -
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 6a0a5d0..d75756d 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -3258,8 +3258,6 @@ static void brcms_b_reset(struct brcms_hardware *wlc_hw)
 
 	/* purge the dma rings */
 	brcms_c_flushqueues(wlc_hw->wlc);
-
-	brcms_c_reset_bmac_done(wlc_hw->wlc);
 }
 
 void brcms_c_reset(struct brcms_c_info *wlc)
@@ -8868,10 +8866,6 @@ void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, u32 req_bit)
 	brcms_b_pllreq(wlc->hw, set, req_bit);
 }
 
-void brcms_c_reset_bmac_done(struct brcms_c_info *wlc)
-{
-}
-
 /* check for the particular priority flow control bit being set */
 bool
 brcms_c_txflowcontrol_prio_isset(struct brcms_c_info *wlc,
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 9e1575c..5a2ec53 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -677,7 +677,6 @@ extern int brcms_c_xmtfifo_sz_get(struct brcms_c_info *wlc, uint fifo,
 extern void brcms_c_write_template_ram(struct brcms_c_info *wlc, int offset,
 				       int len, void *buf);
 extern void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, u32 req_bit);
-extern void brcms_c_reset_bmac_done(struct brcms_c_info *wlc);
 
 #if defined(BCMDBG)
 extern void brcms_c_print_rxh(struct d11rxhdr *rxh);
-- 
1.7.4.1


