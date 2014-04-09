Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43998 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaDIB2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 21:28:53 -0400
Received: by mail-pa0-f42.google.com with SMTP id fb1so1814895pad.29
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 18:28:53 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/8] mac80211: fix possible compile warning in michael.h
Date: Wed,  9 Apr 2014 09:28:08 +0800
Message-Id: <0c2fa5b7a8724d0ee405afd05f393af95e65116c.1397006688.git.gamerh2o@gmail.com> (sfid-20140409_032857_074294_E7D7A9C5)
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

net/mac80211//michael.h:22:4: warning: ‘struct ieee80211_hdr’ declared inside parameter list [enabled by default]
    const u8 *data, size_t data_len, u8 *mic);
    ^
net/mac80211//michael.h:22:4: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/michael.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/michael.h b/net/mac80211/michael.h
index 3b848da..b259547 100644
--- a/net/mac80211/michael.h
+++ b/net/mac80211/michael.h
@@ -10,7 +10,7 @@
 #ifndef MICHAEL_H
 #define MICHAEL_H
 
-#include <linux/types.h>
+#include <linux/ieee80211.h>
 
 #define MICHAEL_MIC_LEN 8
 
-- 
1.9.0

