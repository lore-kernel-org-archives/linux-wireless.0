Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:13958 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbbJHSd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:33:26 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/11] brcmfmac: Move brcmf_c_preinit_dcmds prototype to correct file.
Date: Thu, 8 Oct 2015 20:33:19 +0200
Message-ID: <1444329201-3696-10-git-send-email-arend@broadcom.com> (sfid-20151008_203344_842254_59A4CD1D)
In-Reply-To: <1444329201-3696-1-git-send-email-arend@broadcom.com>
References: <1444329201-3696-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/common.h | 3 +++
 drivers/net/wireless/brcm80211/brcmfmac/core.c   | 1 +
 drivers/net/wireless/brcm80211/brcmfmac/core.h   | 3 ---
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/common.h b/drivers/net/wireless/brcm80211/brcmfmac/common.h
index 0d39d80..21c7488 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/common.h
@@ -17,4 +17,7 @@
 
 extern const u8 ALLFFMAC[ETH_ALEN];
 
+/* Sets dongle media info (drv_version, mac address). */
+int brcmf_c_preinit_dcmds(struct brcmf_if *ifp);
+
 #endif /* BRCMFMAC_COMMON_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index d3212bf..6e39121 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -33,6 +33,7 @@
 #include "feature.h"
 #include "proto.h"
 #include "pcie.h"
+#include "common.h"
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index d81ff95..f10fc37 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -214,7 +214,4 @@ void brcmf_txflowblock_if(struct brcmf_if *ifp,
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
 void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 
-/* Sets dongle media info (drv_version, mac address). */
-int brcmf_c_preinit_dcmds(struct brcmf_if *ifp);
-
 #endif /* BRCMFMAC_CORE_H */
-- 
1.9.1

