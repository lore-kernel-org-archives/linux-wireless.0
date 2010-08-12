Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab0HLNhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Aug 2010 09:37:32 -0400
Subject: [PATCH] mac80211: remove unused don't-encrypt flag
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 15:37:29 +0200
Message-ID: <1281620249.3803.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When MFP is disabled, action frames will not
be encrypted since they are management frames
and the only management frames that can then
be encrypted are authentication frames.

Therefore, setting the don't-encrypt flag on
action frames is unnecessary.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |    2 --
 1 file changed, 2 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2010-08-12 13:42:52.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-08-12 13:42:54.000000000 +0200
@@ -1575,8 +1575,6 @@ static int ieee80211_action(struct wiphy
 			return -ENOLINK;
 		break;
 	case NL80211_IFTYPE_STATION:
-		if (!(sdata->u.mgd.flags & IEEE80211_STA_MFP_ENABLED))
-			flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 		break;
 	default:
 		return -EOPNOTSUPP;


