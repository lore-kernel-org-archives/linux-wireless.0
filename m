Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:53649 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab0CBWrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 17:47:04 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/4] rndis_wlan: remove unused variables from priv structure
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 03 Mar 2010 00:38:31 +0200
Message-ID: <20100302223831.2794.20025.stgit@fate.lan>
In-Reply-To: <20100302223825.2794.13615.stgit@fate.lan>
References: <20100302223825.2794.13615.stgit@fate.lan>
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
index b275713..51e6880 100644
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
@@ -1112,8 +1106,6 @@ static int set_auth_mode(struct usbnet *usbdev, u32 wpa_version,
 	}
 
 	priv->wpa_version = wpa_version;
-	priv->wpa_auth_type = auth_type;
-	priv->wpa_keymgmt = keymgmt;
 
 	return 0;
 }
@@ -1137,7 +1129,6 @@ static int set_priv_filter(struct usbnet *usbdev)
 
 static int set_encr_mode(struct usbnet *usbdev, int pairwise, int groupwise)
 {
-	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	__le32 tmp;
 	int encr_mode, ret;
 
@@ -1165,8 +1156,6 @@ static int set_encr_mode(struct usbnet *usbdev, int pairwise, int groupwise)
 		return ret;
 	}
 
-	priv->wpa_cipher_pair = pairwise;
-	priv->wpa_cipher_group = groupwise;
 	return 0;
 }
 
@@ -2849,9 +2838,6 @@ static void rndis_wlan_unbind(struct usbnet *usbdev, struct usb_interface *intf)
 	flush_workqueue(priv->workqueue);
 	destroy_workqueue(priv->workqueue);
 
-	if (priv && priv->wpa_ie_len)
-		kfree(priv->wpa_ie);
-
 	rndis_unbind(usbdev, intf);
 
 	wiphy_unregister(priv->wdev.wiphy);

