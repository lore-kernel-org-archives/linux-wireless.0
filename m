Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29145 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJIJ6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:58:21 -0400
Date: Thu, 9 Oct 2014 12:57:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] ipw2x00: remove unused ->ibss_dfs pointer
Message-ID: <20141009095742.GA20875@mwanda> (sfid-20141009_115827_713997_DF99767F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ->ibss_dfs pointer is always allocated with a user controlled
length.  This caused a static checker warning because what if the length
was zero?  In that case, any dereference of ->ibss_dfs would lead to an
Oops.

It turns out that this isn't a problem because the ->ibss_dfs pointer is
never used.  This patch deletes it along with all the related code.  In
particular the entire libipw_network_reset() function can be removed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ipw2x00/libipw.h b/drivers/net/wireless/ipw2x00/libipw.h
index 5ce2f59..b057161 100644
--- a/drivers/net/wireless/ipw2x00/libipw.h
+++ b/drivers/net/wireless/ipw2x00/libipw.h
@@ -654,10 +654,6 @@ struct libipw_network {
 	/* TPC Report - mandatory if spctrm mgmt required */
 	struct libipw_tpc_report tpc_report;
 
-	/* IBSS DFS - mandatory if spctrm mgmt required and IBSS
-	 * NOTE: This is variable length and so must be allocated dynamically */
-	struct libipw_ibss_dfs *ibss_dfs;
-
 	/* Channel Switch Announcement - optional if spctrm mgmt required */
 	struct libipw_csa csa;
 
@@ -970,7 +966,6 @@ int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
 /* make sure to set stats->len */
 void libipw_rx_mgt(struct libipw_device *ieee, struct libipw_hdr_4addr *header,
 		   struct libipw_rx_stats *stats);
-void libipw_network_reset(struct libipw_network *network);
 
 /* libipw_geo.c */
 const struct libipw_geo *libipw_get_geo(struct libipw_device *ieee);
diff --git a/drivers/net/wireless/ipw2x00/libipw_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
index 5f31b72..60f2874 100644
--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -84,25 +84,12 @@ static int libipw_networks_allocate(struct libipw_device *ieee)
 	return 0;
 }
 
-void libipw_network_reset(struct libipw_network *network)
-{
-	if (!network)
-		return;
-
-	if (network->ibss_dfs) {
-		kfree(network->ibss_dfs);
-		network->ibss_dfs = NULL;
-	}
-}
-
 static inline void libipw_networks_free(struct libipw_device *ieee)
 {
 	int i;
 
-	for (i = 0; i < MAX_NETWORK_COUNT; i++) {
-		kfree(ieee->networks[i]->ibss_dfs);
+	for (i = 0; i < MAX_NETWORK_COUNT; i++)
 		kfree(ieee->networks[i]);
-	}
 }
 
 void libipw_networks_age(struct libipw_device *ieee,
diff --git a/drivers/net/wireless/ipw2x00/libipw_rx.c b/drivers/net/wireless/ipw2x00/libipw_rx.c
index 2d66984..a6877dd 100644
--- a/drivers/net/wireless/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_rx.c
@@ -1298,13 +1298,6 @@ static int libipw_parse_info_param(struct libipw_info_element
 			break;
 
 		case WLAN_EID_IBSS_DFS:
-			if (network->ibss_dfs)
-				break;
-			network->ibss_dfs = kmemdup(info_element->data,
-						    info_element->len,
-						    GFP_ATOMIC);
-			if (!network->ibss_dfs)
-				return 1;
 			network->flags |= NETWORK_HAS_IBSS_DFS;
 			break;
 
@@ -1335,9 +1328,7 @@ static int libipw_parse_info_param(struct libipw_info_element
 static int libipw_handle_assoc_resp(struct libipw_device *ieee, struct libipw_assoc_response
 				       *frame, struct libipw_rx_stats *stats)
 {
-	struct libipw_network network_resp = {
-		.ibss_dfs = NULL,
-	};
+	struct libipw_network network_resp = { };
 	struct libipw_network *network = &network_resp;
 	struct net_device *dev = ieee->dev;
 
@@ -1472,9 +1463,6 @@ static void update_network(struct libipw_network *dst,
 	int qos_active;
 	u8 old_param;
 
-	libipw_network_reset(dst);
-	dst->ibss_dfs = src->ibss_dfs;
-
 	/* We only update the statistics if they were created by receiving
 	 * the network information on the actual channel the network is on.
 	 *
@@ -1548,9 +1536,7 @@ static void libipw_process_probe_response(struct libipw_device
 						    *stats)
 {
 	struct net_device *dev = ieee->dev;
-	struct libipw_network network = {
-		.ibss_dfs = NULL,
-	};
+	struct libipw_network network = { };
 	struct libipw_network *target;
 	struct libipw_network *oldest = NULL;
 #ifdef CONFIG_LIBIPW_DEBUG
@@ -1618,7 +1604,6 @@ static void libipw_process_probe_response(struct libipw_device
 			LIBIPW_DEBUG_SCAN("Expired '%*pE' (%pM) from network list.\n",
 					  target->ssid_len, target->ssid,
 					  target->bssid);
-			libipw_network_reset(target);
 		} else {
 			/* Otherwise just pull from the free list */
 			target = list_entry(ieee->network_free_list.next,
@@ -1634,7 +1619,6 @@ static void libipw_process_probe_response(struct libipw_device
 				  "BEACON" : "PROBE RESPONSE");
 #endif
 		memcpy(target, &network, sizeof(*target));
-		network.ibss_dfs = NULL;
 		list_add_tail(&target->list, &ieee->network_list);
 	} else {
 		LIBIPW_DEBUG_SCAN("Updating '%*pE' (%pM) via %s.\n",
@@ -1643,7 +1627,6 @@ static void libipw_process_probe_response(struct libipw_device
 				  is_beacon(beacon->header.frame_ctl) ?
 				  "BEACON" : "PROBE RESPONSE");
 		update_network(target, &network);
-		network.ibss_dfs = NULL;
 	}
 
 	spin_unlock_irqrestore(&ieee->lock, flags);
