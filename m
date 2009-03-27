Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38779 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755881AbZC0PoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:44:19 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 4/4] rfkill: allow embedded config without an userspace API
Date: Fri, 27 Mar 2009 12:44:11 -0300
Message-Id: <1238168651-28891-5-git-send-email-hmh@hmh.eng.br> (sfid-20090327_164423_725992_31FDE9B1)
In-Reply-To: <1238168651-28891-1-git-send-email-hmh@hmh.eng.br>
References: <1238168651-28891-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow rfkill to be configured without any of the sysfs APIs, on embedded
systems.

Systems using rfkill-input exclusively and who could care less for userland
feedback do not need the userspace APIs, and can get rid of a reasonable
ammount of code and data that way.

Some code is moved around, but there are no code changes other than the
inclusion of some #ifndef/#else/#endif clauses.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 net/rfkill/Kconfig  |   10 +++++
 net/rfkill/rfkill.c |   94 +++++++++++++++++++++++++++++++--------------------
 2 files changed, 67 insertions(+), 37 deletions(-)

diff --git a/net/rfkill/Kconfig b/net/rfkill/Kconfig
index 7f807b3..ae0181f 100644
--- a/net/rfkill/Kconfig
+++ b/net/rfkill/Kconfig
@@ -10,6 +10,16 @@ menuconfig RFKILL
 	  To compile this driver as a module, choose M here: the
 	  module will be called rfkill.
 
+config RFKILL_NO_CORE_UAPI
+	bool "Remove the rfkill core userspace APIs"
+	depends on RFKILL
+	depends on EMBEDDED
+	default n
+	help
+	  Say Y here if you want to remove the entire rfkill userspace
+	  API.  Use this on highly constrained systems when no userspace
+	  feedback or userspace-based rfkill control is needed.
+
 config RFKILL_INPUT
 	tristate "Input layer to RF switch connector"
 	depends on RFKILL && INPUT
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 16db5cc..80f0fa0 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -53,6 +53,7 @@ static struct rfkill_gsw_state rfkill_global_states[RFKILL_TYPE_MAX];
 static unsigned long rfkill_states_lockdflt[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
 static bool rfkill_epo_lock_active;
 
+static void rfkill_uevent(struct rfkill *rfkill);
 
 #ifdef CONFIG_RFKILL_LEDS
 static void rfkill_led_trigger(struct rfkill *rfkill,
@@ -77,27 +78,6 @@ static void rfkill_led_trigger_activate(struct led_classdev *led)
 }
 #endif /* CONFIG_RFKILL_LEDS */
 
-static void rfkill_uevent(struct rfkill *rfkill)
-{
-	kobject_uevent(&rfkill->dev.kobj, KOBJ_CHANGE);
-}
-
-static void update_rfkill_state(struct rfkill *rfkill)
-{
-	enum rfkill_state newstate, oldstate;
-
-	if (rfkill->get_state) {
-		mutex_lock(&rfkill->mutex);
-		if (!rfkill->get_state(rfkill->data, &newstate)) {
-			oldstate = rfkill->state;
-			rfkill->state = newstate;
-			if (oldstate != newstate)
-				rfkill_uevent(rfkill);
-		}
-		mutex_unlock(&rfkill->mutex);
-	}
-}
-
 /**
  * rfkill_toggle_radio - wrapper for toggle_radio hook
  * @rfkill: the rfkill struct to use
@@ -363,6 +343,29 @@ int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state)
 }
 EXPORT_SYMBOL(rfkill_force_state);
 
+
+/*
+ * rfkill core sysfs interface
+ */
+
+#ifndef CONFIG_RFKILL_NO_CORE_UAPI
+
+static void update_rfkill_state(struct rfkill *rfkill)
+{
+	enum rfkill_state newstate, oldstate;
+
+	if (rfkill->get_state) {
+		mutex_lock(&rfkill->mutex);
+		if (!rfkill->get_state(rfkill->data, &newstate)) {
+			oldstate = rfkill->state;
+			rfkill->state = newstate;
+			if (oldstate != newstate)
+				rfkill_uevent(rfkill);
+		}
+		mutex_unlock(&rfkill->mutex);
+	}
+}
+
 static ssize_t rfkill_name_show(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
@@ -504,6 +507,39 @@ static struct device_attribute rfkill_dev_attrs[] = {
 	__ATTR_NULL
 };
 
+
+/*
+ * rfkill core UEVENT API
+ */
+
+static void rfkill_uevent(struct rfkill *rfkill)
+{
+	kobject_uevent(&rfkill->dev.kobj, KOBJ_CHANGE);
+}
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
+#else
+#define rfkill_dev_attrs NULL
+#define rfkill_dev_uevent NULL
+static void rfkill_uevent(struct rfkill *rfkill) {};
+#endif	/* ifndef CONFIG_RFKILL_NO_CORE_UAPI */
+
+
 static void rfkill_release(struct device *dev)
 {
 	struct rfkill *rfkill = to_rfkill(dev);
@@ -568,22 +604,6 @@ static int rfkill_resume(struct device *dev)
 #define rfkill_resume NULL
 #endif
 
-static int rfkill_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
-{
-	struct rfkill *rfkill = to_rfkill(dev);
-	int error;
-
-	error = add_uevent_var(env, "RFKILL_NAME=%s", rfkill->name);
-	if (error)
-		return error;
-	error = add_uevent_var(env, "RFKILL_TYPE=%s",
-				rfkill_get_type_str(rfkill->type));
-	if (error)
-		return error;
-	error = add_uevent_var(env, "RFKILL_STATE=%d", rfkill->state);
-	return error;
-}
-
 static struct class rfkill_class = {
 	.name		= "rfkill",
 	.dev_release	= rfkill_release,
-- 
1.6.2.1

