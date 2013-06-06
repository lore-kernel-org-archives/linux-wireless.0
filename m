Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4844 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747Ab3FFLSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:18:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/22] brcmfmac: Correct creditmap when credit borrowing
 is active.
Date: Thu, 6 Jun 2013 13:17:54 +0200
Message-ID: <1370517487-14395-10-git-send-email-arend@broadcom.com> (sfid-20130606_131854_068912_5B73BCF7)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
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
index 682ac62..abba7f7 100644
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


