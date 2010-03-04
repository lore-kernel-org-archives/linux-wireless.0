Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:46007 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab0CDQ1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 11:27:14 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/4] rndis_wlan: remove unused variables from priv structure
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 04 Mar 2010 18:27:12 +0200
Message-ID: <20100304162707.2609.33783.stgit@fate.lan>
In-Reply-To: <20100304162657.2609.64867.stgit@fate.lan>
References: <20100304162657.2609.64867.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some variables were left unused after cfg80211 conversion. Remove those and related deadcode.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index a4f70de..15bae0a 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -476,13 +476,7 @@ struct rndis_wlan_private {
 	/* encryption stuff */
 	int  encr_tx_key_index;
 	struct rndis_wlan_encr_key encr_keys[4];
-	enum nl80211_auth_type wpa_auth_type;
 	int  wpa_version;
-	int  wpa_keymgmt;
-	int  wpa_ie_len;
-	u8  *wpa_ie;
-	int  wpa_cipher_pair;
-	int  wpa_cipher_group;
 
 	u8 command_buffer[COMMAND_BUFFER_SIZE];
 };
@@ -1116,8 +1110,6 @@ static int set_auth_mode(struct usbnet *usbdev, u32 wpa_version,
 	}
 
 	priv->wpa_version = wpa_version;
-	priv->wpa_auth_type = auth_type;
-	priv->wpa_keymgmt = keymgmt;
 
 	return 0;
 }
@@ -1142,7 +1134,6 @@ static int set_priv_filter(struct usbnet *usbdev)
 
 static int set_encr_mode(struct usbnet *usbdev, int pairwise, int groupwise)
 {
-	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	__le32 tmp;
 	int encr_mode, ret;
 
@@ -1171,8 +1162,6 @@ static int set_encr_mode(struct usbnet *usbdev, int pairwise, int groupwise)
 		return ret;
 	}
 
-	priv->wpa_cipher_pair = pairwise;
-	priv->wpa_cipher_group = groupwise;
 	return 0;
 }
 
@@ -2871,9 +2860,6 @@ static void rndis_wlan_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 	flush_workqueue(priv->workqueue);
 	destroy_workqueue(priv->workqueue);
 
-	if (priv && priv->wpa_ie_len)
-		kfree(priv->wpa_ie);
-
 	rndis_unbind(usbdev, intf);
 
 	wiphy_unregister(priv->wdev.wiphy);

