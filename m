Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:46688 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbZA0OGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 09:06:42 -0500
Received: by wa-out-1112.google.com with SMTP id v33so782749wah.21
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 06:06:39 -0800 (PST)
Date: Tue, 27 Jan 2009 19:26:28 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Cancel the dynamic ps timer in ioctl_siwpower.
Message-ID: <20090127135628.GA32059@myhost.users.atheros.com> (sfid-20090127_150648_722504_92726B50)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the dynamic power save timer has been started before the power save 
is disabled using iwconfig, we fail to cancel the timer. Hence cancel it
while disabling power save.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/wext.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 70a29b6..5c88b82 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -906,6 +906,8 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
 					IEEE80211_CONF_CHANGE_PS);
 			if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
 				ieee80211_send_nullfunc(local, sdata, 0);
+			del_timer_sync(&local->dynamic_ps_timer);
+			cancel_work_sync(&local->dynamic_ps_enable_work);
 		}
 	}
 
-- 
1.6.0.1

