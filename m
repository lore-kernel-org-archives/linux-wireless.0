Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4282 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727Ab3BFRlJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:41:09 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/12] brcmfmac: Remove copy mac address from drvr at
 netdev up.
Date: Wed, 6 Feb 2013 18:40:37 +0100
Message-ID: <1360172447-2424-3-git-send-email-arend@broadcom.com> (sfid-20130206_184121_778039_EF608FF6)
In-Reply-To: <1360172447-2424-1-git-send-email-arend@broadcom.com>
References: <1360172447-2424-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

At netdev up the mac address from drvr is copied to netdev mac
address. This is incorrect and mac address was already set by
brcmf_net_attach by copying it from ifp.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 2104a4f..7554125 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -567,8 +567,6 @@ static int brcmf_netdev_open(struct net_device *ndev)
 
 	atomic_set(&drvr->pend_8021x_cnt, 0);
 
-	memcpy(ndev->dev_addr, drvr->mac, ETH_ALEN);
-
 	/* Get current TOE mode from dongle */
 	if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
 	    && (toe_ol & TOE_TX_CSUM_OL) != 0)
-- 
1.7.10.4


