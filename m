Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35888 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1KIK3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 05:29:18 -0500
Received: by faan17 with SMTP id n17so1483811faa.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2011 02:29:16 -0800 (PST)
From: Eyal Shapira <eyal@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: add recalc PS in ieee80211_reconfig()
Date: Wed,  9 Nov 2011 12:29:06 +0200
Message-Id: <1320834546-1586-1-git-send-email-eyal@wizery.com> (sfid-20111109_112921_521961_26B8F723)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver should be instructed to enter PS AFTER
reconfiguring ASSOCIATED (in STA case) using ieee80211_bss_info_change_notify
same as it's being done in ieee80211_set_associated()

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 net/mac80211/util.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7439d26..ad6d7a1 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1107,6 +1107,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		}
 	}
 
+	ieee80211_recalc_ps(local, -1);
+
 	/*
 	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
 	 * sessions can be established after a resume.
-- 
1.7.4.1

