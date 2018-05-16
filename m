Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:48320 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752525AbeEPMMe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 08:12:34 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 1/6] brcmfmac: move ALLFFMAC variable in flowring module
Date: Wed, 16 May 2018 14:11:58 +0200
Message-Id: <1526472723-15758-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180516_141243_229104_91CD53C6)
In-Reply-To: <1526472723-15758-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1526472723-15758-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only user of ALLFFMAC is the flowring module so no need to
expose it in a header file.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Hi Kalle,

I recall Joe Perches posted patches dealing with broadcast address declarations,
but don't know what happened with those. In patchwork [1] is says 'Not Applicable'
whatever that means. I noticed Johannes set similar mac80211 change to
'Awaiting Upstream'. Anyway, when applying this patch the patch in [1] needs to
be reworked.

Regards,
Arend

[1] https://patchwork.kernel.org/patch/10318857/
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c   | 2 --
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h   | 2 --
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c | 2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 105b877..cd36510 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -36,8 +36,6 @@
 MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
 MODULE_LICENSE("Dual BSD/GPL");
 
-const u8 ALLFFMAC[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-
 #define BRCMF_DEFAULT_SCAN_CHANNEL_TIME	40
 #define BRCMF_DEFAULT_SCAN_UNASSOC_TIME	40
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index ef91461..a34642c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -19,8 +19,6 @@
 #include <linux/platform_data/brcmfmac.h>
 #include "fwil_types.h"
 
-extern const u8 ALLFFMAC[ETH_ALEN];
-
 #define BRCMF_FW_ALTPATH_LEN			256
 
 /* Definitions for the module global and device specific settings are defined
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
index d0b738d..d0d8b32 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
@@ -46,6 +46,8 @@
 	3
 };
 
+static const u8 ALLFFMAC[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+
 
 static bool
 brcmf_flowring_is_tdls_mac(struct brcmf_flowring *flow, u8 mac[ETH_ALEN])
-- 
1.9.1
