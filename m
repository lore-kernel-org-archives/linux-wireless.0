Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3BDC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF9682089E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfDZJmB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 05:42:01 -0400
Received: from nbd.name ([46.4.11.11]:57608 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbfDZJmA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 05:42:00 -0400
Received: from p548c8674.dip0.t-ipconnect.de ([84.140.134.116] helo=bertha.fritz.box)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hJxMj-00036i-0f; Fri, 26 Apr 2019 11:41:57 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Srini Kode <skode@qti.qualcomm.com>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>
Subject: [PATCH V2 2/3] mac80211: dynamically turn TWT requester support on and off
Date:   Fri, 26 Apr 2019 11:41:49 +0200
Message-Id: <20190426094150.18078-3-john@phrozen.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190426094150.18078-1-john@phrozen.org>
References: <20190426094150.18078-1-john@phrozen.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Turn TWT on/off for STA interfaces when they associate and/or receive a
beacon where the twt_responder bit has changed.

Signed-off-by: Shashidhar Lakkavalli <slakkavalli@datto.com>
Signed-off-by: John Crispin <john@phrozen.org>
---
 net/mac80211/mlme.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2dbcf5d5512e..f3563670ed58 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3151,6 +3151,21 @@ static bool ieee80211_twt_req_supported(const struct sta_info *sta,
 		IEEE80211_HE_MAC_CAP0_TWT_RES;
 }
 
+static int ieee80211_recalc_twt_req(struct ieee80211_sub_if_data *sdata,
+				    struct sta_info *sta,
+				    struct ieee802_11_elems *elems)
+{
+	bool twt_req;
+
+	twt_req = ieee80211_twt_req_supported(sta, elems);
+
+	if (sdata->vif.bss_conf.twt_requester != twt_req) {
+		sdata->vif.bss_conf.twt_requester = twt_req;
+		return BSS_CHANGED_TWT;
+	}
+	return 0;
+}
+
 static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 				    struct cfg80211_bss *cbss,
 				    struct ieee80211_mgmt *mgmt, size_t len)
@@ -3333,8 +3348,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 						  sta);
 
 		bss_conf->he_support = sta->sta.he_cap.has_he;
-		bss_conf->twt_requester =
-			ieee80211_twt_req_supported(sta, &elems);
+		changed |= ieee80211_recalc_twt_req(sdata, sta, &elems);
 	} else {
 		bss_conf->he_support = false;
 		bss_conf->twt_requester = false;
@@ -3994,6 +4008,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	mutex_lock(&local->sta_mtx);
 	sta = sta_info_get(sdata, bssid);
 
+	changed |= ieee80211_recalc_twt_req(sdata, sta, &elems);
+
 	if (ieee80211_config_bw(sdata, sta,
 				elems.ht_cap_elem, elems.ht_operation,
 				elems.vht_operation, elems.he_operation,
-- 
2.11.0

