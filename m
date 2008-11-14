Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:40413 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYKNSlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 13:41:09 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] p54: enable Mesh Point support
Date: Fri, 14 Nov 2008 19:41:06 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>,
	"Andrey Yurovsky" <andrey@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811141941.06542.chunkeey@web.de> (sfid-20081114_194114_393716_48A50CFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables Mesh Point operation for any p54 device.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-01 20:41:08.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-02 13:34:24.000000000 +0100
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
@@ -1829,6 +1833,7 @@ struct ieee80211_hw *p54_init_common(siz
 
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION |
 					  NL80211_IFTYPE_ADHOC |
+					  NL80211_IFTYPE_MESH_POINT |
 					  NL80211_IFTYPE_AP);
 
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
