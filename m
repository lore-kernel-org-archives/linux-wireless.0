Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4309 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1DSG7P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 02:59:15 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] staging: brcm80211: got rid of WL_FFPLD message log
 macro
Date: Tue, 19 Apr 2011 08:59:04 +0200
Message-ID: <1303196344-3157-4-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303196344-3157-1-git-send-email-rvossen@broadcom.com>
References: <1303196344-3157-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Partially removed, remaining replaced with BCMMSG.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_dbg.h    |    8 --------
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |   13 ++++++-------
 drivers/staging/brcm80211/include/wlioctl.h    |    2 --
 3 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
index d95f8a9..2e8948f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
@@ -22,12 +22,6 @@
 /* wl_msg_level is a bit vector with defs in wlioctl.h */
 extern u32 wl_msg_level;
 
-#define WL_PRINT(level, fmt, args...)		\
-do {						\
-	if (wl_msg_level & level)		\
-		printk(fmt, ##args);		\
-} while (0)
-
 #define BCMMSG(dev, fmt, args...)		\
 do {						\
 	if (wl_msg_level & WL_TRACE_VAL)	\
@@ -36,7 +30,6 @@ do {						\
 
 #ifdef BCMDBG
 
-#define WL_FFPLD(fmt, args...)	WL_PRINT(WL_FFPLD_VAL, fmt, ##args)
 
 /* Extra message control for AMPDU debugging */
 #define   WL_AMPDU_UPDN_VAL	0x00000001	/* Config up/down related  */
@@ -79,7 +72,6 @@ do {						\
 
 #else				/* BCMDBG */
 
-#define WL_FFPLD(fmt, args...)		no_printk(fmt, ##args)
 
 #define WL_AMPDU_UPDN(fmt, args...)	no_printk(fmt, ##args)
 #define WL_AMPDU_RX(fmt, args...)	no_printk(fmt, ##args)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index d306bf7..f217cd8 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -315,7 +315,7 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
 			 M_UCODE_MACSTAT + offsetof(macstat_t, txfunfl[fid]));
 	new_txunfl = (u16) (cur_txunfl - fifo->prev_txfunfl);
 	if (new_txunfl == 0) {
-		WL_FFPLD("check_txunfl : TX status FRAG set but no tx underflows\n");
+		BCMMSG(wlc->dev, "TX status FRAG set but no tx underflows\n");
 		return -1;
 	}
 	fifo->prev_txfunfl = cur_txunfl;
@@ -325,7 +325,6 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
 
 	/* check if fifo is big enough */
 	if (wlc_xmtfifo_sz_get(wlc, fid, &xmtfifo_sz)) {
-		WL_FFPLD("check_txunfl : get xmtfifo_sz failed\n");
 		return -1;
 	}
 
@@ -339,8 +338,8 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
 	if (fifo->accum_txfunfl < 10)
 		return 0;
 
-	WL_FFPLD("ampdu_count %d  tx_underflows %d\n",
-		 current_ampdu_cnt, fifo->accum_txfunfl);
+	BCMMSG(wlc->dev, "ampdu_count %d  tx_underflows %d\n",
+		current_ampdu_cnt, fifo->accum_txfunfl);
 
 	/*
 	   compute the current ratio of tx unfl per ampdu.
@@ -367,7 +366,6 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
 	 */
 
 	if (fifo->ampdu_pld_size >= max_mpdu * FFPLD_MPDU_SIZE) {
-		WL_FFPLD(("tx fifo pld : max ampdu fits in fifo\n)"));
 		fifo->accum_txfunfl = 0;
 		return 0;
 	}
@@ -393,8 +391,9 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
 		      (max_mpdu * FFPLD_MPDU_SIZE - fifo->ampdu_pld_size))
 		     / (max_mpdu * FFPLD_MPDU_SIZE)) * 100;
 
-		WL_FFPLD("DMA estimated transfer rate %d; pre-load size %d\n",
-			 fifo->dmaxferrate, fifo->ampdu_pld_size);
+		BCMMSG(wlc->dev, "DMA estimated transfer rate %d; "
+			"pre-load size %d\n",
+			fifo->dmaxferrate, fifo->ampdu_pld_size);
 	} else {
 
 		/* decrease ampdu size */
diff --git a/drivers/staging/brcm80211/include/wlioctl.h b/drivers/staging/brcm80211/include/wlioctl.h
index 5e2b11b..1e11c42 100644
--- a/drivers/staging/brcm80211/include/wlioctl.h
+++ b/drivers/staging/brcm80211/include/wlioctl.h
@@ -1247,8 +1247,6 @@ typedef struct tx_inst_power {
 /* Message levels */
 #define WL_ERROR_VAL		0x00000001
 #define WL_TRACE_VAL		0x00000002
-#define WL_AMPDU_VAL		0x20000000
-#define WL_FFPLD_VAL		0x40000000
 
 /* maximum channels returned by the get valid channels iovar */
 #define WL_NUMCHANNELS		64
-- 
1.7.1


