Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58938 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbbKSGxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:53:44 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/26] staging: wilc1000: rename u8P2P_oui variable
Date: Thu, 19 Nov 2015 15:56:15 +0900
Message-ID: <1447916195-24851-6-git-send-email-glen.lee@atmel.com> (sfid-20151119_075347_248914_B2A149FB)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8P2P_oui variable to p2p_oui to avoid camelcase.
And, remove the relation comment.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3b072ef..6ab4a79 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -171,8 +171,7 @@ struct p2p_mgmt_data {
 
 static u8 wlan_channel = INVALID_CHANNEL;
 static u8 curr_channel;
-
-static u8 u8P2P_oui[] = {0x50, 0x6f, 0x9A, 0x09};
+static u8 p2p_oui[] = {0x50, 0x6f, 0x9A, 0x09};
 static u8 u8P2Plocalrandom = 0x01;
 static u8 u8P2Precvrandom = 0x00;
 static u8 u8P2P_vendorspec[] = {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
@@ -1997,9 +1996,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 					break;
 
 				case PUBLIC_ACT_VENDORSPEC:
-					/*Now we have a public action vendor specific action frame, check if its a p2p public action frame
-					 * based on the standard its should have the p2p_oui attribute with the following values 50 6f 9A 09*/
-					if (!memcmp(u8P2P_oui, &buff[ACTION_SUBTYPE_ID + 1], 4)) {
+					if (!memcmp(p2p_oui, &buff[ACTION_SUBTYPE_ID + 1], 4)) {
 						if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP))	{
 							if (!bWilc_ie) {
 								for (i = P2P_PUB_ACTION_SUBTYPE; i < size; i++)	{
@@ -2016,7 +2013,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 							if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP
 							      || buff[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)) {
 								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < size; i++) {
-									if (buff[i] == P2PELEM_ATTR_ID && !(memcmp(u8P2P_oui, &buff[i + 2], 4))) {
+									if (buff[i] == P2PELEM_ATTR_ID && !(memcmp(p2p_oui, &buff[i + 2], 4))) {
 										WILC_WFI_CfgParseRxAction(&buff[i + 6], size - (i + 6));
 										break;
 									}
@@ -2292,9 +2289,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 
 				case PUBLIC_ACT_VENDORSPEC:
 				{
-					/*Now we have a public action vendor specific action frame, check if its a p2p public action frame
-					 * based on the standard its should have the p2p_oui attribute with the following values 50 6f 9A 09*/
-					if (!memcmp(u8P2P_oui, &buf[ACTION_SUBTYPE_ID + 1], 4)) {
+					if (!memcmp(p2p_oui, &buf[ACTION_SUBTYPE_ID + 1], 4)) {
 						/*For the connection of two WILC's connection generate a rand number to determine who will be a GO*/
 						if ((buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP)) {
 							if (u8P2Plocalrandom == 1 && u8P2Precvrandom < u8P2Plocalrandom) {
@@ -2311,7 +2306,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 
 								/*Search for the p2p information information element , after the Public action subtype theres a byte for teh dialog token, skip that*/
 								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
-									if (buf[i] == P2PELEM_ATTR_ID && !(memcmp(u8P2P_oui, &buf[i + 2], 4))) {
+									if (buf[i] == P2PELEM_ATTR_ID && !(memcmp(p2p_oui, &buf[i + 2], 4))) {
 										if (buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)
 											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), true, nic->iftype);
 
-- 
1.9.1

