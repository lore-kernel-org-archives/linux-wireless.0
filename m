Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46802 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755914AbYLaPmd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 10:42:33 -0500
Message-Id: <20081231154224.895735911@w1.fi> (sfid-20081231_164236_937324_6C9976A7)
References: <20081231153834.840526845@w1.fi>
Date: Wed, 31 Dec 2008 17:38:41 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [RFC 07/11] mac80211: 802.11w - Configuration of MFP disabled/optional/required
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new WEXT IW_AUTH_* parameter for setting MFP
disabled/optional/required.

Signed-off-by: Jouni Malinen <j@w1.fi>


---
 include/linux/wireless.h   |    6 ++++++
 net/mac80211/ieee80211_i.h |    6 ++++++
 net/mac80211/mlme.c        |    4 ++++
 net/mac80211/wext.c        |    7 +++++++
 4 files changed, 23 insertions(+)

--- wireless-testing.orig/include/linux/wireless.h	2008-12-31 17:11:41.000000000 +0200
+++ wireless-testing/include/linux/wireless.h	2008-12-31 17:12:37.000000000 +0200
@@ -578,6 +578,7 @@
 #define IW_AUTH_ROAMING_CONTROL		9
 #define IW_AUTH_PRIVACY_INVOKED		10
 #define IW_AUTH_CIPHER_GROUP_MGMT	11
+#define IW_AUTH_MFP			12
 
 /* IW_AUTH_WPA_VERSION values (bit field) */
 #define IW_AUTH_WPA_VERSION_DISABLED	0x00000001
@@ -607,6 +608,11 @@
 #define IW_AUTH_ROAMING_DISABLE	1	/* user space program used for roaming
 					 * control */
 
+/* IW_AUTH_MFP (management frame protection) values */
+#define IW_AUTH_MFP_DISABLED	0	/* MFP disabled */
+#define IW_AUTH_MFP_OPTIONAL	1	/* MFP optional */
+#define IW_AUTH_MFP_REQUIRED	2	/* MFP required */
+
 /* SIOCSIWENCODEEXT definitions */
 #define IW_ENCODE_SEQ_MAX_SIZE	8
 /* struct iw_encode_ext ->alg */
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2008-12-31 17:04:36.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2008-12-31 17:12:37.000000000 +0200
@@ -317,6 +317,12 @@ struct ieee80211_if_sta {
 	int auth_alg; /* currently used IEEE 802.11 authentication algorithm */
 	int auth_transaction;
 
+	enum {
+		IEEE80211_MFP_DISABLED,
+		IEEE80211_MFP_OPTIONAL,
+		IEEE80211_MFP_REQUIRED
+	} mfp; /* management frame protection */
+
 	unsigned long ibss_join_req;
 	struct sk_buff *probe_resp; /* ProbeResp template for IBSS */
 	u32 supp_rates_bits[IEEE80211_NUM_BANDS];
--- wireless-testing.orig/net/mac80211/wext.c	2008-12-31 17:11:41.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2008-12-31 17:12:37.000000000 +0200
@@ -961,6 +961,13 @@ static int ieee80211_ioctl_siwauth(struc
 		else
 			ret = -EOPNOTSUPP;
 		break;
+	case IW_AUTH_MFP:
+		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+		    sdata->vif.type == NL80211_IFTYPE_ADHOC)
+			sdata->u.sta.mfp = data->value;
+		else
+			ret = -EOPNOTSUPP;
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
--- wireless-testing.orig/net/mac80211/mlme.c	2008-12-31 16:48:01.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2008-12-31 17:12:37.000000000 +0200
@@ -2332,6 +2332,10 @@ static int ieee80211_sta_config_auth(str
 					       selected->ssid_len);
 		ieee80211_sta_set_bssid(sdata, selected->bssid);
 		ieee80211_sta_def_wmm_params(sdata, selected);
+		if (sdata->u.sta.mfp == IEEE80211_MFP_REQUIRED)
+			sdata->u.sta.flags |= IEEE80211_STA_MFP_ENABLED;
+		else
+			sdata->u.sta.flags &= ~IEEE80211_STA_MFP_ENABLED;
 
 		/* Send out direct probe if no probe resp was received or
 		 * the one we have is outdated

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
