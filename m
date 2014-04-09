Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34251 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaDIB2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 21:28:51 -0400
Received: by mail-pa0-f53.google.com with SMTP id ld10so1787857pab.40
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 18:28:50 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/8] mac80211: fix possible compile warning in debugfs.h
Date: Wed,  9 Apr 2014 09:28:07 +0800
Message-Id: <c0057fcae3f31eb2fc8d085590bee3eedec79f4f.1397006688.git.gamerh2o@gmail.com> (sfid-20140409_032854_855772_3F206876)
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

net/mac80211/debugfs.h:5:28: warning: ‘struct ieee80211_local’ declared inside parameter list [enabled by default]
 void debugfs_hw_add(struct ieee80211_local *local);
                            ^
net/mac80211/debugfs.h:5:28: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/debugfs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/debugfs.h b/net/mac80211/debugfs.h
index 214ed4e..60c35af 100644
--- a/net/mac80211/debugfs.h
+++ b/net/mac80211/debugfs.h
@@ -1,6 +1,8 @@
 #ifndef __MAC80211_DEBUGFS_H
 #define __MAC80211_DEBUGFS_H
 
+#include "ieee80211_i.h"
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 void debugfs_hw_add(struct ieee80211_local *local);
 int __printf(4, 5) mac80211_format_buffer(char __user *userbuf, size_t count,
-- 
1.9.0

