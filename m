Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:27029 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbZJSI0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 04:26:06 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: change IW_ESSID_MAX_SIZE -> IEEE80211_MAX_SSID_LEN
Date: Mon, 19 Oct 2009 10:23:41 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910191023.41565.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/assoc.c
+++ linux-wl/drivers/net/wireless/libertas/assoc.c
@@ -226,7 +226,7 @@
 	priv->connect_status = LBS_CONNECTED;
 
 	/* Update current SSID and BSSID */
-	memcpy(&priv->curbssparams.ssid, &bss->ssid, IW_ESSID_MAX_SIZE);
+	memcpy(&priv->curbssparams.ssid, &bss->ssid, IEEE80211_MAX_SSID_LEN);
 	priv->curbssparams.ssid_len = bss->ssid_len;
 	memcpy(priv->curbssparams.bssid, bss->bssid, ETH_ALEN);
 
@@ -467,7 +467,7 @@
 	memcpy(&priv->curbssparams.bssid, bss->bssid, ETH_ALEN);
 
 	/* Set the new SSID to current SSID */
-	memcpy(&priv->curbssparams.ssid, &bss->ssid, IW_ESSID_MAX_SIZE);
+	memcpy(&priv->curbssparams.ssid, &bss->ssid, IEEE80211_MAX_SSID_LEN);
 	priv->curbssparams.ssid_len = bss->ssid_len;
 
 	netif_carrier_on(priv->dev);
@@ -1083,7 +1083,7 @@
 			/* else send START command */
 			lbs_deb_assoc("SSID not found, creating adhoc network\n");
 			memcpy(&assoc_req->bss.ssid, &assoc_req->ssid,
-				IW_ESSID_MAX_SIZE);
+				IEEE80211_MAX_SSID_LEN);
 			assoc_req->bss.ssid_len = assoc_req->ssid_len;
 			lbs_adhoc_start(priv, assoc_req);
 		}
@@ -1541,7 +1541,7 @@
 
 	found = lbs_find_best_ssid_in_list(priv, preferred_mode);
 	if (found && (found->ssid_len > 0)) {
-		memcpy(out_ssid, &found->ssid, IW_ESSID_MAX_SIZE);
+		memcpy(out_ssid, &found->ssid, IEEE80211_MAX_SSID_LEN);
 		*out_ssid_len = found->ssid_len;
 		*out_mode = found->mode;
 		ret = 0;
@@ -1759,7 +1759,7 @@
 	assoc_req = priv->pending_assoc_req;
 	if (!test_bit(ASSOC_FLAG_SSID, &assoc_req->flags)) {
 		memcpy(&assoc_req->ssid, &priv->curbssparams.ssid,
-		       IW_ESSID_MAX_SIZE);
+		       IEEE80211_MAX_SSID_LEN);
 		assoc_req->ssid_len = priv->curbssparams.ssid_len;
 	}
 
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -1168,7 +1168,7 @@
 		ie->val.mesh_id_len = priv->mesh_ssid_len;
 		memcpy(ie->val.mesh_id, priv->mesh_ssid, priv->mesh_ssid_len);
 		ie->len = sizeof(struct mrvl_meshie_val) -
-			IW_ESSID_MAX_SIZE + priv->mesh_ssid_len;
+			IEEE80211_MAX_SSID_LEN + priv->mesh_ssid_len;
 		cmd.length = cpu_to_le16(sizeof(struct mrvl_meshie_val));
 		break;
 	case CMD_ACT_MESH_CONFIG_STOP:
--- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
+++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
@@ -68,7 +68,7 @@
 	 * no longer valid.
 	 */
 	memset(&priv->curbssparams.bssid, 0, ETH_ALEN);
-	memset(&priv->curbssparams.ssid, 0, IW_ESSID_MAX_SIZE);
+	memset(&priv->curbssparams.ssid, 0, IEEE80211_MAX_SSID_LEN);
 	priv->curbssparams.ssid_len = 0;
 
 	if (priv->psstate != PS_STATE_FULL_POWER) {
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -65,7 +65,7 @@
 	/** bssid */
 	u8 bssid[ETH_ALEN];
 	/** ssid */
-	u8 ssid[IW_ESSID_MAX_SIZE + 1];
+	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
 
 	/** band */
@@ -163,7 +163,7 @@
 	struct work_struct sync_channel;
 	/* remember which channel was scanned last, != 0 if currently scanning */
 	int scan_channel;
-	u8 scan_ssid[IW_ESSID_MAX_SIZE + 1];
+	u8 scan_ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 scan_ssid_len;
 
 	/** Hardware access */
@@ -230,7 +230,7 @@
 	struct current_bss_params curbssparams;
 
 	uint16_t mesh_tlv;
-	u8 mesh_ssid[IW_ESSID_MAX_SIZE + 1];
+	u8 mesh_ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 mesh_ssid_len;
 
 	/* IW_MODE_* */
@@ -340,7 +340,7 @@
 struct bss_descriptor {
 	u8 bssid[ETH_ALEN];
 
-	u8 ssid[IW_ESSID_MAX_SIZE + 1];
+	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
 
 	u16 capability;
@@ -389,7 +389,7 @@
 #define ASSOC_FLAG_WPA_IE		11
 	unsigned long flags;
 
-	u8 ssid[IW_ESSID_MAX_SIZE + 1];
+	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
 	u8 channel;
 	u8 band;
--- linux-wl.orig/drivers/net/wireless/libertas/host.h
+++ linux-wl/drivers/net/wireless/libertas/host.h
@@ -719,7 +719,7 @@
 struct cmd_ds_802_11_ad_hoc_start {
 	struct cmd_header hdr;
 
-	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 bsstype;
 	__le16 beaconperiod;
 	u8 dtimperiod;   /* Reserved on v9 and later */
@@ -742,7 +742,7 @@
 
 struct adhoc_bssdesc {
 	u8 bssid[ETH_ALEN];
-	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 type;
 	__le16 beaconperiod;
 	u8 dtimperiod;
--- linux-wl.orig/drivers/net/wireless/libertas/persistcfg.c
+++ linux-wl/drivers/net/wireless/libertas/persistcfg.c
@@ -187,9 +187,9 @@
 	if (ret)
 		return ret;
 
-	if (defs.meshie.val.mesh_id_len > IW_ESSID_MAX_SIZE) {
+	if (defs.meshie.val.mesh_id_len > IEEE80211_MAX_SSID_LEN) {
 		lbs_pr_err("inconsistent mesh ID length");
-		defs.meshie.val.mesh_id_len = IW_ESSID_MAX_SIZE;
+		defs.meshie.val.mesh_id_len = IEEE80211_MAX_SSID_LEN;
 	}
 
 	/* SSID not null terminated: reserve room for \0 + \n */
@@ -214,7 +214,7 @@
 	int len;
 	int ret;
 
-	if (count < 2 || count > IW_ESSID_MAX_SIZE + 1)
+	if (count < 2 || count > IEEE80211_MAX_SSID_LEN + 1)
 		return -EINVAL;
 
 	memset(&cmd, 0, sizeof(struct cmd_ds_mesh_config));
@@ -233,7 +233,7 @@
 	/* SSID len */
 	ie->val.mesh_id_len = len;
 	/* IE len */
-	ie->len = sizeof(struct mrvl_meshie_val) - IW_ESSID_MAX_SIZE + len;
+	ie->len = sizeof(struct mrvl_meshie_val) - IEEE80211_MAX_SSID_LEN + len;
 
 	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_SET,
 				   CMD_TYPE_MESH_SET_MESH_IE);
--- linux-wl.orig/drivers/net/wireless/libertas/types.h
+++ linux-wl/drivers/net/wireless/libertas/types.h
@@ -5,8 +5,8 @@
 #define _LBS_TYPES_H_
 
 #include <linux/if_ether.h>
+#include <linux/ieee80211.h>
 #include <asm/byteorder.h>
-#include <linux/wireless.h>
 
 struct ieee_ie_header {
 	u8 id;
@@ -247,7 +247,7 @@
 	uint8_t active_metric_id;
 	uint8_t mesh_capability;
 	uint8_t mesh_id_len;
-	uint8_t mesh_id[IW_ESSID_MAX_SIZE];
+	uint8_t mesh_id[IEEE80211_MAX_SSID_LEN];
 } __attribute__ ((packed));
 
 struct mrvl_meshie {
--- linux-wl.orig/drivers/net/wireless/libertas/scan.c
+++ linux-wl/drivers/net/wireless/libertas/scan.c
@@ -19,11 +19,11 @@
 
 //! Approximate amount of data needed to pass a scan result back to iwlist
 #define MAX_SCAN_CELL_SIZE  (IW_EV_ADDR_LEN             \
-                             + IW_ESSID_MAX_SIZE        \
+                             + IEEE80211_MAX_SSID_LEN   \
                              + IW_EV_UINT_LEN           \
                              + IW_EV_FREQ_LEN           \
                              + IW_EV_QUAL_LEN           \
-                             + IW_ESSID_MAX_SIZE        \
+                             + IEEE80211_MAX_SSID_LEN   \
                              + IW_EV_PARAM_LEN          \
                              + 40)	/* 40 for WPAIE */
 
@@ -775,7 +775,7 @@
 	/* SSID */
 	iwe.cmd = SIOCGIWESSID;
 	iwe.u.data.flags = 1;
-	iwe.u.data.length = min((uint32_t) bss->ssid_len, (uint32_t) IW_ESSID_MAX_SIZE);
+	iwe.u.data.length = min((uint32_t) bss->ssid_len, (uint32_t) IEEE80211_MAX_SSID_LEN);
 	start = iwe_stream_add_point(info, start, stop, &iwe, bss->ssid);
 
 	/* Mode */
--- linux-wl.orig/drivers/net/wireless/libertas/wext.c
+++ linux-wl/drivers/net/wireless/libertas/wext.c
@@ -1989,7 +1989,7 @@
 {
 	struct lbs_private *priv = dev->ml_priv;
 	int ret = 0;
-	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len = 0;
 	struct assoc_request * assoc_req;
 	int in_ssid_len = dwrq->length;
@@ -2003,7 +2003,7 @@
 	}
 
 	/* Check the size of the string */
-	if (in_ssid_len > IW_ESSID_MAX_SIZE) {
+	if (in_ssid_len > IEEE80211_MAX_SSID_LEN) {
 		ret = -E2BIG;
 		goto out;
 	}
@@ -2034,7 +2034,7 @@
 			ret = -ENOMEM;
 		} else {
 			/* Copy the SSID to the association request */
-			memcpy(&assoc_req->ssid, &ssid, IW_ESSID_MAX_SIZE);
+			memcpy(&assoc_req->ssid, &ssid, IEEE80211_MAX_SSID_LEN);
 			assoc_req->ssid_len = ssid_len;
 			set_bit(ASSOC_FLAG_SSID, &assoc_req->flags);
 			lbs_postpone_association_work(priv);
@@ -2085,7 +2085,7 @@
 	}
 
 	/* Check the size of the string */
-	if (dwrq->length > IW_ESSID_MAX_SIZE) {
+	if (dwrq->length > IEEE80211_MAX_SSID_LEN) {
 		ret = -E2BIG;
 		goto out;
 	}

-- 
http://www.holgerschurig.de
