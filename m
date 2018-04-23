Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:2854 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755433AbeDWQey (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:34:54 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 02/33] staging: wilc1000: removed unused static variables for gtk and ptk information
Date: Mon, 23 Apr 2018 22:03:04 +0530
Message-ID: <1524501215-4963-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183520_607528_F572CF68)
In-Reply-To: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
References: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed the unnecessary static variables used to store gtk and ptk
information. Key data stored in the params was never access using these
variables.

Variables given below are removed

g_add_gtk_key_params;
g_key_gtk_params;
g_add_ptk_key_params;
g_key_ptk_params;
g_key_wep_params;
g_ptk_keys_saved;
g_gtk_keys_saved;
g_wep_keys_saved;

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 80 -----------------------
 1 file changed, 80 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f9a95f2..402f12e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -166,15 +166,6 @@ struct add_key_params {
 	u8 *mac_addr;
 };
 
-static struct add_key_params g_add_gtk_key_params;
-static struct wilc_wfi_key g_key_gtk_params;
-static struct add_key_params g_add_ptk_key_params;
-static struct wilc_wfi_key g_key_ptk_params;
-static struct wilc_wfi_wep_key g_key_wep_params;
-static bool g_ptk_keys_saved;
-static bool g_gtk_keys_saved;
-static bool g_wep_keys_saved;
-
 #define AGING_TIME	(9 * 1000)
 #define during_ip_time	15000
 
@@ -739,12 +730,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			priv->WILC_WFI_wep_key_len[sme->key_idx] = sme->key_len;
 			memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
 
-			g_key_wep_params.key_len = sme->key_len;
-			g_key_wep_params.key = kmalloc(sme->key_len, GFP_KERNEL);
-			memcpy(g_key_wep_params.key, sme->key, sme->key_len);
-			g_key_wep_params.key_idx = sme->key_idx;
-			g_wep_keys_saved = true;
-
 			wilc_set_wep_default_keyid(vif, sme->key_idx);
 			wilc_add_wep_key_bss_sta(vif, sme->key, sme->key_len,
 						 sme->key_idx);
@@ -754,12 +739,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			priv->WILC_WFI_wep_key_len[sme->key_idx] = sme->key_len;
 			memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
 
-			g_key_wep_params.key_len = sme->key_len;
-			g_key_wep_params.key = kmalloc(sme->key_len, GFP_KERNEL);
-			memcpy(g_key_wep_params.key, sme->key, sme->key_len);
-			g_key_wep_params.key_idx = sme->key_idx;
-			g_wep_keys_saved = true;
-
 			wilc_set_wep_default_keyid(vif, sme->key_idx);
 			wilc_add_wep_key_bss_sta(vif, sme->key, sme->key_len,
 						 sme->key_idx);
@@ -1012,27 +991,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					keylen = params->key_len - 16;
 				}
 
-				if (!g_gtk_keys_saved && netdev == wl->vif[0]->ndev) {
-					g_add_gtk_key_params.key_idx = key_index;
-					g_add_gtk_key_params.pairwise = pairwise;
-					if (!mac_addr) {
-						g_add_gtk_key_params.mac_addr = NULL;
-					} else {
-						g_add_gtk_key_params.mac_addr = kmalloc(ETH_ALEN, GFP_KERNEL);
-						memcpy(g_add_gtk_key_params.mac_addr, mac_addr, ETH_ALEN);
-					}
-					g_key_gtk_params.key_len = params->key_len;
-					g_key_gtk_params.seq_len = params->seq_len;
-					g_key_gtk_params.key =  kmalloc(params->key_len, GFP_KERNEL);
-					memcpy(g_key_gtk_params.key, params->key, params->key_len);
-					if (params->seq_len > 0) {
-						g_key_gtk_params.seq =  kmalloc(params->seq_len, GFP_KERNEL);
-						memcpy(g_key_gtk_params.seq, params->seq, params->seq_len);
-					}
-					g_key_gtk_params.cipher = params->cipher;
-					g_gtk_keys_saved = true;
-				}
-
 				wilc_add_rx_gtk(vif, params->key, keylen,
 						key_index, params->seq_len,
 						params->seq, rx_mic,
@@ -1045,27 +1003,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					keylen = params->key_len - 16;
 				}
 
-				if (!g_ptk_keys_saved && netdev == wl->vif[0]->ndev) {
-					g_add_ptk_key_params.key_idx = key_index;
-					g_add_ptk_key_params.pairwise = pairwise;
-					if (!mac_addr) {
-						g_add_ptk_key_params.mac_addr = NULL;
-					} else {
-						g_add_ptk_key_params.mac_addr = kmalloc(ETH_ALEN, GFP_KERNEL);
-						memcpy(g_add_ptk_key_params.mac_addr, mac_addr, ETH_ALEN);
-					}
-					g_key_ptk_params.key_len = params->key_len;
-					g_key_ptk_params.seq_len = params->seq_len;
-					g_key_ptk_params.key =  kmalloc(params->key_len, GFP_KERNEL);
-					memcpy(g_key_ptk_params.key, params->key, params->key_len);
-					if (params->seq_len > 0) {
-						g_key_ptk_params.seq =  kmalloc(params->seq_len, GFP_KERNEL);
-						memcpy(g_key_ptk_params.seq, params->seq, params->seq_len);
-					}
-					g_key_ptk_params.cipher = params->cipher;
-					g_ptk_keys_saved = true;
-				}
-
 				wilc_add_ptk(vif, params->key, keylen,
 					     mac_addr, rx_mic, tx_mic,
 					     STATION_MODE, u8mode, key_index);
@@ -1095,13 +1032,6 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	wl = vif->wilc;
 
 	if (netdev == wl->vif[0]->ndev) {
-		g_ptk_keys_saved = false;
-		g_gtk_keys_saved = false;
-		g_wep_keys_saved = false;
-
-		kfree(g_key_wep_params.key);
-		g_key_wep_params.key = NULL;
-
 		if (priv->wilc_gtk[key_index] != NULL) {
 			kfree(priv->wilc_gtk[key_index]->key);
 			priv->wilc_gtk[key_index]->key = NULL;
@@ -1120,16 +1050,6 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 			kfree(priv->wilc_ptk[key_index]);
 			priv->wilc_ptk[key_index] = NULL;
 		}
-
-		kfree(g_key_ptk_params.key);
-		g_key_ptk_params.key = NULL;
-		kfree(g_key_ptk_params.seq);
-		g_key_ptk_params.seq = NULL;
-
-		kfree(g_key_gtk_params.key);
-		g_key_gtk_params.key = NULL;
-		kfree(g_key_gtk_params.seq);
-		g_key_gtk_params.seq = NULL;
 	}
 
 	if (key_index >= 0 && key_index <= 3) {
-- 
2.7.4
