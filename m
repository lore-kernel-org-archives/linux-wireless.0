Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34565 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752331AbdCDP6P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Mar 2017 10:58:15 -0500
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: w.d.hubbs@gmail.com
Cc: chris@the-brannons.com, outreachy-kernel@googlegroups.com,
        kirk@reisers.ca, samuel.thibault@ens-lyon.org,
        gregkh@linuxfoundation.org, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        linux-wireless@vger.kernel.org,
        Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 4/6] staging: wilc1000: Alignment should match open parenthesis
Date: Sat,  4 Mar 2017 21:27:38 +0530
Message-Id: <20170304155740.26105-5-arushisinghal19971997@gmail.com> (sfid-20170304_165949_863988_F60FA42F)
In-Reply-To: <20170304155740.26105-1-arushisinghal19971997@gmail.com>
References: <20170304155740.26105-1-arushisinghal19971997@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch issues: "CHECK: Alignment should match open parenthesis".

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c         |  2 +-
 drivers/staging/wilc1000/wilc_spi.c               |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 16 ++++++++--------
 drivers/staging/wilc1000/wilc_wlan.c              | 10 +++++-----
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f848bb85ff1f..2429c85052bf 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1350,7 +1350,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 
 				if (u32RcvdAssocRespInfoLen != 0) {
 					s32Err = wilc_parse_assoc_resp_info(rcv_assoc_resp, u32RcvdAssocRespInfoLen,
-								    &pstrConnectRespInfo);
+									    &pstrConnectRespInfo);
 					if (s32Err) {
 						netdev_err(vif->ndev, "wilc_parse_assoc_resp_info() returned error %d\n", s32Err);
 					} else {
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 55d53c3a95df..fb7ccfc29a19 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -410,7 +410,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 
 	if (len2 > ARRAY_SIZE(wb)) {
 		dev_err(&spi->dev, "spi buffer size too small (%d) (%zu)\n",
-			 len2, ARRAY_SIZE(wb));
+			len2, ARRAY_SIZE(wb));
 		return N_FAIL;
 	}
 	/* zero spi write buffers. */
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4a6fe90a41de..8cb7506bd0e5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1301,16 +1301,16 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
 		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
-				 ETH_ALEN)) {
+			    ETH_ALEN)) {
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
+			    ETH_ALEN)) {
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
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index bc5ad20af0a3..9addef1f1e12 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -287,7 +287,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 
 	while (dropped > 0) {
 		wait_for_completion_timeout(&wilc->txq_event,
-						msecs_to_jiffies(1));
+					    msecs_to_jiffies(1));
 		dropped--;
 	}
 
@@ -810,9 +810,9 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 				if (!is_cfg_packet) {
 					if (pkt_len > 0) {
 						wilc_frmw_to_linux(wilc,
-							      &buffer[offset],
-							      pkt_len,
-							      pkt_offset);
+								   &buffer[offset],
+								   pkt_len,
+								   pkt_offset);
 					}
 				} else {
 					struct wilc_cfg_rsp rsp;
@@ -1226,7 +1226,7 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 			ret_size = 0;
 
 		if (!wait_for_completion_timeout(&wilc->cfg_event,
-					msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
+						 msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
 			netdev_dbg(vif->ndev, "Set Timed Out\n");
 			ret_size = 0;
 		}
-- 
2.11.0
