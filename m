Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:58368 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab1K2Rkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 12:40:32 -0500
Received: by qao25 with SMTP id 25so549945qao.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 09:40:31 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <j@w1.fi>, David Miller <davem@davemloft.net>
Subject: [PATCH] prism54: remove private driver ioctls
Date: Tue, 29 Nov 2011 12:40:16 -0500
Message-Id: <1322588416-15398-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111129_184047_049453_68518B13)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As of hostap_0_7_1~358 the CONFIG_DRIVER_PRISM54
was removed from upstream wpa_supplicant/hostapd so
lets just kill the useless old prism54 private ioctl
crap.

Cc: Jouni Malinen <j@w1.fi>
Cc: David Miller <davem@davemloft.net>
Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/prism54/isl_ioctl.c  |  333 -----------------------------
 drivers/net/wireless/prism54/isl_ioctl.h  |    2 -
 drivers/net/wireless/prism54/islpci_dev.c |    1 -
 3 files changed, 0 insertions(+), 336 deletions(-)

diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index bc2ba80..4e44b1a 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -2493,323 +2493,7 @@ prism54_set_mac_address(struct net_device *ndev, void *addr)
 	return ret;
 }
 
-/* Note: currently, use hostapd ioctl from the Host AP driver for WPA
- * support. This is to be replaced with Linux wireless extensions once they
- * get WPA support. */
-
-/* Note II: please leave all this together as it will be easier to remove later,
- * once wireless extensions add WPA support -mcgrof */
-
-/* PRISM54_HOSTAPD ioctl() cmd: */
-enum {
-	PRISM2_SET_ENCRYPTION = 6,
-	PRISM2_HOSTAPD_SET_GENERIC_ELEMENT = 12,
-	PRISM2_HOSTAPD_MLME = 13,
-	PRISM2_HOSTAPD_SCAN_REQ = 14,
-};
-
 #define PRISM54_SET_WPA			SIOCIWFIRSTPRIV+12
-#define PRISM54_HOSTAPD			SIOCIWFIRSTPRIV+25
-#define PRISM54_DROP_UNENCRYPTED	SIOCIWFIRSTPRIV+26
-
-#define PRISM2_HOSTAPD_MAX_BUF_SIZE 1024
-#define PRISM2_HOSTAPD_GENERIC_ELEMENT_HDR_LEN \
-	offsetof(struct prism2_hostapd_param, u.generic_elem.data)
-
-/* Maximum length for algorithm names (-1 for nul termination)
- * used in ioctl() */
-#define HOSTAP_CRYPT_ALG_NAME_LEN 16
-
-struct prism2_hostapd_param {
-	u32 cmd;
-	u8 sta_addr[ETH_ALEN];
-	union {
-	       struct {
-		       u8 alg[HOSTAP_CRYPT_ALG_NAME_LEN];
-		       u32 flags;
-		       u32 err;
-		       u8 idx;
-		       u8 seq[8]; /* sequence counter (set: RX, get: TX) */
-		       u16 key_len;
-		       u8 key[0];
-		       } crypt;
-               struct {
-                       u8 len;
-                       u8 data[0];
-               } generic_elem;
-               struct {
-#define MLME_STA_DEAUTH 0
-#define MLME_STA_DISASSOC 1
-                       u16 cmd;
-                       u16 reason_code;
-               } mlme;
-               struct {
-                       u8 ssid_len;
-                       u8 ssid[32];
-               } scan_req;
-       } u;
-};
-
-
-static int
-prism2_ioctl_set_encryption(struct net_device *dev,
-	struct prism2_hostapd_param *param,
-	int param_len)
-{
-	islpci_private *priv = netdev_priv(dev);
-	int rvalue = 0, force = 0;
-	int authen = DOT11_AUTH_OS, invoke = 0, exunencrypt = 0;
-	union oid_res_t r;
-
-	/* with the new API, it's impossible to get a NULL pointer.
-	 * New version of iwconfig set the IW_ENCODE_NOKEY flag
-	 * when no key is given, but older versions don't. */
-
-	if (param->u.crypt.key_len > 0) {
-		/* we have a key to set */
-		int index = param->u.crypt.idx;
-		int current_index;
-		struct obj_key key = { DOT11_PRIV_TKIP, 0, "" };
-
-		/* get the current key index */
-		rvalue = mgt_get_request(priv, DOT11_OID_DEFKEYID, 0, NULL, &r);
-		current_index = r.u;
-		/* Verify that the key is not marked as invalid */
-		if (!(param->u.crypt.flags & IW_ENCODE_NOKEY)) {
-			key.length = param->u.crypt.key_len > sizeof (param->u.crypt.key) ?
-			    sizeof (param->u.crypt.key) : param->u.crypt.key_len;
-			memcpy(key.key, param->u.crypt.key, key.length);
-			if (key.length == 32)
-				/* we want WPA-PSK */
-				key.type = DOT11_PRIV_TKIP;
-			if ((index < 0) || (index > 3))
-				/* no index provided use the current one */
-				index = current_index;
-
-			/* now send the key to the card  */
-			rvalue |=
-			    mgt_set_request(priv, DOT11_OID_DEFKEYX, index,
-					    &key);
-		}
-		/*
-		 * If a valid key is set, encryption should be enabled
-		 * (user may turn it off later).
-		 * This is also how "iwconfig ethX key on" works
-		 */
-		if ((index == current_index) && (key.length > 0))
-			force = 1;
-	} else {
-		int index = (param->u.crypt.flags & IW_ENCODE_INDEX) - 1;
-		if ((index >= 0) && (index <= 3)) {
-			/* we want to set the key index */
-			rvalue |=
-			    mgt_set_request(priv, DOT11_OID_DEFKEYID, 0,
-					    &index);
-		} else {
-			if (!(param->u.crypt.flags & IW_ENCODE_MODE)) {
-				/* we cannot do anything. Complain. */
-				return -EINVAL;
-			}
-		}
-	}
-	/* now read the flags */
-	if (param->u.crypt.flags & IW_ENCODE_DISABLED) {
-		/* Encoding disabled,
-		 * authen = DOT11_AUTH_OS;
-		 * invoke = 0;
-		 * exunencrypt = 0; */
-	}
-	if (param->u.crypt.flags & IW_ENCODE_OPEN)
-		/* Encode but accept non-encoded packets. No auth */
-		invoke = 1;
-	if ((param->u.crypt.flags & IW_ENCODE_RESTRICTED) || force) {
-		/* Refuse non-encoded packets. Auth */
-		authen = DOT11_AUTH_BOTH;
-		invoke = 1;
-		exunencrypt = 1;
-	}
-	/* do the change if requested  */
-	if ((param->u.crypt.flags & IW_ENCODE_MODE) || force) {
-		rvalue |=
-		    mgt_set_request(priv, DOT11_OID_AUTHENABLE, 0, &authen);
-		rvalue |=
-		    mgt_set_request(priv, DOT11_OID_PRIVACYINVOKED, 0, &invoke);
-		rvalue |=
-		    mgt_set_request(priv, DOT11_OID_EXUNENCRYPTED, 0,
-				    &exunencrypt);
-	}
-	return rvalue;
-}
-
-static int
-prism2_ioctl_set_generic_element(struct net_device *ndev,
-	struct prism2_hostapd_param *param,
-	int param_len)
-{
-       islpci_private *priv = netdev_priv(ndev);
-       int max_len, len, alen, ret=0;
-       struct obj_attachment *attach;
-
-       len = param->u.generic_elem.len;
-       max_len = param_len - PRISM2_HOSTAPD_GENERIC_ELEMENT_HDR_LEN;
-       if (max_len < 0 || max_len < len)
-               return -EINVAL;
-
-       alen = sizeof(*attach) + len;
-       attach = kzalloc(alen, GFP_KERNEL);
-       if (attach == NULL)
-               return -ENOMEM;
-
-#define WLAN_FC_TYPE_MGMT 0
-#define WLAN_FC_STYPE_ASSOC_REQ 0
-#define WLAN_FC_STYPE_REASSOC_REQ 2
-
-       /* Note: endianness is covered by mgt_set_varlen */
-
-       attach->type = (WLAN_FC_TYPE_MGMT << 2) |
-               (WLAN_FC_STYPE_ASSOC_REQ << 4);
-       attach->id = -1;
-       attach->size = len;
-       memcpy(attach->data, param->u.generic_elem.data, len);
-
-       ret = mgt_set_varlen(priv, DOT11_OID_ATTACHMENT, attach, len);
-
-       if (ret == 0) {
-               attach->type = (WLAN_FC_TYPE_MGMT << 2) |
-                       (WLAN_FC_STYPE_REASSOC_REQ << 4);
-
-	       ret = mgt_set_varlen(priv, DOT11_OID_ATTACHMENT, attach, len);
-
-	       if (ret == 0)
-		       printk(KERN_DEBUG "%s: WPA IE Attachment was set\n",
-				       ndev->name);
-       }
-
-       kfree(attach);
-       return ret;
-
-}
-
-static int
-prism2_ioctl_mlme(struct net_device *dev, struct prism2_hostapd_param *param)
-{
-	return -EOPNOTSUPP;
-}
-
-static int
-prism2_ioctl_scan_req(struct net_device *ndev,
-                     struct prism2_hostapd_param *param)
-{
-	islpci_private *priv = netdev_priv(ndev);
-	struct iw_request_info info;
-	int i, rvalue;
-	struct obj_bsslist *bsslist;
-	u32 noise = 0;
-	char *extra = "";
-	char *current_ev = "foo";
-	union oid_res_t r;
-
-	if (islpci_get_state(priv) < PRV_STATE_INIT) {
-		/* device is not ready, fail gently */
-		return 0;
-	}
-
-	/* first get the noise value. We will use it to report the link quality */
-	rvalue = mgt_get_request(priv, DOT11_OID_NOISEFLOOR, 0, NULL, &r);
-	noise = r.u;
-
-	/* Ask the device for a list of known bss. We can report at most
-	 * IW_MAX_AP=64 to the range struct. But the device won't repport anything
-	 * if you change the value of IWMAX_BSS=24.
-	 */
-	rvalue |= mgt_get_request(priv, DOT11_OID_BSSLIST, 0, NULL, &r);
-	bsslist = r.ptr;
-
-	info.cmd = PRISM54_HOSTAPD;
-	info.flags = 0;
-
-	/* ok now, scan the list and translate its info */
-	for (i = 0; i < min(IW_MAX_AP, (int) bsslist->nr); i++)
-		current_ev = prism54_translate_bss(ndev, &info, current_ev,
-						   extra + IW_SCAN_MAX_DATA,
-						   &(bsslist->bsslist[i]),
-						   noise);
-	kfree(bsslist);
-
-	return rvalue;
-}
-
-static int
-prism54_hostapd(struct net_device *ndev, struct iw_point *p)
-{
-       struct prism2_hostapd_param *param;
-       int ret = 0;
-       u32 uwrq;
-
-       printk(KERN_DEBUG "prism54_hostapd - len=%d\n", p->length);
-       if (p->length < sizeof(struct prism2_hostapd_param) ||
-           p->length > PRISM2_HOSTAPD_MAX_BUF_SIZE || !p->pointer)
-               return -EINVAL;
-
-	param = memdup_user(p->pointer, p->length);
-	if (IS_ERR(param))
-		return PTR_ERR(param);
-
-       switch (param->cmd) {
-       case PRISM2_SET_ENCRYPTION:
-	       printk(KERN_DEBUG "%s: Caught WPA supplicant set encryption request\n",
-			       ndev->name);
-               ret = prism2_ioctl_set_encryption(ndev, param, p->length);
-               break;
-       case PRISM2_HOSTAPD_SET_GENERIC_ELEMENT:
-	       printk(KERN_DEBUG "%s: Caught WPA supplicant set WPA IE request\n",
-			       ndev->name);
-               ret = prism2_ioctl_set_generic_element(ndev, param,
-                                                      p->length);
-               break;
-       case PRISM2_HOSTAPD_MLME:
-	       printk(KERN_DEBUG "%s: Caught WPA supplicant MLME request\n",
-			       ndev->name);
-               ret = prism2_ioctl_mlme(ndev, param);
-               break;
-       case PRISM2_HOSTAPD_SCAN_REQ:
-	       printk(KERN_DEBUG "%s: Caught WPA supplicant scan request\n",
-			       ndev->name);
-               ret = prism2_ioctl_scan_req(ndev, param);
-               break;
-	case PRISM54_SET_WPA:
-	       printk(KERN_DEBUG "%s: Caught WPA supplicant wpa init request\n",
-			       ndev->name);
-	       uwrq = 1;
-	       ret = prism54_set_wpa(ndev, NULL, &uwrq, NULL);
-	       break;
-	case PRISM54_DROP_UNENCRYPTED:
-	       printk(KERN_DEBUG "%s: Caught WPA drop unencrypted request\n",
-			       ndev->name);
-#if 0
-	       uwrq = 0x01;
-	       mgt_set(priv, DOT11_OID_EXUNENCRYPTED, &uwrq);
-	       down_write(&priv->mib_sem);
-	       mgt_commit(priv);
-	       up_write(&priv->mib_sem);
-#endif
-	       /* Not necessary, as set_wpa does it, should we just do it here though? */
-	       ret = 0;
-	       break;
-       default:
-	       printk(KERN_DEBUG "%s: Caught a WPA supplicant request that is not supported\n",
-			       ndev->name);
-               ret = -EOPNOTSUPP;
-               break;
-       }
-
-       if (ret == 0 && copy_to_user(p->pointer, param, p->length))
-               ret = -EFAULT;
-
-       kfree(param);
-
-       return ret;
-}
 
 static int
 prism54_set_wpa(struct net_device *ndev, struct iw_request_info *info,
@@ -3223,20 +2907,3 @@ const struct iw_handler_def prism54_handler_def = {
 	.private_args = (struct iw_priv_args *) prism54_private_args,
 	.get_wireless_stats = prism54_get_wireless_stats,
 };
-
-/* For wpa_supplicant */
-
-int
-prism54_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
-{
-	struct iwreq *wrq = (struct iwreq *) rq;
-	int ret = -1;
-	switch (cmd) {
-		case PRISM54_HOSTAPD:
-		if (!capable(CAP_NET_ADMIN))
-			return -EPERM;
-		ret = prism54_hostapd(ndev, &wrq->u.data);
-		return ret;
-	}
-	return -EOPNOTSUPP;
-}
diff --git a/drivers/net/wireless/prism54/isl_ioctl.h b/drivers/net/wireless/prism54/isl_ioctl.h
index bcfbfb9..a34bceb 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.h
+++ b/drivers/net/wireless/prism54/isl_ioctl.h
@@ -43,8 +43,6 @@ void prism54_wpa_bss_ie_clean(islpci_private *priv);
 
 int prism54_set_mac_address(struct net_device *, void *);
 
-int prism54_ioctl(struct net_device *, struct ifreq *, int);
-
 extern const struct iw_handler_def prism54_handler_def;
 
 #endif				/* _ISL_IOCTL_H */
diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index 8a3cf4f..5970ff6 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -804,7 +804,6 @@ static const struct ethtool_ops islpci_ethtool_ops = {
 static const struct net_device_ops islpci_netdev_ops = {
 	.ndo_open 		= islpci_open,
 	.ndo_stop		= islpci_close,
-	.ndo_do_ioctl		= prism54_ioctl,
 	.ndo_start_xmit		= islpci_eth_transmit,
 	.ndo_tx_timeout		= islpci_eth_tx_timeout,
 	.ndo_set_mac_address 	= prism54_set_mac_address,
-- 
1.7.4.15.g7811d

