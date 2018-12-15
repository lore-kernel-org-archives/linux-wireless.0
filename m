Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FE1C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D257A2084D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbeLOJDg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:03:36 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42194 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729077AbeLOJDf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:03:35 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rB-0002oc-48; Sat, 15 Dec 2018 11:03:33 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:04 +0200
Message-Id: <20181215090325.31604-4-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/24] mac80211: propagate the support for TWT to the driver
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

TWT is a feature that was added in 11ah and enhanced in
11ax. There are two bits that need to be set if we want
to use the feature in 11ax: one in the HE Capability IE
and one in the Extended Capability IE. This is because
of backward compatibility between 11ah and 11ax.

In order to simplify the flow for the low level driver
in managed mode, aggregate the two bits and add a boolean
that tells whether TWT is supported or not, but only if
11ax is supported.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h |  3 +++
 net/mac80211/mlme.c    | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9386cf9fe714..1553152b77e0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -496,6 +496,8 @@ struct ieee80211_ftm_responder_params {
  * @uora_ocw_range: UORA element's OCW Range field
  * @frame_time_rts_th: HE duration RTS threshold, in units of 32us
  * @he_support: does this BSS support HE
+ * @twt_requester: does this BSS support TWT requester (relevant for managed
+ *	mode only, set if the AP advertises TWT responder role)
  * @assoc: association status
  * @ibss_joined: indicates whether this station is part of an IBSS
  *	or not
@@ -594,6 +596,7 @@ struct ieee80211_bss_conf {
 	u8 uora_ocw_range;
 	u16 frame_time_rts_th;
 	bool he_support;
+	bool twt_requester;
 	/* association related data */
 	bool assoc, ibss_joined;
 	bool ibss_creator;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d2bc8d57c87e..3d1334a4a264 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3058,6 +3058,19 @@ static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
 	}
 }
 
+static bool ieee80211_twt_req_supported(const struct sta_info *sta,
+					const struct ieee802_11_elems *elems)
+{
+	if (elems->ext_capab_len < 10)
+		return false;
+
+	if (!(elems->ext_capab[9] & WLAN_EXT_CAPA10_TWT_RESPONDER_SUPPORT))
+		return false;
+
+	return sta->sta.he_cap.he_cap_elem.mac_cap_info[0] &
+		IEEE80211_HE_MAC_CAP0_TWT_RES;
+}
+
 static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 				    struct cfg80211_bss *cbss,
 				    struct ieee80211_mgmt *mgmt, size_t len)
@@ -3247,8 +3260,11 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 						  sta);
 
 		bss_conf->he_support = sta->sta.he_cap.has_he;
+		bss_conf->twt_requester =
+			ieee80211_twt_req_supported(sta, &elems);
 	} else {
 		bss_conf->he_support = false;
+		bss_conf->twt_requester = false;
 	}
 
 	if (bss_conf->he_support) {
-- 
2.19.2

