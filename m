Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2083 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758193Ab1F2XtW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:22 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 023/119] staging: brcm80211: corrected tx status
 feedback for non AMPDU packets
Date: Wed, 29 Jun 2011 16:46:47 -0700
Message-ID: <1309391303-22741-24-git-send-email-frankyl@broadcom.com> (sfid-20110630_015236_333809_663C9450)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code still contained a 'FIXME' label that said tx status feedback (consumed by
the rate control algorithm) was not yet taking RTS/CTS into account.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   30 ++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 9aa74df..64f4fe7 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -4371,8 +4371,18 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	if (!lastframe) {
 		wiphy_err(wlc->wiphy, "Not last frame!\n");
 	} else {
-		u16 sfbl, lfbl;
-		ieee80211_tx_info_clear_status(tx_info);
+		/*
+		 * Set information to be consumed by Minstrel ht.
+		 *
+		 * The "fallback limit" is the number of tx attempts a given
+		 * MPDU is sent at the "primary" rate. Tx attempts beyond that
+		 * limit are sent at the "secondary" rate.
+		 * A 'short frame' does not exceed RTS treshold.
+		 */
+		u16 sfbl,	/* Short Frame Rate Fallback Limit */
+		    lfbl,	/* Long Frame Rate Fallback Limit */
+		    fbl;
+
 		if (queue < AC_COUNT) {
 			sfbl = WLC_WME_RETRY_SFB_GET(wlc, wme_fifo2ac[queue]);
 			lfbl = WLC_WME_RETRY_LFB_GET(wlc, wme_fifo2ac[queue]);
@@ -4382,14 +4392,20 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, tx_status_t *txs, u32 frm_tx2)
 		}
 
 		txrate = tx_info->status.rates;
-		/* FIXME: this should use a combination of sfbl, lfbl depending on frame length and RTS setting */
-		if ((tx_frame_count > sfbl) && (txrate[1].idx >= 0)) {
+		if (txrate[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
+			fbl = lfbl;
+		else
+			fbl = sfbl;
+
+		ieee80211_tx_info_clear_status(tx_info);
+
+		if ((tx_frame_count > fbl) && (txrate[1].idx >= 0)) {
 			/* rate selection requested a fallback rate and we used it */
-			txrate->count = lfbl;
-			txrate[1].count = tx_frame_count - lfbl;
+			txrate[0].count = fbl;
+			txrate[1].count = tx_frame_count - fbl;
 		} else {
 			/* rate selection did not request fallback rate, or we didn't need it */
-			txrate->count = tx_frame_count;
+			txrate[0].count = tx_frame_count;
 			/* rc80211_minstrel.c:minstrel_tx_status() expects unused rates to be marked with idx = -1 */
 			txrate[1].idx = -1;
 			txrate[1].count = 0;
-- 
1.7.1


