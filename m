Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:32783 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab1E0OYk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 10:24:40 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 27 May 2011 07:24:08 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] cfg80211: skip disabled channels on channel survey
Date: Fri, 27 May 2011 07:24:02 -0700
Message-ID: <1306506242-7552-1-git-send-email-lrodriguez@atheros.com> (sfid-20110527_162443_611903_E6DA81B3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The channel survey information will be empy for
disabled channels so simply discard those entries.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/nl80211.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ec83f41..e283816 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3754,10 +3754,6 @@ static int nl80211_send_survey(struct sk_buff *msg, u32 pid, u32 seq,
 	void *hdr;
 	struct nlattr *infoattr;
 
-	/* Survey without a channel doesn't make sense */
-	if (!survey->channel)
-		return -EINVAL;
-
 	hdr = nl80211hdr_put(msg, pid, seq, flags,
 			     NL80211_CMD_NEW_SURVEY_RESULTS);
 	if (!hdr)
@@ -3820,6 +3816,8 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 	}
 
 	while (1) {
+		struct ieee80211_channel *chan;
+
 		res = dev->ops->dump_survey(&dev->wiphy, netdev, survey_idx,
 					    &survey);
 		if (res == -ENOENT)
@@ -3827,6 +3825,19 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 		if (res)
 			goto out_err;
 
+		/* Survey without a channel doesn't make sense */
+		if (!survey.channel) {
+			res = -EINVAL;
+			goto out;
+		}
+
+		chan = ieee80211_get_channel(&dev->wiphy,
+					     survey.channel->center_freq);
+		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED) {
+			survey_idx++;
+			continue;
+		}
+
 		if (nl80211_send_survey(skb,
 				NETLINK_CB(cb->skb).pid,
 				cb->nlh->nlmsg_seq, NLM_F_MULTI,
-- 
1.7.4.1

