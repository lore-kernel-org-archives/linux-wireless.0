Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:43880 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1041635AbdDVH1s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Apr 2017 03:27:48 -0400
From: richard@netpro.work
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Richard Miller <richard@netpro.work>
Subject: [PATCH] staging: wilc1000: Fixes Alignment should match open parenthesis
Date: Sat, 22 Apr 2017 07:28:30 +0100
Message-Id: <20170422062830.30715-1-richard@netpro.work> (sfid-20170422_092912_975250_3B01195E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Richard Miller <richard@netpro.work>

This patch fixes the following checkpatch.pl
check: CHECK: Alignment should match open parenthesis

Signed-off-by: Richard Miller <richard@netpro.work>
---
 drivers/staging/wilc1000/host_interface.c         |  2 +-
 drivers/staging/wilc1000/linux_wlan.c             |  8 ++++----
 drivers/staging/wilc1000/wilc_spi.c               |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 19 +++++++++----------
 drivers/staging/wilc1000/wilc_wlan.c              | 12 ++++++------
 5 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c307ccef..ef25850f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1350,7 +1350,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 
 				if (u32RcvdAssocRespInfoLen != 0) {
 					s32Err = wilc_parse_assoc_resp_info(rcv_assoc_resp, u32RcvdAssocRespInfoLen,
-								    &pstrConnectRespInfo);
+					                                    &pstrConnectRespInfo);
 					if (s32Err) {
 						netdev_err(vif->ndev, "wilc_parse_assoc_resp_info() returned error %d\n", s32Err);
 					} else {
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2eebc621..1cb6f172 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -870,12 +870,12 @@ static int wilc_mac_open(struct net_device *ndev)
 				if (memcmp(wl->vif[i ^ 1]->bssid,
 					   wl->vif[i ^ 1]->src_addr, 6))
 					wilc_set_wfi_drv_handler(vif,
-							 wilc_get_vif_idx(vif),
-							 0);
+					                         wilc_get_vif_idx(vif),
+					                         0);
 				else
 					wilc_set_wfi_drv_handler(vif,
-							 wilc_get_vif_idx(vif),
-							 1);
+					                         wilc_get_vif_idx(vif),
+					                         1);
 			}
 			wilc_set_operation_mode(vif, vif->iftype);
 
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 55d53c3a..8d0c4c69 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -410,7 +410,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 
 	if (len2 > ARRAY_SIZE(wb)) {
 		dev_err(&spi->dev, "spi buffer size too small (%d) (%zu)\n",
-			 len2, ARRAY_SIZE(wb));
+		        len2, ARRAY_SIZE(wb));
 		return N_FAIL;
 	}
 	/* zero spi write buffers. */
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7961d1c5..ed398ed5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1301,16 +1301,16 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
 		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
-				 ETH_ALEN)) {
+		            ETH_ALEN)) {
 			flag = PMKID_FOUND;
 			break;
 		}
 	}
 	if (i < WILC_MAX_NUM_PMKIDS) {
 		memcpy(priv->pmkid_list.pmkidlist[i].bssid, pmksa->bssid,
-			    ETH_ALEN);
+		       ETH_ALEN);
 		memcpy(priv->pmkid_list.pmkidlist[i].pmkid, pmksa->pmkid,
-			    PMKID_LEN);
+		       PMKID_LEN);
 		if (!(flag == PMKID_FOUND))
 			priv->pmkid_list.numpmkid++;
 	} else {
@@ -1334,7 +1334,7 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
 		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
-				 ETH_ALEN)) {
+		            ETH_ALEN)) {
 			memset(&priv->pmkid_list.pmkidlist[i], 0, sizeof(struct host_if_pmkid));
 			break;
 		}
@@ -1343,11 +1343,11 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 	if (i < priv->pmkid_list.numpmkid && priv->pmkid_list.numpmkid > 0) {
 		for (; i < (priv->pmkid_list.numpmkid - 1); i++) {
 			memcpy(priv->pmkid_list.pmkidlist[i].bssid,
-				    priv->pmkid_list.pmkidlist[i + 1].bssid,
-				    ETH_ALEN);
+			       priv->pmkid_list.pmkidlist[i + 1].bssid,
+			       ETH_ALEN);
 			memcpy(priv->pmkid_list.pmkidlist[i].pmkid,
-				    priv->pmkid_list.pmkidlist[i].pmkid,
-				    PMKID_LEN);
+			       priv->pmkid_list.pmkidlist[i].pmkid,
+			       PMKID_LEN);
 		}
 		priv->pmkid_list.numpmkid--;
 	} else {
@@ -2040,8 +2040,7 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		if (!mac)
-			s32Error = wilc_del_allstation(vif,
-				     priv->assoc_stainfo.au8Sta_AssociatedBss);
+			s32Error = wilc_del_allstation(vif, priv->assoc_stainfo.au8Sta_AssociatedBss);
 
 		s32Error = wilc_del_station(vif, mac);
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index bc5ad20a..7ad16696 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -287,7 +287,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 
 	while (dropped > 0) {
 		wait_for_completion_timeout(&wilc->txq_event,
-						msecs_to_jiffies(1));
+		                            msecs_to_jiffies(1));
 		dropped--;
 	}
 
@@ -810,9 +810,9 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 				if (!is_cfg_packet) {
 					if (pkt_len > 0) {
 						wilc_frmw_to_linux(wilc,
-							      &buffer[offset],
-							      pkt_len,
-							      pkt_offset);
+						                   &buffer[offset],
+						                   pkt_len,
+						                   pkt_offset);
 					}
 				} else {
 					struct wilc_cfg_rsp rsp;
@@ -1226,7 +1226,7 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 			ret_size = 0;
 
 		if (!wait_for_completion_timeout(&wilc->cfg_event,
-					msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
+		                                 msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
 			netdev_dbg(vif->ndev, "Set Timed Out\n");
 			ret_size = 0;
 		}
@@ -1264,7 +1264,7 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 			ret_size = 0;
 
 		if (!wait_for_completion_timeout(&wilc->cfg_event,
-					msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
+		                                 msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
 			netdev_dbg(vif->ndev, "Get Timed Out\n");
 			ret_size = 0;
 		}
-- 
2.12.2
