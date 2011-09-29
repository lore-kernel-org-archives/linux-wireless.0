Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1884 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052Ab1I2Wet (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 18:34:49 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 22/25] staging: brcm80211: move rssi computation to
 place we need it
Date: Thu, 29 Sep 2011 15:34:33 -0700
Message-ID: <1317335676-3424-23-git-send-email-frankyl@broadcom.com> (sfid-20110930_003545_598844_D61C19C4)
In-Reply-To: <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
 <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The rssi computation was done upon getting the frame from the
queue, but the value is needed when filling in the receive status
data for mac80211. The call to wlc_phy_rssi_compute() has been
deferred.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 3e39407..bdc0611 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -828,11 +828,6 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 		rxh->RxTSFTime = le16_to_cpu(rxh_le->RxTSFTime);
 		rxh->RxChan = le16_to_cpu(rxh_le->RxChan);
 
-		/*
-		 * compute the RSSI from d11rxhdr and record it in wlc_rxd11hr
-		 */
-		wlc_rxhdr->rssi = (s8)wlc_phy_rssi_compute(wlc_hw->band->pi,
-							   rxh);
 		brcms_c_recv(wlc_hw->wlc, p);
 	}
 
@@ -8172,7 +8167,7 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 		rx_status->freq = ieee80211_dsss_chan_to_freq(channel);
 	}
 
-	rx_status->signal = wlc_rxh->rssi;
+	rx_status->signal = wlc_phy_rssi_compute(wlc->hw->band->pi, rxh);
 
 	/* noise */
 	/* qual */
-- 
1.7.1


