Return-Path: <SRS0=efDY=C3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B43C43464
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Sep 2020 11:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7307A20DD4
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Sep 2020 11:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgIRLxT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Sep 2020 07:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRLxS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Sep 2020 07:53:18 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6624C06174A
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2020 04:53:18 -0700 (PDT)
Received: from [149.224.67.249] (helo=localhost.localdomain)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1kJEwz-0006ac-RY; Fri, 18 Sep 2020 13:53:13 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>
Subject: [PATCH] mac80211: fix 80mhz assoc to 160/80p80 on 6GHz
Date:   Fri, 18 Sep 2020 13:53:04 +0200
Message-Id: <20200918115304.1135693-1-john@phrozen.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Trying to associcate to an AP on 6GHz with a STA that only has 80Mhz
the cf2 field inside the chandef will get set causing the assoc to fail
when trying to validate the chandef. Fix this by checking the support flags
prior to setting cf2.

Signed-off-by: John Crispin <john@phrozen.org>
---
 net/mac80211/util.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c8504ffc71a1..8d3bfc0fe176 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3353,9 +3353,10 @@ bool ieee80211_chandef_he_6ghz_oper(struct ieee80211_sub_if_data *sdata,
 		he_chandef.center_freq1 =
 			ieee80211_channel_to_frequency(he_6ghz_oper->ccfs0,
 						       NL80211_BAND_6GHZ);
-		he_chandef.center_freq2 =
-			ieee80211_channel_to_frequency(he_6ghz_oper->ccfs1,
-						       NL80211_BAND_6GHZ);
+		if (support_80_80 || support_160)
+			he_chandef.center_freq2 =
+				ieee80211_channel_to_frequency(he_6ghz_oper->ccfs1,
+							       NL80211_BAND_6GHZ);
 	}
 
 	if (!cfg80211_chandef_valid(&he_chandef)) {
-- 
2.25.1

