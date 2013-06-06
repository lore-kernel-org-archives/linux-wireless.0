Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1442 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932543Ab3FFLUD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:20:03 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 21/22] brcmfmac: increment hard_header_len instead of
 overriding
Date: Thu, 6 Jun 2013 13:18:06 +0200
Message-ID: <1370517487-14395-22-git-send-email-arend@broadcom.com> (sfid-20130606_132014_756104_1D86F4A0)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_net_attach() the hard_header_len is set to sum of ETH_HLEN
and the headroom needed by the bus interface. Better use increment
instead as hard_header_len is already initialized upon alloc_netdev().

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 6d6ff33..05d7598 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -640,7 +640,7 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 	/* set appropriate operations */
 	ndev->netdev_ops = &brcmf_netdev_ops_pri;
 
-	ndev->hard_header_len = ETH_HLEN + drvr->hdrlen;
+	ndev->hard_header_len += drvr->hdrlen;
 	ndev->ethtool_ops = &brcmf_ethtool_ops;
 
 	drvr->rxsz = ndev->mtu + ndev->hard_header_len +
-- 
1.7.10.4


