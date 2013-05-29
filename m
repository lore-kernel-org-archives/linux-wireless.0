Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1401 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758978Ab3E2QjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 12:39:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 12/16] brcmfmac: fix invalid ifp lookup in
 firmware-signalling
Date: Wed, 29 May 2013 18:39:02 +0200
Message-ID: <1369845546-31950-13-git-send-email-arend@broadcom.com> (sfid-20130529_183937_204665_39947894)
In-Reply-To: <1369845546-31950-1-git-send-email-arend@broadcom.com>
References: <1369845546-31950-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The destination entries for firmware-signalled flow control have
the interface id stored. This needs to be translated to bsscfg
index when looking up the ifp object for the interface.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 1b0538d..b11a51b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -882,7 +882,7 @@ static void
 brcmf_fws_flow_control_check(struct brcmf_fws_info *fws, struct pktq *pq,
 			     u8 if_id)
 {
-	struct brcmf_if *ifp = fws->drvr->iflist[if_id];
+	struct brcmf_if *ifp = fws->drvr->iflist[!if_id ? 0 : if_id + 1];
 
 	if (WARN_ON(!ifp))
 		return;
-- 
1.7.10.4


