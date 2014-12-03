Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:63570 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaLCUFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 15:05:40 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/7] brcmfmac: Fix ifidx for rx data by msgbuf.
Date: Wed, 3 Dec 2014 21:05:28 +0100
Message-ID: <1417637133-6966-3-git-send-email-arend@broadcom.com> (sfid-20141203_210552_340386_85C85310)
In-Reply-To: <1417637133-6966-1-git-send-email-arend@broadcom.com>
References: <1417637133-6966-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The ifidx provided by FW needs to be offsetted when receiving data
packets.

Cc: stable@vger.kernel.org # v3.17, v3.18
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 5b0b70f..456944a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -1080,8 +1080,17 @@ brcmf_msgbuf_rx_skb(struct brcmf_msgbuf *msgbuf, struct sk_buff *skb,
 {
 	struct brcmf_if *ifp;
 
+	/* The ifidx is the idx to map to matching netdev/ifp. When receiving
+	 * events this is easy because it contains the bssidx which maps
+	 * 1-on-1 to the netdev/ifp. But for data frames the ifidx is rcvd.
+	 * bssidx 1 is used for p2p0 and no data can be received or
+	 * transmitted on it. Therefor bssidx is ifidx + 1 if ifidx > 0
+	 */
+	if (ifidx)
+		(ifidx)++;
 	ifp = msgbuf->drvr->iflist[ifidx];
 	if (!ifp || !ifp->ndev) {
+		brcmf_err("Received pkt for invalid ifidx %d\n", ifidx);
 		brcmu_pkt_buf_free_skb(skb);
 		return;
 	}
-- 
1.9.1

