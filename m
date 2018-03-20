Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:25207 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbeCTQ4P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 12:56:15 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 06/11] staging: wilc1000: refactor mgmt_tx to fix line over 80 chars
Date: Tue, 20 Mar 2018 22:25:39 +0530
Message-ID: <1521564944-3565-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180320_175619_216998_23B7FF41)
In-Reply-To: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor mgmt_tx() to fix line over 80 characters issue. Split the
function to avoid the checkpatch.pl warning. Returning the same error
code in case of memory allocation failure.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 187 +++++++++++++---------
 1 file changed, 111 insertions(+), 76 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d7ff0a9..9950ca5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1555,6 +1555,58 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 			priv->remain_on_ch_params.listen_session_id);
 }
 
+static void wilc_wfi_cfg_tx_vendor_spec(struct p2p_mgmt_data *mgmt_tx,
+					struct cfg80211_mgmt_tx_params *params,
+					u8 iftype, u32 buf_len)
+{
+	const u8 *buf = params->buf;
+	size_t len = params->len;
+	u32 i;
+	u8 subtype = buf[P2P_PUB_ACTION_SUBTYPE];
+
+	if (subtype == GO_NEG_REQ || subtype == GO_NEG_RSP) {
+		if (p2p_local_random == 1 &&
+		    p2p_recv_random < p2p_local_random) {
+			get_random_bytes(&p2p_local_random, 1);
+			p2p_local_random++;
+		}
+	}
+
+	if (p2p_local_random > p2p_recv_random && (subtype == GO_NEG_REQ ||
+						   subtype == GO_NEG_RSP ||
+						   subtype == P2P_INV_REQ ||
+						   subtype == P2P_INV_RSP)) {
+		bool found = false;
+		bool oper_ch = false;
+
+		for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
+			if (buf[i] == P2PELEM_ATTR_ID &&
+			    !(memcmp(p2p_oui, &buf[i + 2], 4))) {
+				if (subtype == P2P_INV_REQ ||
+				    subtype == P2P_INV_RSP)
+					oper_ch = true;
+
+				found = true;
+				break;
+			}
+		}
+
+		if (found)
+			wilc_wfi_cfg_parse_tx_action(&mgmt_tx->buff[i + 6],
+						     len - (i + 6), oper_ch,
+						     iftype);
+
+		if (subtype != P2P_INV_REQ && subtype != P2P_INV_RSP) {
+			int vendor_spec_len = sizeof(p2p_vendor_spec);
+
+			memcpy(&mgmt_tx->buff[len], p2p_vendor_spec,
+			       vendor_spec_len);
+			mgmt_tx->buff[len + vendor_spec_len] = p2p_local_random;
+			mgmt_tx->size = buf_len;
+		}
+	}
+}
+
 static int mgmt_tx(struct wiphy *wiphy,
 		   struct wireless_dev *wdev,
 		   struct cfg80211_mgmt_tx_params *params,
@@ -1568,9 +1620,9 @@ static int mgmt_tx(struct wiphy *wiphy,
 	struct p2p_mgmt_data *mgmt_tx;
 	struct wilc_priv *priv;
 	struct host_if_drv *wfi_drv;
-	u32 i;
 	struct wilc_vif *vif;
 	u32 buf_len = len + sizeof(p2p_vendor_spec) + sizeof(p2p_local_random);
+	int ret = 0;
 
 	vif = netdev_priv(wdev->netdev);
 	priv = wiphy_priv(wiphy);
@@ -1580,92 +1632,75 @@ static int mgmt_tx(struct wiphy *wiphy,
 	priv->tx_cookie = *cookie;
 	mgmt = (const struct ieee80211_mgmt *)buf;
 
-	if (ieee80211_is_mgmt(mgmt->frame_control)) {
-		mgmt_tx = kmalloc(sizeof(struct p2p_mgmt_data), GFP_KERNEL);
-		if (!mgmt_tx)
-			return -EFAULT;
+	if (!ieee80211_is_mgmt(mgmt->frame_control))
+		goto out;
 
-		mgmt_tx->buff = kmalloc(buf_len, GFP_KERNEL);
-		if (!mgmt_tx->buff) {
-			kfree(mgmt_tx);
-			return -ENOMEM;
-		}
+	mgmt_tx = kmalloc(sizeof(struct p2p_mgmt_data), GFP_KERNEL);
+	if (!mgmt_tx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	mgmt_tx->buff = kmalloc(buf_len, GFP_KERNEL);
+	if (!mgmt_tx->buff) {
+		ret = -ENOMEM;
+		kfree(mgmt_tx);
+		goto out;
+	}
+
+	memcpy(mgmt_tx->buff, buf, len);
+	mgmt_tx->size = len;
+
+	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
+		wilc_set_mac_chnl_num(vif, chan->hw_value);
+		curr_channel = chan->hw_value;
+		goto out_txq_add_pkt;
+	}
 
-		memcpy(mgmt_tx->buff, buf, len);
-		mgmt_tx->size = len;
+	if (!ieee80211_is_action(mgmt->frame_control))
+		goto out_txq_add_pkt;
 
-		if (ieee80211_is_probe_resp(mgmt->frame_control)) {
+	if (buf[ACTION_CAT_ID] == PUB_ACTION_ATTR_ID) {
+		if (buf[ACTION_SUBTYPE_ID] != PUBLIC_ACT_VENDORSPEC ||
+		    buf[P2P_PUB_ACTION_SUBTYPE] != GO_NEG_CONF) {
 			wilc_set_mac_chnl_num(vif, chan->hw_value);
 			curr_channel = chan->hw_value;
-		} else if (ieee80211_is_action(mgmt->frame_control))   {
-			if (buf[ACTION_CAT_ID] == PUB_ACTION_ATTR_ID) {
-				if (buf[ACTION_SUBTYPE_ID] != PUBLIC_ACT_VENDORSPEC ||
-				    buf[P2P_PUB_ACTION_SUBTYPE] != GO_NEG_CONF)	{
-					wilc_set_mac_chnl_num(vif,
-							      chan->hw_value);
-					curr_channel = chan->hw_value;
-				}
-				switch (buf[ACTION_SUBTYPE_ID])	{
-				case GAS_INITIAL_REQ:
-					break;
+		}
+		switch (buf[ACTION_SUBTYPE_ID]) {
+		case GAS_INITIAL_REQ:
+		case GAS_INITIAL_RSP:
+			break;
 
-				case GAS_INITIAL_RSP:
-					break;
+		case PUBLIC_ACT_VENDORSPEC:
+			if (!memcmp(p2p_oui, &buf[ACTION_SUBTYPE_ID + 1], 4))
+				wilc_wfi_cfg_tx_vendor_spec(mgmt_tx, params,
+							    vif->iftype,
+							    buf_len);
+			else
+				netdev_dbg(vif->ndev,
+					   "Not a P2P public action frame\n");
 
-				case PUBLIC_ACT_VENDORSPEC:
-				{
-					if (!memcmp(p2p_oui, &buf[ACTION_SUBTYPE_ID + 1], 4)) {
-						if ((buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP)) {
-							if (p2p_local_random == 1 && p2p_recv_random < p2p_local_random) {
-								get_random_bytes(&p2p_local_random, 1);
-								p2p_local_random++;
-							}
-						}
-
-						if ((buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP ||
-						     buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)) {
-							if (p2p_local_random > p2p_recv_random)	{
-								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
-									if (buf[i] == P2PELEM_ATTR_ID && !(memcmp(p2p_oui, &buf[i + 2], 4))) {
-										if (buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)
-											wilc_wfi_cfg_parse_tx_action(&mgmt_tx->buff[i + 6], len - (i + 6), true, vif->iftype);
-										else
-											wilc_wfi_cfg_parse_tx_action(&mgmt_tx->buff[i + 6], len - (i + 6), false, vif->iftype);
-										break;
-									}
-								}
-
-								if (buf[P2P_PUB_ACTION_SUBTYPE] != P2P_INV_REQ && buf[P2P_PUB_ACTION_SUBTYPE] != P2P_INV_RSP) {
-									memcpy(&mgmt_tx->buff[len], p2p_vendor_spec, sizeof(p2p_vendor_spec));
-									mgmt_tx->buff[len + sizeof(p2p_vendor_spec)] = p2p_local_random;
-									mgmt_tx->size = buf_len;
-								}
-							}
-						}
-
-					} else {
-						netdev_dbg(vif->ndev, "Not a P2P public action frame\n");
-					}
+			break;
 
-					break;
-				}
+		default:
+			netdev_dbg(vif->ndev,
+				   "NOT HANDLED PUBLIC ACTION FRAME TYPE:%x\n",
+				   buf[ACTION_SUBTYPE_ID]);
+			break;
+		}
+	}
 
-				default:
-				{
-					netdev_dbg(vif->ndev, "NOT HANDLED PUBLIC ACTION FRAME TYPE:%x\n", buf[ACTION_SUBTYPE_ID]);
-					break;
-				}
-				}
-			}
+	wfi_drv->p2p_timeout = (jiffies + msecs_to_jiffies(wait));
 
-			wfi_drv->p2p_timeout = (jiffies + msecs_to_jiffies(wait));
-		}
+out_txq_add_pkt:
 
-		wilc_wlan_txq_add_mgmt_pkt(wdev->netdev, mgmt_tx,
-					   mgmt_tx->buff, mgmt_tx->size,
-					   wilc_wfi_mgmt_tx_complete);
-	}
-	return 0;
+	wilc_wlan_txq_add_mgmt_pkt(wdev->netdev, mgmt_tx,
+				   mgmt_tx->buff, mgmt_tx->size,
+				   wilc_wfi_mgmt_tx_complete);
+
+out:
+
+	return ret;
 }
 
 static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
-- 
2.7.4
