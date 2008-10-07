Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34712 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762AbYJGQ6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 12:58:14 -0400
Message-Id: <20081007100441.062316000@sipsolutions.net> (sfid-20081007_185820_436471_6D993D6B)
References: <20081007100428.868688000@sipsolutions.net>
Date: Tue, 07 Oct 2008 12:04:33 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/8] mac80211: remove wiphy_to_hw
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This isn't used by anyone, if we ever need it we can add
it back, until then it's useless.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    2 --
 net/mac80211/cfg.c     |    7 -------
 2 files changed, 9 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-10-07 11:26:51.000000000 +0200
+++ everything/include/net/mac80211.h	2008-10-07 11:27:02.000000000 +0200
@@ -846,8 +846,6 @@ struct ieee80211_hw {
 	s8 max_signal;
 };
 
-struct ieee80211_hw *wiphy_to_hw(struct wiphy *wiphy);
-
 /**
  * SET_IEEE80211_DEV - set device for 802.11 hardware
  *
--- everything.orig/net/mac80211/cfg.c	2008-10-07 11:26:56.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-10-07 11:27:02.000000000 +0200
@@ -17,13 +17,6 @@
 #include "rate.h"
 #include "mesh.h"
 
-struct ieee80211_hw *wiphy_to_hw(struct wiphy *wiphy)
-{
-	struct ieee80211_local *local = wiphy_priv(wiphy);
-	return &local->hw;
-}
-EXPORT_SYMBOL(wiphy_to_hw);
-
 static bool nl80211_type_check(enum nl80211_iftype type)
 {
 	switch (type) {

-- 

