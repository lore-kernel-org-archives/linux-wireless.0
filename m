Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr18.hinet.net ([168.95.4.118]:46698 "EHLO msr18.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab1GPHBb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 03:01:31 -0400
From: Ali Bahar <ali@internetdog.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Ali Bahar <ali@internetdog.org>
Subject: [PATCH v2] staging: r8712u: Most return-values changed from -1 to proper errno macros.
Date: Sat, 16 Jul 2011 14:59:33 +0800
Message-Id: <1310799573-4407-1-git-send-email-ali@internetDog.org> (sfid-20110716_090141_960942_9B25D162)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ioctl handlers were frequently returning -1 upon failure. Most of
these have now been changed to proper errno macros.
The few remaining ones have been left untouched because either the
handler is not called (and so cannot be tested), or the function never
fails (and so cannot be system-tested), or requires new code to
distinguish its failures.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |   44 ++++++++++++------------
 drivers/staging/rtl8712/rtl871x_ioctl_set.c   |    3 +-
 drivers/staging/rtl8712/rtl871x_ioctl_set.h   |    2 +-
 3 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 40e6b5c..50b8b47 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -526,7 +526,7 @@ static int r871x_set_wpa_ie(struct _adapter *padapter, char *pie,
 		memcpy(buf, pie , ielen);
 		pos = buf;
 		if (ielen < RSN_HEADER_LEN) {
-			ret  = -1;
+			ret  = -EINVAL;
 			goto exit;
 		}
 		if (r8712_parse_wpa_ie(buf, ielen, &group_cipher,
@@ -736,8 +736,9 @@ static int r8711_wx_get_freq(struct net_device *dev,
 			       pcur_bss->Configuration.DSConfig-1] * 100000;
 		wrqu->freq.e = 1;
 		wrqu->freq.i = pcur_bss->Configuration.DSConfig;
-	} else
-		return -1;
+	} else {
+		return -ENOLINK;
+	}
 	return 0;
 }
 
@@ -768,8 +769,8 @@ static int r8711_wx_set_mode(struct net_device *dev,
 		r8712_setopmode_cmd(padapter, networkType);
 	else
 		r8712_setopmode_cmd(padapter, Ndis802_11AutoUnknown);
-	if (!r8712_set_802_11_infrastructure_mode(padapter, networkType))
-		return -1;
+
+	r8712_set_802_11_infrastructure_mode(padapter, networkType);
 	return 0;
 }
 
@@ -995,7 +996,7 @@ static int r8711_wx_set_wap(struct net_device *dev,
 	if (padapter->bup == false)
 		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true)
-		return -1;
+		return -EBUSY;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING) == true)
 		return ret;
 	if (temp->sa_family != ARPHRD_ETHER)
@@ -1012,16 +1013,15 @@ static int r8711_wx_set_wap(struct net_device *dev,
 		pmlmepriv->pscanned = get_next(pmlmepriv->pscanned);
 		dst_bssid = pnetwork->network.MacAddress;
 		if (!memcmp(dst_bssid, temp->sa_data, ETH_ALEN)) {
-			if (r8712_set_802_11_infrastructure_mode(padapter,
-			    pnetwork->network.InfrastructureMode) == false)
-				ret = -1;
+			r8712_set_802_11_infrastructure_mode(padapter,
+			    pnetwork->network.InfrastructureMode);
 			break;
 		}
 	}
 	spin_unlock_irqrestore(&queue->lock, irqL);
 	if (!ret) {
 		if (!r8712_set_802_11_authentication_mode(padapter, authmode))
-			ret = -1;
+			ret = -ENOMEM;
 		else {
 			if (!r8712_set_802_11_bssid(padapter, temp->sa_data))
 				ret = -1;
@@ -1088,7 +1088,7 @@ static int r8711_wx_set_scan(struct net_device *dev,
 		return -1;
 	}
 	if (padapter->bup == false)
-		return -1;
+		return -ENETDOWN;
 	if (padapter->hw_init_completed == false)
 		return -1;
 	if ((check_fwstate(pmlmepriv, _FW_UNDER_SURVEY|_FW_UNDER_LINKING)) ||
@@ -1187,7 +1187,7 @@ static int r8711_wx_set_essid(struct net_device *dev,
 	if (padapter->bup == false)
 		return -1;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
-		return -1;
+		return -EBUSY;
 	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING))
 		return 0;
 	if (wrqu->essid.length > IW_ESSID_MAX_SIZE)
@@ -1212,10 +1212,9 @@ static int r8711_wx_set_essid(struct net_device *dev,
 			if ((!memcmp(dst_ssid, src_ssid, ndis_ssid.SsidLength))
 			    && (pnetwork->network.Ssid.SsidLength ==
 			     ndis_ssid.SsidLength)) {
-				if (!r8712_set_802_11_infrastructure_mode(
+				r8712_set_802_11_infrastructure_mode(
 				     padapter,
-				     pnetwork->network.InfrastructureMode))
-					return -1;
+				     pnetwork->network.InfrastructureMode);
 				break;
 			}
 		}
@@ -1239,8 +1238,9 @@ static int r8711_wx_get_essid(struct net_device *dev,
 		wrqu->essid.length = len;
 		memcpy(extra, pcur_bss->Ssid.Ssid, len);
 		wrqu->essid.flags = 1;
-	} else
-		ret = -1;
+	} else {
+		ret = -ENOLINK;
+	}
 	return ret;
 }
 
@@ -1312,7 +1312,7 @@ set_rate:
 			datarates[i] = 0xff;
 	}
 	if (r8712_setdatarate_cmd(padapter, datarates) != _SUCCESS)
-		ret = -1;
+		ret = -ENOMEM;
 	return ret;
 }
 
@@ -1371,7 +1371,7 @@ static int r8711_wx_get_rate(struct net_device *dev,
 			wrqu->bitrate.value = max_rate * 500000;
 		}
 	} else
-		return -1;
+		return -ENOLINK;
 	return 0;
 }
 
@@ -1701,7 +1701,7 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
 	param_len = sizeof(struct ieee_param) + pext->key_len;
 	param = (struct ieee_param *)_malloc(param_len);
 	if (param == NULL)
-		return -1;
+		return -ENOMEM;
 	memset(param, 0, param_len);
 	param->cmd = IEEE_CMD_SET_ENCRYPTION;
 	memset(param->sta_addr, 0xff, ETH_ALEN);
@@ -1719,7 +1719,7 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
 		alg_name = "CCMP";
 		break;
 	default:
-		return -1;
+		return -EINVAL;
 	}
 	strncpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
 	if (pext->ext_flags & IW_ENCODE_EXT_GROUP_KEY)
@@ -1785,7 +1785,7 @@ static int dummy(struct net_device *dev,
 		struct iw_request_info *a,
 		union iwreq_data *wrqu, char *b)
 {
-	return -1;
+	return -ENOSYS;
 }
 
 static int r8711_drvext_hdl(struct net_device *dev,
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_set.c b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
index 8486eb1..fb29b42 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_set.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
@@ -243,7 +243,7 @@ done:
 	spin_unlock_irqrestore(&pmlmepriv->lock, irqL);
 }
 
-u8 r8712_set_802_11_infrastructure_mode(struct _adapter *padapter,
+void r8712_set_802_11_infrastructure_mode(struct _adapter *padapter,
 	enum NDIS_802_11_NETWORK_INFRASTRUCTURE networktype)
 {
 	unsigned long irqL;
@@ -290,7 +290,6 @@ u8 r8712_set_802_11_infrastructure_mode(struct _adapter *padapter,
 		}
 		spin_unlock_irqrestore(&pmlmepriv->lock, irqL);
 	}
-	return true;
 }
 
 u8 r8712_set_802_11_disassociate(struct _adapter *padapter)
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_set.h b/drivers/staging/rtl8712/rtl871x_ioctl_set.h
index 8dff2b1..ef92fed 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_set.h
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_set.h
@@ -22,7 +22,7 @@ u8 r8712_set_802_11_disassociate(struct _adapter *padapter);
 
 u8 r8712_set_802_11_bssid_list_scan(struct _adapter *padapter);
 
-u8 r8712_set_802_11_infrastructure_mode(struct _adapter *padapter,
+void r8712_set_802_11_infrastructure_mode(struct _adapter *padapter,
 			enum NDIS_802_11_NETWORK_INFRASTRUCTURE networktype);
 
 void r8712_set_802_11_ssid(struct _adapter *padapter,
-- 
1.7.6

