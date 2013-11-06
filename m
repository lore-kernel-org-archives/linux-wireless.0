Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40652 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3KFSEr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 13:04:47 -0500
Received: by mail-pd0-f179.google.com with SMTP id y10so10415224pdj.38
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 10:04:46 -0800 (PST)
From: Javier Lopez <jlopex@cozybit.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	marco@cozybit.com, Javier Lopez <jlopex@cozybit.com>
Subject: [PATCH] mac80211: fix for mesh beacon update on powersave
Date: Wed,  6 Nov 2013 10:04:29 -0800
Message-Id: <1383761069-31615-1-git-send-email-jlopex@cozybit.com> (sfid-20131106_190450_145576_B5C2B746)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh beacon was not being rebuild after user triggered a mesh
powersave change.

To solve this issue use ieee80211_mbss_info_change_notify instead
of ieee80211_bss_info_change_notify. This helper function forces
mesh beacon to be rebuild and then notifies the driver about the
beacon change.

Signed-off-by: Javier Lopez <jlopex@cozybit.com>
---
 net/mac80211/cfg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 95667b0..ad2889f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1368,7 +1368,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 			changed |=
 			      ieee80211_mps_set_sta_local_pm(sta,
 							     params->local_pm);
-		ieee80211_bss_info_change_notify(sdata, changed);
+		ieee80211_mbss_info_change_notify(sdata, changed);
 #endif
 	}
 
-- 
1.7.9.5

