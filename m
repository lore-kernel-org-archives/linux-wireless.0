Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1533 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759982Ab3BHO4g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:36 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/27] brcmfmac: fix generation of the p2p related mac
 addresses
Date: Fri, 8 Feb 2013 15:53:40 +0100
Message-ID: <1360335242-12608-6-git-send-email-arend@broadcom.com> (sfid-20130208_155643_311369_EECB1A5E)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver determines the P2P interface address and device
address from the primary mac address. However, the function
used an invalid input. This caused a mac address mismatch
between firmware and driver. This was hidden because the
brcmf_if_add() function corrected the error upon receiving
the IF_ADD event from firmware.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index ecc96f3..cec4116 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -132,12 +132,10 @@ static int brcmf_p2p_set_firmware(struct brcmf_p2p_info *p2p)
  */
 static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p)
 {
-	struct net_device *ndev = cfg_to_ndev(p2p->cfg);
-
 	/* Generate the P2P Device Address.  This consists of the device's
 	 * primary MAC address with the locally administered bit set.
 	 */
-	memcpy(p2p->dev_addr, ndev->dev_addr, ETH_ALEN);
+	memcpy(p2p->dev_addr, p2p->cfg->pub->mac, ETH_ALEN);
 	p2p->dev_addr[0] |= 0x02;
 
 	/* Generate the P2P Interface Address.  If the discovery and connection
-- 
1.7.10.4


