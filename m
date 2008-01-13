Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbYAMVVx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 16:21:53 -0500
Subject: [PATCH] rfkill - rfkill_register() doesn't call
	rfkill_led_trigger_unregister() on error
From: Eric Paris <eparis@redhat.com>
To: bcm43xx-dev@lists.berlios.de
Cc: mb@bu3sch.de, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sun, 13 Jan 2008 16:20:56 -0500
Message-Id: <1200259256.4393.24.camel@localhost.localdomain> (sfid-20080113_212157_066027_DBF7EFE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code inspection turned up that error cases in rfkill_register() do not
call rfkill_led_trigger_unregister() even though we have already
registered.

Signed-off-by: Eric Paris <eparis@redhat.com>

---

 net/rfkill/rfkill.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 4469a7b..d06d338 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -392,11 +392,14 @@ int rfkill_register(struct rfkill *rfkill)
 	rfkill_led_trigger_register(rfkill);
 
 	error = rfkill_add_switch(rfkill);
-	if (error)
+	if (error) {
+		rfkill_led_trigger_unregister(rfkill);
 		return error;
+	}
 
 	error = device_add(dev);
 	if (error) {
+		rfkill_led_trigger_unregister(rfkill);
 		rfkill_remove_switch(rfkill);
 		return error;
 	}


