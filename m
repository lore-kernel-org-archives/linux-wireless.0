Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3932 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab2BIUJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>,
	"Stanislaw Gruszka" <sgruszka@redhat.com>
Subject: [PATCH 04/15] brcm80211: smac: fix endless retry of A-MPDU
 transmissions
Date: Thu, 9 Feb 2012 21:08:58 +0100
Message-ID: <1328818149-4826-5-git-send-email-arend@broadcom.com> (sfid-20120209_211027_503145_415A0465)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The A-MPDU code checked against a retry limit, but it was using
the wrong variable to do so. This patch fixes this to assure
proper retry mechanism.

This problem had a side-effect causing the mac80211 flush callback
to remain waiting forever as well. That side effect has been fixed
by commit by Stanislaw Gruszka:

commit f96b08a7e6f69c0f0a576554df3df5b1b519c479
Date:   Tue Jan 17 12:38:50 2012 +0100

    brcmsmac: fix tx queue flush infinite loop

    Reference:
    https://bugzilla.kernel.org/show_bug.cgi?id=42576

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index d89dcb1..c1ce831 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -1051,17 +1051,13 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		}
 		/* either retransmit or send bar if ack not recd */
 		if (!ack_recd) {
-			struct ieee80211_tx_rate *txrate =
-			    tx_info->status.rates;
-			if (retry && (txrate[0].count < (int)retry_limit)) {
+			if (retry && (ini->txretry[index] < (int)retry_limit)) {
 				ini->txretry[index]++;
 				ini->tx_in_transit--;
 				/*
 				 * Use high prededence for retransmit to
 				 * give some punch
 				 */
-				/* brcms_c_txq_enq(wlc, scb, p,
-				 * BRCMS_PRIO_TO_PREC(tid)); */
 				brcms_c_txq_enq(wlc, scb, p,
 						BRCMS_PRIO_TO_HI_PREC(tid));
 			} else {
-- 
1.7.5.4


