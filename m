Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:44234 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754648AbeDZKRN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 06:17:13 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/6] brcmfmac: check p2pdev mac address uniqueness
Date: Thu, 26 Apr 2018 12:16:47 +0200
Message-Id: <1524737811-1965-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180426_121725_358173_570CD0CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac address for p2pdev must be different from the primary interface
due to firmware requirement. Add an explicit check for this requirement
if user-space provides a mac address.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index bcef208..4b2149b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2073,6 +2073,13 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	}
 
 	pri_ifp = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
+
+	/* firmware requires unique mac address for p2pdev interface */
+	if (addr && ether_addr_equal(addr, pri_ifp->mac_addr)) {
+		brcmf_err("discovery vif must be different from primary interface\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	brcmf_p2p_generate_bss_mac(p2p, addr);
 	brcmf_p2p_set_firmware(pri_ifp, p2p->dev_addr);
 
-- 
1.9.1
