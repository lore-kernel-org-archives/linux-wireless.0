Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:9649 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab0EQO6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 10:58:46 -0400
Received: by fg-out-1718.google.com with SMTP id d23so2766911fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 May 2010 07:58:44 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC] cfg80211: allow HT20 channels on devices incabable of HT40
Date: Mon, 17 May 2010 16:58:33 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005171658.33673.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was just trying to set up a rt2800 AP but hostapd was unable to
set the channel when configuring 11n.

rt2800 doesn't support HT40 yet, that's why it doesn't set
IEEE80211_HT_CAP_SUP_WIDTH_20_40 and cfg80211 refuses to set the
channel when the device doesn't support IEEE80211_HT_CAP_SUP_WIDTH_20_40
even if  a HT20 only channel should be set.

Did I miss anything or should it be allowed to set a HT20 channel
on a HT capable device that doesn't allow HT40?

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

