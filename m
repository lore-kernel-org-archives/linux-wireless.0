Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4879 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966747Ab3DQT0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 15:26:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/10] brcmfmac: remove error message upon allocation
 failure
Date: Wed, 17 Apr 2013 21:25:51 +0200
Message-ID: <1366226758-20641-4-git-send-email-arend@broadcom.com> (sfid-20130417_212625_745069_F2C68D3C)
In-Reply-To: <1366226758-20641-1-git-send-email-arend@broadcom.com>
References: <1366226758-20641-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In function brcmf_add_if() an error message is printed
upon alloc_netdev() failure. The allocation failure itself
spews enough info in the log so remove the error message.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 269fde2..a0afef2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -760,10 +760,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 		brcmf_dbg(INFO, "allocate netdev interface\n");
 		/* Allocate netdev, including space for private structure */
 		ndev = alloc_netdev(sizeof(*ifp), name, ether_setup);
-		if (!ndev) {
-			brcmf_err("OOM - alloc_netdev\n");
+		if (!ndev)
 			return ERR_PTR(-ENOMEM);
-		}
 
 		ifp = netdev_priv(ndev);
 		ifp->ndev = ndev;
-- 
1.7.10.4


