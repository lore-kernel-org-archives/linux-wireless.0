Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3930 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab1DRJcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 05:32:04 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] staging: brcm80211: removed all ASSERTs from
 wlc_ampdu.c
Date: Mon, 18 Apr 2011 11:31:48 +0200
Message-ID: <1303119108-32487-4-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303119108-32487-1-git-send-email-rvossen@broadcom.com>
References: <1303119108-32487-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Either removed ASSERTs or replaced with WARN_ON in case of HW failure.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 43aa232..dfdcc83 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -521,8 +521,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 	f = ampdu->fifo_tb + prio2fifo[tid];
 
 	scb = wlc->pub->global_scb;
-	ASSERT(scb->magic == SCB_MAGIC);
-
 	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
 	ini = &scb_ampdu->ini[tid];
 
@@ -906,7 +904,6 @@ wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 	if (likely(scb)) {
 		scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
 		ini = SCB_AMPDU_INI(scb_ampdu, p->priority);
-		ASSERT(ini->scb == scb);
 		wlc_ampdu_dotxstatus_complete(ampdu, scb, p, txs, s1, s2);
 	} else {
 		/* loop through all pkts and free */
@@ -989,13 +986,13 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			update_rate = false;
 		}
 
-		ASSERT(txs->status & TX_STATUS_INTERMEDIATE);
+		WARN_ON(!(txs->status & TX_STATUS_INTERMEDIATE));
 		start_seq = txs->sequence >> SEQNUM_SHIFT;
 		bitmap[0] = (txs->status & TX_STATUS_BA_BMAP03_MASK) >>
 		    TX_STATUS_BA_BMAP03_SHIFT;
 
-		ASSERT(!(s1 & TX_STATUS_INTERMEDIATE));
-		ASSERT(s1 & TX_STATUS_AMPDU);
+		WARN_ON(s1 & TX_STATUS_INTERMEDIATE);
+		WARN_ON(!(s1 & TX_STATUS_AMPDU));
 
 		bitmap[0] |=
 		    (s1 & TX_STATUS_BA_BMAP47_MASK) <<
-- 
1.7.1


