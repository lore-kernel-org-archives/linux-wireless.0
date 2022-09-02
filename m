Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3269ECAAD5
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Sep 2022 14:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbiIBOuE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Sep 2022 10:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237150AbiIBOtk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2022 10:49:40 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD34303D3
        for <linux-wireless@vger.kernel.org>; Fri,  2 Sep 2022 07:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=yh9fhySYVLADBv7giFkClVPf4fetSKj/cm48072kEgM=; t=1662127896; x=1663337496; 
        b=CN4pOtdYV3P6+AB/sIvyTIPWpfzjzuZdAY0dz3iJT9JKFDprmRtcAEQUO+ddBf+i3QKBvSLYl0Z
        yeTfeIL6XkewKJMggiOMqgVkQCUIuc5kWLJ9FWxEThOPMsoaBJcSIYV4Um9+iB/hmZOLLm3JXK2tX
        C/db/xHiHg7aOk9cvYbfiWEmM0384+j7NcbrrocGAMzZ5zXf78BasIZDVBjv/PzafzUhr55N3gzEE
        E6TFkkUZwaG68qxKBUl3k73m1hZJdkIh2kWMwBlArlYvlTwKnHBLytrkfkCBVSsLZwChRbOIao8BN
        G/1Ca/ezBUVhMyMmla3QzCnITnw4JcS8XftA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oU7OP-006Cg0-1n;
        Fri, 02 Sep 2022 16:11:33 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2] wifi: mac80211: fix link warning in RX agg timer expiry
Date:   Fri,  2 Sep 2022 16:11:31 +0200
Message-Id: <20220902161130.af23678ddc21.I3d9a23c49e1df3bd0c91ef0e1c1805dd09937db8@changeid>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

The rx data link pointer isn't set from the RX aggregation timer,
resulting in a later warning. Fix that by setting it to the first
valid link for now, with a FIXME to worry about statistics later,
it's not very important since it's just the timeout case.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/498d714c-76be-9d04-26db-a1206878de5e@redhat.com
Fixes: 56057da4569b ("wifi: mac80211: rx: track link in RX data")
Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index cc139fe5fb78..511c809e2c6b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4084,6 +4084,7 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 		.link_id = -1,
 	};
 	struct tid_ampdu_rx *tid_agg_rx;
+	u8 link_id;
 
 	tid_agg_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
 	if (!tid_agg_rx)
@@ -4103,6 +4104,9 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 		};
 		drv_event_callback(rx.local, rx.sdata, &event);
 	}
+	/* FIXME: statistics won't be right with this */
+	link_id = sta->sta.valid_links ? ffs(sta->sta.valid_links) - 1 : 0;
+	rx.link = rcu_dereference(sta->sdata->link[link_id]);
 
 	ieee80211_rx_handlers(&rx, &frames);
 }
-- 
2.37.2

