Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:43332 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbbGJSbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 14:31:23 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 7/7] brcmfmac: block the correct flowring when backup queue overflow
Date: Fri, 10 Jul 2015 20:31:11 +0200
Message-ID: <1436553071-32423-8-git-send-email-arend@broadcom.com> (sfid-20150710_203136_045129_0B45301B)
In-Reply-To: <1436553071-32423-1-git-send-email-arend@broadcom.com>
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>
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
index e30f8fa..5b7a8ee 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
@@ -198,11 +198,15 @@ static void brcmf_flowring_block(struct brcmf_flowring *flow, u16 flowid,
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
@@ -213,8 +217,8 @@ static void brcmf_flowring_block(struct brcmf_flowring *flow, u16 flowid,
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

