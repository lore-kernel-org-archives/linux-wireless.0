Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0823CC4320A
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Aug 2021 06:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6C9460ED6
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Aug 2021 06:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbhHEGpI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Aug 2021 02:45:08 -0400
Received: from m12-13.163.com ([220.181.12.13]:48310 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231418AbhHEGpH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Aug 2021 02:45:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=RfB/J
        nJf9EP8SNAwmDp79LofGOgEFWPMAYpseX6FoDI=; b=FlCE++Mc+hr6Q/36HOak7
        FAaK3PAbnvhXSTYyQ8TxErZ1xQ5O1cKDqFvIaHDPZBc1h3vqkYGNpgyXkHrvSrui
        bd+p5//Ew5XKarrVVvhsxOFWCvVKhHoZdZRiZpF66XqzmpxGLJSqSjaAmvY7EwmV
        N4a5YY8e6X4l9nOHeme6iI=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp9 (Coremail) with SMTP id DcCowAA3PZHKiAthGZjwOA--.41047S2;
        Thu, 05 Aug 2021 14:44:30 +0800 (CST)
From:   dingsenjie@163.com
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] net: mac80211: Remove unnecessary variable and label
Date:   Thu,  5 Aug 2021 14:43:49 +0800
Message-Id: <20210805064349.202148-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowAA3PZHKiAthGZjwOA--.41047S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF48trWfZFW8Wr4rZw47urg_yoW8Xw1xpF
        9xK34DtrWkJr15Aw1rAryqqF95Cr40ka40gr4xJ3Z3ZFsI9rn8Gr1Uuw4FqFyYkFZrt34a
        vFWv9r45Zw1DGrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jmwZ7UUUUU=
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiHgThyFSIwHli5QABsQ
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

The variable ret and label just used as return, so we delete it and
use the return statement instead of the goto statement.

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 net/mac80211/ibss.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 1f552f3..9115b68 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -489,7 +489,6 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 	const struct cfg80211_bss_ies *ies;
 	u16 capability = WLAN_CAPABILITY_IBSS;
 	u64 tsf;
-	int ret = 0;
 
 	sdata_assert_lock(sdata);
 
@@ -501,10 +500,8 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 				ifibss->ssid_len, IEEE80211_BSS_TYPE_IBSS,
 				IEEE80211_PRIVACY(ifibss->privacy));
 
-	if (WARN_ON(!cbss)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (WARN_ON(!cbss))
+		return -EINVAL;
 
 	rcu_read_lock();
 	ies = rcu_dereference(cbss->ies);
@@ -520,18 +517,14 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 					   sdata->vif.bss_conf.basic_rates,
 					   capability, tsf, &ifibss->chandef,
 					   NULL, csa_settings);
-	if (!presp) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!presp)
+		return -ENOMEM;
 
 	rcu_assign_pointer(ifibss->presp, presp);
 	if (old_presp)
 		kfree_rcu(old_presp, rcu_head);
 
 	return BSS_CHANGED_BEACON;
- out:
-	return ret;
 }
 
 int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
-- 
1.9.1


