Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbXEKDIP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 23:08:15 -0400
Subject: [PATCH 05/19] libertas: remove setauthalg private ioctl
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178852055.8607.21.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
	 <1178852055.8607.21.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 23:11:46 -0400
Message-Id: <1178853106.8607.56.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I screwed up formatting, please use this one.

Obsoleted by SIOCSIWAUTH's IW_AUTH_80211_AUTH_ALG option introduced
by WE-18.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/defs.h  |    7 -----
 drivers/net/wireless/libertas/ioctl.c |   45 ---------------------------------
 drivers/net/wireless/libertas/wext.c  |    6 ----
 3 files changed, 0 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index 888a007..15fcb2c 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -223,13 +223,6 @@ enum SNRNF_DATA {
 	MAX_TYPE_AVG
 };
 
-/** WLAN_802_11_AUTH_ALG*/
-enum WLAN_802_11_AUTH_ALG {
-	AUTH_ALG_OPEN_SYSTEM = 1,
-	AUTH_ALG_SHARED_KEY = 2,
-	AUTH_ALG_NETWORK_EAP = 8,
-};
-
 /** WLAN_802_11_ENCRYPTION_MODE */
 enum WLAN_802_11_ENCRYPTION_MODE {
 	CIPHER_NONE,
diff --git a/drivers/net/wireless/libertas/ioctl.c b/drivers/net/wireless/libertas/ioctl.c
index c53c0f9..f70930a 100644
--- a/drivers/net/wireless/libertas/ioctl.c
+++ b/drivers/net/wireless/libertas/ioctl.c
@@ -577,47 +577,6 @@ static int wlan_set_multiple_dtim_ioctl(wlan_private * priv, struct ifreq *req)
 	return ret;
 }
 
-/**
- *  @brief Set authentication mode
- *  @param priv                 A pointer to wlan_private structure
- *  @param req			A pointer to ifreq structure
- *  @return 	   		0 --success, otherwise fail
- */
-static int wlan_setauthalg_ioctl(wlan_private * priv, struct ifreq *req)
-{
-	int alg;
-	struct iwreq *wrq = (struct iwreq *)req;
-	wlan_adapter *adapter = priv->adapter;
-
-	if (wrq->u.data.flags == 0) {
-		//from iwpriv subcmd
-		alg = SUBCMD_DATA(wrq);
-	} else {
-		//from wpa_supplicant subcmd
-		if (copy_from_user(&alg, wrq->u.data.pointer, sizeof(alg))) {
-			lbs_pr_debug(1, "Copy from user failed\n");
-			return -EFAULT;
-		}
-	}
-
-	lbs_pr_debug(1, "auth alg is %#x\n", alg);
-
-	switch (alg) {
-	case AUTH_ALG_SHARED_KEY:
-		adapter->secinfo.authmode = wlan802_11authmodeshared;
-		break;
-	case AUTH_ALG_NETWORK_EAP:
-		adapter->secinfo.authmode =
-		    wlan802_11authmodenetworkEAP;
-		break;
-	case AUTH_ALG_OPEN_SYSTEM:
-	default:
-		adapter->secinfo.authmode = wlan802_11authmodeopen;
-		break;
-	}
-	return 0;
-}
-
 static int wlan_setencryptionmode_ioctl(wlan_private * priv, struct ifreq *req)
 {
 	int mode;
@@ -2043,10 +2002,6 @@ int libertas_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 			ret = wlan_set_multiple_dtim_ioctl(priv, req);
 			break;
 
-		case WLANSETAUTHALG:
-			ret = wlan_setauthalg_ioctl(priv, req);
-			break;
-
 		case WLANSETENCRYPTIONMODE:
 			ret = wlan_setencryptionmode_ioctl(priv, req);
 			break;
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 81ee83c..d161787 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1082,12 +1082,6 @@ static const struct iw_priv_args wlan_private_args[] = {
 	 IW_PRIV_TYPE_NONE,
 	 "settxant"},
 	{
-	 WLANSETAUTHALG,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE,
-	 "authalgs",
-	 },
-	{
 	 WLANSETENCRYPTIONMODE,
 	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
 	 IW_PRIV_TYPE_NONE,
-- 
1.5.0.6



