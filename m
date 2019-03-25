Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF118C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 08:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C993A20879
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 08:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbfCYIVG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 04:21:06 -0400
Received: from nbd.name ([46.4.11.11]:36736 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729914AbfCYIVF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 04:21:05 -0400
Received: from p548c84a0.dip0.t-ipconnect.de ([84.140.132.160] helo=bertha.datto.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1h8Kqt-0001AM-Vd; Mon, 25 Mar 2019 09:21:04 +0100
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>
Subject: [PATCH] mac80211: HE: add Spatial Reuse IE parsing support
Date:   Mon, 25 Mar 2019 09:20:57 +0100
Message-Id: <20190325082057.26710-1-john@phrozen.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add support to mac80211 for parsing SPR IEs as per
P802.11ax_D3.0 section 9.4.2.241.

Signed-off-by: John Crispin <john@phrozen.org>
---
 include/linux/ieee80211.h  | 49 ++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/util.c        |  4 ++++
 3 files changed, 54 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 48703ec60d06..9e4ca3053ab1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1629,6 +1629,18 @@ struct ieee80211_he_operation {
 } __packed;
 
 /**
+ * struct ieee80211_he_spr - HE spatial reuse element
+ *
+ * This structure is the "HE spatial reuse element" element as
+ * described in P802.11ax_D3.0 section 9.4.2.241
+ */
+struct ieee80211_he_spr {
+	u8 he_sr_control;
+	/* Optional 0 to 19 bytes: depends on @he_sr_control */
+	u8 optional[0];
+} __packed;
+
+/**
  * struct ieee80211_he_mu_edca_param_ac_rec - MU AC Parameter Record field
  *
  * This structure is the "MU AC Parameter Record" fields as
@@ -2063,6 +2075,42 @@ ieee80211_he_oper_size(const u8 *he_oper_ie)
 	return oper_len;
 }
 
+/* HE Spatial Reuse defines */
+#define IEEE80211_HE_SPR_NONE_SRG_OFFSET_PRESENT		0x4
+#define IEEE80211_HE_SPR_SRG_INFORMATION_PRESENT		0x8
+
+/*
+ * ieee80211_he_spr_size - calculate 802.11ax HE Spatial Reuse IE size
+ * @he_spr_ie: byte data of the He Spatial Reuse IE, stating from the the byte
+ *	after the ext ID byte. It is assumed that he_spr_ie has at least
+ *	sizeof(struct ieee80211_he_spr) bytes, checked already in
+ *	ieee802_11_parse_elems_crc()
+ * @return the actual size of the IE data (not including header), or 0 on error
+ */
+static inline u8
+ieee80211_he_spr_size(const u8 *he_spr_ie)
+{
+	struct ieee80211_he_spr *he_spr = (void *)he_spr_ie;
+	u8 spr_len = sizeof(struct ieee80211_he_spr);
+	u32 he_spr_params;
+
+	/* Make sure the input is not NULL */
+	if (!he_spr_ie)
+		return 0;
+
+	/* Calc required length */
+	he_spr_params = le32_to_cpu(he_spr->he_sr_control);
+	if (he_spr_params & IEEE80211_HE_SPR_NONE_SRG_OFFSET_PRESENT)
+		spr_len++;
+	if (he_spr_params & IEEE80211_HE_SPR_SRG_INFORMATION_PRESENT)
+		spr_len += 2;
+
+	/* Add the first byte (extension ID) to the total length */
+	spr_len++;
+
+	return spr_len;
+}
+
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
 #define WLAN_AUTH_SHARED_KEY 1
@@ -2485,6 +2533,7 @@ enum ieee80211_eid_ext {
 	WLAN_EID_EXT_HE_OPERATION = 36,
 	WLAN_EID_EXT_UORA = 37,
 	WLAN_EID_EXT_HE_MU_EDCA = 38,
+	WLAN_EID_EXT_HE_SPR = 39,
 	WLAN_EID_EXT_MAX_CHANNEL_SWITCH_TIME = 52,
 	WLAN_EID_EXT_MULTIPLE_BSSID_CONFIGURATION = 55,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e170f986d226..5c455681d1b8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1482,6 +1482,7 @@ struct ieee802_11_elems {
 	const struct ieee80211_meshconf_ie *mesh_config;
 	const u8 *he_cap;
 	const struct ieee80211_he_operation *he_operation;
+	const struct ieee80211_he_spr *he_spr;
 	const struct ieee80211_mu_edca_param_set *mu_edca_param_set;
 	const u8 *uora_element;
 	const u8 *mesh_id;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 4c1655972565..1b7076d24c18 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1282,6 +1282,10 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 				   WLAN_EID_EXT_MULTIPLE_BSSID_CONFIGURATION &&
 				   elen == 3) {
 				elems->mbssid_config_ie = (void *)&pos[1];
+			} else if (pos[0] == WLAN_EID_EXT_HE_SPR &&
+				   elen >= sizeof(*elems->he_spr) &&
+				   elen >= ieee80211_he_spr_size(&pos[1])) {
+				elems->he_spr = (void *)&pos[1];
 			}
 			break;
 		default:
-- 
2.11.0

