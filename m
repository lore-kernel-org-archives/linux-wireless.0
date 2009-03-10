Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZCJCFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:05:07 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/4] cfg80211: check allowed channel max bandwidth before setting HT40
Date: Mon,  9 Mar 2009 22:04:56 -0400
Message-Id: <1236650699-30538-2-git-send-email-lrodriguez@atheros.com> (sfid-20090310_030522_315911_56EF47FF)
In-Reply-To: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com>
References: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/nl80211.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 531bb67..08d4f55 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -398,6 +398,12 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		/* Primary channel not allowed */
 		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED)
 			goto bad_res;
+		/* You need 40 MHz for an HT40 channel */
+		if (channel_type == NL80211_CHAN_HT40PLUS ||
+		    channel_type == NL80211_CHAN_HT40MINUS) {
+			if (chan->max_bandwidth < 40)
+				goto bad_res;
+		}
 
 		if (channel_type == NL80211_CHAN_HT40MINUS)
 			sec_freq = freq - 20;
-- 
1.6.0.6

