Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45305 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597AbZC0P6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:58:12 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 4/4] rfkill: export events for global state changes
Date: Fri, 27 Mar 2009 12:58:05 -0300
Message-Id: <1238169485-29298-5-git-send-email-hmh@hmh.eng.br> (sfid-20090327_165816_505645_15FBACBE)
In-Reply-To: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br>
References: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Issue uevents for global rfkill state changes.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 901e6c2..2f23cf7 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -56,6 +56,8 @@ static unsigned long rfkill_states_lockdflt[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
 static bool rfkill_epo_lock_active;
 
 static void rfkill_uevent(struct rfkill *rfkill);
+static void rfkill_global_uevent(enum rfkill_type type,
+				 enum rfkill_state state);
 
 #ifdef CONFIG_RFKILL_LEDS
 static void rfkill_led_trigger(struct rfkill *rfkill,
@@ -188,6 +190,7 @@ static void __rfkill_switch_all(const enum rfkill_type type,
 			mutex_unlock(&rfkill->mutex);
 		}
 	}
+	rfkill_global_uevent(type, state);
 }
 
 /**
@@ -1238,6 +1241,42 @@ static struct platform_driver rfkill_pdrv = {
 		.owner = THIS_MODULE,
 	},
 };
+
+/*
+ * Global rfkill uevents
+ */
+
+static void rfkill_global_uevent(enum rfkill_type type,
+				 enum rfkill_state state)
+{
+	struct kobj_uevent_env *env;
+
+	env = kzalloc(sizeof(*env), GFP_KERNEL);
+	if (WARN(!env, "rfkill: out of memory while trying to issue "
+			"RFKILL_GLOBAL_STATE_CHANGED uevent for type "
+			"%u\n", type))
+		return;
+
+	if (add_uevent_var(env, "RFKILL_GLOBAL_TYPE=%s",
+				rfkill_get_type_str(type)) ||
+	    add_uevent_var(env, "RFKILL_GLOBAL_STATE=%d",
+				state))
+		goto err_exit;
+
+	kobject_uevent_env(&rfkill_pdev->dev.kobj, KOBJ_CHANGE,
+			   (char **)&env->envp);
+	kfree(env);
+	return;
+
+err_exit:
+	WARN(1, "rfkill: failed to build uevent RFKILL_GLOBAL_STATE_CHANGED "
+		"data structures for type %u\n", type);
+	kfree(env);
+	return;
+}
+#else
+static void rfkill_global_uevent(enum rfkill_type type,
+				 enum rfkill_state state) {};
 #endif /* CONFIG_RFKILL_GLOBAL_UAPI && !CONFIG_RFKILL_NO_CORE_UAPI */
 
 /*
-- 
1.6.2.1

