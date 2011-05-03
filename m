Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64694 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab1ECX5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:40 -0400
Received: by mail-pw0-f46.google.com with SMTP id 15so278996pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:40 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	Javier Cardona <javier@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 07/13] nl80211: allow setting MFP flag for a meshif
Date: Tue,  3 May 2011 16:57:13 -0700
Message-Id: <1304467039-7730-8-git-send-email-javier@cozybit.com> (sfid-20110504_015747_200435_06C73BE0)
In-Reply-To: <1304467039-7730-1-git-send-email-javier@cozybit.com>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Pedersen <thomas@cozybit.com>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/wireless/nl80211.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 176d118..da1cdbe 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2297,6 +2297,7 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			err = -EINVAL;
 		if (params.sta_flags_mask &
 				~(BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				  BIT(NL80211_STA_FLAG_MFP) |
 				  BIT(NL80211_STA_FLAG_AUTHORIZED)))
 			err = -EINVAL;
 		break;
-- 
1.7.1

