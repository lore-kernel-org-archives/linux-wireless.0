Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4911 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758731Ab1EMKAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:10 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/32] staging: brcm80211: removed support for
 proprietary ioctl WLC_GET_PKTCNTS
Date: Fri, 13 May 2011 11:59:35 +0200
Message-ID: <1305280792-9475-15-git-send-email-arend@broadcom.com> (sfid-20110513_120102_715896_7466682C)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>


Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |   18 ------------------
 drivers/staging/brcm80211/include/wlioctl.h   |    9 ---------
 2 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index e4cf9f6..cdd55f8 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -3542,24 +3542,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		wlc->default_bss->atim_window = (u32) val;
 		break;
 
-	case WLC_GET_PKTCNTS:{
-			get_pktcnt_t *pktcnt = (get_pktcnt_t *) pval;
-			wlc_statsupd(wlc);
-			pktcnt->rx_good_pkt = wlc->pub->_cnt->rxframe;
-			pktcnt->rx_bad_pkt = wlc->pub->_cnt->rxerror;
-			pktcnt->tx_good_pkt =
-			    wlc->pub->_cnt->txfrmsnt;
-			pktcnt->tx_bad_pkt =
-			    wlc->pub->_cnt->txerror +
-			    wlc->pub->_cnt->txfail;
-			if (len >= (int)sizeof(get_pktcnt_t)) {
-				/* Be backward compatible - only if buffer is large enough  */
-				pktcnt->rx_ocast_good_pkt =
-				    wlc->pub->_cnt->rxmfrmocast;
-			}
-			break;
-		}
-
 #ifdef SUPPORT_HWKEY
 	case WLC_GET_WSEC:
 		bcmerror =
diff --git a/drivers/staging/brcm80211/include/wlioctl.h b/drivers/staging/brcm80211/include/wlioctl.h
index 1e11c42..d7f316d 100644
--- a/drivers/staging/brcm80211/include/wlioctl.h
+++ b/drivers/staging/brcm80211/include/wlioctl.h
@@ -585,15 +585,6 @@ struct maclist {
 	u8 ea[1][ETH_ALEN];	/* variable length array of MAC addresses */
 };
 
-/* get pkt count struct passed through ioctl */
-typedef struct get_pktcnt {
-	uint rx_good_pkt;
-	uint rx_bad_pkt;
-	uint tx_good_pkt;
-	uint tx_bad_pkt;
-	uint rx_ocast_good_pkt;	/* unicast packets destined for others */
-} get_pktcnt_t;
-
 #ifdef BRCM_FULLMAC
 /* Linux network driver ioctl encoding */
 typedef struct wl_ioctl {
-- 
1.7.4.1


