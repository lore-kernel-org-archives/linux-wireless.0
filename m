Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2420 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab2FIVZZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 17:25:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/5] brcmsmac: fix smatch warning found in ampdu.c
Date: Sat, 9 Jun 2012 22:51:42 +0200
Message-ID: <1339275105-3593-3-git-send-email-arend@broadcom.com> (sfid-20120609_232528_729771_0BD8CCED)
In-Reply-To: <1339275105-3593-1-git-send-email-arend@broadcom.com>
References: <1339275105-3593-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes potential NULL pointer dereference in ampdu. This
was found running smatch static code checker. Smatch warning says:

drivers/net/wireless/brcm80211/brcmsmac/ampdu.c:741 brcms_c_sendampdu()
	 warn: variable dereferenced before check 'p'

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 95b5902..01b190a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -735,10 +735,8 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 		 * a candidate for aggregation
 		 */
 		p = pktq_ppeek(&qi->q, prec);
-		/* tx_info must be checked with current p */
-		tx_info = IEEE80211_SKB_CB(p);
-
 		if (p) {
+			tx_info = IEEE80211_SKB_CB(p);
 			if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) &&
 			    ((u8) (p->priority) == tid)) {
 				plen = p->len + AMPDU_MAX_MPDU_OVERHEAD;
@@ -759,6 +757,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 					p = NULL;
 					continue;
 				}
+				/* next packet fit for aggregation so dequeue */
 				p = brcmu_pktq_pdeq(&qi->q, prec);
 			} else {
 				p = NULL;
-- 
1.7.9.5


