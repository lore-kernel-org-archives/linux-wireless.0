Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2171 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab2CBV4K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:56:10 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 7/7] brcm80211: smac: cleanup couple of debug output
 statements
Date: Fri, 2 Mar 2012 22:55:51 +0100
Message-ID: <1330725351-3803-8-git-send-email-arend@broadcom.com> (sfid-20120302_225614_737807_43711970)
In-Reply-To: <1330725351-3803-1-git-send-email-arend@broadcom.com>
References: <1330725351-3803-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tidying up some debug statements in brcms_c_ampdu_dotxstatus_complete()
that got broken strings to satisfy checkpatch, but the rules changed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index dbee696..95b5902 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -959,14 +959,13 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		if (supr_status) {
 			update_rate = false;
 			if (supr_status == TX_STATUS_SUPR_BADCH) {
-				wiphy_err(wiphy, "%s: Pkt tx suppressed, "
-					  "illegal channel possibly %d\n",
+				wiphy_err(wiphy,
+					  "%s: Pkt tx suppressed, illegal channel possibly %d\n",
 					  __func__, CHSPEC_CHANNEL(
 					  wlc->default_bss->chanspec));
 			} else {
 				if (supr_status != TX_STATUS_SUPR_FRAG)
-					wiphy_err(wiphy, "%s:"
-						  "supr_status 0x%x\n",
+					wiphy_err(wiphy, "%s: supr_status 0x%x\n",
 						  __func__, supr_status);
 			}
 			/* no need to retry for badch; will fail again */
@@ -988,9 +987,8 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			}
 		} else if (txs->phyerr) {
 			update_rate = false;
-			wiphy_err(wiphy, "wl%d: ampdu tx phy "
-				  "error (0x%x)\n", wlc->pub->unit,
-				  txs->phyerr);
+			wiphy_err(wiphy, "%s: ampdu tx phy error (0x%x)\n",
+				  __func__, txs->phyerr);
 
 			if (brcm_msg_level & LOG_ERROR_VAL) {
 				brcmu_prpkt("txpkt (AMPDU)", p);
@@ -1018,10 +1016,10 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		ack_recd = false;
 		if (ba_recd) {
 			bindex = MODSUB_POW2(seq, start_seq, SEQNUM_MAX);
-			BCMMSG(wlc->wiphy, "tid %d seq %d,"
-				" start_seq %d, bindex %d set %d, index %d\n",
-				tid, seq, start_seq, bindex,
-				isset(bitmap, bindex), index);
+			BCMMSG(wiphy,
+			       "tid %d seq %d, start_seq %d, bindex %d set %d, index %d\n",
+			       tid, seq, start_seq, bindex,
+			       isset(bitmap, bindex), index);
 			/* if acked then clear bit and free packet */
 			if ((bindex < AMPDU_TX_BA_MAX_WSIZE)
 			    && isset(bitmap, bindex)) {
-- 
1.7.5.4


