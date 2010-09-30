Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42250 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab0I3WVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 18:21:11 -0400
Received: by mail-qy0-f181.google.com with SMTP id 33so2539710qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 15:21:10 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Sep 2010 18:21:10 -0400
Message-ID: <AANLkTin2cVXkQ5zmQkm1Yg39Vi3Fzoy067JLBwx+RBKj@mail.gmail.com>
Subject: [PATCH 2/3] cfg80211: patches to allow setting the WDS peer
From: Bill Jordan <bjordan@rajant.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added a nl interface to set the peer bssid of a WDS interface.

Signed-off-by: Bill Jordan <bjordan@rajant.com>
---
 include/linux/nl80211.h |    3 ++
 net/wireless/nl80211.c  |   49 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index f0518b0..35a9681 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -387,6 +387,8 @@
  *	of any other interfaces, and other interfaces will again take
  *	precedence when they are used.
  *
+ * @NL80211_CMD_SET_WDS_PEER: Set the MAC address of the peer on a
WDS interface.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -489,6 +491,7 @@ enum nl80211_commands {
 	NL80211_CMD_NOTIFY_CQM,

 	NL80211_CMD_SET_CHANNEL,
+	NL80211_CMD_SET_WDS_PEER,

 	/* add new commands above here */

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9c84825..c401349 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -603,6 +603,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg,
u32 pid, u32 seq, int flags,
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
 	}
 	CMD(set_channel, SET_CHANNEL);
+	CMD(set_wds_peer, SET_WDS_PEER);

 #undef CMD

@@ -831,6 +832,48 @@ static int nl80211_set_channel(struct sk_buff
*skb, struct genl_info *info)
 	return result;
 }
