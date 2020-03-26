Return-Path: <SRS0=ssZ+=5L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 510B4C43331
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Mar 2020 13:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28E2720737
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Mar 2020 13:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgCZNJ6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 26 Mar 2020 09:09:58 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44316 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725994AbgCZNJ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Mar 2020 09:09:57 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jHSGg-00044K-V3; Thu, 26 Mar 2020 15:09:55 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 26 Mar 2020 15:09:33 +0200
Message-Id: <iwlwifi.20200326150855.1dcb2d16fa74.I74d7c007dad2601d2e39f54612fe6554dd5ab386@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326130943.623208-1-luca@coelho.fi>
References: <20200326130943.623208-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 02/12] mac80211: add twt_protected flag to the bss_conf structure
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

Add a flag to the BSS conf whether the BSS and STA support protected TWT.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h | 2 ++
 net/mac80211/mlme.c    | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b6b4de0e4b5e..f2b0a7795d0a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -508,6 +508,7 @@ struct ieee80211_ftm_responder_params {
  *	mode only, set if the AP advertises TWT responder role)
  * @twt_responder: does this BSS support TWT requester (relevant for managed
  *	mode only, set if the AP advertises TWT responder role)
+ * @twt_protected: does this BSS support protected TWT frames
  * @assoc: association status
  * @ibss_joined: indicates whether this station is part of an IBSS
  *	or not
@@ -618,6 +619,7 @@ struct ieee80211_bss_conf {
 	bool he_support;
 	bool twt_requester;
 	bool twt_responder;
+	bool twt_protected;
 	/* association related data */
 	bool assoc, ibss_joined;
 	bool ibss_creator;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 16d75da0996a..f1f518790c12 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3384,10 +3384,19 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 						  sta);
 
 		bss_conf->he_support = sta->sta.he_cap.has_he;
+		if (elems->rsnx && elems->rsnx_len &&
+		    (elems->rsnx[0] & WLAN_RSNX_CAPA_PROTECTED_TWT) &&
+		    wiphy_ext_feature_isset(local->hw.wiphy,
+					    NL80211_EXT_FEATURE_PROTECTED_TWT))
+			bss_conf->twt_protected = true;
+		else
+			bss_conf->twt_protected = false;
+
 		changed |= ieee80211_recalc_twt_req(sdata, sta, elems);
 	} else {
 		bss_conf->he_support = false;
 		bss_conf->twt_requester = false;
+		bss_conf->twt_protected = false;
 	}
 
 	if (bss_conf->he_support) {
-- 
2.25.1

