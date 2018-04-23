Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:2854 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755597AbeDWQfN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:35:13 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 11/33] staging: wilc1000: remove line over 80 char warning in few functions
Date: Mon, 23 Apr 2018 22:03:13 +0530
Message-ID: <1524501215-4963-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183525_669758_F18DAE27)
In-Reply-To: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
References: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove 'line over 80 characters' issues found by checkpatch.pl script
for following functions.

disconnect()
del_pmksa()
wilc_create_wiphy()
del_pmksa()

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 394b606..d3818af 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -816,7 +816,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
-static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_code)
+static int disconnect(struct wiphy *wiphy, struct net_device *dev,
+		      u16 reason_code)
 {
 	s32 ret = 0;
 	struct wilc_priv *priv;
@@ -1260,7 +1261,8 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
 		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
 			    ETH_ALEN)) {
-			memset(&priv->pmkid_list.pmkidlist[i], 0, sizeof(struct host_if_pmkid));
+			memset(&priv->pmkid_list.pmkidlist[i], 0,
+			       sizeof(struct host_if_pmkid));
 			break;
 		}
 	}
@@ -1969,7 +1971,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		memcpy(sta_params.bssid, mac, ETH_ALEN);
-		memcpy(priv->assoc_stainfo.sta_associated_bss[params->aid], mac, ETH_ALEN);
+		memcpy(priv->assoc_stainfo.sta_associated_bss[params->aid], mac,
+		       ETH_ALEN);
 		sta_params.aid = params->aid;
 		sta_params.rates_len = params->supported_rates_len;
 		sta_params.rates = params->supported_rates;
@@ -2225,7 +2228,8 @@ static struct wireless_dev *wilc_wfi_cfg_alloc(void)
 	return NULL;
 }
 
-struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *dev)
+struct wireless_dev *wilc_create_wiphy(struct net_device *net,
+				       struct device *dev)
 {
 	struct wilc_priv *priv;
 	struct wireless_dev *wdev;
-- 
2.7.4
