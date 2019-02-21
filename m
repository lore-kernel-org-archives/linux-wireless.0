Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69779C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 23:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 363F2206A3
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 23:12:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=4sigma.it header.i=@4sigma.it header.b="frgPMng4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfBUXMa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 18:12:30 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41669 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfBUXMa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 18:12:30 -0500
Received: by mail-wr1-f65.google.com with SMTP id n2so310499wrw.8
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 15:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=4sigma.it; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=UBvT747HcZAlE2Jn/xPLTuKslB0UyLXMGwpB3AeXbhQ=;
        b=frgPMng40gfEzqGiOGWv+GgH6UupZHlHL1YunYeygKT/0sRx8phbmgmwxl9PIVAGxd
         ZQkaBgsvXaciVzvCu/B84Fpl9llNyBjiSptQRHthjwLE39Mm8C84RnCxz5Us8ywglWIp
         dGtfaEfuIf6GqEax3sJR9CWUeaeqTy61gfFYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UBvT747HcZAlE2Jn/xPLTuKslB0UyLXMGwpB3AeXbhQ=;
        b=ub6MYqiCT+yQHd+YEzRZf29GWLLhKhbmnZldiQOurbaQP2J5zoott+AVS3P246YE/S
         AtFZBOPVc+nhkS6OvDepFJab1rdkdO5oymYo1jimMTvpSH6NLhpbC7Au5XNULtJe/PGh
         lkSJQrF78uu3jZ5UIBlyKk0F3JjMRoOOypRIR52M82Cc9SU6vTM21CdRzLkxbHmM+lkf
         /I/E3DNoKZg9nLV81xxyGMYVG65FExsval3trJKm/5v29OTgVp1ZaBIWRGHOXsywTDXZ
         Wj/USLz+dW/pNjJ39aVXLZ9+Xf4bT7qka5cMKdpxwfnRcjnsgvgjjHiv8LS4Vwwl+gXJ
         hoVQ==
X-Gm-Message-State: AHQUAuY+sgJSq1j1z40m8nxK2TefyYI9oJ66lRi5GfjCyuMi5nyL2qB1
        DWlluVbhtSCq6pHI4PW4jFKapQ==
X-Google-Smtp-Source: AHgI3IbUUG7L1msRvm/r6EgoivDt+Z26qhFm5FXJ4DbHyQygo/XSeHPM9CWJbCyacOwzW5TIIW3ebQ==
X-Received: by 2002:adf:ec10:: with SMTP id x16mr618705wrn.171.1550790748058;
        Thu, 21 Feb 2019 15:12:28 -0800 (PST)
Received: from localhost.localdomain (host121-71-dynamic.24-79-r.retail.telecomitalia.it. [79.24.71.121])
        by smtp.googlemail.com with ESMTPSA id f10sm133258wmb.35.2019.02.21.15.12.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Feb 2019 15:12:27 -0800 (PST)
From:   Andrea Greco <a.greco@4sigma.it>
X-Google-Original-From: Andrea Greco <andrea.greco.gapmilano@gmail.com>
To:     johannes.berg@intel.com
Cc:     Andrea Greco <a.greco@4sigma.it>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] nl80211: Allow change CW to Ad-Hock network
Date:   Fri, 22 Feb 2019 00:11:47 +0100
Message-Id: <20190221231147.6141-1-andrea.greco.gapmilano@gmail.com>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrea Greco <a.greco@4sigma.it>

Add net-link support for change CW in Ad-Hock network

Signed-off-by: Andrea Greco <a.greco@4sigma.it>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d91a408db113..4fcc63fa4380 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2731,7 +2731,8 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 
 		if (netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-		    netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		    netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO &&
+		    netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC)
 			return -EINVAL;
 
 		if (!netif_running(netdev))
-- 
2.17.2

