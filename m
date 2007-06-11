Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbXFKIQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 04:16:20 -0400
Subject: [PATCH] mac80211: fix debugfs tx power reduction output
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 08:07:13 +0200
Message-Id: <1181542033.3566.21.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a typo in mac80211's debugfs.c.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- wireless-dev.orig/net/mac80211/debugfs.c	2007-06-09 14:58:38.521881735 +0200
+++ wireless-dev/net/mac80211/debugfs.c	2007-06-09 14:58:42.761881735 +0200
@@ -126,7 +126,7 @@ DEBUGFS_READONLY_FILE(wep_iv, 20, "%#06x
 		      local->wep_iv & 0xffffff);
 DEBUGFS_READONLY_FILE(tx_power_reduction, 20, "%d.%d dBm",
 		      local->hw.conf.tx_power_reduction / 10,
-		      local->hw.conf.tx_power_reduction & 10);
+		      local->hw.conf.tx_power_reduction % 10);
 
 DEBUGFS_READ(rate_ctrl_alg, 100, "%s",
 	     local->rate_ctrl ? local->rate_ctrl->ops->name : "<unset>");


