Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1521 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab3FGJDK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 05:03:10 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH] brcmfmac: free primary net_device when
 brcmf_bus_start() fails
Date: Fri, 7 Jun 2013 11:03:00 +0200
Message-ID: <1370595780-5904-1-git-send-email-arend@broadcom.com> (sfid-20130607_110320_434210_FE8E582F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When initialization within brcmf_bus_start() fails on steps
before the brcmf_net_attach() the net_device for the primary
interface needs to be freed.

This patch resolves a panic during kernel boot as reported
by Stephen Warren.

ref.: http://mid.gmane.org/51AD1F22.2080004@wwwdotorg.org

Tested-by: Stephen Warren <swarren@nvidia.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 2982886..8c402e7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -941,6 +941,10 @@ fail:
 			brcmf_fws_del_interface(ifp);
 			brcmf_fws_deinit(drvr);
 		}
+		if (drvr->iflist[0]) {
+			free_netdev(ifp->ndev);
+			drvr->iflist[0] = NULL;
+		}
 		if (p2p_ifp) {
 			free_netdev(p2p_ifp->ndev);
 			drvr->iflist[1] = NULL;
-- 
1.7.10.4


