Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:26870 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbbHTUGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 16:06:30 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V3 4/6] brcmfmac: block the correct flowring when backup queue overflow
Date: Thu, 20 Aug 2015 22:06:06 +0200
Message-ID: <1440101168-2252-5-git-send-email-arend@broadcom.com> (sfid-20150820_220632_937532_E1A2D062)
In-Reply-To: <1440101168-2252-1-git-send-email-arend@broadcom.com>
References: <1440101168-2252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

brcmf_flowring_block blocks the last active flowring under the same
interface instead of the one provided by caller. This could lead to a
dead lock of netif stop if there are more than one flowring under the
interface and the traffic is high enough so brcmf_flowring_enqueue can
not unblock the ring right away.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
index 5944063..8d1ab4a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
@@ -194,11 +194,15 @@ static void brcmf_flowring_block(struct brcmf_flowring *flow, u8 flowid,
 	spin_lock_irqsave(&flow->block_lock, flags);
 
 	ring = flow->rings[flowid];
+	if (ring->blocked == blocked) {
+		spin_unlock_irqrestore(&flow->block_lock, flags);
+		return;
+	}
 	ifidx = brcmf_flowring_ifidx_get(flow, flowid);
 
 	currently_blocked = false;
 	for (i = 0; i < flow->nrofrings; i++) {
-		if (flow->rings[i]) {
+		if ((flow->rings[i]) && (i != flowid)) {
 			ring = flow->rings[i];
 			if ((ring->status == RING_OPEN) &&
 			    (brcmf_flowring_ifidx_get(flow, i) == ifidx)) {
@@ -209,8 +213,8 @@ static void brcmf_flowring_block(struct brcmf_flowring *flow, u8 flowid,
 			}
 		}
 	}
-	ring->blocked = blocked;
-	if (currently_blocked == blocked) {
+	flow->rings[flowid]->blocked = blocked;
+	if (currently_blocked) {
 		spin_unlock_irqrestore(&flow->block_lock, flags);
 		return;
 	}
-- 
1.9.1

