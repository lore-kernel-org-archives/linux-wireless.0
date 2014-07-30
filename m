Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:11760 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaG3LUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 07:20:11 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/8] brcmfmac: Export brcmf_netif_rx for new protocol msgbuf.
Date: Wed, 30 Jul 2014 13:20:01 +0200
Message-ID: <1406719207-5126-3-git-send-email-arend@broadcom.com> (sfid-20140730_132018_574540_D9A1F125)
In-Reply-To: <1406719207-5126-1-git-send-email-arend@broadcom.com>
References: <1406719207-5126-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h       | 1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 7da6441..1825f73 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -181,6 +181,7 @@ void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
 void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp, u8 ifidx,
 		      bool success);
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 
 /* Sets dongle media info (drv_version, mac address). */
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index bf44808..7e14e5f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -288,7 +288,7 @@ void brcmf_txflowblock(struct device *dev, bool state)
 	brcmf_fws_bus_blocked(drvr, state);
 }
 
-static void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 {
 	skb->dev = ifp->ndev;
 	skb->protocol = eth_type_trans(skb, skb->dev);
-- 
1.9.1

