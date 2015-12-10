Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52558 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbbLJJmU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 04:42:20 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] rfkill: copy the name into the rfkill struct
Date: Thu, 10 Dec 2015 10:42:12 +0100
Message-Id: <1449740532-4292-1-git-send-email-johannes@sipsolutions.net> (sfid-20151210_104224_388217_0123EA52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some users of rfkill, like NFC and cfg80211, use a dynamic name when
allocating rfkill, in those cases dev_name(). Therefore, the pointer
passed to rfkill_alloc() might not be valid forever, I specifically
found the case that the rfkill name was quite obviously an invalid
pointer (or at least garbage) when the wiphy had been renamed.

Fix this by making a copy of the rfkill name in rfkill_alloc().

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/rfkill/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index b41e9ea2ffff..f53bf3b6558b 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -49,7 +49,6 @@
 struct rfkill {
 	spinlock_t		lock;
 
-	const char		*name;
 	enum rfkill_type	type;
 
 	unsigned long		state;
@@ -73,6 +72,7 @@ struct rfkill {
 	struct delayed_work	poll_work;
 	struct work_struct	uevent_work;
 	struct work_struct	sync_work;
+	char			name[];
 };
 #define to_rfkill(d)	container_of(d, struct rfkill, dev)
 
@@ -876,14 +876,14 @@ struct rfkill * __must_check rfkill_alloc(const char *name,
 	if (WARN_ON(type == RFKILL_TYPE_ALL || type >= NUM_RFKILL_TYPES))
 		return NULL;
 
-	rfkill = kzalloc(sizeof(*rfkill), GFP_KERNEL);
+	rfkill = kzalloc(sizeof(*rfkill) + strlen(name) + 1, GFP_KERNEL);
 	if (!rfkill)
 		return NULL;
 
 	spin_lock_init(&rfkill->lock);
 	INIT_LIST_HEAD(&rfkill->node);
 	rfkill->type = type;
-	rfkill->name = name;
+	strcpy(rfkill->name, name);
 	rfkill->ops = ops;
 	rfkill->data = ops_data;
 
-- 
2.6.2

