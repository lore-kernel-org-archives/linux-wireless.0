Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2969 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab2JVRgh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:37 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/14] brcmfmac: use bssidx from struct brcmf_if for
 bsscfg specific commands
Date: Mon, 22 Oct 2012 10:36:21 -0700
Message-ID: <1350927387-25608-9-git-send-email-frankyl@broadcom.com> (sfid-20121022_193643_283572_2CAEA0E9)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The firmware interface has functions to send bsscfg specific commands
to the device. These functions currently have a bssidx parameter, but
that same information is stored in struct brcmf_if, which is in the
private data of the net_device parameter.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |   27 +++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |   14 ++++-----
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   28 ++++++++++----------
 3 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index 196797e..a3a39cc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -26,6 +26,7 @@
 #include "dhd.h"
 #include "dhd_bus.h"
 #include "dhd_dbg.h"
+#include "fwil.h"
 
 
 static s32
@@ -263,7 +264,7 @@ brcmf_create_bsscfg(s32 bssidx, char *name, char *data, u32 datalen, char *buf,
 }
 
 s32
-brcmf_fil_bsscfg_data_set(struct net_device *ndev, s32 bssidx, char *name,
+brcmf_fil_bsscfg_data_set(struct net_device *ndev, char *name,
 			  void *data, u32 len)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
@@ -273,11 +274,11 @@ brcmf_fil_bsscfg_data_set(struct net_device *ndev, s32 bssidx, char *name,
 
 	mutex_lock(&drvr->proto_block);
 
-	brcmf_dbg(FIL, "bssidx=%d, name=%s, len=%d\n", bssidx, name, len);
+	brcmf_dbg(FIL, "bssidx=%d, name=%s, len=%d\n", ifp->bssidx, name, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data, len, "data");
 
-	buflen = brcmf_create_bsscfg(bssidx, name, data, len, drvr->proto_buf,
-				     sizeof(drvr->proto_buf));
+	buflen = brcmf_create_bsscfg(ifp->bssidx, name, data, len,
+				     drvr->proto_buf, sizeof(drvr->proto_buf));
 	if (buflen) {
 		err = brcmf_fil_cmd_data(ifp, BRCMF_C_SET_VAR, drvr->proto_buf,
 					 buflen, true);
@@ -291,7 +292,7 @@ brcmf_fil_bsscfg_data_set(struct net_device *ndev, s32 bssidx, char *name,
 }
 
 s32
-brcmf_fil_bsscfg_data_get(struct net_device *ndev, s32 bssidx, char *name,
+brcmf_fil_bsscfg_data_get(struct net_device *ndev, char *name,
 			  void *data, u32 len)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
@@ -301,8 +302,8 @@ brcmf_fil_bsscfg_data_get(struct net_device *ndev, s32 bssidx, char *name,
 
 	mutex_lock(&drvr->proto_block);
 
-	buflen = brcmf_create_bsscfg(bssidx, name, NULL, len, drvr->proto_buf,
-				     sizeof(drvr->proto_buf));
+	buflen = brcmf_create_bsscfg(ifp->bssidx, name, NULL, len,
+				     drvr->proto_buf, sizeof(drvr->proto_buf));
 	if (buflen) {
 		err = brcmf_fil_cmd_data(ifp, BRCMF_C_GET_VAR, drvr->proto_buf,
 					 buflen, false);
@@ -312,7 +313,7 @@ brcmf_fil_bsscfg_data_get(struct net_device *ndev, s32 bssidx, char *name,
 		err = -EPERM;
 		brcmf_dbg(ERROR, "Creating bsscfg failed\n");
 	}
-	brcmf_dbg(FIL, "bssidx=%d, name=%s, len=%d\n", bssidx, name, len);
+	brcmf_dbg(FIL, "bssidx=%d, name=%s, len=%d\n", ifp->bssidx, name, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data, len, "data");
 
 	mutex_unlock(&drvr->proto_block);
@@ -321,23 +322,21 @@ brcmf_fil_bsscfg_data_get(struct net_device *ndev, s32 bssidx, char *name,
 }
 
 s32
-brcmf_fil_bsscfg_int_set(struct net_device *ndev, s32 bssidx, char *name,
-			 u32 data)
+brcmf_fil_bsscfg_int_set(struct net_device *ndev, char *name, u32 data)
 {
 	__le32 data_le = cpu_to_le32(data);
 
-	return brcmf_fil_bsscfg_data_set(ndev, bssidx, name, &data_le,
+	return brcmf_fil_bsscfg_data_set(ndev, name, &data_le,
 					 sizeof(data_le));
 }
 
 s32
-brcmf_fil_bsscfg_int_get(struct net_device *ndev, s32 bssidx, char *name,
-			 u32 *data)
+brcmf_fil_bsscfg_int_get(struct net_device *ndev, char *name, u32 *data)
 {
 	__le32 data_le = cpu_to_le32(*data);
 	s32 err;
 
-	err = brcmf_fil_bsscfg_data_get(ndev, bssidx, name, &data_le,
+	err = brcmf_fil_bsscfg_data_get(ndev, name, &data_le,
 					sizeof(data_le));
 	if (err == 0)
 		*data = le32_to_cpu(data_le);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
index 54855ef..4d08499 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
@@ -31,13 +31,11 @@ s32 brcmf_fil_iovar_data_get(struct net_device *ndev, char *name, void *data,
 s32 brcmf_fil_iovar_int_set(struct net_device *ndev, char *name, u32 data);
 s32 brcmf_fil_iovar_int_get(struct net_device *ndev, char *name, u32 *data);
 
-s32 brcmf_fil_bsscfg_data_set(struct net_device *ndev, s32 bssidx, char *name,
-			      void *data, u32 len);
-s32 brcmf_fil_bsscfg_data_get(struct net_device *ndev, s32 bssidx, char *name,
-			      void *data, u32 len);
-s32 brcmf_fil_bsscfg_int_set(struct net_device *ndev, s32 bssidx, char *name,
-			     u32 data);
-s32 brcmf_fil_bsscfg_int_get(struct net_device *ndev, s32 bssidx, char *name,
-			     u32 *data);
+s32 brcmf_fil_bsscfg_data_set(struct net_device *ndev, char *name, void *data,
+			      u32 len);
+s32 brcmf_fil_bsscfg_data_get(struct net_device *ndev, char *name, void *data,
+			      u32 len);
+s32 brcmf_fil_bsscfg_int_set(struct net_device *ndev, char *name, u32 data);
+s32 brcmf_fil_bsscfg_int_get(struct net_device *ndev, char *name, u32 *data);
 
 #endif /* _fwil_h_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 30e9c12..cb491d9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -417,7 +417,7 @@ send_key_to_dongle(struct brcmf_cfg80211_info *cfg, s32 bssidx,
 
 	brcmf_netdev_wait_pend8021x(ndev);
 
-	err = brcmf_fil_bsscfg_data_set(ndev, bssidx, "wsec_key", &key_le,
+	err = brcmf_fil_bsscfg_data_set(ndev, "wsec_key", &key_le,
 					sizeof(key_le));
 
 	if (err)
@@ -1596,7 +1596,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	if (sec->auth_type == NL80211_AUTHTYPE_SHARED_KEY) {
 		WL_CONN("set auth_type to shared key\n");
 		val = WL_AUTH_SHARED_KEY;	/* shared key */
-		err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "auth", val);
+		err = brcmf_fil_bsscfg_int_set(ndev, "auth", val);
 		if (err)
 			WL_ERR("set auth failed (%d)\n", err);
 	}
@@ -1815,7 +1815,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	bssidx = brcmf_find_bssidx(cfg, ndev);
-	err = brcmf_fil_bsscfg_int_get(ndev, bssidx, "wsec", &wsec);
+	err = brcmf_fil_bsscfg_int_get(ndev, "wsec", &wsec);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		goto done;
@@ -1994,13 +1994,13 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (err)
 		goto done;
 
-	err = brcmf_fil_bsscfg_int_get(ndev, bssidx, "wsec", &wsec);
+	err = brcmf_fil_bsscfg_int_get(ndev, "wsec", &wsec);
 	if (err) {
 		WL_ERR("get wsec error (%d)\n", err);
 		goto done;
 	}
 	wsec |= val;
-	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "wsec", wsec);
+	err = brcmf_fil_bsscfg_int_set(ndev, "wsec", wsec);
 	if (err) {
 		WL_ERR("set wsec error (%d)\n", err);
 		goto done;
@@ -2070,7 +2070,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 	memset(&params, 0, sizeof(params));
 
 	bssidx = brcmf_find_bssidx(cfg, ndev);
-	err = brcmf_fil_bsscfg_int_get(ndev, bssidx, "wsec", &wsec);
+	err = brcmf_fil_bsscfg_int_get(ndev, "wsec", &wsec);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -3481,19 +3481,19 @@ static s32 brcmf_configure_opensecurity(struct net_device *ndev, s32 bssidx)
 	s32 err;
 
 	/* set auth */
-	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "auth", 0);
+	err = brcmf_fil_bsscfg_int_set(ndev, "auth", 0);
 	if (err < 0) {
 		WL_ERR("auth error %d\n", err);
 		return err;
 	}
 	/* set wsec */
-	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "wsec", 0);
+	err = brcmf_fil_bsscfg_int_set(ndev, "wsec", 0);
 	if (err < 0) {
 		WL_ERR("wsec error %d\n", err);
 		return err;
 	}
 	/* set upper-layer auth */
-	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "wpa_auth", WPA_AUTH_NONE);
+	err = brcmf_fil_bsscfg_int_set(ndev, "wpa_auth", WPA_AUTH_NONE);
 	if (err < 0) {
 		WL_ERR("wpa_auth error %d\n", err);
 		return err;
@@ -3654,7 +3654,7 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 				wme_bss_disable = 0;
 		}
 		/* set wme_bss_disable to sync RSN Capabilities */
-		err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "wme_bss_disable",
+		err = brcmf_fil_bsscfg_int_set(ndev, "wme_bss_disable",
 					       wme_bss_disable);
 		if (err < 0) {
 			WL_ERR("wme_bss_disable error %d\n", err);
@@ -3665,19 +3665,19 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 	wsec = (pval | gval | SES_OW_ENABLED);
 
 	/* set auth */
-	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "auth", auth);
+	err = brcmf_fil_bsscfg_int_set(ndev, "auth", auth);
 	if (err < 0) {
 		WL_ERR("auth error %d\n", err);
 		goto exit;
 	}
 	/* set wsec */
-	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "wsec", wsec);
+	err = brcmf_fil_bsscfg_int_set(ndev, "wsec", wsec);
 	if (err < 0) {
 		WL_ERR("wsec error %d\n", err);
 		goto exit;
 	}
 	/* set upper-layer auth */
-	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "wpa_auth", wpa_auth);
+	err = brcmf_fil_bsscfg_int_set(ndev, "wpa_auth", wpa_auth);
 	if (err < 0) {
 		WL_ERR("wpa_auth error %d\n", err);
 		goto exit;
@@ -3907,7 +3907,7 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 		}
 	}
 	if (total_ie_buf_len) {
-		err  = brcmf_fil_bsscfg_data_set(ndev, bssidx, "vndr_ie",
+		err  = brcmf_fil_bsscfg_data_set(ndev, "vndr_ie",
 						 iovar_ie_buf,
 						 total_ie_buf_len);
 		if (err)
-- 
1.7.6


