Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:36282 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbeCTQ4b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 12:56:31 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 11/11] staging: wilc1000: remove line over 80 char warning in few functions
Date: Tue, 20 Mar 2018 22:25:44 +0530
Message-ID: <1521564944-3565-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180320_175635_165953_14103C7F)
In-Reply-To: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
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
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b9bba86..69f1e06 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -823,7 +823,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
-static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_code)
+static int disconnect(struct wiphy *wiphy, struct net_device *dev,
+		      u16 reason_code)
 {
 	s32 ret = 0;
 	struct wilc_priv *priv;
@@ -1267,7 +1268,8 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
 		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
 			    ETH_ALEN)) {
-			memset(&priv->pmkid_list.pmkidlist[i], 0, sizeof(struct host_if_pmkid));
+			memset(&priv->pmkid_list.pmkidlist[i], 0,
+			       sizeof(struct host_if_pmkid));
 			break;
 		}
 	}
@@ -1979,7 +1981,8 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		memcpy(sta_params.bssid, mac, ETH_ALEN);
-		memcpy(priv->assoc_stainfo.sta_associated_bss[params->aid], mac, ETH_ALEN);
+		memcpy(priv->assoc_stainfo.sta_associated_bss[params->aid], mac,
+		       ETH_ALEN);
 		sta_params.aid = params->aid;
 		sta_params.rates_len = params->supported_rates_len;
 		sta_params.rates = params->supported_rates;
@@ -2235,7 +2238,8 @@ static struct wireless_dev *wilc_wfi_cfg_alloc(void)
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
