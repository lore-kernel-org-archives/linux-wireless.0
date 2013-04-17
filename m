Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4305 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966757Ab3DQT0U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 15:26:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/10] brcmfmac: finalize transmit upon any rollback
 failure
Date: Wed, 17 Apr 2013 21:25:56 +0200
Message-ID: <1366226758-20641-9-git-send-email-arend@broadcom.com> (sfid-20130417_212633_009724_10864BE6)
In-Reply-To: <1366226758-20641-1-git-send-email-arend@broadcom.com>
References: <1366226758-20641-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All rollback failures should result in freeing of the sk_buff
by calling brcmf_txfinalize().

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 1cfec56..13518ec 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1616,7 +1616,6 @@ brcmf_fws_rollback_toq(struct brcmf_fws_info *fws, struct sk_buff *skb)
 				/* free the hanger slot */
 				brcmf_fws_hanger_poppkt(&fws->hanger, hslot,
 							&pktout, true);
-				brcmf_txfinalize(fws->drvr, skb, false);
 				rc = -EINVAL;
 				goto fail;
 			}
@@ -1650,9 +1649,10 @@ brcmf_fws_rollback_toq(struct brcmf_fws_info *fws, struct sk_buff *skb)
 
 
 fail:
-	if (rc)
+	if (rc) {
+		brcmf_txfinalize(fws->drvr, skb, false);
 		fws->stats.rollback_failed++;
-	else
+	} else
 		fws->stats.rollback_success++;
 	return rc;
 }
-- 
1.7.10.4


