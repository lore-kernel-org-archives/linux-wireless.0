Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4847 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757Ab3FFLTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:19:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/22] brcmfmac: On bus flow control use fw signalling
 or netif.
Date: Thu, 6 Jun 2013 13:17:52 +0200
Message-ID: <1370517487-14395-8-git-send-email-arend@broadcom.com> (sfid-20130606_131921_256883_72F204E1)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
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
index 2fee9b6..6d6ff33 100644
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


