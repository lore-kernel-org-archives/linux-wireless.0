Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57124 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754084AbZC0PoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:44:17 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 2/4] rfkill: status initialization paranoia
Date: Fri, 27 Mar 2009 12:44:09 -0300
Message-Id: <1238168651-28891-3-git-send-email-hmh@hmh.eng.br> (sfid-20090327_164422_352905_58860B76)
In-Reply-To: <1238168651-28891-1-git-send-email-hmh@hmh.eng.br>
References: <1238168651-28891-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Track, and detect if rfkill->status is unitialized at
rfkill_register() time.

Note that if rfkill->get_status() is defined, the status will be
initialized by the core at rfkill_register() time.  This is nothing
new, it already happened in the rfkill_toggle_radio() call done by
rfkill_add_switch().

Also, update relevant docs and comments.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 Documentation/rfkill.txt |    3 ++-
 net/rfkill/rfkill.c      |   26 ++++++++++++++++++++++----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index 4d3ee31..8c611ec 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -483,7 +483,8 @@ You should:
 	- rfkill_allocate()
 	- modify rfkill fields (flags, name)
 	- modify state to the current hardware state (THIS IS THE ONLY TIME
-	  YOU CAN ACCESS state DIRECTLY)
+	  YOU CAN ACCESS state DIRECTLY) if you don't provide a get_state()
+	  hook
 	- rfkill_register()
 
 The only way to set a device to the RFKILL_STATE_HARD_BLOCKED state is through
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index f00df8c..16db5cc 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -662,10 +662,10 @@ static void rfkill_remove_switch(struct rfkill *rfkill)
  *
  * This function should be called by the network driver when it needs
  * rfkill structure.  Once the structure is allocated the driver should
- * finish its initialization by setting the name, private data, enable_radio
- * and disable_radio methods and then register it with rfkill_register().
+ * finish its initialization by setting the name, private data, hooks,
+ * and other relevant fields... and then register it with rfkill_register().
  *
- * NOTE: If registration fails the structure shoudl be freed by calling
+ * NOTE: If registration fails the structure should be freed by calling
  * rfkill_free() otherwise rfkill_unregister() should be used.
  */
 struct rfkill * __must_check rfkill_allocate(struct device *parent,
@@ -687,6 +687,7 @@ struct rfkill * __must_check rfkill_allocate(struct device *parent,
 	mutex_init(&rfkill->mutex);
 	INIT_LIST_HEAD(&rfkill->node);
 	rfkill->type = type;
+	rfkill->state = RFKILL_STATE_MAX; /* pre-init to illegal value */
 
 	dev = &rfkill->dev;
 	dev->class = &rfkill_class;
@@ -754,7 +755,7 @@ int __must_check rfkill_register(struct rfkill *rfkill)
 
 	if (WARN((!rfkill || !rfkill->toggle_radio ||
 			rfkill->type >= RFKILL_TYPE_MAX ||
-			rfkill->state >= RFKILL_STATE_MAX),
+			rfkill->state > RFKILL_STATE_MAX),
 			KERN_WARNING
 			"rfkill: attempt to register a "
 			"badly initialized rfkill struct\n"))
@@ -764,6 +765,23 @@ int __must_check rfkill_register(struct rfkill *rfkill)
 
 	rfkill_led_trigger_register(rfkill);
 
+	/* rfkill->state initialization */
+	if (rfkill->get_state) {
+		mutex_lock(&rfkill->mutex);
+		error = rfkill->get_state(rfkill->data, &rfkill->state);
+		mutex_unlock(&rfkill->mutex);
+		if (error < 0) {
+			printk(KERN_WARNING
+				"rfkill: get_state() hook failed "
+				"during registration...\n");
+			return error;
+		}
+	}
+	if (WARN((rfkill->state >= RFKILL_STATE_MAX),
+			KERN_WARNING
+			"rfkill: rfkill->state not properly initialized\n"))
+		return -EINVAL;
+
 	error = rfkill_add_switch(rfkill);
 	if (error) {
 		rfkill_led_trigger_unregister(rfkill);
-- 
1.6.2.1

