Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:11133 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab0EQPbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 11:31:13 -0400
Received: by fg-out-1718.google.com with SMTP id 22so606177fge.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 May 2010 08:31:11 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] cfg80211: don't refuse HT20 channels on devices that don't support HT40
Date: Mon, 17 May 2010 17:30:59 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Message-Id: <201005171730.59566.helmut.schaa@googlemail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't refuse HT20 channels on devices that don't support HT40.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/wireless/chan.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index d92d088..647832a 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -35,8 +35,9 @@ rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 		if (!ht_cap->ht_supported)
 			return NULL;
 
-		if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
-		    ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT)
+		if (channel_type != NL80211_CHAN_HT20 &&
+		    (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
+		    ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT))
 			return NULL;
 	}
 
-- 
1.6.4.2

