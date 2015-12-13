Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38848 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbbLMSML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2015 13:12:11 -0500
Received: by wmpp66 with SMTP id p66so33943818wmp.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Dec 2015 10:12:10 -0800 (PST)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] nl80211: Potential memory leaks in reg.c
Date: Sun, 13 Dec 2015 19:12:03 +0100
Message-Id: <1450030323-6637-1-git-send-email-ola1olsson@gmail.com> (sfid-20151213_191215_763471_5664AA1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first leak occurs when entering the default case
in the switch for the initiator in set_regdom.
The second leaks a platform_device struct if the
platform registration in regulatory_init succeeds but
the sub sequent regulatory hint fails due to no memory.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 net/wireless/reg.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2e8d6f3..06d050d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3029,6 +3029,7 @@ int set_regdom(const struct ieee80211_regdomain *rd,
 		break;
 	default:
 		WARN(1, "invalid initiator %d\n", lr->initiator);
+		kfree(rd);
 		return -EINVAL;
 	}
 
@@ -3221,8 +3222,10 @@ int __init regulatory_init(void)
 	/* We always try to get an update for the static regdomain */
 	err = regulatory_hint_core(cfg80211_world_regdom->alpha2);
 	if (err) {
-		if (err == -ENOMEM)
+		if (err == -ENOMEM) {
+			platform_device_unregister(reg_pdev);
 			return err;
+		}
 		/*
 		 * N.B. kobject_uevent_env() can fail mainly for when we're out
 		 * memory which is handled and propagated appropriately above
-- 
1.7.9.5

