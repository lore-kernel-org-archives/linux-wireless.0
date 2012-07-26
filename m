Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52781 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2GZBvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 21:51:14 -0400
Received: by gglu4 with SMTP id u4so1430439ggl.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 18:51:14 -0700 (PDT)
From: AceLan Kao <acelan.kao@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH] Revert "rfkill: remove dead code"
Date: Thu, 26 Jul 2012 09:51:08 +0800
Message-Id: <1343267468-9986-1-git-send-email-acelan.kao@canonical.com> (sfid-20120726_035152_273520_D33FA452)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 2e48928d8a0f38c1b5c81eb3f1294de8a6382c68.

Those functions are needed and should not be removed, or
there is no way to set the rfkill led trigger name.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
---
 include/linux/rfkill.h |   31 +++++++++++++++++++++++++++++++
 net/rfkill/core.c      |   14 ++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 6fdf027..0ec590b 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -354,6 +354,37 @@ static inline bool rfkill_blocked(struct rfkill *rfkill)
 }
 #endif /* RFKILL || RFKILL_MODULE */
 
+
+#ifdef CONFIG_RFKILL_LEDS
+/**
+ * rfkill_get_led_trigger_name - Get the LED trigger name for the button's LED.
+ * This function might return a NULL pointer if registering of the
+ * LED trigger failed. Use this as "default_trigger" for the LED.
+ */
+const char *rfkill_get_led_trigger_name(struct rfkill *rfkill);
+
+/**
+ * rfkill_set_led_trigger_name -- set the LED trigger name
+ * @rfkill: rfkill struct
+ * @name: LED trigger name
+ *
+ * This function sets the LED trigger name of the radio LED
+ * trigger that rfkill creates. It is optional, but if called
+ * must be called before rfkill_register() to be effective.
+ */
+void rfkill_set_led_trigger_name(struct rfkill *rfkill, const char *name);
+#else
+static inline const char *rfkill_get_led_trigger_name(struct rfkill *rfkill)
+{
+	return NULL;
+}
+
+static inline void
+rfkill_set_led_trigger_name(struct rfkill *rfkill, const char *name)
+{
+}
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif /* RFKILL_H */
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index f974961..2364064 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -150,6 +150,20 @@ static void rfkill_led_trigger_activate(struct led_classdev *led)
 	rfkill_led_trigger_event(rfkill);
 }
 
+const char *rfkill_get_led_trigger_name(struct rfkill *rfkill)
+{
+	return rfkill->led_trigger.name;
+}
+EXPORT_SYMBOL(rfkill_get_led_trigger_name);
+
+void rfkill_set_led_trigger_name(struct rfkill *rfkill, const char *name)
+{
+	BUG_ON(!rfkill);
+
+	rfkill->ledtrigname = name;
+}
+EXPORT_SYMBOL(rfkill_set_led_trigger_name);
+
 static int rfkill_led_trigger_register(struct rfkill *rfkill)
 {
 	rfkill->led_trigger.name = rfkill->ledtrigname
-- 
1.7.9.5

