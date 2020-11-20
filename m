Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DFBFC64E75
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Nov 2020 18:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F2F22242B
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Nov 2020 18:39:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="0jCij1Sp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731328AbgKTSid (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:38:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730900AbgKTSic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Nov 2020 13:38:32 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC37021D91;
        Fri, 20 Nov 2020 18:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897511;
        bh=7HSbST/2t31kvMTXGlvPkReRJ1IIMMECQBUSQW1XHTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0jCij1SpVqHQleV/9Sh+BuNaF/MK1JoqjkJuWE+UkkzsdY5jfoemT9w1BFOek0iY7
         xlen4mVrwSaPEaJQKDr90JvhOoaINFDEvAzcHwXvGKsM4l8YoCqfchm8k1GProOguB
         CtbAGzevmwnSwOEfhP5diQea5ADooSZnbPYJlNww=
Date:   Fri, 20 Nov 2020 12:38:37 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 113/141] nl80211: Fix fall-through warnings for Clang
Message-ID: <fe5afd456a1244751177e53359d3dd149a63a873.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a77174b99b07..132540a9ac4a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11165,6 +11165,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_P2P_DEVICE:
 		if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
 			return -EINVAL;
+		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_P2P_CLIENT:
-- 
2.27.0

