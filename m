Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35540 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934322AbeFVSnd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jun 2018 14:43:33 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/6] brcmfmac: rename BRCMF_FEAT_MONITOR_FMT_RADIOTAP to BRCMF_FEAT_RADIOTAP
Date: Fri, 22 Jun 2018 20:43:20 +0200
Message-Id: <1529693004-20569-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180622_204350_923836_D5066E8F)
In-Reply-To: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a bit of bike-shedding so nothing functionally changed.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c    | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index b1f702f..d3fdbb3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -407,7 +407,7 @@ void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 
 void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 {
-	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MONITOR_FMT_RADIOTAP)) {
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_RADIOTAP)) {
 		/* Do nothing */
 	} else {
 		struct ieee80211_radiotap_header *radiotap;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index 0782f2a..31a746b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -34,7 +34,7 @@
  * GSCAN: enhanced scan offload feature.
  * FWSUP: Firmware supplicant.
  * MONITOR: monitor interface
- * MONITOR_FMT_RADIOTAP: monitor packets include radiotap header
+ * RADIOTAP: monitor packets include radiotap header
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
@@ -52,7 +52,7 @@
 	BRCMF_FEAT_DEF(GSCAN) \
 	BRCMF_FEAT_DEF(FWSUP) \
 	BRCMF_FEAT_DEF(MONITOR) \
-	BRCMF_FEAT_DEF(MONITOR_FMT_RADIOTAP)
+	BRCMF_FEAT_DEF(RADIOTAP)
 
 /*
  * Quirks:
-- 
1.9.1
