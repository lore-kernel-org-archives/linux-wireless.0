Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4980 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759119Ab3E2QjT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 12:39:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 07/16] brcmfmac: On bus flow control use fw
 signalling or netif.
Date: Wed, 29 May 2013 18:38:57 +0200
Message-ID: <1369845546-31950-8-git-send-email-arend@broadcom.com> (sfid-20130529_183930_152452_A4FF30A0)
In-Reply-To: <1369845546-31950-1-git-send-email-arend@broadcom.com>
References: <1369845546-31950-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Currently on a bus flow control both fws is informed and netif queue
gets closed. In case of fw signalling enabled, let the flow control
be handled by fw signalling only.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 9450d10..63cadf6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -269,11 +269,14 @@ void brcmf_txflowblock(struct device *dev, bool state)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	brcmf_fws_bus_blocked(drvr, state);
-
-	for (i = 0; i < BRCMF_MAX_IFS; i++)
-		brcmf_txflowblock_if(drvr->iflist[i],
-				     BRCMF_NETIF_STOP_REASON_BLOCK_BUS, state);
+	if (brcmf_fws_fc_active(drvr->fws)) {
+		brcmf_fws_bus_blocked(drvr, state);
+	} else {
+		for (i = 0; i < BRCMF_MAX_IFS; i++)
+			brcmf_txflowblock_if(drvr->iflist[i],
+					     BRCMF_NETIF_STOP_REASON_BLOCK_BUS,
+					     state);
+	}
 }
 
 void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
-- 
1.7.10.4


