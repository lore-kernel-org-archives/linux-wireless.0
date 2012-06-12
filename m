Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57981 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab2FLMNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 08:13:31 -0400
Received: by lbbgm6 with SMTP id gm6so301544lbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 05:13:29 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH v2] mac80211: Disallow changing chan type on monitor when CHAN_MODE_FIXED
Date: Tue, 12 Jun 2012 14:13:19 +0200
Message-Id: <1339503199-1237-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20120612_141334_240035_3DC4C969)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you add a monitor interface in paralell to a normal interface
mac80211 will let you to change the channel type on the monitor
interface even if you are connected. Add an explicit check to
disallow this.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 net/mac80211/cfg.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 498c94e..a87591b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -689,7 +689,8 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 	case CHAN_MODE_HOPPING:
 		return -EBUSY;
 	case CHAN_MODE_FIXED:
-		if (local->oper_channel != chan)
+		if (local->oper_channel != chan ||
+		    (!netdev && local->_oper_channel_type != channel_type))
 			return -EBUSY;
 		if (!sdata && local->_oper_channel_type == channel_type)
 			return 0;
-- 
1.7.5.4

