Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3796 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab1ILKPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:24 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 17/20] staging: brcm80211: removed unused softmac
 transmit power variables
Date: Mon, 12 Sep 2011 12:15:01 +0200
Message-ID: <1315822504-24210-18-git-send-email-rvossen@broadcom.com> (sfid-20110912_121535_639613_B2F9ED25)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Struct member variables were only set to '0'. As a result, function
brcms_c_local_constraint_qdbm() always returned BRCMS_TXPWR_MAX and
thus could be removed.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   34 +---------------------------
 drivers/staging/brcm80211/brcmsmac/main.h |    7 ------
 2 files changed, 2 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 9df2f86..5199f6a 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -3275,44 +3275,14 @@ static brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec,
 		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
 }
 
-static u8 brcms_c_local_constraint_qdbm(struct brcms_c_info *wlc)
-{
-	u8 local;
-	s16 local_max;
-
-	local = BRCMS_TXPWR_MAX;
-	if (wlc->pub->associated &&
-	    (brcmu_chspec_ctlchan(wlc->chanspec) ==
-	     brcmu_chspec_ctlchan(wlc->home_chanspec))) {
-
-		/* get the local power constraint if we are on the AP's
-		 * channel [802.11h, 7.3.2.13]
-		 */
-		/* Clamp the value between 0 and BRCMS_TXPWR_MAX w/o
-		 * overflowing the target */
-		local_max =
-		    (wlc->txpwr_local_max -
-		     wlc->txpwr_local_constraint) * BRCMS_TXPWR_DB_FACTOR;
-		if (local_max > 0 && local_max < BRCMS_TXPWR_MAX)
-			return (u8) local_max;
-		if (local_max < 0)
-			return 0;
-	}
-
-	return local;
-}
-
 static void brcms_c_set_phy_chanspec(struct brcms_c_info *wlc,
 				     u16 chanspec)
 {
 	/* Save our copy of the chanspec */
 	wlc->chanspec = chanspec;
 
-	/* Set the chanspec and power limits for this locale after computing
-	 * any 11h local tx power constraints.
-	 */
-	brcms_c_channel_set_chanspec(wlc->cmi, chanspec,
-				 brcms_c_local_constraint_qdbm(wlc));
+	/* Set the chanspec and power limits for this locale */
+	brcms_c_channel_set_chanspec(wlc->cmi, chanspec, BRCMS_TXPWR_MAX);
 
 	if (wlc->stf->ss_algosel_auto)
 		brcms_c_stf_ss_algo_channel_get(wlc, &wlc->stf->ss_algo_channel,
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 1ee283c..58d5c2e 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -467,8 +467,6 @@ struct brcms_txq_info {
  * war16165: PCI slow clock 16165 war flag.
  * txpend16165war: PCI slow clock 16165 war flag.
  * qvalid: DirFrmQValid and BcMcFrmQValid.
- * txpwr_local_max: regulatory local txpwr max.
- * txpwr_local_constraint: local power contraint in dB.
  * ampdu: ampdu module handler.
  * asi: antsel module handler.
  * cmi: channel manager module handler.
@@ -574,11 +572,6 @@ struct brcms_c_info {
 	/* packet queue */
 	uint qvalid;
 
-	/* Regulatory power limits */
-	s8 txpwr_local_max;
-	u8 txpwr_local_constraint;
-
-
 	struct ampdu_info *ampdu;
 	struct antsel_info *asi;
 	struct brcms_cm_info *cmi;
-- 
1.7.4.1


