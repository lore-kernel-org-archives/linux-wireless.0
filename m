Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f216.google.com ([209.85.220.216]:53872 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab0BXNZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2010 08:25:39 -0500
Received: by fxm8 with SMTP id 8so2573805fxm.28
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2010 05:25:38 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: use listen interval 5 as default
Date: Wed, 24 Feb 2010 14:19:37 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201002241419.38121.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently if a driver does not set hw.max_listen_interval a listen
interval of 1 is negotiated with the AP. Thus, the AP could drop
buffered frames for us after just one beacon interval which can
easily happen with the current powersave and scan implementation.
To avoid this issue increase the default interval to 5 which should
be a reasonable safe default.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/main.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ec8f767..06c33b6 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -558,8 +558,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	debugfs_hw_add(local);
 
+	/*
+	 * if the driver doesn't specify a max listen interval we
+	 * use 5 which should be a safe default
+	 */
 	if (local->hw.max_listen_interval == 0)
-		local->hw.max_listen_interval = 1;
+		local->hw.max_listen_interval = 5;
 
 	local->hw.conf.listen_interval = local->hw.max_listen_interval;
 
-- 
1.6.0.2

