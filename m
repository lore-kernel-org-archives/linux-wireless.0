Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3411 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758137Ab1EMKAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 17/32] staging: brcm80211: removed more unused counter
 related structures
Date: Fri, 13 May 2011 11:59:37 +0200
Message-ID: <1305280792-9475-17-git-send-email-arend@broadcom.com> (sfid-20110513_120130_006055_840CF359)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/include/wlioctl.h |  103 ---------------------------
 1 files changed, 0 insertions(+), 103 deletions(-)

diff --git a/drivers/staging/brcm80211/include/wlioctl.h b/drivers/staging/brcm80211/include/wlioctl.h
index 0e79dc8..40016b9 100644
--- a/drivers/staging/brcm80211/include/wlioctl.h
+++ b/drivers/staging/brcm80211/include/wlioctl.h
@@ -1249,114 +1249,11 @@ struct tsinfo_arg {
 
 #define	NFIFO			6	/* # tx/rx fifopairs */
 
-#define	WL_DELTA_STATS_T_VERSION	1	/* current version of wl_delta_stats_t struct */
-
-typedef struct {
-	u16 version;		/* see definition of WL_DELTA_STATS_T_VERSION */
-	u16 length;		/* length of entire structure */
-
-	/* transmit stat counters */
-	u32 txframe;		/* tx data frames */
-	u32 txbyte;		/* tx data bytes */
-	u32 txretrans;	/* tx mac retransmits */
-	u32 txfail;		/* tx failures */
-
-	/* receive stat counters */
-	u32 rxframe;		/* rx data frames */
-	u32 rxbyte;		/* rx data bytes */
-
-	/* per-rate receive stat counters */
-	u32 rx1mbps;		/* packets rx at 1Mbps */
-	u32 rx2mbps;		/* packets rx at 2Mbps */
-	u32 rx5mbps5;	/* packets rx at 5.5Mbps */
-	u32 rx6mbps;		/* packets rx at 6Mbps */
-	u32 rx9mbps;		/* packets rx at 9Mbps */
-	u32 rx11mbps;	/* packets rx at 11Mbps */
-	u32 rx12mbps;	/* packets rx at 12Mbps */
-	u32 rx18mbps;	/* packets rx at 18Mbps */
-	u32 rx24mbps;	/* packets rx at 24Mbps */
-	u32 rx36mbps;	/* packets rx at 36Mbps */
-	u32 rx48mbps;	/* packets rx at 48Mbps */
-	u32 rx54mbps;	/* packets rx at 54Mbps */
-	u32 rx108mbps;	/* packets rx at 108mbps */
-	u32 rx162mbps;	/* packets rx at 162mbps */
-	u32 rx216mbps;	/* packets rx at 216 mbps */
-	u32 rx270mbps;	/* packets rx at 270 mbps */
-	u32 rx324mbps;	/* packets rx at 324 mbps */
-	u32 rx378mbps;	/* packets rx at 378 mbps */
-	u32 rx432mbps;	/* packets rx at 432 mbps */
-	u32 rx486mbps;	/* packets rx at 486 mbps */
-	u32 rx540mbps;	/* packets rx at 540 mbps */
-} wl_delta_stats_t;
-
-#define WL_WME_CNT_VERSION	1	/* current version of wl_wme_cnt_t */
-
-typedef struct {
-	u32 packets;
-	u32 bytes;
-} wl_traffic_stats_t;
-
-typedef struct {
-	u16 version;		/* see definition of WL_WME_CNT_VERSION */
-	u16 length;		/* length of entire structure */
-
-	wl_traffic_stats_t tx[AC_COUNT];	/* Packets transmitted */
-	wl_traffic_stats_t tx_failed[AC_COUNT];	/* Packets dropped or failed to transmit */
-	wl_traffic_stats_t rx[AC_COUNT];	/* Packets received */
-	wl_traffic_stats_t rx_failed[AC_COUNT];	/* Packets failed to receive */
-
-	wl_traffic_stats_t forward[AC_COUNT];	/* Packets forwarded by AP */
-
-	wl_traffic_stats_t tx_expired[AC_COUNT];	/* packets dropped due to lifetime expiry */
-
-} wl_wme_cnt_t;
-
 struct wl_msglevel2 {
 	u32 low;
 	u32 high;
 };
 
-#ifdef WLBA
-
-#define	WLC_BA_CNT_VERSION	1	/* current version of wlc_ba_cnt_t */
-
-/* block ack related stats */
-typedef struct wlc_ba_cnt {
-	u16 version;		/* WLC_BA_CNT_VERSION */
-	u16 length;		/* length of entire structure */
-
-	/* transmit stat counters */
-	u32 txpdu;		/* pdus sent */
-	u32 txsdu;		/* sdus sent */
-	u32 txfc;		/* tx side flow controlled packets */
-	u32 txfci;		/* tx side flow control initiated */
-	u32 txretrans;	/* retransmitted pdus */
-	u32 txbatimer;	/* ba resend due to timer */
-	u32 txdrop;		/* dropped packets */
-	u32 txaddbareq;	/* addba req sent */
-	u32 txaddbaresp;	/* addba resp sent */
-	u32 txdelba;		/* delba sent */
-	u32 txba;		/* ba sent */
-	u32 txbar;		/* bar sent */
-	u32 txpad[4];	/* future */
-
-	/* receive side counters */
-	u32 rxpdu;		/* pdus recd */
-	u32 rxqed;		/* pdus buffered before sending up */
-	u32 rxdup;		/* duplicate pdus */
-	u32 rxnobuf;		/* pdus discarded due to no buf */
-	u32 rxaddbareq;	/* addba req recd */
-	u32 rxaddbaresp;	/* addba resp recd */
-	u32 rxdelba;		/* delba recd */
-	u32 rxba;		/* ba recd */
-	u32 rxbar;		/* bar recd */
-	u32 rxinvba;		/* invalid ba recd */
-	u32 rxbaholes;	/* ba recd with holes */
-	u32 rxunexp;		/* unexpected packets */
-	u32 rxpad[4];	/* future */
-} wlc_ba_cnt_t;
-#endif				/* WLBA */
-
 /* structure for per-tid ampdu control */
 struct ampdu_tid_control {
 	u8 tid;		/* tid */
-- 
1.7.4.1


