Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:60145 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751608AbeB0Xme (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 18:42:34 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/2] brcmfmac: fix P2P_DEVICE ethernet address generation
Date: Wed, 28 Feb 2018 00:42:20 +0100
Message-Id: <1519774940-20793-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180228_004239_228001_D1208B7A)
In-Reply-To: <1519774940-20793-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1519774940-20793-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware has a requirement that the P2P_DEVICE address should
be different from the address of the primary interface. When not
specified by user-space, the driver generates the MAC address for
the P2P_DEVICE interface using the MAC address of the primary
interface and setting the locally administered bit. However, the MAC
address of the primary interface may already have that bit set causing
the creation of the P2P_DEVICE interface to fail with -EBUSY. Fix this
by using the permanent address instead to determing the P2P_DEVICE
address.

Cc: stable@vger.kernel.org # 3.10.y
Reported-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 2ee5413..ddbb386 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -462,8 +462,8 @@ static int brcmf_p2p_set_firmware(struct brcmf_if *ifp, u8 *p2p_mac)
  * @dev_addr: optional device address.
  *
  * P2P needs mac addresses for P2P device and interface. If no device
- * address it specified, these are derived from the primary net device, ie.
- * the permanent ethernet address of the device.
+ * address it specified, these are derived from the permanent ethernet
+ * address of the device.
  */
 static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p, u8 *dev_addr)
 {
@@ -471,12 +471,12 @@ static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p, u8 *dev_addr)
 	bool local_admin = false;
 
 	if (!dev_addr || is_zero_ether_addr(dev_addr)) {
-		dev_addr = pri_ifp->mac_addr;
+		dev_addr = pri_ifp->drvr->mac;
 		local_admin = true;
 	}
 
 	/* Generate the P2P Device Address.  This consists of the device's
-	 * primary MAC address with the locally administered bit set.
+	 * permanent ethernet address with the locally administered bit set.
 	 */
 	memcpy(p2p->dev_addr, dev_addr, ETH_ALEN);
 	if (local_admin)
@@ -486,7 +486,7 @@ static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p, u8 *dev_addr)
 	 * BSSCFGs need to simultaneously co-exist, then this address must be
 	 * different from the P2P Device Address, but also locally administered.
 	 */
-	memcpy(p2p->int_addr, p2p->dev_addr, ETH_ALEN);
+	memcpy(p2p->int_addr, dev_addr, ETH_ALEN);
 	p2p->int_addr[0] |= 0x02;
 	p2p->int_addr[4] ^= 0x80;
 }
-- 
1.9.1
