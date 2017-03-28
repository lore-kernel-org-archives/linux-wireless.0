Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:41343 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754572AbdC1KoG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 06:44:06 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 4/5] brcmfmac: restore bus state when enter_D3 fails
Date: Tue, 28 Mar 2017 11:43:27 +0100
Message-Id: <1490697808-5538-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170328_124744_732258_52872A1D)
In-Reply-To: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_pcie_suspend() we inform the firmware on the device that
it will enter in D3 state. Before this is done we already bring down
the bus state. However, When entering D3 fails we abort the suspend
and the bus state need to be restored.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Change-Id: I837664ac9e06303b3a9596096f0f7c2bf7636b9a
Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/8160
Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 6fae4cf..f36b96d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1877,6 +1877,7 @@ static int brcmf_pcie_pm_enter_D3(struct device *dev)
 			   BRCMF_PCIE_MBDATA_TIMEOUT);
 	if (!devinfo->mbdata_completed) {
 		brcmf_err("Timeout on response for entering D3 substate\n");
+		brcmf_bus_change_state(bus, BRCMF_BUS_UP);
 		return -EIO;
 	}
 
-- 
1.9.1
