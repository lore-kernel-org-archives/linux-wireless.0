Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52162 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752145AbdDCOjU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 10:39:20 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v33EYq2N029554
        for <linux-wireless@vger.kernel.org>; Mon, 3 Apr 2017 07:39:20 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 29kgqnt8j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 07:39:19 -0700
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Karthik Ananthapadmanabha <karthida@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: add missing IEs related to TDLS operation
Date: Mon, 3 Apr 2017 20:06:50 +0530
Message-ID: <1491230210-28489-1-git-send-email-gbhat@marvell.com> (sfid-20170403_163924_421877_54C516FF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik Ananthapadmanabha <karthida@marvell.com>

In mwifiex,IEs such as supported channels, supported operating classes
20/40 BSS COexistence are missing and also extra QOS capabilities IE
is added during TDLS discovery response, TDLS setup request and
TDLS setupresponse.
This patch adds require IEs and also removes extra IE.

Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/ioctl.h |  2 ++
 drivers/net/wireless/marvell/mwifiex/tdls.c  | 49 ++++++++++++++++++++++++++--
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/ioctl.h b/drivers/net/wireless/marvell/mwifiex/ioctl.h
index 536ab83..48e154e 100644
--- a/drivers/net/wireless/marvell/mwifiex/ioctl.h
+++ b/drivers/net/wireless/marvell/mwifiex/ioctl.h
@@ -91,6 +91,8 @@ struct wep_key {
 #define MWIFIEX_TDLS_DEF_QOS_CAPAB		0xf
 #define MWIFIEX_PRIO_BK				2
 #define MWIFIEX_PRIO_VI				5
+#define MWIFIEX_SUPPORTED_CHANNELS		2
+#define MWIFIEX_OPERATING_CLASSES		16
 
 struct mwifiex_uap_bss_param {
 	u8 channel;
diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wireless/marvell/mwifiex/tdls.c
index e228c03..6e507c99 100644
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -431,6 +431,41 @@ static void mwifiex_tdls_add_qos_capab(struct sk_buff *skb)
 	*buf++ = qosinfo; /* U-APSD no in use */
 }
 
+static void mwifiex_tdls_add_bss_co_2040(struct sk_buff *skb)
+{
+	struct ieee_types_bss_co_2040 *bssco;
+
+	bssco = (void *)skb_put(skb, sizeof(struct ieee_types_bss_co_2040));
+	bssco->ieee_hdr.element_id = WLAN_EID_BSS_COEX_2040;
+	bssco->ieee_hdr.len = sizeof(struct ieee_types_bss_co_2040) -
+			      sizeof(struct ieee_types_header);
+	bssco->bss_2040co = 0x01;
+}
+
+static void mwifiex_tdls_add_supported_chan(struct sk_buff *skb)
+{
+	struct ieee_types_generic *supp_chan;
+	u8 chan_supp[] = {1, 11};
+
+	supp_chan = (void *)skb_put(skb, (sizeof(struct ieee_types_header) +
+					  sizeof(chan_supp)));
+	supp_chan->ieee_hdr.element_id = WLAN_EID_SUPPORTED_CHANNELS;
+	supp_chan->ieee_hdr.len = sizeof(chan_supp);
+	memcpy(supp_chan->data, chan_supp, sizeof(chan_supp));
+}
+
+static void mwifiex_tdls_add_oper_class(struct sk_buff *skb)
+{
+	struct ieee_types_generic *reg_class;
+	u8 rc_list[] = {1,
+		1, 2, 3, 4, 12, 22, 23, 24, 25, 27, 28, 29, 30, 32, 33};
+	reg_class = (void *)skb_put(skb, (sizeof(struct ieee_types_header) +
+					  sizeof(rc_list)));
+	reg_class->ieee_hdr.element_id = WLAN_EID_SUPPORTED_REGULATORY_CLASSES;
+	reg_class->ieee_hdr.len = sizeof(rc_list);
+	memcpy(reg_class->data, rc_list, sizeof(rc_list));
+}
+
 static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
 					const u8 *peer, u8 action_code,
 					u8 dialog_token,
@@ -484,7 +519,9 @@ static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
 		}
 
 		mwifiex_tdls_add_ext_capab(priv, skb);
-		mwifiex_tdls_add_qos_capab(skb);
+		mwifiex_tdls_add_bss_co_2040(skb);
+		mwifiex_tdls_add_supported_chan(skb);
+		mwifiex_tdls_add_oper_class(skb);
 		mwifiex_add_wmm_info_ie(priv, skb, 0);
 		break;
 
@@ -522,7 +559,9 @@ static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
 		}
 
 		mwifiex_tdls_add_ext_capab(priv, skb);
-		mwifiex_tdls_add_qos_capab(skb);
+		mwifiex_tdls_add_bss_co_2040(skb);
+		mwifiex_tdls_add_supported_chan(skb);
+		mwifiex_tdls_add_oper_class(skb);
 		mwifiex_add_wmm_info_ie(priv, skb, 0);
 		break;
 
@@ -612,6 +651,9 @@ int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, const u8 *peer,
 		  sizeof(struct ieee_types_bss_co_2040) +
 		  sizeof(struct ieee80211_ht_operation) +
 		  sizeof(struct ieee80211_tdls_lnkie) +
+		  (2 * (sizeof(struct ieee_types_header))) +
+		   MWIFIEX_SUPPORTED_CHANNELS +
+		   MWIFIEX_OPERATING_CLASSES +
 		  sizeof(struct ieee80211_wmm_param_ie) +
 		  extra_ies_len;
 
@@ -760,7 +802,10 @@ int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, const u8 *peer,
 		}
 
 		mwifiex_tdls_add_ext_capab(priv, skb);
+		mwifiex_tdls_add_bss_co_2040(skb);
+		mwifiex_tdls_add_supported_chan(skb);
 		mwifiex_tdls_add_qos_capab(skb);
+		mwifiex_tdls_add_oper_class(skb);
 		break;
 	default:
 		mwifiex_dbg(priv->adapter, ERROR, "Unknown TDLS action frame type\n");
-- 
1.9.1
