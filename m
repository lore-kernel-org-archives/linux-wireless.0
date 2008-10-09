Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58194 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752788AbYJIVPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 17:15:40 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 2/5] rfkill: export global states to rfkill-input
Date: Thu,  9 Oct 2008 18:15:30 -0300
Message-Id: <1223586933-17753-3-git-send-email-hmh@hmh.eng.br> (sfid-20081009_231545_316561_F90363D4)
In-Reply-To: <1223586933-17753-1-git-send-email-hmh@hmh.eng.br>
References: <1223586933-17753-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Export the the global switch states to rfkill-input.  This is needed to
properly implement KEY_* handling without disregarding the initial state.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill-input.h |    1 +
 net/rfkill/rfkill.c       |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/rfkill-input.h b/net/rfkill/rfkill-input.h
index bbfa646..d1e03e8 100644
--- a/net/rfkill/rfkill-input.h
+++ b/net/rfkill/rfkill-input.h
@@ -14,5 +14,6 @@
 void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state);
 void rfkill_epo(void);
 void rfkill_restore_states(void);
+enum rfkill_state rfkill_get_global_state(const enum rfkill_type type);
 
 #endif /* __RFKILL_INPUT_H */
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 08be968..fdf87d2 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -324,6 +324,19 @@ void rfkill_restore_states(void)
 EXPORT_SYMBOL_GPL(rfkill_restore_states);
 
 /**
+ * rfkill_get_global_state - returns global state for a type
+ * @type: the type to get the global state of
+ *
+ * Returns the current global state for a given wireless
+ * device type.
+ */
+enum rfkill_state rfkill_get_global_state(const enum rfkill_type type)
+{
+	return rfkill_global_states[type].current_state;
+}
+EXPORT_SYMBOL_GPL(rfkill_get_global_state);
+
+/**
  * rfkill_force_state - Force the internal rfkill radio state
  * @rfkill: pointer to the rfkill class to modify.
  * @state: the current radio state the class should be forced to.
@@ -834,6 +847,7 @@ int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
 
 	if (!test_and_set_bit(type, rfkill_states_lockdflt)) {
 		rfkill_global_states[type].default_state = state;
+		rfkill_global_states[type].current_state = state;
 		error = 0;
 	} else
 		error = -EPERM;
-- 
1.5.6.5

