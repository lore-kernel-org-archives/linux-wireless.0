Return-Path: <SRS0=c1p6=V5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA66BC19759
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Aug 2019 07:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5FD0206A2
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Aug 2019 07:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbfHAHai (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Aug 2019 03:30:38 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54498 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfHAHai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Aug 2019 03:30:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ht5Xo-0008Ar-5I; Thu, 01 Aug 2019 09:30:36 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix possible sta leak
Date:   Thu,  1 Aug 2019 09:30:33 +0200
Message-Id: <20190801073033.7892-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If TDLS station addition is rejected, the sta memory is leaked.
Avoid this by moving the check before the allocation.

Fixes: 7ed5285396c2 ("mac80211: don't initiate TDLS connection if station is not associated to AP")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4d458067d80d..111c400199ec 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1546,6 +1546,11 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (is_multicast_ether_addr(mac))
 		return -EINVAL;
 
+	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER) &&
+	    sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !sdata->u.mgd.associated)
+		return -EINVAL;
+
 	sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
 	if (!sta)
 		return -ENOMEM;
@@ -1553,10 +1558,6 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
 		sta->sta.tdls = true;
 
-	if (sta->sta.tdls && sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    !sdata->u.mgd.associated)
-		return -EINVAL;
-
 	err = sta_apply_parameters(local, sta, params);
 	if (err) {
 		sta_info_free(local, sta);
-- 
2.20.1

