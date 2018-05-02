Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1383 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbeEBHPD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:03 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 03/21] staging: wilc1000: modified NULL check used for 'if' condition in delete_key()
Date: Wed, 2 May 2018 12:43:29 +0530
Message-ID: <1525245227-3924-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_092058_721309_8DF4F587)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix below issue reported by checkpatch.pl script.

'Comparison to NULL could be written "priv->wilc_gtk[key_index]"'
'Comparison to NULL could be written "priv->wilc_ptk[key_index]"'

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3ca0c97..d82a7b0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1038,7 +1038,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	wl = vif->wilc;
 
 	if (netdev == wl->vif[0]->ndev) {
-		if (priv->wilc_gtk[key_index] != NULL) {
+		if (priv->wilc_gtk[key_index]) {
 			kfree(priv->wilc_gtk[key_index]->key);
 			priv->wilc_gtk[key_index]->key = NULL;
 			kfree(priv->wilc_gtk[key_index]->seq);
@@ -1048,7 +1048,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 			priv->wilc_gtk[key_index] = NULL;
 		}
 
-		if (priv->wilc_ptk[key_index] != NULL) {
+		if (priv->wilc_ptk[key_index]) {
 			kfree(priv->wilc_ptk[key_index]->key);
 			priv->wilc_ptk[key_index]->key = NULL;
 			kfree(priv->wilc_ptk[key_index]->seq);
-- 
2.7.4
