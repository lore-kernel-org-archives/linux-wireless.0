Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40737 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762176AbYFWUXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 16:23:22 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Fabien Crespel <fabien@crespel.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 10/13] rfkill: add uevent notifications
Date: Mon, 23 Jun 2008 17:23:05 -0300
Message-Id: <1214252588-30723-11-git-send-email-hmh@hmh.eng.br> (sfid-20080623_224915_038231_7F78D873)
In-Reply-To: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the notification chains to also send uevents, so that userspace can be
notified of state changes of every rfkill switch.

Userspace should use these events for OSD/status report applications and
rfkill GUI frontends.  HAL might want to broadcast them over DBUS, for
example.  It might be also useful for userspace implementations of
rfkill-input, or to use HAL as the platform driver which promotes rfkill
switch change events into input events (to synchronize all other switches)
when necessary for platforms that lack a convenient platform-specific
kernel module to do it.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 net/rfkill/rfkill.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 3c77734..dd1c3f1 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -386,12 +386,51 @@ static int rfkill_resume(struct device *dev)
 #define rfkill_resume NULL
 #endif
 
+static int rfkill_blocking_uevent_notifier(struct notifier_block *nb,
+					unsigned long eventid,
+					void *data)
+{
+	struct rfkill *rfkill = (struct rfkill *)data;
+
+	switch (eventid) {
+	case RFKILL_STATE_CHANGED:
+		kobject_uevent(&rfkill->dev.kobj, KOBJ_CHANGE);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block rfkill_blocking_uevent_nb = {
+	.notifier_call	= rfkill_blocking_uevent_notifier,
+	.priority	= 0,
+};
+
+static int rfkill_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
+	int error;
+
+	error = add_uevent_var(env, "RFKILL_NAME=%s", rfkill->name);
+	if (error)
+		return error;
+	error = add_uevent_var(env, "RFKILL_TYPE=%s",
+				rfkill_get_type_str(rfkill->type));
+	if (error)
+		return error;
+	error = add_uevent_var(env, "RFKILL_STATE=%d", rfkill->state);
+	return error;
+}
+
 static struct class rfkill_class = {
 	.name		= "rfkill",
 	.dev_release	= rfkill_release,
 	.dev_attrs	= rfkill_dev_attrs,
 	.suspend	= rfkill_suspend,
 	.resume		= rfkill_resume,
+	.dev_uevent	= rfkill_dev_uevent,
 };
 
 static int rfkill_add_switch(struct rfkill *rfkill)
@@ -566,11 +605,14 @@ static int __init rfkill_init(void)
 		return error;
 	}
 
+	register_rfkill_notifier(&rfkill_blocking_uevent_nb);
+
 	return 0;
 }
 
 static void __exit rfkill_exit(void)
 {
+	unregister_rfkill_notifier(&rfkill_blocking_uevent_nb);
 	class_unregister(&rfkill_class);
 }
 
-- 
1.5.5.4

