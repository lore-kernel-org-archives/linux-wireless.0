Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41195 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933091AbbFVIHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:07:54 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M80NBL000563
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:54 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1v57pduf3g-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:54 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 12/17] mwifiex: enable traffic only when port is open
Date: Mon, 22 Jun 2015 19:06:18 +0530
Message-ID: <1434980183-2901-13-git-send-email-patila@marvell.com> (sfid-20150622_103355_451493_0E42CB86)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to enable data traffic only when port is open.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c        | 2 +-
 drivers/net/wireless/mwifiex/join.c        | 2 ++
 drivers/net/wireless/mwifiex/main.h        | 1 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 2 ++
 drivers/net/wireless/mwifiex/sta_event.c   | 4 +++-
 drivers/net/wireless/mwifiex/uap_event.c   | 3 +++
 drivers/net/wireless/mwifiex/wmm.c         | 5 ++++-
 7 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index e1b62bf..8fa363a 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -77,7 +77,7 @@ int mwifiex_init_priv(struct mwifiex_private *priv)
 
 	priv->media_connected = false;
 	eth_broadcast_addr(priv->curr_addr);
-
+	priv->port_open = false;
 	priv->pkt_tx_ctrl = 0;
 	priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
 	priv->data_rate = 0;	/* Initially indicate the rate as auto */
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 56b024a..3cda1f9 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -783,6 +783,8 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 
 	if (priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
 		priv->scan_block = true;
+	else
+		priv->port_open = true;
 
 done:
 	/* Need to indicate IOCTL complete */
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index c59430e..6f98d7e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -519,6 +519,7 @@ struct mwifiex_private {
 	u8 frame_type;
 	u8 curr_addr[ETH_ALEN];
 	u8 media_connected;
+	u8 port_open;
 	u32 num_tx_timeout;
 	/* track consecutive timeout */
 	u8 tx_timeout_cnt;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 6a85c77..18f269e 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -599,6 +599,7 @@ static int mwifiex_ret_802_11_key_material_v1(struct mwifiex_private *priv,
 				    "info: key: GTK is set\n");
 			priv->wpa_is_gtk_set = true;
 			priv->scan_block = false;
+			priv->port_open = true;
 		}
 	}
 
@@ -629,6 +630,7 @@ static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
 			mwifiex_dbg(priv->adapter, INFO, "info: key: GTK is set\n");
 			priv->wpa_is_gtk_set = true;
 			priv->scan_block = false;
+			priv->port_open = true;
 		}
 	}
 
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index f1045d4..72be16e 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -54,6 +54,7 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 	priv->media_connected = false;
 
 	priv->scan_block = false;
+	priv->port_open = false;
 
 	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
 	    ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info)) {
@@ -474,7 +475,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_PS_AWAKE:
 		mwifiex_dbg(adapter, EVENT, "info: EVENT: AWAKE\n");
-		if (!adapter->pps_uapsd_mode &&
+		if (!adapter->pps_uapsd_mode && priv->port_open &&
 		    priv->media_connected && adapter->sleep_period.period) {
 				adapter->pps_uapsd_mode = true;
 				mwifiex_dbg(adapter, EVENT,
@@ -553,6 +554,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_PORT_RELEASE:
 		mwifiex_dbg(adapter, EVENT, "event: PORT RELEASE\n");
+		priv->port_open = true;
 		break;
 
 	case EVENT_EXT_SCAN_REPORT:
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 7bc1f85..a412c3d 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -176,6 +176,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		break;
 	case EVENT_UAP_BSS_IDLE:
 		priv->media_connected = false;
+		priv->port_open = false;
 		if (netif_carrier_ok(priv->netdev))
 			netif_carrier_off(priv->netdev);
 		mwifiex_stop_net_dev_queue(priv->netdev, adapter);
@@ -185,6 +186,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		break;
 	case EVENT_UAP_BSS_ACTIVE:
 		priv->media_connected = true;
+		priv->port_open = true;
 		if (!netif_carrier_ok(priv->netdev))
 			netif_carrier_on(priv->netdev);
 		mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
@@ -192,6 +194,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 	case EVENT_UAP_BSS_START:
 		mwifiex_dbg(adapter, EVENT,
 			    "AP EVENT: event id: %#x\n", eventcause);
+		priv->port_open = false;
 		memcpy(priv->netdev->dev_addr, adapter->event_body + 2,
 		       ETH_ALEN);
 		if (priv->hist_data)
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 7995f92..173d366 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -465,6 +465,8 @@ mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter)
 
 	for (i = 0; i < adapter->priv_num; ++i) {
 		priv = adapter->priv[i];
+		if (priv && !priv->port_open)
+			continue;
 		if (priv && atomic_read(&priv->wmm.tx_pkts_queued))
 			return false;
 	}
@@ -1080,7 +1082,8 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 
 			priv_tmp = adapter->bss_prio_tbl[j].bss_prio_cur->priv;
 
-			if (atomic_read(&priv_tmp->wmm.tx_pkts_queued) == 0)
+			if (!priv_tmp->port_open ||
+			    (atomic_read(&priv_tmp->wmm.tx_pkts_queued) == 0))
 				continue;
 
 			/* iterate over the WMM queues of the BSS */
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
