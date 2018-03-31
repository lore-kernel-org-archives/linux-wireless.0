Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:46877 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752931AbeCaHFz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Mar 2018 03:05:55 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH 07/12] brcmfmac: Convert ALLFFMAC to ether_broadcast_addr
Date: Sat, 31 Mar 2018 00:05:22 -0700
Message-Id: <f60d14eaf9027774cff547b82cfb01d0904f6391.1522479608.git.joe@perches.com> (sfid-20180331_090907_301129_DA3CBA32)
In-Reply-To: <cover.1522479607.git.joe@perches.com>
References: <cover.1522479607.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the local ALLFFMAC extern array and use the new global instead.

Miscellanea:

o Convert char *mac to const char *mac as it can't be modified

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c   | 2 --
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h   | 2 --
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c | 8 ++++----
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 105b8774fca9..cd3651069d0c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -36,8 +36,6 @@ MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
 MODULE_LICENSE("Dual BSD/GPL");
 
-const u8 ALLFFMAC[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-
 #define BRCMF_DEFAULT_SCAN_CHANNEL_TIME	40
 #define BRCMF_DEFAULT_SCAN_UNASSOC_TIME	40
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index ef914619e8e1..a34642cb4d2f 100644
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
index d0b738da2458..f042531dd43c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
@@ -73,13 +73,13 @@ u32 brcmf_flowring_lookup(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 	bool found;
 	bool sta;
 	u8 fifo;
-	u8 *mac;
+	const u8 *mac;
 
 	fifo = brcmf_flowring_prio2fifo[prio];
 	sta = (flow->addr_mode[ifidx] == ADDR_INDIRECT);
 	mac = da;
 	if ((!sta) && (is_multicast_ether_addr(da))) {
-		mac = (u8 *)ALLFFMAC;
+		mac = ether_broadcast_addr;
 		fifo = 0;
 	}
 	if ((sta) && (flow->tdls_active) &&
@@ -118,13 +118,13 @@ u32 brcmf_flowring_create(struct brcmf_flowring *flow, u8 da[ETH_ALEN],
 	bool found;
 	u8 fifo;
 	bool sta;
-	u8 *mac;
+	const u8 *mac;
 
 	fifo = brcmf_flowring_prio2fifo[prio];
 	sta = (flow->addr_mode[ifidx] == ADDR_INDIRECT);
 	mac = da;
 	if ((!sta) && (is_multicast_ether_addr(da))) {
-		mac = (u8 *)ALLFFMAC;
+		mac = ether_broadcast_addr;
 		fifo = 0;
 	}
 	if ((sta) && (flow->tdls_active) &&
-- 
2.15.0
