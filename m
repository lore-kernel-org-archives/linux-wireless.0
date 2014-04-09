Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58327 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaDIB24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 21:28:56 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so1802509pbb.36
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 18:28:55 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 4/8] mac80211: fix possible compile warning in debugfs_netdev.h
Date: Wed,  9 Apr 2014 09:28:09 +0800
Message-Id: <9709360a8341770ec487d9033bfa17fdebbb4bf0.1397006688.git.gamerh2o@gmail.com> (sfid-20140409_032900_490103_D8892A6C)
In-Reply-To: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
In-Reply-To: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The warning doesn't show up due to duplicate including, but it's worth
fixing it.

net/mac80211//debugfs_netdev.h:7:42: warning: ‘struct ieee80211_sub_if_data’ declared inside parameter list [enabled by default]
 void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata);
                                          ^
net/mac80211//debugfs_netdev.h:7:42: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/debugfs_netdev.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/debugfs_netdev.h b/net/mac80211/debugfs_netdev.h
index 79025e7..9f5501a 100644
--- a/net/mac80211/debugfs_netdev.h
+++ b/net/mac80211/debugfs_netdev.h
@@ -3,6 +3,8 @@
 #ifndef __IEEE80211_DEBUGFS_NETDEV_H
 #define __IEEE80211_DEBUGFS_NETDEV_H
 
+#include "ieee80211_i.h"
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata);
-- 
1.9.0

