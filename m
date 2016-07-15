Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:13899 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403AbcGOKQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2016 06:16:43 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] brcmfmac: restore stopping netdev queue when bus clogs up
Date: Fri, 15 Jul 2016 12:16:12 +0200
Message-Id: <1468577794-12606-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160715_121646_871023_7284CE54)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the host-interface bus has hard time handling transmit packets
it informs higher layer about this and it would stop the netdev
queue when needed. However, since commit 9cd18359d31e ("brcmfmac:
Make FWS queueing configurable.") this was broken. With this patch
the behaviour is restored.

Cc: stable@vger.kernel.org # v4.5, v4.6, v4.7
Fixes: 9cd18359d31e ("brcmfmac: Make FWS queueing configurable.")
Tested-by: Per Förlin <per.forlin@gmail.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Hi Kalle,

The issue fixed with this patch does not crash anything so it is
probably fine for 4.8 after the merge window. So I have marked it
for 4.7-stable.

Regards,
Arend
---
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 5b30922..2ce3199 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2469,10 +2469,22 @@ void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 void brcmf_fws_bus_blocked(struct brcmf_pub *drvr, bool flow_blocked)
 {
 	struct brcmf_fws_info *fws = drvr->fws;
+	struct brcmf_if *ifp;
+	int i;
 
-	fws->bus_flow_blocked = flow_blocked;
-	if (!flow_blocked)
-		brcmf_fws_schedule_deq(fws);
-	else
-		fws->stats.bus_flow_block++;
+	if (fws->avoid_queueing) {
+		for (i = 0; i < BRCMF_MAX_IFS; i++) {
+			ifp = drvr->iflist[i];
+			if (!ifp || !ifp->ndev)
+				continue;
+			brcmf_txflowblock_if(ifp, BRCMF_NETIF_STOP_REASON_FLOW,
+					     flow_blocked);
+		}
+	} else {
+		fws->bus_flow_blocked = flow_blocked;
+		if (!flow_blocked)
+			brcmf_fws_schedule_deq(fws);
+		else
+			fws->stats.bus_flow_block++;
+	}
 }
-- 
1.9.1

