Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:54462 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYKOQCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 11:02:34 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] p54: enable Mesh Point support v2
Date: Sat, 15 Nov 2008 17:02:31 +0100
Cc: "John W Linville" <linville@tuxdriver.com>
References: <200811141941.06542.chunkeey@web.de> <45e8e6c40811141422l6e7aa7b9g7227c4243ab701c5@mail.gmail.com>
In-Reply-To: <45e8e6c40811141422l6e7aa7b9g7227c4243ab701c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811151702.31483.chunkeey@web.de> (sfid-20081115_170250_661341_2D7F7C76)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables Mesh Point operation for any p54 device.
 
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-15 16:50:58.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-15 16:50:19.000000000 +0100
@@ -1059,6 +1059,7 @@ static int p54_tx_fill(struct ieee80211_
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
 		if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
 			*aid = 0;
 			*queue = 3;
@@ -1571,6 +1572,7 @@ static int p54_add_interface(struct ieee
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_MESH_POINT:
 		priv->mode = conf->type;
 		break;
 	default:
@@ -1590,6 +1592,7 @@ static int p54_add_interface(struct ieee
 		p54_setup_mac(dev, P54_FILTER_TYPE_AP, priv->mac_addr);
 		break;
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
 		p54_setup_mac(dev, P54_FILTER_TYPE_IBSS, NULL);
 		break;
 	default:
@@ -1654,6 +1657,7 @@ static int p54_config_interface(struct i
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
 		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
 		ret = p54_set_freq(dev, dev->conf.channel->center_freq);
 		if (ret)
@@ -1827,9 +1831,10 @@ struct ieee80211_hw *p54_init_common(siz
 		     IEEE80211_HW_SIGNAL_DBM |
 		     IEEE80211_HW_NOISE_DBM;
 
-	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION |
-					  NL80211_IFTYPE_ADHOC |
-					  NL80211_IFTYPE_AP);
+	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				      BIT(NL80211_IFTYPE_ADHOC) |
+				      BIT(NL80211_IFTYPE_AP) |
+				      BIT(NL80211_IFTYPE_MESH_POINT);
 
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
 	priv->tx_stats[0].limit = 1;		/* Beacon queue */
