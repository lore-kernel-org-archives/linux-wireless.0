Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55256 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZDBBfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 21:35:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 2/3] cfg80211: add netlink channel put helper
Date: Wed,  1 Apr 2009 21:35:29 -0400
Message-Id: <1238636130-27747-2-git-send-email-lrodriguez@atheros.com> (sfid-20090402_033550_579321_249B71AF)
In-Reply-To: <1238636130-27747-1-git-send-email-lrodriguez@atheros.com>
References: <1238636130-27747-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a netlink channel put helper, nl80211_msg_put_channel(),
which we will also make use of later for the beacon hints events.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/nl80211.c |   41 +++++++++++++++++++++++++++--------------
 1 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 353e1a4..d154f95 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -126,6 +126,30 @@ static inline void *nl80211hdr_put(struct sk_buff *skb, u32 pid, u32 seq,
 	return genlmsg_put(skb, pid, seq, &nl80211_fam, flags, cmd);
 }
 
+static int nl80211_msg_put_channel(struct sk_buff *msg,
+				   struct ieee80211_channel *chan)
+{
+	NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_FREQ,
+		    chan->center_freq);
+
+	if (chan->flags & IEEE80211_CHAN_DISABLED)
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_DISABLED);
+	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_PASSIVE_SCAN);
+	if (chan->flags & IEEE80211_CHAN_NO_IBSS)
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS);
+	if (chan->flags & IEEE80211_CHAN_RADAR)
+		NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR);
+
+	NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
+		    DBM_TO_MBM(chan->max_power));
+
+	return 0;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+
 /* netlink command implementations */
 
 static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
@@ -202,20 +226,9 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 				goto nla_put_failure;
 
 			chan = &dev->wiphy.bands[band]->channels[i];
-			NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_FREQ,
-				    chan->center_freq);
-
-			if (chan->flags & IEEE80211_CHAN_DISABLED)
-				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_DISABLED);
-			if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_PASSIVE_SCAN);
-			if (chan->flags & IEEE80211_CHAN_NO_IBSS)
-				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_NO_IBSS);
-			if (chan->flags & IEEE80211_CHAN_RADAR)
-				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR);
-
-			NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
-				    DBM_TO_MBM(chan->max_power));
+
+			if (nl80211_msg_put_channel(msg, chan))
+				goto nla_put_failure;
 
 			nla_nest_end(msg, nl_freq);
 		}
-- 
1.6.0.6

