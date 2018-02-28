Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:54082 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934329AbeB1UP1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 15:15:27 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.16 V3 2/2] brcmfmac: fix P2P_DEVICE ethernet address generation
Date: Wed, 28 Feb 2018 21:15:20 +0100
Message-Id: <1519848920-18000-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180228_211553_955531_8C93931C)
In-Reply-To: <1519848920-18000-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1519848920-18000-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware has a requirement that the P2P_DEVICE address should
be different from the address of the primary interface. When not
specified by user-space, the driver generates the MAC address for
the P2P_DEVICE interface using the MAC address of the primary
interface and setting the locally administered bit. However, the MAC
address of the primary interface may already have that bit set causing
the creation of the P2P_DEVICE interface to fail with -EBUSY. Fix this
by using a random address instead to determine the P2P_DEVICE address.

Cc: stable@vger.kernel.org # 3.10.y
Reported-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 V3:
  - use eth_random_addr() suggested by Hans.
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 24 ++++++++++------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 2ee5413..82064e9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -462,25 +462,23 @@ static int brcmf_p2p_set_firmware(struct brcmf_if *ifp, u8 *p2p_mac)
  * @dev_addr: optional device address.
  *
  * P2P needs mac addresses for P2P device and interface. If no device
- * address it specified, these are derived from the primary net device, ie.
- * the permanent ethernet address of the device.
+ * address it specified, these are derived from a random ethernet
+ * address.
  */
 static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p, u8 *dev_addr)
 {
-	struct brcmf_if *pri_ifp = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
-	bool local_admin = false;
+	bool random_addr = false;
 
-	if (!dev_addr || is_zero_ether_addr(dev_addr)) {
-		dev_addr = pri_ifp->mac_addr;
-		local_admin = true;
-	}
+	if (!dev_addr || is_zero_ether_addr(dev_addr))
+		random_addr = true;
 
-	/* Generate the P2P Device Address.  This consists of the device's
-	 * primary MAC address with the locally administered bit set.
+	/* Generate the P2P Device Address obtaining a random ethernet
+	 * address with the locally administered bit set.
 	 */
-	memcpy(p2p->dev_addr, dev_addr, ETH_ALEN);
-	if (local_admin)
-		p2p->dev_addr[0] |= 0x02;
+	if (random_addr)
+		eth_random_addr(p2p->dev_addr);
+	else
+		memcpy(p2p->dev_addr, dev_addr, ETH_ALEN);
 
 	/* Generate the P2P Interface Address.  If the discovery and connection
 	 * BSSCFGs need to simultaneously co-exist, then this address must be
-- 
1.9.1
