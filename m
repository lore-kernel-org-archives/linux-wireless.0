Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35992 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab3GUNg5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jul 2013 09:36:57 -0400
Received: by mail-ee0-f50.google.com with SMTP id d49so3327618eek.9
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jul 2013 06:36:55 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/2] regulatory: use correct regulatory initiator on wiphy register
Date: Sun, 21 Jul 2013 16:36:48 +0300
Message-Id: <1374413809-26005-1-git-send-email-arik@wizery.com> (sfid-20130721_154507_440351_5B8F6C3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current regdomain was not always set by the core. This causes
cards with a custom regulatory domain to ignore user initiated changes
if done before the card was registered.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/wireless/reg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ddeff80..1ec3933 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2250,10 +2250,13 @@ int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 void wiphy_regulatory_register(struct wiphy *wiphy)
 {
+	struct regulatory_request *lr;
+
 	if (!reg_dev_ignore_cell_hint(wiphy))
 		reg_num_devs_support_basehint++;
 
-	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
+	lr = get_last_request();
+	wiphy_update_regulatory(wiphy, lr->initiator);
 }
 
 void wiphy_regulatory_deregister(struct wiphy *wiphy)
-- 
1.8.1.2

