Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:34671 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdAYX4Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jan 2017 18:56:25 -0500
Received: by mail-pg0-f42.google.com with SMTP id 14so68262434pgg.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jan 2017 15:56:25 -0800 (PST)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] nl80211: Fix mesh HT operation check
Date: Thu, 26 Jan 2017 08:56:13 +0900
Message-Id: <1485388573-4264-1-git-send-email-masashi.honma@gmail.com> (sfid-20170126_005634_579432_E21360A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 9757235f451c27deaa88925399f070ff6fcea832 ('nl80211: correct
checks for NL80211_MESHCONF_HT_OPMODE value') missed to mask a flag
when replacing FILL_IN_MESH_PARAM_IF_SET with checking codes. This
could drop the received HT operation value when called by
nl80211_update_mesh_config().

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e6ed8dc..006c147 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5924,6 +5924,7 @@ do {									    \
 			break;
 		}
 		cfg->ht_opmode = ht_opmode;
+		mask |= (1 << (NL80211_MESHCONF_HT_OPMODE - 1));
 	}
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathToRootTimeout,
 				  1, 65535, mask,
-- 
2.7.4
