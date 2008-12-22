Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:27961 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791AbYLVVjh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 16:39:37 -0500
Subject: [PATCH] mac80211: allow mode change if IBSS is not allowed
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Mon, 22 Dec 2008 16:39:36 -0500
Message-ID: <20081222213935.26129.4212.stgit@dv.roinet.com> (sfid-20081222_223953_952557_F52B06C5)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changing mode on an interface is not allowed if IBSS is disabled for the
current channel.  That restriction should only apply when switching to
the ad-hoc mode, as it was prior to db17d8c4.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 net/mac80211/iface.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5abbc3f..b907482 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -699,7 +699,8 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 		return 0;
 
 	/* Setting ad-hoc mode on non-IBSS channel is not supported. */
-	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)
+	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS &&
+	    type == NL80211_IFTYPE_ADHOC)
 		return -EOPNOTSUPP;
 
 	/*
