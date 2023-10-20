Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B9FCDB47E
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Oct 2023 07:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376441AbjJTHih (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376317AbjJTHif (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Oct 2023 03:38:35 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48A691
        for <linux-wireless@vger.kernel.org>; Fri, 20 Oct 2023 00:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=euIrGYvFY+h7bFtxVunlF/q6Y11GfRxxl5htk8lowm0=; t=1697787514; x=1698997114; 
        b=xq9+nUTzh8p7+ybQGr+sl9fAjum497cB9nkB6MWPRT8Nj+e9XO7rLfw5iSk/MxYCJRzEXjvgGj7
        k8JCfWwOFkbFCs2j+TBw0sz7FJEbWzW4hXvhfZn88fTWV7eEkGqjJwbPMPdlo82AMCRE89ptSVVj+
        a5zMc+W0QrAWCBPfdulWX5bSYFqHL54/wHrHI991r3I2A7XGjeib3eWpnz3LeZ1JkL7AooS8DI4YF
        2cQyb57Q3u7SJKsSy10McCByKqkJPoiklpPQl0rfQ9c90NgSCGO20ySuD0uDAMWTKJyMBAmtv88pN
        +aiZf+8nNdI6kKy1QpVBVybQ09DQvDVu4/og==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.97-RC1)
        (envelope-from <johannes@sipsolutions.net>)
        id 1qtk5X-0000000EPn6-1BSw;
        Fri, 20 Oct 2023 09:38:31 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH wireless-next] wifi: mac80211: fix another key installation error path
Date:   Fri, 20 Oct 2023 09:38:28 +0200
Message-ID: <20231020093827.1ef4151a930a.I42ac9a3d8480964d29ba845bbffdf74fe13dae1a@changeid>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Due to overlapping changes and merges, another error
path ended up broken. Fix this one as well.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index e0ff3a753e15..af74d7f9d94d 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -881,8 +881,10 @@ int ieee80211_key_link(struct ieee80211_key *key,
 		if (link_id >= 0) {
 			link_sta = rcu_dereference_protected(sta->link[link_id],
 							     lockdep_is_held(&sta->local->hw.wiphy->mtx));
-			if (!link_sta)
-				return -ENOLINK;
+			if (!link_sta) {
+				ret = -ENOLINK;
+				goto out;
+			}
 		}
 
 		old_key = wiphy_dereference(sdata->local->hw.wiphy,
-- 
2.41.0

