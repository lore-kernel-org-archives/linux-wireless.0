Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59009 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbbKSGyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:54:01 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/26] staging: wilc1000: rename u8P2P_vendorspec variable
Date: Thu, 19 Nov 2015 15:56:18 +0900
Message-ID: <1447916195-24851-9-git-send-email-glen.lee@atmel.com> (sfid-20151119_075405_523962_34FC5243)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8P2P_vendorspec variable to p2p_vendor_spec
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 904b214..0a7226c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -174,7 +174,7 @@ static u8 curr_channel;
 static u8 p2p_oui[] = {0x50, 0x6f, 0x9A, 0x09};
 static u8 p2p_local_random = 0x01;
 static u8 p2p_recv_random = 0x00;
-static u8 u8P2P_vendorspec[] = {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
+static u8 p2p_vendor_spec[] = {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
 static bool bWilc_ie;
 
 static struct ieee80211_supported_band WILC_WFI_band_2ghz = {
@@ -2000,7 +2000,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 						if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP))	{
 							if (!bWilc_ie) {
 								for (i = P2P_PUB_ACTION_SUBTYPE; i < size; i++)	{
-									if (!memcmp(u8P2P_vendorspec, &buff[i], 6)) {
+									if (!memcmp(p2p_vendor_spec, &buff[i], 6)) {
 										p2p_recv_random = buff[i + 6];
 										bWilc_ie = true;
 										PRINT_D(GENERIC_DBG, "WILC Vendor specific IE:%02x\n", p2p_recv_random);
@@ -2225,7 +2225,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 	struct host_if_drv *pstrWFIDrv;
 	u32 i;
 	perInterface_wlan_t *nic;
-	u32 buf_len = len + sizeof(u8P2P_vendorspec) + sizeof(p2p_local_random);
+	u32 buf_len = len + sizeof(p2p_vendor_spec) + sizeof(p2p_local_random);
 
 	nic = netdev_priv(wdev->netdev);
 	priv = wiphy_priv(wiphy);
@@ -2323,8 +2323,8 @@ static int mgmt_tx(struct wiphy *wiphy,
 									 * Adding WILC information element to allow two WILC devices to
 									 * identify each other and connect
 									 */
-									memcpy(&mgmt_tx->buff[len], u8P2P_vendorspec, sizeof(u8P2P_vendorspec));
-									mgmt_tx->buff[len + sizeof(u8P2P_vendorspec)] = p2p_local_random;
+									memcpy(&mgmt_tx->buff[len], p2p_vendor_spec, sizeof(p2p_vendor_spec));
+									mgmt_tx->buff[len + sizeof(p2p_vendor_spec)] = p2p_local_random;
 									mgmt_tx->size = buf_len;
 								}
 							} else {
-- 
1.9.1

