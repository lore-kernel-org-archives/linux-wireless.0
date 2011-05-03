Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1685 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab1ECJgT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 32/61] staging: brcm80211: remove tsf retrieval from
 wlc_bmac.c
Date: Tue, 3 May 2011 11:35:32 +0200
Message-ID: <1304415361-7813-33-git-send-email-arend@broadcom.com> (sfid-20110503_113751_686338_FE5FFC08)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon receiving a packet the lowest 32 bits of tsf are filled in
by wlc_bmac in wlc_bmac_recv, but this is not useful as wlc_main
needs to reconstruct 64 bit tsf which is retrieves to recover the
actual tsf value at which packet is received. Therefore tsf
retrieval is removed from wlc_bmac.c.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 8dbf388..daeb363 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -265,7 +265,6 @@ wlc_bmac_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound)
 	struct sk_buff *tail = NULL;
 	uint n = 0;
 	uint bound_limit = bound ? wlc_hw->wlc->pub->tunables->rxbnd : -1;
-	u32 tsf_h, tsf_l;
 	wlc_d11rxhdr_t *wlc_rxhdr = NULL;
 
 	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
@@ -284,9 +283,6 @@ wlc_bmac_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound)
 			break;
 	}
 
-	/* get the TSF REG reading */
-	wlc_bmac_read_tsf(wlc_hw, &tsf_l, &tsf_h);
-
 	/* post more rbufs */
 	dma_rxfill(wlc_hw->di[fifo]);
 
@@ -295,9 +291,7 @@ wlc_bmac_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound)
 		head = head->prev;
 		p->prev = NULL;
 
-		/* record the tsf_l in wlc_rxd11hdr */
 		wlc_rxhdr = (wlc_d11rxhdr_t *) p->data;
-		wlc_rxhdr->tsf_l = cpu_to_le32(tsf_l);
 
 		/* compute the RSSI from d11rxhdr and record it in wlc_rxd11hr */
 		wlc_phy_rssi_compute(wlc_hw->band->pi, wlc_rxhdr);
-- 
1.7.4.1


