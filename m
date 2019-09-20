Return-Path: <SRS0=+Ljc=XP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED383C4CEC9
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Sep 2019 19:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C77A5208C3
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Sep 2019 19:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfITTy3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 20 Sep 2019 15:54:29 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:50276 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727721AbfITTy3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Sep 2019 15:54:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iBOz4-0005ZQ-VM; Fri, 20 Sep 2019 21:54:27 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Kees Cook <keescook@chromium.org>,
        Nicolas Waisman <nico@semmle.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] cfg80211: validate SSID/MBSSID element ordering assumption
Date:   Fri, 20 Sep 2019 21:54:18 +0200
Message-Id: <1569009255-I1673911f5eae02964e21bdc11b2bf58e5e207e59@changeid>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1569009255-I7ac7fbe9436e9d8733439eab8acbbd35e55c74ef@changeid>
References: <1569009255-I7ac7fbe9436e9d8733439eab8acbbd35e55c74ef@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The code copying the data assumes that the SSID element is
before the MBSSID element, but since the data is untrusted
from the AP, this cannot be guaranteed.

Validate that this is indeed the case and ignore the MBSSID
otherwise, to avoid having to deal with both cases for the
copy of data that should be between them.

Cc: stable@vger.kernel.org
Fixes: 0b8fb8235be8 ("cfg80211: Parsing of Multiple BSSID information in scanning")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d66e6d4b7555..27d76c4c5cea 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1711,7 +1711,12 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 		return;
 	new_ie_len -= trans_ssid[1];
 	mbssid = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen);
-	if (!mbssid)
+	/*
+	 * It's not valid to have the MBSSID element before SSID
+	 * ignore if that happens - the code below assumes it is
+	 * after (while copying things inbetween).
+	 */
+	if (!mbssid || mbssid < trans_ssid)
 		return;
 	new_ie_len -= mbssid[1];
 	rcu_read_lock();
-- 
2.20.1

