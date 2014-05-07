Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42845 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932222AbaEGQHV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 12:07:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, standby24x7@gmail.com
Date: Wed,  7 May 2014 19:07:05 +0300
Message-Id: <1399478825-18141-1-git-send-email-luca@coelho.fi> (sfid-20140507_180725_755173_F3382CD3)
Subject: [PATCH] cfg80211: fix docbook warning
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

When trying to generate documentation, at least xmldocs, we get the
following warning:

Warning(include/net/cfg80211.h:461): No description found for parameter 'nl80211_iftype'

Fix it by adding the iftype argument name to the
cfg80211_chandef_dfs_required() function declaration.

Reported-and-tested-by: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0631230..28f6f1a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -458,7 +458,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
  */
 int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 				  const struct cfg80211_chan_def *chandef,
-				  enum nl80211_iftype);
+				  enum nl80211_iftype iftype);
 
 /**
  * ieee80211_chandef_rate_flags - returns rate flags for a channel
-- 
2.0.0.rc0

