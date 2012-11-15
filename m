Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3385 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933217Ab2KOCrF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:47:05 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/19] brcmfmac: remove mac address validation from
 brcmf_net_attach()
Date: Wed, 14 Nov 2012 18:46:12 -0800
Message-ID: <1352947583-25341-9-git-send-email-frankyl@broadcom.com> (sfid-20121115_041525_971614_3669DF3C)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The mac_addr field in ifp object is always valid so no need to
validate.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 9a590cb..51cbc72 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -648,7 +648,6 @@ int brcmf_net_attach(struct brcmf_if *ifp)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct net_device *ndev;
-	u8 temp_addr[ETH_ALEN];
 
 	brcmf_dbg(TRACE, "ifidx %d mac %pM\n", ifp->idx, ifp->mac_addr);
 	ndev = ifp->ndev;
@@ -659,21 +658,14 @@ int brcmf_net_attach(struct brcmf_if *ifp)
 	else
 		ndev->netdev_ops = &brcmf_netdev_ops_virt;
 
-	/*
-	 * determine mac address to use
-	 */
-	if (is_valid_ether_addr(ifp->mac_addr))
-		memcpy(temp_addr, ifp->mac_addr, ETH_ALEN);
-	else
-		memcpy(temp_addr, drvr->mac, ETH_ALEN);
-
 	ndev->hard_header_len = ETH_HLEN + drvr->hdrlen;
 	ndev->ethtool_ops = &brcmf_ethtool_ops;
 
 	drvr->rxsz = ndev->mtu + ndev->hard_header_len +
 			      drvr->hdrlen;
 
-	memcpy(ndev->dev_addr, temp_addr, ETH_ALEN);
+	/* set the mac address */
+	memcpy(ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
 
 	if (register_netdev(ndev) != 0) {
 		brcmf_dbg(ERROR, "couldn't register the net device\n");
-- 
1.7.9.5


