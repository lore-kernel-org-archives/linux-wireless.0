Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([84.19.176.117]:46532 "EHLO ns.pmeerw.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751723AbeFDVeK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 17:34:10 -0400
From: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Subject: [PATCH] rfkill: Fixes and cleanup of header file
Date: Mon,  4 Jun 2018 23:34:06 +0200
Message-Id: <20180604213406.31016-1-pmeerw@pmeerw.net> (sfid-20180604_233425_621332_945350CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes kerneldoc parameter names to match implementation,
rfkill_set_hw_state(), rfkill_set_sw_state().
Fix description of rfkill_resume_polling().
Fix typos in documentation of rfkill_find_type().
Consistently start kerneldoc description with uppercase
letter.

Signed-off-by: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
---
 include/linux/rfkill.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index e6a0031d1b1f..8ad2487a86d5 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -66,7 +66,7 @@ struct rfkill_ops {
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 /**
- * rfkill_alloc - allocate rfkill structure
+ * rfkill_alloc - Allocate rfkill structure
  * @name: name of the struct -- the string is not copied internally
  * @parent: device that has rf switch on it
  * @type: type of the switch (RFKILL_TYPE_*)
@@ -112,7 +112,7 @@ void rfkill_pause_polling(struct rfkill *rfkill);
 /**
  * rfkill_resume_polling(struct rfkill *rfkill)
  *
- * Pause polling -- say transmitter is off for other reasons.
+ * Resume polling
  * NOTE: not necessary for suspend/resume -- in that case the
  * core stops polling anyway
  */
@@ -130,7 +130,7 @@ void rfkill_resume_polling(struct rfkill *rfkill);
 void rfkill_unregister(struct rfkill *rfkill);
 
 /**
- * rfkill_destroy - free rfkill structure
+ * rfkill_destroy - Free rfkill structure
  * @rfkill: rfkill structure to be destroyed
  *
  * Destroys the rfkill structure.
@@ -140,7 +140,7 @@ void rfkill_destroy(struct rfkill *rfkill);
 /**
  * rfkill_set_hw_state - Set the internal rfkill hardware block state
  * @rfkill: pointer to the rfkill class to modify.
- * @state: the current hardware block state to set
+ * @blocked: the current hardware block state to set
  *
  * rfkill drivers that get events when the hard-blocked state changes
  * use this function to notify the rfkill core (and through that also
@@ -161,7 +161,7 @@ bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
 /**
  * rfkill_set_sw_state - Set the internal rfkill software block state
  * @rfkill: pointer to the rfkill class to modify.
- * @state: the current software block state to set
+ * @blocked: the current software block state to set
  *
  * rfkill drivers that get events when the soft-blocked state changes
  * (yes, some platforms directly act on input but allow changing again)
@@ -183,7 +183,7 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked);
 /**
  * rfkill_init_sw_state - Initialize persistent software block state
  * @rfkill: pointer to the rfkill class to modify.
- * @state: the current software block state to set
+ * @blocked: the current software block state to set
  *
  * rfkill drivers that preserve their software block state over power off
  * use this function to notify the rfkill core (and through that also
@@ -208,17 +208,17 @@ void rfkill_init_sw_state(struct rfkill *rfkill, bool blocked);
 void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw);
 
 /**
- * rfkill_blocked - query rfkill block
+ * rfkill_blocked - Query rfkill block state
  *
  * @rfkill: rfkill struct to query
  */
 bool rfkill_blocked(struct rfkill *rfkill);
 
 /**
- * rfkill_find_type - Helpper for finding rfkill type by name
+ * rfkill_find_type - Helper for finding rfkill type by name
  * @name: the name of the type
  *
- * Returns enum rfkill_type that conrresponds the name.
+ * Returns enum rfkill_type that corresponds to the name.
  */
 enum rfkill_type rfkill_find_type(const char *name);
 
@@ -296,7 +296,7 @@ static inline enum rfkill_type rfkill_find_type(const char *name)
 const char *rfkill_get_led_trigger_name(struct rfkill *rfkill);
 
 /**
- * rfkill_set_led_trigger_name -- set the LED trigger name
+ * rfkill_set_led_trigger_name - Set the LED trigger name
  * @rfkill: rfkill struct
  * @name: LED trigger name
  *
-- 
2.11.0
