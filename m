Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:54703 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbYKBNkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 08:40:15 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFT][PATCH] p54: enable Mesh Point support
Date: Sun, 2 Nov 2008 14:40:10 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811021440.10376.chunkeey@web.de> (sfid-20081102_144022_556099_CD89B943)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables Mesh Point operation for any p54 device.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
if someone with a p54 & zd1211/b43 is interesed. 
this patch only works on top of the current wireless-testing tree for now.

Regards,
	Chr
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
