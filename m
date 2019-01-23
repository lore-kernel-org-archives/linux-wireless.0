Return-Path: <SRS0=ZHYo=P7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB18C282C5
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 07:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEC9F21850
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 07:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfAWHDg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Jan 2019 02:03:36 -0500
Received: from gateway31.websitewelcome.com ([192.185.144.96]:11615 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726158AbfAWHDf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Jan 2019 02:03:35 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 2C8FA51569
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2019 01:03:34 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id mCZSg39HL2qH7mCZSgfHQz; Wed, 23 Jan 2019 01:03:34 -0600
X-Authority-Reason: nr=8
Received: from [189.250.130.205] (port=46142 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gmCZR-002zMV-Gx; Wed, 23 Jan 2019 01:03:33 -0600
Date:   Wed, 23 Jan 2019 01:03:32 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] cfg80211: mark expected switch fall-throughs
Message-ID: <20190123070332.GA814@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.130.205
X-Source-L: No
X-Exim-ID: 1gmCZR-002zMV-Gx
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.130.205]:46142
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

This patch fixes the following warnings:

net/wireless/wext-compat.c:1327:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
net/wireless/wext-compat.c:1341:6: warning: this statement may fall through [-Wimplicit-fallthrough=]

Warning level 3 was used: -Wimplicit-fallthrough=3

This patch is part of the ongoing efforts to enabling
-Wimplicit-fallthrough

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/wireless/wext-compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 06943d9c9835..d522787c7354 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1337,6 +1337,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 			wstats.qual.qual = sig + 110;
 			break;
 		}
+		/* fall through */
 	case CFG80211_SIGNAL_TYPE_UNSPEC:
 		if (sinfo.filled & BIT_ULL(NL80211_STA_INFO_SIGNAL)) {
 			wstats.qual.updated |= IW_QUAL_LEVEL_UPDATED;
@@ -1345,6 +1346,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 			wstats.qual.qual = sinfo.signal;
 			break;
 		}
+		/* fall through */
 	default:
 		wstats.qual.updated |= IW_QUAL_LEVEL_INVALID;
 		wstats.qual.updated |= IW_QUAL_QUAL_INVALID;
-- 
2.20.1

