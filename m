Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4194 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966477Ab3DQT0N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 15:26:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/10] brcmfmac: destination mac closed when interface
 is closed
Date: Wed, 17 Apr 2013 21:25:53 +0200
Message-ID: <1366226758-20641-6-git-send-email-arend@broadcom.com> (sfid-20130417_212620_437498_AE4347B2)
In-Reply-To: <1366226758-20641-1-git-send-email-arend@broadcom.com>
References: <1366226758-20641-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware signals a destination is closed as well as an interface. A
destination is associated with an interface. When an interface is
closed consequently the destination should be considered closed as
well.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 9dae8fc..0d2ff60 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -714,11 +714,21 @@ done:
 	return entry;
 }
 
-static bool brcmf_fws_mac_desc_closed(struct brcmf_fws_mac_descriptor *entry,
+static bool brcmf_fws_mac_desc_closed(struct brcmf_fws_info *fws,
+				      struct brcmf_fws_mac_descriptor *entry,
 				      int fifo)
 {
+	struct brcmf_fws_mac_descriptor *if_entry;
 	bool closed;
 
+	/* for unique destination entries the related interface
+	 * may be closed.
+	 */
+	if (entry->mac_handle) {
+		if_entry = &fws->desc.iface[entry->interface_id];
+		if (if_entry->state == BRCMF_FWS_STATE_CLOSE)
+			return true;
+	}
 	/* an entry is closed when the state is closed and
 	 * the firmware did not request anything.
 	 */
@@ -1079,7 +1089,8 @@ static struct sk_buff *brcmf_fws_deq(struct brcmf_fws_info *fws, int fifo)
 
 	for (i = 0; i < num_nodes; i++) {
 		entry = &table[(node_pos + i) % num_nodes];
-		if (!entry->occupied || brcmf_fws_mac_desc_closed(entry, fifo))
+		if (!entry->occupied ||
+		    brcmf_fws_mac_desc_closed(fws, entry, fifo))
 			continue;
 
 		if (entry->suppressed)
@@ -1753,7 +1764,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 
 	brcmf_fws_lock(drvr, flags);
 	if (skcb->mac->suppressed ||
-	    brcmf_fws_mac_desc_closed(skcb->mac, fifo) ||
+	    brcmf_fws_mac_desc_closed(drvr->fws, skcb->mac, fifo) ||
 	    brcmu_pktq_mlen(&skcb->mac->psq, 3 << (fifo * 2)) ||
 	    (!multicast &&
 	     brcmf_fws_consume_credit(drvr->fws, fifo, skb) < 0)) {
-- 
1.7.10.4


