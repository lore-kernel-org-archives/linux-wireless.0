Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D100C10F11
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 01:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA632206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 01:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="apW/hpbb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbfDWBKv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Apr 2019 21:10:51 -0400
Received: from 15.mo1.mail-out.ovh.net ([188.165.38.232]:34379 "EHLO
        15.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728615AbfDWBKv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Apr 2019 21:10:51 -0400
X-Greylist: delayed 10799 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Apr 2019 21:10:50 EDT
Received: from player774.ha.ovh.net (unknown [10.108.42.239])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id C306F16A02C
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2019 23:34:22 +0200 (CEST)
Received: from awhome.eu (p57B7E5B2.dip0.t-ipconnect.de [87.183.229.178])
        (Authenticated sender: postmaster@awhome.eu)
        by player774.ha.ovh.net (Postfix) with ESMTPSA id 27BF84FCF198;
        Mon, 22 Apr 2019 21:34:21 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1555968858;
        bh=s8t48NXZa6gc1Q8vLHeUnxBFD1vZHBuqRu7UTw69KO0=;
        h=From:To:Cc:Subject:Date;
        b=apW/hpbbWOlk3Gb/P/8FosA+W+v6V71zd6ChNrNNCpdlt/kj3TJobRVUIEZ7GejyM
         yODK2bE5KIy9GcYFWhVrZW/e2V1yZ75Mu5HUUbjKFsTboVjivbqdh6uBi+IeKLi4by
         moPUcJKiq2c5jIVYOSCsHV/3lviYNydQmwSM5loU=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH 1/2] mac80211: Fix Extended Key ID auto activation
Date:   Mon, 22 Apr 2019 23:34:11 +0200
Message-Id: <20190422213412.16533-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3701395944886312135
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrgeeigdduheegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Only enable Extended Key ID support for drivers which are not supporting
crypto offload and also do not support A-MPDU.

While any driver using SW crypto from mac80211 is generally able to also
support Extended Key ID these drivers are likely to mix keyIDs in
AMPDUs when rekeying.

According to IEEE 802.11-2016 "9.7.3 A-MPDU contents" this is not
allowed.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 net/mac80211/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5d6b93050c0b..af73f42960fa 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1051,7 +1051,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		}
 	}
 
-	if (!local->ops->set_key ||
+	/* Enable Extended Key IDs when driver is either allowing it or only
+	 * supporting SW crypto without A-MPDU
+	 */
+	if (!(local->ops->set_key ||
+	      ieee80211_hw_check(hw, AMPDU_AGGREGATION)) ||
 	    ieee80211_hw_check(&local->hw, EXT_KEY_ID_NATIVE))
 		wiphy_ext_feature_set(local->hw.wiphy,
 				      NL80211_EXT_FEATURE_EXT_KEY_ID);
-- 
2.21.0

