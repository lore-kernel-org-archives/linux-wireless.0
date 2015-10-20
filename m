Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:17137 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbbJTIPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:15:11 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/13] staging: wilc1000: add_key: use netdev private wilc instead of g_linux_wlan
Date: Tue, 20 Oct 2015 17:13:59 +0900
Message-ID: <1445328843-32247-9-git-send-email-tony.cho@atmel.com> (sfid-20151020_101601_566221_AD4020F6)
In-Reply-To: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
References: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

Use netdev private data member wilc instead of global variable g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1533804..8aea4b5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1086,8 +1086,12 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	u8 u8gmode = NO_ENCRYPT;
 	u8 u8pmode = NO_ENCRYPT;
 	enum AUTHTYPE tenuAuth_type = ANY;
+	struct wilc *wl;
+	perInterface_wlan_t *nic;
 
 	priv = wiphy_priv(wiphy);
+	nic = netdev_priv(netdev);
+	wl = nic->wilc;
 
 	PRINT_D(CFG80211_DBG, "Adding key with cipher suite = %x\n", params->cipher);
 
@@ -1259,7 +1263,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 				/*save keys only on interface 0 (wifi interface)*/
-				if (!g_gtk_keys_saved && netdev == g_linux_wlan->vif[0].ndev) {
+				if (!g_gtk_keys_saved && netdev == wl->vif[0].ndev) {
 					g_add_gtk_key_params.key_idx = key_index;
 					g_add_gtk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
@@ -1295,7 +1299,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 				}
 
 				/*save keys only on interface 0 (wifi interface)*/
-				if (!g_ptk_keys_saved && netdev == g_linux_wlan->vif[0].ndev) {
+				if (!g_ptk_keys_saved && netdev == wl->vif[0].ndev) {
 					g_add_ptk_key_params.key_idx = key_index;
 					g_add_ptk_key_params.pairwise = pairwise;
 					if (!mac_addr) {
-- 
1.9.1

