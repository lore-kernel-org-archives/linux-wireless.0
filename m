Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1677 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GHLIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 07:08:25 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] Fix oops when set_monitor_enabled() not defined in the struct cfg80211_ops
Date: Sun, 8 Jul 2012 14:08:10 +0300
Message-ID: <1341745690-12574-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120708_130858_284398_1162D6C1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quick fix for method being invoked without checking its existence

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 net/wireless/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index eb60410..e42a97b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -774,8 +774,9 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 
 	has_monitors_only_new = cfg80211_has_monitors_only(rdev);
 	if (has_monitors_only_new != has_monitors_only_old) {
-		rdev->ops->set_monitor_enabled(&rdev->wiphy,
-					       has_monitors_only_new);
+		if (rdev->ops->set_monitor_enabled)
+			rdev->ops->set_monitor_enabled(&rdev->wiphy,
+						       has_monitors_only_new);
 
 		if (!has_monitors_only_new) {
 			rdev->monitor_channel = NULL;
-- 
1.7.9.5

