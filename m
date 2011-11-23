Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4819 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759554Ab1KWBWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:15 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/24] brcm80211: fmac: discard packet received when net
 device not registered
Date: Tue, 22 Nov 2011 17:21:46 -0800
Message-ID: <1322011319-24863-12-git-send-email-frankyl@broadcom.com> (sfid-20111123_022238_274366_F87DE755)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new feature in the dongle firmware requires a handshake during
firmware intialization. The request is sent in event packets which the
host driver is not able to handle before any net device registered.
Discard those packets as the context for handling it is missing.
The initialization handler will be added as part of feature support
code in the future.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 7af1413..62413e8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -431,6 +431,12 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
 		if (ifp == NULL)
 			ifp = drvr_priv->iflist[0];
 
+		if (!ifp || !ifp->ndev ||
+		    ifp->ndev->reg_state != NETREG_REGISTERED) {
+			brcmu_pkt_buf_free_skb(skb);
+			continue;
+		}
+
 		skb->dev = ifp->ndev;
 		skb->protocol = eth_type_trans(skb, skb->dev);
 
-- 
1.7.5.4


