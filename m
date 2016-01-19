Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:34185 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbcASPoJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 10:44:09 -0500
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: johannes@sipsolutions.net
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, jprvita@endlessm.com,
	linux@endlessm.com
Subject: [PATCH 6/8] rfkill: Move user_state_from_blocked() close to its user
Date: Tue, 19 Jan 2016 10:42:41 -0500
Message-Id: <1453218163-31998-7-git-send-email-jprvita@endlessm.com> (sfid-20160119_164549_319718_03081A7C)
In-Reply-To: <1453218163-31998-1-git-send-email-jprvita@endlessm.com>
References: <1453218163-31998-1-git-send-email-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the removal of the state attribute there is only one user of
user_state_from_blocked() left. Moving this function close to its only
user makes the code more organized and easier to read.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 net/rfkill/core.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 26da4f0..0b9d5bf 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -673,16 +673,6 @@ static ssize_t soft_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(soft);
 
-static u8 user_state_from_blocked(unsigned long state)
-{
-	if (state & RFKILL_BLOCK_HW)
-		return RFKILL_USER_STATE_HARD_BLOCKED;
-	if (state & RFKILL_BLOCK_SW)
-		return RFKILL_USER_STATE_SOFT_BLOCKED;
-
-	return RFKILL_USER_STATE_UNBLOCKED;
-}
-
 static struct attribute *rfkill_dev_attrs[] = {
 	&dev_attr_name.attr,
 	&dev_attr_type.attr,
@@ -701,6 +691,16 @@ static void rfkill_release(struct device *dev)
 	kfree(rfkill);
 }
 
+static u8 user_state_from_blocked(unsigned long state)
+{
+	if (state & RFKILL_BLOCK_HW)
+		return RFKILL_USER_STATE_HARD_BLOCKED;
+	if (state & RFKILL_BLOCK_SW)
+		return RFKILL_USER_STATE_SOFT_BLOCKED;
+
+	return RFKILL_USER_STATE_UNBLOCKED;
+}
+
 static int rfkill_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct rfkill *rfkill = to_rfkill(dev);
-- 
2.5.0

