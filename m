Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64694 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab1ECX5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:47 -0400
Received: by mail-pw0-f46.google.com with SMTP id 15so278996pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:47 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 12/13] mac80211: allow setting supported rates on mesh peers
Date: Tue,  3 May 2011 16:57:18 -0700
Message-Id: <1304467039-7730-13-git-send-email-javier@cozybit.com> (sfid-20110504_015754_434818_686A9880)
In-Reply-To: <1304467039-7730-1-git-send-email-javier@cozybit.com>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is necessary for userspace managed stations.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/wireless/nl80211.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index da1cdbe..afc07df 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2293,8 +2293,6 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			err = -EINVAL;
 		if (params.listen_interval >= 0)
 			err = -EINVAL;
-		if (params.supported_rates)
-			err = -EINVAL;
 		if (params.sta_flags_mask &
 				~(BIT(NL80211_STA_FLAG_AUTHENTICATED) |
 				  BIT(NL80211_STA_FLAG_MFP) |
-- 
1.7.1

