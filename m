Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760758AbZDBW0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 18:26:13 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/5] cfg80211: check allowed channel type upon userspace requests
Date: Thu,  2 Apr 2009 18:26:05 -0400
Message-Id: <1238711166-2208-5-git-send-email-lrodriguez@atheros.com> (sfid-20090403_002621_023844_AA7146A8)
In-Reply-To: <1238711166-2208-1-git-send-email-lrodriguez@atheros.com>
References: <1238711166-2208-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks to nl80211 userspace can be very specific upon device
configuration. Before processing the request for the new HT40
channel types (HT40- or HT40+) we need to ensure we can use them
regulatory-wise. This wasn't required with wireless extensions as
specifying the channel type wasn't not available and configuration
was done towards the end implicitly upon association or reception
of beacons from the AP. For the new nl80211 we have to check this
when configuring the interfaces explicitly.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/nl80211.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 411c233..1d05b17 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -457,6 +457,24 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED)
 			goto bad_res;
 
+		if (channel_type == NL80211_CHAN_HT40MINUS ||
+		    channel_type == NL80211_CHAN_HT40PLUS)
+			if (chan->flags & IEEE80211_CHAN_NO_HT40)
+				goto bad_res;
+
+		if (channel_type == NL80211_CHAN_HT40MINUS &&
+		    (chan->flags & IEEE80211_CHAN_NO_HT40MINUS))
+			goto bad_res;
+		else if (channel_type == NL80211_CHAN_HT40PLUS &&
+			 (chan->flags & IEEE80211_CHAN_NO_HT40PLUS))
+			goto bad_res;
+
+		/*
+		 * At this point we know if that if HT40 was requested
+		 * we are allowed to use it and the extension channel
+		 * exists.
+		 */
+
 		if (channel_type == NL80211_CHAN_HT40MINUS)
 			sec_freq = freq - 20;
 		else if (channel_type == NL80211_CHAN_HT40PLUS)
-- 
1.6.0.6

