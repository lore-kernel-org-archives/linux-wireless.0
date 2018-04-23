Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:2854 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754788AbeDWQe6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:34:58 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 04/33] staging: wilc1000: refactor WILC_WFI_p2p_rx() to avoid line over 80 char
Date: Mon, 23 Apr 2018 22:03:06 +0530
Message-ID: <1524501215-4963-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183510_211433_B5595F56)
In-Reply-To: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
References: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 characters' issue found by checkpatch.pl script.
Refactor and split the function to avoid the checkpatch reported issues.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 145 ++++++++++++----------
 1 file changed, 82 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 8bd821f..7a6ca03 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1358,12 +1358,49 @@ static void wilc_wfi_cfg_parse_tx_action(u8 *buf, u32 len, bool oper_ch,
 					   op_channel_attr_index);
 }
 
+static void wilc_wfi_cfg_parse_rx_vendor_spec(struct wilc_priv *priv, u8 *buff,
+					      u32 size)
+{
+	int i;
+	u8 subtype;
+	struct wilc_vif *vif = netdev_priv(priv->dev);
+
+	subtype = buff[P2P_PUB_ACTION_SUBTYPE];
+	if ((subtype == GO_NEG_REQ || subtype == GO_NEG_RSP) && !wilc_ie) {
+		for (i = P2P_PUB_ACTION_SUBTYPE; i < size; i++) {
+			if (!memcmp(p2p_vendor_spec, &buff[i], 6)) {
+				p2p_recv_random = buff[i + 6];
+				wilc_ie = true;
+				break;
+			}
+		}
+	}
+
+	if (p2p_local_random <= p2p_recv_random) {
+		netdev_dbg(vif->ndev,
+			   "PEER WILL BE GO LocaRand=%02x RecvRand %02x\n",
+			   p2p_local_random, p2p_recv_random);
+		return;
+	}
+
+	if (subtype == GO_NEG_REQ || subtype == GO_NEG_RSP ||
+	    subtype == P2P_INV_REQ || subtype == P2P_INV_RSP) {
+		for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < size; i++) {
+			if (buff[i] == P2PELEM_ATTR_ID &&
+			    !(memcmp(p2p_oui, &buff[i + 2], 4))) {
+				wilc_wfi_cfg_parse_rx_action(&buff[i + 6],
+							     size - (i + 6));
+				break;
+			}
+		}
+	}
+}
+
 void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 {
 	struct wilc_priv *priv;
 	u32 header, pkt_offset;
 	struct host_if_drv *wfi_drv;
-	u32 i = 0;
 	s32 s32Freq;
 
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
@@ -1374,75 +1411,57 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 	pkt_offset = GET_PKT_OFFSET(header);
 
 	if (pkt_offset & IS_MANAGMEMENT_CALLBACK) {
-		if (buff[FRAME_TYPE_ID] == IEEE80211_STYPE_PROBE_RESP) {
-			cfg80211_mgmt_tx_status(priv->wdev, priv->tx_cookie, buff, size, true, GFP_KERNEL);
-			return;
-		} else {
-			if (pkt_offset & IS_MGMT_STATUS_SUCCES)
-				cfg80211_mgmt_tx_status(priv->wdev, priv->tx_cookie, buff, size, true, GFP_KERNEL);
-			else
-				cfg80211_mgmt_tx_status(priv->wdev, priv->tx_cookie, buff, size, false, GFP_KERNEL);
-			return;
-		}
-	} else {
-		s32Freq = ieee80211_channel_to_frequency(curr_channel, NL80211_BAND_2GHZ);
+		bool ack = false;
 
-		if (ieee80211_is_action(buff[FRAME_TYPE_ID])) {
-			if (priv->cfg_scanning && time_after_eq(jiffies, (unsigned long)wfi_drv->p2p_timeout)) {
-				netdev_dbg(dev, "Receiving action wrong ch\n");
-				return;
-			}
-			if (buff[ACTION_CAT_ID] == PUB_ACTION_ATTR_ID) {
-				switch (buff[ACTION_SUBTYPE_ID]) {
-				case GAS_INITIAL_REQ:
-					break;
+		if (buff[FRAME_TYPE_ID] == IEEE80211_STYPE_PROBE_RESP ||
+		    pkt_offset & IS_MGMT_STATUS_SUCCES)
+			ack = true;
 
-				case GAS_INITIAL_RSP:
-					break;
+		cfg80211_mgmt_tx_status(priv->wdev, priv->tx_cookie, buff, size,
+					ack, GFP_KERNEL);
+		return;
+	}
 
-				case PUBLIC_ACT_VENDORSPEC:
-					if (!memcmp(p2p_oui, &buff[ACTION_SUBTYPE_ID + 1], 4)) {
-						if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP))	{
-							if (!wilc_ie) {
-								for (i = P2P_PUB_ACTION_SUBTYPE; i < size; i++)	{
-									if (!memcmp(p2p_vendor_spec, &buff[i], 6)) {
-										p2p_recv_random = buff[i + 6];
-										wilc_ie = true;
-										break;
-									}
-								}
-							}
-						}
-						if (p2p_local_random > p2p_recv_random)	{
-							if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP ||
-							     buff[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)) {
-								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < size; i++) {
-									if (buff[i] == P2PELEM_ATTR_ID && !(memcmp(p2p_oui, &buff[i + 2], 4))) {
-										wilc_wfi_cfg_parse_rx_action(&buff[i + 6], size - (i + 6));
-										break;
-									}
-								}
-							}
-						} else {
-							netdev_dbg(dev, "PEER WILL BE GO LocaRand=%02x RecvRand %02x\n", p2p_local_random, p2p_recv_random);
-						}
-					}
+	s32Freq = ieee80211_channel_to_frequency(curr_channel, NL80211_BAND_2GHZ);
 
-					if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP) && (wilc_ie))	{
-						cfg80211_rx_mgmt(priv->wdev, s32Freq, 0, buff, size - 7, 0);
-						return;
-					}
-					break;
+	if (!ieee80211_is_action(buff[FRAME_TYPE_ID])) {
+		cfg80211_rx_mgmt(priv->wdev, s32Freq, 0, buff, size, 0);
+		return;
+	}
 
-				default:
-					netdev_dbg(dev, "NOT HANDLED PUBLIC ACTION FRAME TYPE:%x\n", buff[ACTION_SUBTYPE_ID]);
-					break;
-				}
-			}
-		}
+	if (priv->cfg_scanning &&
+	    time_after_eq(jiffies, (unsigned long)wfi_drv->p2p_timeout)) {
+		netdev_dbg(dev, "Receiving action wrong ch\n");
+		return;
+	}
+	if (buff[ACTION_CAT_ID] == PUB_ACTION_ATTR_ID) {
+		u8 subtype = buff[P2P_PUB_ACTION_SUBTYPE];
 
-		cfg80211_rx_mgmt(priv->wdev, s32Freq, 0, buff, size, 0);
+		switch (buff[ACTION_SUBTYPE_ID]) {
+		case GAS_INITIAL_REQ:
+		case GAS_INITIAL_RSP:
+			break;
+
+		case PUBLIC_ACT_VENDORSPEC:
+			if (!memcmp(p2p_oui, &buff[ACTION_SUBTYPE_ID + 1], 4))
+				wilc_wfi_cfg_parse_rx_vendor_spec(priv, buff,
+								  size);
+
+			if ((subtype == GO_NEG_REQ || subtype == GO_NEG_RSP) &&
+			    wilc_ie)
+				size -= 7;
+
+			break;
+
+		default:
+			netdev_dbg(dev,
+				   "NOT HANDLED PUBLIC ACTION FRAME TYPE:%x\n",
+				   buff[ACTION_SUBTYPE_ID]);
+			break;
+		}
 	}
+
+	cfg80211_rx_mgmt(priv->wdev, s32Freq, 0, buff, size, 0);
 }
 
 static void wilc_wfi_mgmt_tx_complete(void *priv, int status)
-- 
2.7.4
