Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50297 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2DSCYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 22:24:19 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so9656149pbc.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 19:24:19 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 2/2] mac80211: fix STA channel width field
Date: Wed, 18 Apr 2012 19:24:14 -0700
Message-Id: <1334802254-4704-2-git-send-email-thomas@cozybit.com> (sfid-20120419_042430_563375_A3E38B58)
In-Reply-To: <1334802254-4704-1-git-send-email-thomas@cozybit.com>
References: <1334802254-4704-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to IEEE 802.11 8.4.2.59, set the "STA channel width" bit to 0
if transmitting STA is using a 20mhz channel.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/util.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 89c1e5b..577942b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1684,7 +1684,9 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 		ht_oper->ht_param = IEEE80211_HT_PARAM_CHA_SEC_NONE;
 		break;
 	}
-	if (ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+	if (ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 &&
+	    channel_type != NL80211_CHAN_NO_HT &&
+	    channel_type != NL80211_CHAN_HT20)
 		ht_oper->ht_param |= IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
 
 	/*
-- 
1.7.5.4

