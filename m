Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185AbXEKCto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 22:49:44 -0400
Subject: [PATCH 04/19] libertas: remove 8021xauthalgs private ioctl
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 22:53:14 -0400
Message-Id: <1178851994.8607.17.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Useless; it set an internal variable that was unused anyway.
A supplicant handles all 802.1x authentication, not the driver.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/defs.h  |    9 ---------
 drivers/net/wireless/libertas/dev.h   |    1 -
 drivers/net/wireless/libertas/fw.c    |    1 -
 drivers/net/wireless/libertas/ioctl.c |   30 ------------------------------
 drivers/net/wireless/libertas/wext.c  |    6 ------
 5 files changed, 0 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index fb1478c..888a007 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -230,15 +230,6 @@ enum WLAN_802_11_AUTH_ALG {
 	AUTH_ALG_NETWORK_EAP = 8,
 };
 
-/** WLAN_802_1X_AUTH_ALG */
-enum WLAN_802_1X_AUTH_ALG {
-	WLAN_1X_AUTH_ALG_NONE = 1,
-	WLAN_1X_AUTH_ALG_LEAP = 2,
-	WLAN_1X_AUTH_ALG_TLS = 4,
-	WLAN_1X_AUTH_ALG_TTLS = 8,
-	WLAN_1X_AUTH_ALG_MD5 = 16,
-};
-
 /** WLAN_802_11_ENCRYPTION_MODE */
 enum WLAN_802_11_ENCRYPTION_MODE {
 	CIPHER_NONE,
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 295e7d0..5b88449 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -59,7 +59,6 @@ struct wlan_802_11_security {
 	u8 WPA2enabled;
 	enum WLAN_802_11_WEP_STATUS WEPstatus;
 	enum WLAN_802_11_AUTHENTICATION_MODE authmode;
-	enum WLAN_802_1X_AUTH_ALG auth1xalg;
 	enum WLAN_802_11_ENCRYPTION_MODE Encryptionmode;
 };
 
diff --git a/drivers/net/wireless/libertas/fw.c b/drivers/net/wireless/libertas/fw.c
index b194a45..b167a85 100644
--- a/drivers/net/wireless/libertas/fw.c
+++ b/drivers/net/wireless/libertas/fw.c
@@ -201,7 +201,6 @@ static void wlan_init_adapter(wlan_private * priv)
 	adapter->wep_tx_keyidx = 0;
 	adapter->secinfo.WEPstatus = wlan802_11WEPdisabled;
 	adapter->secinfo.authmode = wlan802_11authmodeopen;
-	adapter->secinfo.auth1xalg = WLAN_1X_AUTH_ALG_NONE;
 	adapter->secinfo.Encryptionmode = CIPHER_NONE;
 	adapter->inframode = wlan802_11infrastructure;
 
diff --git a/drivers/net/wireless/libertas/ioctl.c b/drivers/net/wireless/libertas/ioctl.c
index 82b3964..c53c0f9 100644
--- a/drivers/net/wireless/libertas/ioctl.c
+++ b/drivers/net/wireless/libertas/ioctl.c
@@ -618,32 +618,6 @@ static int wlan_setauthalg_ioctl(wlan_private * priv, struct ifreq *req)
 	return 0;
 }
 
-/**
- *  @brief Set 802.1x authentication mode
- *  @param priv                 A pointer to wlan_private structure
- *  @param req			A pointer to ifreq structure
- *  @return 	   		0 --success, otherwise fail
- */
-static int wlan_set8021xauthalg_ioctl(wlan_private * priv, struct ifreq *req)
-{
-	int alg;
-	struct iwreq *wrq = (struct iwreq *)req;
-
-	if (wrq->u.data.flags == 0) {
-		//from iwpriv subcmd
-		alg = SUBCMD_DATA(wrq);
-	} else {
-		//from wpa_supplicant subcmd
-		if (copy_from_user(&alg, wrq->u.data.pointer, sizeof(int))) {
-			lbs_pr_debug(1, "Copy from user failed\n");
-			return -EFAULT;
-		}
-	}
-	lbs_pr_debug(1, "802.1x auth alg is %#x\n", alg);
-	priv->adapter->secinfo.auth1xalg = alg;
-	return 0;
-}
-
 static int wlan_setencryptionmode_ioctl(wlan_private * priv, struct ifreq *req)
 {
 	int mode;
@@ -2073,10 +2047,6 @@ int libertas_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 			ret = wlan_setauthalg_ioctl(priv, req);
 			break;
 
-		case WLANSET8021XAUTHALG:
-			ret = wlan_set8021xauthalg_ioctl(priv, req);
-			break;
-
 		case WLANSETENCRYPTIONMODE:
 			ret = wlan_setencryptionmode_ioctl(priv, req);
 			break;
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 4a52336..81ee83c 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1088,12 +1088,6 @@ static const struct iw_priv_args wlan_private_args[] = {
 	 "authalgs",
 	 },
 	{
-	 WLANSET8021XAUTHALG,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE,
-	 "8021xauthalgs",
-	 },
-	{
 	 WLANSETENCRYPTIONMODE,
 	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
 	 IW_PRIV_TYPE_NONE,
-- 
1.5.0.6



