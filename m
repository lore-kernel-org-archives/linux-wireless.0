Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1173 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933225Ab1JDVTk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:40 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 22/26] staging: brcm80211: remove brcms_b_dotxstatus
 wrapper function
Date: Tue, 4 Oct 2011 23:19:08 +0200
Message-ID: <1317763152-17607-23-git-send-email-arend@broadcom.com> (sfid-20111004_231948_879194_92CB76C4)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

- removed brcms_b_dotxstatus
- changed 'fatal' argument of brcms_b_txstatus from INOUT to OUT.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 0656d99..4e2226e 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -995,21 +995,6 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 
 }
 
-static bool
-brcms_b_dotxstatus(struct brcms_hardware *wlc_hw, struct tx_status *txs)
-{
-	/* discard intermediate indications for ucode with one legitimate case:
-	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange,
-	 *   but the subsequent tx of DATA failed. so it will start rts/cts from
-	 *   the beginning (resetting the rts transmission count)
-	 */
-	if (!(txs->status & TX_STATUS_AMPDU)
-	    && (txs->status & TX_STATUS_INTERMEDIATE))
-		return false;
-
-	return brcms_c_dotxstatus(wlc_hw->wlc, txs);
-}
-
 /* process tx completion events in BMAC
  * Return true if more tx status need to be processed. false otherwise.
  */
@@ -1032,6 +1017,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 
 	txs = &txstatus;
 	regs = wlc_hw->regs;
+	*fatal = false;
 	while (!(*fatal)
 	       && (s1 = R_REG(&regs->frmtxstatus)) & TXS_V) {
 
@@ -1041,7 +1027,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 			return morepending;
 		}
 
-			s2 = R_REG(&regs->frmtxstatus2);
+		s2 = R_REG(&regs->frmtxstatus2);
 
 		txs->status = s1 & TXS_STATUS_MASK;
 		txs->frameid = (s1 & TXS_FID_MASK) >> TXS_FID_SHIFT;
@@ -1049,7 +1035,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 		txs->phyerr = (s2 & TXS_PTX_MASK) >> TXS_PTX_SHIFT;
 		txs->lasttxtime = 0;
 
-		*fatal = brcms_b_dotxstatus(wlc_hw, txs);
+		*fatal = brcms_c_dotxstatus(wlc_hw->wlc, txs);
 
 		/* !give others some time to run! */
 		if (++n >= max_tx_num)
@@ -1077,7 +1063,6 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	u32 macintstatus;
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	struct d11regs __iomem *regs = wlc_hw->regs;
-	bool fatal = false;
 	struct wiphy *wiphy = wlc->wiphy;
 
 	if (brcms_deviceremoved(wlc)) {
@@ -1098,6 +1083,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 
 	/* tx status */
 	if (macintstatus & MI_TFS) {
+		bool fatal;
 		if (brcms_b_txstatus(wlc->hw, bounded, &fatal))
 			wlc->macintstatus |= MI_TFS;
 		if (fatal) {
-- 
1.7.4.1


