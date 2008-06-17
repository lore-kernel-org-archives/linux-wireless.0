Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:35750 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbYFQQBV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 12:01:21 -0400
Message-Id: <20080617160027.897662688@localhost> (sfid-20080617_180143_912941_3FB21552)
References: <20080617154008.883383150@localhost>
Date: Tue, 17 Jun 2008 18:40:15 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 7/7] 802.11w: Configuration of MFP disabled/optional/required
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new WEXT IW_AUTH_* parameter for setting MFP
disabled/optional/required.

Signed-off-by: Jouni Malinen <j@w1.fi>


Index: wireless-testing/include/linux/wireless.h
===================================================================
--- wireless-testing.orig/include/linux/wireless.h
+++ wireless-testing/include/linux/wireless.h
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
Index: wireless-testing/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-testing.orig/net/mac80211/ieee80211_i.h
+++ wireless-testing/net/mac80211/ieee80211_i.h
@@ -372,6 +372,11 @@ struct ieee80211_if_sta {
 	int auth_alg; /* currently used IEEE 802.11 authentication algorithm */
 	int auth_transaction;
 
+#define IEEE80211_MFP_DISABLED 0
+#define IEEE80211_MFP_OPTIONAL 1
+#define IEEE80211_MFP_REQUIRED 2
+	int mfp; /* management frame protection */
+
 	unsigned long ibss_join_req;
 	struct sk_buff *probe_resp; /* ProbeResp template for IBSS */
 	u32 supp_rates_bits[IEEE80211_NUM_BANDS];
Index: wireless-testing/net/mac80211/wext.c
===================================================================
--- wireless-testing.orig/net/mac80211/wext.c
+++ wireless-testing/net/mac80211/wext.c
@@ -1003,6 +1003,13 @@ static int ieee80211_ioctl_siwauth(struc
 		else
 			ret = -EOPNOTSUPP;
 		break;
+	case IW_AUTH_MFP:
+		if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+		    sdata->vif.type == IEEE80211_IF_TYPE_IBSS)
+			sdata->u.sta.mfp = data->value;
+		else
+			ret = -EOPNOTSUPP;
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;

--

-- 
Jouni Malinen                                            PGP id EFC895FA
