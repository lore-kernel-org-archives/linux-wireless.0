Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3797 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab1ILKPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:24 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 13/20] staging: brcm80211: removed softmac ratespec
 override functionality
Date: Mon, 12 Sep 2011 12:14:57 +0200
Message-ID: <1315822504-24210-14-git-send-email-rvossen@broadcom.com> (sfid-20110912_121535_077457_51F51B9A)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was unused.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   17 +++--------------
 drivers/staging/brcm80211/brcmsmac/main.h |    2 --
 drivers/staging/brcm80211/brcmsmac/stf.c  |   12 ++++--------
 3 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index e330c02..d30116d 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -5913,12 +5913,6 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	 */
 	if ((gmode == GMODE_LEGACY_B) && (band->gmode != GMODE_LEGACY_B)) {
 		band->gmode = gmode;
-		if (band->rspec_override && !IS_CCK(band->rspec_override)) {
-			band->rspec_override = 0;
-			brcms_c_reprate_init(wlc);
-		}
-		if (band->mrspec_override && !IS_CCK(band->mrspec_override))
-			band->mrspec_override = 0;
 	}
 
 	band->gmode = gmode;
@@ -5988,12 +5982,8 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
 		for (i = 0; i < wlc->pub->_nbands; i++) {
 			memset(wlc->bandstate[i]->hw_rateset.mcs, 0,
 			       MCSSET_LEN);
-			if (IS_MCS(wlc->band->rspec_override)) {
-				wlc->bandstate[i]->rspec_override = 0;
+			if (IS_MCS(0))
 				brcms_c_reprate_init(wlc);
-			}
-			if (IS_MCS(wlc->band->mrspec_override))
-				wlc->bandstate[i]->mrspec_override = 0;
 		}
 		break;
 
@@ -7052,8 +7042,7 @@ done:
 static u16
 brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		     struct sk_buff *p, struct scb *scb, uint frag,
-		     uint nfrags, uint queue, uint next_frag_len,
-		     u32 rspec_override)
+		     uint nfrags, uint queue, uint next_frag_len)
 {
 	struct ieee80211_hdr *h;
 	struct d11txh *txh;
@@ -7713,7 +7702,7 @@ void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 	prio = ieee80211_is_data(d11_header->frame_control) ? sdu->priority :
 		MAXPRIO;
 	fifo = prio2fifo[prio];
-	if (brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0, 0))
+	if (brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0))
 		return;
 	brcms_c_txq_enq(wlc, scb, sdu, BRCMS_PRIO_TO_PREC(prio));
 	brcms_c_send_q(wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index b31c20f..4e576e5 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -271,8 +271,6 @@ struct brcms_band {
 	/* band-specific copy of default_bss.rateset */
 	struct brcms_c_rateset defrateset;
 
-	u32 rspec_override;	/* 802.11 rate override */
-	u32 mrspec_override;	/* multicast rate override */
 	u8 band_stf_ss_mode;	/* Configured STF type, 0:siso; 1:cdd */
 	s8 band_stf_stbc_tx;	/* STBC TX 0:off; 1:force on; -1:auto */
 	/* rates supported by chip (phy-specific) */
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 0a101a4..71c5d23 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -293,26 +293,22 @@ int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
 
 	if (txstreams == 1) {
 		for (i = 0; i < wlc->pub->_nbands; i++)
-			if ((RSPEC_STF(wlc->bandstate[i]->rspec_override) !=
+			if ((RSPEC_STF(0) !=
 			     PHY_TXC1_MODE_SISO)
-			    || (RSPEC_STF(wlc->bandstate[i]->mrspec_override) !=
+			    || (RSPEC_STF(0) !=
 				PHY_TXC1_MODE_SISO)) {
 				if (!force)
 					return -EBADE;
 
 				/* over-write the override rspec */
-				if (RSPEC_STF(wlc->bandstate[i]->rspec_override)
+				if (RSPEC_STF(0)
 				    != PHY_TXC1_MODE_SISO) {
-					wlc->bandstate[i]->rspec_override = 0;
 					wiphy_err(wlc->wiphy, "%s(): temp "
 						  "sense override non-SISO "
 						  "rspec_override\n",
 						  __func__);
 				}
-				if (RSPEC_STF
-				    (wlc->bandstate[i]->mrspec_override) !=
-				    PHY_TXC1_MODE_SISO) {
-					wlc->bandstate[i]->mrspec_override = 0;
+				if (RSPEC_STF(0) != PHY_TXC1_MODE_SISO) {
 					wiphy_err(wlc->wiphy, "%s(): temp "
 						  "sense override non-SISO "
 						  "mrspec_override\n",
-- 
1.7.4.1


