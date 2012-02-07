Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38194 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab2BGLqC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 06:46:02 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: add #ifdef CONFIG_MAC80211_VERBOSE_DEBUG for a debug printk
Date: Tue,  7 Feb 2012 12:45:44 +0100
Message-Id: <1328615144-66050-1-git-send-email-nbd@openwrt.org> (sfid-20120207_124607_346922_78FFE4AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When not debugging mac80211 code, station state transitions do not need to
show up in the kernel log.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/sta_info.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 31cd6d9..4034ee6 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1379,8 +1379,10 @@ int sta_info_move_state(struct sta_info *sta,
 		return -EINVAL;
 	}
 
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: moving STA %pM to state %d\n",
 		sta->sdata->name, sta->sta.addr, new_state);
+#endif
 
 	/*
 	 * notify the driver before the actual changes so it can
-- 
1.7.3.2

