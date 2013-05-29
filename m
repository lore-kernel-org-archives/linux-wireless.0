Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1463 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759340Ab3E2QjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 12:39:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 09/16] brcmfmac: Correct creditmap when credit
 borrowing is active.
Date: Wed, 29 May 2013 18:38:59 +0200
Message-ID: <1369845546-31950-10-git-send-email-arend@broadcom.com> (sfid-20130529_183943_782488_E1B092A0)
In-Reply-To: <1369845546-31950-1-git-send-email-arend@broadcom.com>
References: <1369845546-31950-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When credit borrowing is active the BE credits have been depleted,
however the worker should still be scheduled. In case of credit
borrowing correct credit map to make sure worker remains active.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index cd8b5f5..d07c2a7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1020,6 +1020,8 @@ static void brcmf_fws_return_credits(struct brcmf_fws_info *fws,
 	if (!credits)
 		return;
 
+	fws->fifo_credit_map |= 1 << fifo;
+
 	if ((fifo == BRCMF_FWS_FIFO_AC_BE) &&
 	    (fws->credits_borrowed[0])) {
 		for (lender_ac = BRCMF_FWS_FIFO_AC_VO; lender_ac >= 0;
@@ -1041,7 +1043,6 @@ static void brcmf_fws_return_credits(struct brcmf_fws_info *fws,
 		}
 	}
 
-	fws->fifo_credit_map |= 1 << fifo;
 	fws->fifo_credit[fifo] += credits;
 }
 
@@ -1675,8 +1676,10 @@ static int brcmf_fws_borrow_credit(struct brcmf_fws_info *fws)
 {
 	int lender_ac;
 
-	if (time_after(fws->borrow_defer_timestamp, jiffies))
+	if (time_after(fws->borrow_defer_timestamp, jiffies)) {
+		fws->fifo_credit_map &= ~(1 << BRCMF_FWS_FIFO_AC_BE);
 		return -ENAVAIL;
+	}
 
 	for (lender_ac = 0; lender_ac <= BRCMF_FWS_FIFO_AC_VO; lender_ac++) {
 		if (fws->fifo_credit[lender_ac]) {
@@ -1684,10 +1687,12 @@ static int brcmf_fws_borrow_credit(struct brcmf_fws_info *fws)
 			fws->fifo_credit[lender_ac]--;
 			if (fws->fifo_credit[lender_ac] == 0)
 				fws->fifo_credit_map &= ~(1 << lender_ac);
+			fws->fifo_credit_map |= (1 << BRCMF_FWS_FIFO_AC_BE);
 			brcmf_dbg(DATA, "borrow credit from: %d\n", lender_ac);
 			return 0;
 		}
 	}
+	fws->fifo_credit_map &= ~(1 << BRCMF_FWS_FIFO_AC_BE);
 	return -ENAVAIL;
 }
 
-- 
1.7.10.4


