Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2346 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 26/61] staging: brcm80211: removed all ASSERTs from
 wlc_ampdu.c
Date: Tue, 3 May 2011 11:35:26 +0200
Message-ID: <1304415361-7813-27-git-send-email-arend@broadcom.com> (sfid-20110503_113844_853416_501D21CB)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Either removed ASSERTs or replaced with WARN_ON in case of HW failure.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index b3e12f7..04493e9 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -520,8 +520,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 	f = ampdu->fifo_tb + prio2fifo[tid];
 
 	scb = wlc->pub->global_scb;
-	ASSERT(scb->magic == SCB_MAGIC);
-
 	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
 	ini = &scb_ampdu->ini[tid];
 
@@ -900,7 +898,6 @@ wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 	if (likely(scb)) {
 		scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
 		ini = SCB_AMPDU_INI(scb_ampdu, p->priority);
-		ASSERT(ini->scb == scb);
 		wlc_ampdu_dotxstatus_complete(ampdu, scb, p, txs, s1, s2);
 	} else {
 		/* loop through all pkts and free */
@@ -983,13 +980,13 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
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
1.7.4.1


