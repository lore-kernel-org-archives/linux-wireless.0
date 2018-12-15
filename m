Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A38C0C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DBD92084D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbeLOJHN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:07:13 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42318 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbeLOJHN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:07:13 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rJ-0002oc-Q7; Sat, 15 Dec 2018 11:03:42 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:16 +0200
Message-Id: <20181215090325.31604-16-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/24] cfg80211: fix ieee80211_get_vht_max_nss()
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Fix two bugs in ieee80211_get_vht_max_nss():
 * the spec says we should round down
   (reported by Nissim)
 * there's a double condition, the first one is wrong,
   supp_width == 0 / ext_nss_bw == 2 is valid in 80+80
   (found by smatch)

Fixes: b0aa75f0b1b2 ("ieee80211: add new VHT capability fields/parsing")
Reported-by: Nissim Bendanan <nissimx.bendanan@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/util.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index ef14d80ca03e..06a084236841 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -2013,33 +2013,32 @@ int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap *cap,
 	case IEEE80211_VHT_CHANWIDTH_160MHZ:
 		if (supp_width == 0 &&
 		    (ext_nss_bw == 1 || ext_nss_bw == 2))
-			return DIV_ROUND_UP(max_vht_nss, 2);
+			return max_vht_nss / 2;
 		if (supp_width == 0 &&
 		    ext_nss_bw == 3)
-			return DIV_ROUND_UP(3 * max_vht_nss, 4);
+			return (3 * max_vht_nss) / 4;
 		if (supp_width == 1 &&
 		    ext_nss_bw == 3)
 			return 2 * max_vht_nss;
 		break;
 	case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
-		if (supp_width == 0 &&
-		    (ext_nss_bw == 1 || ext_nss_bw == 2))
+		if (supp_width == 0 && ext_nss_bw == 1)
 			return 0; /* not possible */
 		if (supp_width == 0 &&
 		    ext_nss_bw == 2)
-			return DIV_ROUND_UP(max_vht_nss, 2);
+			return max_vht_nss / 2;
 		if (supp_width == 0 &&
 		    ext_nss_bw == 3)
-			return DIV_ROUND_UP(3 * max_vht_nss, 4);
+			return (3 * max_vht_nss) / 4;
 		if (supp_width == 1 &&
 		    ext_nss_bw == 0)
 			return 0; /* not possible */
 		if (supp_width == 1 &&
 		    ext_nss_bw == 1)
-			return DIV_ROUND_UP(max_vht_nss, 2);
+			return max_vht_nss / 2;
 		if (supp_width == 1 &&
 		    ext_nss_bw == 2)
-			return DIV_ROUND_UP(3 * max_vht_nss, 4);
+			return (3 * max_vht_nss) / 4;
 		break;
 	}
 
-- 
2.19.2

