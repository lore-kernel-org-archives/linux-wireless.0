Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76CE9C10F12
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 06:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E4ED2073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 06:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbfDQGer (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 02:34:47 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53478 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725767AbfDQGer (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 02:34:47 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hGe9d-0006eP-7n; Wed, 17 Apr 2019 09:34:45 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 17 Apr 2019 09:34:40 +0300
Message-Id: <20190417063441.19909-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <35f813d89f2d0eed572fe9ceb6530ab42d081aa2.camel@sipsolutions.net>
References: <35f813d89f2d0eed572fe9ceb6530ab42d081aa2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 03/11] nl80211: do a struct assignment to radar_chandef instead of memcpy()
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

We are copying one entire structure to another of the same type in
nl80211_notify_radar_detection, so it's simpler and safer to do a
struct assignment instead of memcpy().

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 846d25d2dc82..64af8309f397 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8182,7 +8182,7 @@ static int nl80211_notify_radar_detection(struct sk_buff *skb,
 
 	cfg80211_sched_dfs_chan_update(rdev);
 
-	memcpy(&rdev->radar_chandef, &chandef, sizeof(chandef));
+	rdev->radar_chandef = chandef;
 
 	/* Propagate this notification to other radios as well */
 	queue_work(cfg80211_wq, &rdev->propagate_radar_detect_wk);
-- 
2.20.1

