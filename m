Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35550 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934331AbeFVSne (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jun 2018 14:43:34 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Rafal Milecki <rafal@milecki.pl>
Subject: [PATCH 5/6] brcmfmac: add new feature flags for monitor mode operation
Date: Fri, 22 Jun 2018 20:43:23 +0200
Message-Id: <1529693004-20569-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180622_204349_108945_896D3939)
In-Reply-To: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add two new feature flags to be used for monitor mode. One indicating
support to enable packet capture and one indicating captured packets
from firmware already include radiotap header.

Signed-off-by: Rafal Milecki <rafal@milecki.pl>
[arend: change flags and description]
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 0ee3a25..f70fec6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -49,6 +49,7 @@ struct brcmf_feat_fwcap {
 	{ BRCMF_FEAT_MCHAN, "mchan" },
 	{ BRCMF_FEAT_P2P, "p2p" },
 	{ BRCMF_FEAT_MONITOR, "monitor" },
+	{ BRCMF_FEAT_RADIOTAP, "rtap" },
 };
 
 #ifdef DEBUG
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index 31a746b..31198d0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -33,8 +33,8 @@
  * MFP: 802.11w Management Frame Protection.
  * GSCAN: enhanced scan offload feature.
  * FWSUP: Firmware supplicant.
- * MONITOR: monitor interface
- * RADIOTAP: monitor packets include radiotap header
+ * MONITOR: firmware can pass monitor packets to host.
+ * RADIOTAP: firmware provides monitor packets including radiotap header
  */
 #define BRCMF_FEAT_LIST \
 	BRCMF_FEAT_DEF(MBSS) \
-- 
1.9.1
