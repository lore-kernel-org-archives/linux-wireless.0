Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19732 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbbA0QL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 11:11:27 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: fix world_regdom's n_reg_rules
Date: Tue, 27 Jan 2015 18:10:51 +0200
Message-Id: <1422375051-20709-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150127_171130_431808_A92A3D19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the commit:
131a19b - regulatory: enable channels 52-64 and 100-144 for world roaming

2 entries added to the world_regdom.reg_rules, while
world_regdom.n_reg_rules was not updated to reflect array size.
Fix it.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b586d0d..48dfc7b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -228,7 +228,7 @@ static DECLARE_DELAYED_WORK(reg_timeout, reg_timeout_work);
 
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
-	.n_reg_rules = 6,
+	.n_reg_rules = 8,
 	.alpha2 =  "00",
 	.reg_rules = {
 		/* IEEE 802.11b/g, channels 1..11 */
-- 
2.1.0

