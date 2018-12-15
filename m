Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA80CC43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85B31206A2
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbeLOJWU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:22:20 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42392 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728731AbeLOJWU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:22:20 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rM-0002oc-OU; Sat, 15 Dec 2018 11:03:45 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:20 +0200
Message-Id: <20181215090325.31604-20-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 19/24] mac80211: do not advertise HE cap IE if HE disabled
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

When disabling HE due to the lack of HT/VHT, do it
at an earlier stage to avoid advertising HE capabilities IE.
Also, at this point, no need to check if AP supports HE, since
it is already checked earlier (in ieee80211_prep_channel).

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8c6a4dc017a5..54e511dbbc12 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -916,6 +916,15 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		ieee80211_add_vht_ie(sdata, skb, sband,
 				     &assoc_data->ap_vht_cap);
 
+	/*
+	 * If AP doesn't support HT, mark HE as disabled.
+	 * If on the 5GHz band, make sure it supports VHT.
+	 */
+	if (ifmgd->flags & IEEE80211_STA_DISABLE_HT ||
+	    (sband->band == NL80211_BAND_5GHZ &&
+	     ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
+		ifmgd->flags |= IEEE80211_STA_DISABLE_HE;
+
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HE))
 		ieee80211_add_he_ie(sdata, skb, sband);
 
@@ -3231,16 +3240,6 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	/*
-	 * If AP doesn't support HT, or it doesn't have HE mandatory IEs, mark
-	 * HE as disabled. If on the 5GHz band, make sure it supports VHT.
-	 */
-	if (ifmgd->flags & IEEE80211_STA_DISABLE_HT ||
-	    (sband->band == NL80211_BAND_5GHZ &&
-	     ifmgd->flags & IEEE80211_STA_DISABLE_VHT) ||
-	    (!elems.he_cap && !elems.he_operation))
-		ifmgd->flags |= IEEE80211_STA_DISABLE_HE;
-
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HE) &&
 	    (!elems.he_cap || !elems.he_operation)) {
 		mutex_unlock(&sdata->local->sta_mtx);
-- 
2.19.2

