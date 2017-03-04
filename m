Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34647 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752429AbdCDP6U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Mar 2017 10:58:20 -0500
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: w.d.hubbs@gmail.com
Cc: chris@the-brannons.com, outreachy-kernel@googlegroups.com,
        kirk@reisers.ca, samuel.thibault@ens-lyon.org,
        gregkh@linuxfoundation.org, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        linux-wireless@vger.kernel.org,
        Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 6/6] staging: wilc1000: Logical continuations should be on the previous line
Date: Sat,  4 Mar 2017 21:27:40 +0530
Message-Id: <20170304155740.26105-7-arushisinghal19971997@gmail.com> (sfid-20170304_165853_242627_1738BC2D)
In-Reply-To: <20170304155740.26105-1-arushisinghal19971997@gmail.com>
References: <20170304155740.26105-1-arushisinghal19971997@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the checkpatch issue:
CHECK: Logical continuations should be on the previous line.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 drivers/staging/wilc1000/wilc_spi.c               |  4 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index fb7ccfc29a19..5e28adc95371 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -454,8 +454,8 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 		return N_FAIL;
 	}
 
-	if ((cmd == CMD_INTERNAL_READ) || (cmd == CMD_SINGLE_READ)
-	    || (cmd == CMD_DMA_READ) || (cmd == CMD_DMA_EXT_READ)) {
+	if ((cmd == CMD_INTERNAL_READ) || (cmd == CMD_SINGLE_READ) ||
+	    (cmd == CMD_DMA_READ) || (cmd == CMD_DMA_EXT_READ)) {
 		int retry;
 		/* u16 crc1, crc2; */
 		u8 crc[2];
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 8cb7506bd0e5..54412e97d45b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -765,8 +765,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
-	if ((sme->crypto.wpa_versions & NL80211_WPA_VERSION_1)
-	    || (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2)) {
+	if ((sme->crypto.wpa_versions & NL80211_WPA_VERSION_1) ||
+	    (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2)) {
 		for (i = 0; i < sme->crypto.n_ciphers_pairwise; i++) {
 			if (sme->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_TKIP)
 				u8security = u8security | TKIP;
@@ -1497,8 +1497,8 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 							}
 						}
 						if (p2p_local_random > p2p_recv_random)	{
-							if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP
-							      || buff[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)) {
+							if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP ||
+							     buff[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)) {
 								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < size; i++) {
 									if (buff[i] == P2PELEM_ATTR_ID && !(memcmp(p2p_oui, &buff[i + 2], 4))) {
 										WILC_WFI_CfgParseRxAction(&buff[i + 6], size - (i + 6));
@@ -1682,8 +1682,8 @@ static int mgmt_tx(struct wiphy *wiphy,
 							}
 						}
 
-						if ((buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP
-						      || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)) {
+						if ((buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP ||
+						     buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)) {
 							if (p2p_local_random > p2p_recv_random)	{
 								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
 									if (buf[i] == P2PELEM_ATTR_ID && !(memcmp(p2p_oui, &buf[i + 2], 4))) {
-- 
2.11.0
