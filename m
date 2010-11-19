Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65219 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab0KSLkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 06:40:46 -0500
Received: by mail-bw0-f46.google.com with SMTP id 15so3773153bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 03:40:46 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/2] mac80211: Apply ht_opmode changes in ieee80211_change_bss
Date: Fri, 19 Nov 2010 12:40:26 +0100
Message-Id: <1290166826-27063-2-git-send-email-helmut.schaa@googlemail.com>
In-Reply-To: <1290166826-27063-1-git-send-email-helmut.schaa@googlemail.com>
References: <1290166826-27063-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/cfg.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0c54407..e907604 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1108,6 +1108,12 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 			sdata->flags &= ~IEEE80211_SDATA_DONT_BRIDGE_PACKETS;
 	}
 
+	if (params->ht_opmode >= 0) {
+		sdata->vif.bss_conf.ht_operation_mode =
+			(u16) params->ht_opmode;
+		changed |= BSS_CHANGED_HT;
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	return 0;
-- 
1.7.1

