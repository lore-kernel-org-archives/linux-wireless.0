Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52988 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3FUGxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 02:53:45 -0400
Received: by mail-pb0-f44.google.com with SMTP id uo1so7344179pbc.3
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jun 2013 23:53:44 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>, marco@cozybit.com,
	Bob Copeland <me@bobcopeland.com>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/2] mac80211: allow self-protected frame tx without sta
Date: Thu, 20 Jun 2013 23:50:58 -0700
Message-Id: <1371797459-16585-1-git-send-email-thomas@cozybit.com> (sfid-20130621_085348_661821_2B34415B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Useful for userspace mesh to authenticate and peer without
a station entry, since both steps may fail anyway.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/cfg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 18ba7ed..d6f9823 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2821,7 +2821,8 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		    !rcu_access_pointer(sdata->bss->beacon))
 			need_offchan = true;
 		if (!ieee80211_is_action(mgmt->frame_control) ||
-		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC)
+		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC ||
+		    mgmt->u.action.category == WLAN_CATEGORY_SELF_PROTECTED)
 			break;
 		rcu_read_lock();
 		sta = sta_info_get(sdata, mgmt->da);
-- 
1.7.10.4

