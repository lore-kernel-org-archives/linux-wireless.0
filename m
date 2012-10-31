Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34528 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423011Ab2JaOuh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 10:50:37 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.7] mac80211: do not call ieee80211_configure_filter if no interfaces are up
Date: Wed, 31 Oct 2012 15:50:34 +0100
Message-Id: <1351695034-74874-1-git-send-email-nbd@openwrt.org> (sfid-20121031_155046_166346_B3DF2633)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers are not expected to handle it before drv_start has been called. It
will be called again after an interface has been brought up.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/cfg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5eab132..7669002 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2613,6 +2613,9 @@ static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
 		else
 			local->probe_req_reg--;
 
+		if (!local->open_count)
+			break;
+
 		ieee80211_queue_work(&local->hw, &local->reconfig_filter);
 		break;
 	default:
-- 
1.7.12.2

