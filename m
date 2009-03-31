Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZCaTMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 15:12:14 -0400
Subject: [RFC v3] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>, dbaryshkov@gmail.com,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1238349195.24972.5.camel@johannes.local> (sfid-20090329_195345_745378_2F2074B3)
References: <1238349195.24972.5.camel@johannes.local>
	 (sfid-20090329_195345_745378_2F2074B3)
Content-Type: text/plain
Date: Tue, 31 Mar 2009 21:11:34 +0200
Message-Id: <1238526694.5970.123.camel@johannes.local> (sfid-20090331_211224_651346_AF7D7A62)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch completely rewrites the rfkill core to address
the following deficiencies:

 * all rfkill drivers need to implement polling where necessary
   rather than having one central implementation

 * updating the rfkill state cannot be done from arbitrary
   contexts, forcing drivers to use schedule_work and requiring
   lots of code

 * rfkill drivers need to keep track of soft/hard blocked
   internally -- the core should do this

 * the rfkill API has many unexpected quirks, for example being
   asymmetric wrt. alloc/free and register/unregister

 * rfkill-input pointlessly is a separate module

 * drivers need to #ifdef rfkill functions (unless they want to
   depend on or select RFKILL) -- rfkill should provide inlines
   that do nothing if it isn't compiled in

 * the rfkill structure is not opaque -- drivers need to initialise
   it correctly (lots of sanity checking code required) -- instead
   force drivers to pass the right variables to rfkill_alloc()

 * the documentation is hard to read because it always assumes the
   reader is completely clueless and contains way TOO MANY CAPS

 * the rfkill code needlessly uses a lot of locks and atomic
   operations in locked sections

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v3: * fix locking bugs
    * fix bug in input.c that made it ignore things
    * allow setting LED trigger name
    * apply default state while registering
    * convert HSO

TODO
 * convert toshiba, thinkpad
 * (compile) test tosa conversion
 * test

 Documentation/rfkill.txt                  |  639 +++-------------------
 MAINTAINERS                               |    6 
 arch/arm/mach-pxa/tosa-bt.c               |   30 -
 arch/arm/mach-pxa/tosa.c                  |    1 
 drivers/net/usb/hso.c                     |   42 -
 drivers/net/wireless/ath9k/ath9k.h        |    7 
 drivers/net/wireless/ath9k/main.c         |  115 +---
 drivers/net/wireless/ath9k/pci.c          |   15 
 drivers/net/wireless/b43/Kconfig          |    2 
 drivers/net/wireless/b43/leds.c           |    2 
 drivers/net/wireless/b43/main.c           |    4 
 drivers/net/wireless/b43/phy_a.c          |    4 
 drivers/net/wireless/b43/phy_common.c     |   17 
 drivers/net/wireless/b43/phy_common.h     |    4 
 drivers/net/wireless/b43/phy_g.c          |    4 
 drivers/net/wireless/b43/phy_lp.c         |    2 
 drivers/net/wireless/b43/phy_n.c          |    2 
 drivers/net/wireless/b43/rfkill.c         |  122 +---
 drivers/net/wireless/b43/rfkill.h         |    5 
 drivers/net/wireless/b43legacy/Kconfig    |    2 
 drivers/net/wireless/b43legacy/leds.c     |    3 
 drivers/net/wireless/b43legacy/rfkill.c   |  118 +---
 drivers/net/wireless/b43legacy/rfkill.h   |    6 
 drivers/net/wireless/iwlwifi/Kconfig      |    5 
 drivers/net/wireless/iwlwifi/iwl-rfkill.c |   69 --
 drivers/platform/x86/Kconfig              |    6 
 drivers/platform/x86/acer-wmi.c           |   50 -
 drivers/platform/x86/dell-laptop.c        |  101 +--
 drivers/platform/x86/eeepc-laptop.c       |   91 ---
 drivers/platform/x86/hp-wmi.c             |  103 +--
 drivers/platform/x86/toshiba_acpi.c       |   23 
 include/linux/Kbuild                      |    1 
 include/linux/rfkill.h                    |  330 +++++++++--
 include/net/wimax.h                       |    8 
 net/rfkill/Kconfig                        |   14 
 net/rfkill/Makefile                       |    4 
 net/rfkill/core.c                         |  780 +++++++++++++++++++++++++++
 net/rfkill/input.c                        |  342 ++++++++++++
 net/rfkill/rfkill-input.c                 |  392 -------------
 net/rfkill/rfkill-input.h                 |   21 
 net/rfkill/rfkill.c                       |  843 ------------------------------
 net/rfkill/rfkill.h                       |   27 
 net/wimax/Kconfig                         |   14 
 net/wimax/op-rfkill.c                     |  125 ----
 44 files changed, 1865 insertions(+), 2636 deletions(-)

--- wireless-testing.orig/include/linux/rfkill.h	2009-03-31 11:48:54.000000000 +0200
+++ wireless-testing/include/linux/rfkill.h	2009-03-31 20:35:04.000000000 +0200
@@ -4,6 +4,7 @@
 /*
  * Copyright (C) 2006 - 2007 Ivo van Doorn
  * Copyright (C) 2007 Dmitry Torokhov
+ * Copyright 2009 Johannes Berg <johannes@sipsolutions.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -21,6 +22,24 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+
+/* define userspace visible states */
+#define RFKILL_STATE_SOFT_BLOCKED	0
+#define RFKILL_STATE_UNBLOCKED		1
+#define RFKILL_STATE_HARD_BLOCKED	2
+
+/* and that's all userspace gets */
+#ifdef __KERNEL__
+/* don't allow anyone to use these in the kernel */
+enum rfkill_user_states {
+	RFKILL_USER_STATE_SOFT_BLOCKED	= RFKILL_STATE_SOFT_BLOCKED,
+	RFKILL_USER_STATE_UNBLOCKED	= RFKILL_STATE_UNBLOCKED,
+	RFKILL_USER_STATE_HARD_BLOCKED	= RFKILL_STATE_HARD_BLOCKED,
+};
+#undef RFKILL_STATE_SOFT_BLOCKED
+#undef RFKILL_STATE_UNBLOCKED
+#undef RFKILL_STATE_HARD_BLOCKED
+
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -30,11 +49,13 @@
 
 /**
  * enum rfkill_type - type of rfkill switch.
- * RFKILL_TYPE_WLAN: switch is on a 802.11 wireless network device.
- * RFKILL_TYPE_BLUETOOTH: switch is on a bluetooth device.
- * RFKILL_TYPE_UWB: switch is on a ultra wideband device.
- * RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
- * RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
+ *
+ * @RFKILL_TYPE_WLAN: switch is on a 802.11 wireless network device.
+ * @RFKILL_TYPE_BLUETOOTH: switch is on a bluetooth device.
+ * @RFKILL_TYPE_UWB: switch is on a ultra wideband device.
+ * @RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
+ * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
+ * @NUM_RFKILL_TYPES: number of defined rfkill types
  */
 enum rfkill_type {
 	RFKILL_TYPE_WLAN ,
@@ -42,97 +63,260 @@ enum rfkill_type {
 	RFKILL_TYPE_UWB,
 	RFKILL_TYPE_WIMAX,
 	RFKILL_TYPE_WWAN,
-	RFKILL_TYPE_MAX,
+	NUM_RFKILL_TYPES,
 };
 
-enum rfkill_state {
-	RFKILL_STATE_SOFT_BLOCKED = 0,	/* Radio output blocked */
-	RFKILL_STATE_UNBLOCKED    = 1,	/* Radio output allowed */
-	RFKILL_STATE_HARD_BLOCKED = 2,	/* Output blocked, non-overrideable */
-	RFKILL_STATE_MAX,		/* marker for last valid state */
+#define RFKILL_BLOCK_HW_BIT		0
+#define RFKILL_BLOCK_SW_BIT		1
+
+/**
+ * struct rfkill_ops - rfkill driver methods
+ *
+ * @poll_hw_block: poll the rfkill hardware block state (return true
+ *	for blocked) -- only assign this method when you cannot
+ *	do without polling
+ * @query_hw_block: query the rfkill hardware block state (return true
+ *	for blocked) -- assign this method if input events can cause
+ *	hardware state changes
+ * @set_block: turn the transmitter on (blocked == false) or off
+ *	(blocked == true) -- this is called only while the transmitter
+ *	is not hard-blocked. This must be assigned.
+ */
+struct rfkill_ops {
+	bool	(*poll_hw_block)(void *data);
+	bool	(*query_hw_block)(void *data);
+	int	(*set_block)(void *data, bool blocked);
 };
 
+/* this is opaque */
+struct rfkill;
+
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 /**
- * struct rfkill - rfkill control structure.
- * @name: Name of the switch.
- * @type: Radio type which the button controls, the value stored
- *	here should be a value from enum rfkill_type.
- * @state: State of the switch, "UNBLOCKED" means radio can operate.
- * @mutex: Guards switch state transitions.  It serializes callbacks
- *	and also protects the state.
- * @data: Pointer to the RF button drivers private data which will be
- *	passed along when toggling radio state.
- * @toggle_radio(): Mandatory handler to control state of the radio.
- *	only RFKILL_STATE_SOFT_BLOCKED and RFKILL_STATE_UNBLOCKED are
- *	valid parameters.
- * @get_state(): handler to read current radio state from hardware,
- *      may be called from atomic context, should return 0 on success.
- *      Either this handler OR judicious use of rfkill_force_state() is
- *      MANDATORY for any driver capable of RFKILL_STATE_HARD_BLOCKED.
- * @led_trigger: A LED trigger for this button's LED.
- * @dev: Device structure integrating the switch into device tree.
- * @node: Used to place switch into list of all switches known to the
- *	the system.
- *
- * This structure represents a RF switch located on a network device.
- */
-struct rfkill {
-	const char *name;
-	enum rfkill_type type;
-
-	/* the mutex serializes callbacks and also protects
-	 * the state */
-	struct mutex mutex;
-	enum rfkill_state state;
-	void *data;
-	int (*toggle_radio)(void *data, enum rfkill_state state);
-	int (*get_state)(void *data, enum rfkill_state *state);
+ * rfkill_alloc - allocate rfkill structure
+ * @name: name of the struct -- the string is not copied internally
+ * @parent: device that has rf switch on it
+ * @type: type of the switch (RFKILL_TYPE_*)
+ * @ops: rfkill methods
+ * @ops_data: data passed to each method
+ *
+ * This function should be called by the transmitter driver to allocate an
+ * rfkill structure.
+ */
+struct rfkill * __must_check rfkill_alloc(const char *name,
+					  struct device *parent,
+					  const enum rfkill_type type,
+					  const struct rfkill_ops *ops,
+					  void *ops_data);
 
-#ifdef CONFIG_RFKILL_LEDS
-	struct led_trigger led_trigger;
-#endif
+/**
+ * rfkill_has_sw_block_memory -- turn on calling set_block unconditionally
+ * @rfkill: rfkill struct
+ *
+ * This function tells the rfkill core that the device is capable of
+ * remembering soft blocks (which it is notified of via the set_block
+ * method) -- this means that the driver may ignore the return value
+ * from rfkill_set_hw_state().
+ *
+ * This function must be called before rfkill_register().
+ */
+void rfkill_has_sw_block_memory(struct rfkill *rfkill);
 
-	struct device dev;
-	struct list_head node;
-	enum rfkill_state state_for_resume;
-};
-#define to_rfkill(d)	container_of(d, struct rfkill, dev)
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
 
-struct rfkill * __must_check rfkill_allocate(struct device *parent,
-					     enum rfkill_type type);
-void rfkill_free(struct rfkill *rfkill);
+/**
+ * rfkill_register - Register a rfkill structure.
+ * @rfkill: rfkill structure to be registered
+ *
+ * This function should be called by the transmitter driver to register
+ * the rfkill structure needs to be registered. Before calling this function
+ * the driver needs to be ready to service method calls from rfkill.
+ */
 int __must_check rfkill_register(struct rfkill *rfkill);
+
+/**
+ * rfkill_pause_polling(struct rfkill *rfkill)
+ *
+ * Pause polling -- say transmitter is off for other reasons.
+ * NOTE: not necessary for suspend/resume -- in that case the
+ * core stops polling anyway
+ */
+void rfkill_pause_polling(struct rfkill *rfkill);
+
+/**
+ * rfkill_resume_polling(struct rfkill *rfkill)
+ *
+ * Pause polling -- say transmitter is off for other reasons.
+ * NOTE: not necessary for suspend/resume -- in that case the
+ * core stops polling anyway
+ */
+void rfkill_resume_polling(struct rfkill *rfkill);
+
+
+/**
+ * rfkill_unregister - Unregister a rfkill structure.
+ * @rfkill: rfkill structure to be unregistered
+ *
+ * This function should be called by the network driver during device
+ * teardown to destroy rfkill structure. Until it returns, the driver
+ * needs to be able to service method calls.
+ */
 void rfkill_unregister(struct rfkill *rfkill);
 
-int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state);
-int rfkill_set_default(enum rfkill_type type, enum rfkill_state state);
+/**
+ * rfkill_destroy - free rfkill structure
+ * @rfkill: rfkill structure to be destroyed
+ *
+ * Destroys the rfkill structure.
+ */
+void rfkill_destroy(struct rfkill *rfkill);
 
 /**
- * rfkill_state_complement - return complementar state
- * @state: state to return the complement of
+ * rfkill_set_hw_state - Set the internal rfkill hardware block state
+ * @rfkill: pointer to the rfkill class to modify.
+ * @state: the current hardware block state to set
+ *
+ * rfkill drivers that get events when the hard-blocked state changes
+ * use this function to notify the rfkill core (and through that also
+ * userspace) of the current state -- they should also use this after
+ * resume if the state could have changed.
+ *
+ * You need not (but may) call this function if poll_state is assigned.
+ *
+ * This function can be called in any context.
  *
- * Returns RFKILL_STATE_SOFT_BLOCKED if @state is RFKILL_STATE_UNBLOCKED,
- * returns RFKILL_STATE_UNBLOCKED otherwise.
+ * The function returns the combined block state (true if transmitter
+ * should be blocked) so that drivers need not keep track of the soft
+ * block state -- which they might not be able to.
+ *
+ * If the device is able to, call rfkill_has_sw_block_memory() and
+ * ignore the return value of this function.
  */
-static inline enum rfkill_state rfkill_state_complement(enum rfkill_state state)
+bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
+
+/**
+ * rfkill_set_sw_state - Set the internal rfkill software block state
+ * @rfkill: pointer to the rfkill class to modify.
+ * @state: the current software block state to set
+ *
+ * rfkill drivers that get events when the soft-blocked state changes
+ * (yes, some platforms directly act on input but allow changing again)
+ * use this function to notify the rfkill core (and through that also
+ * userspace) of the current state -- they should also use this after
+ * resume if the state could have changed.
+ *
+ * This function can be called in any context.
+ *
+ * The function returns the combined block state (true if transmitter
+ * should be blocked).
+ */
+bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked);
+
+/**
+ * rfkill_set_global_sw_state - set global sw block default
+ * @type: rfkill type to set default for
+ * @blocked: default to set
+ *
+ * This function sets the global default -- use at boot if your platform has
+ * an rfkill switch. If not early enough this call may be ignored.
+ *
+ * XXX: instead of ignoring -- how about just updating all currently
+ *	registered drivers?
+ */
+void rfkill_set_global_sw_state(const enum rfkill_type type, bool blocked);
+#else /* !RFKILL */
+static inline struct rfkill * __must_check
+rfkill_alloc(const char *name,
+	     struct device *parent,
+	     const enum rfkill_type type,
+	     const struct rfkill_ops *ops,
+	     void *ops_data)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline void rfkill_has_sw_block_memory(struct rfkill *rfkill)
+{
+}
+
+static inline int __must_check rfkill_register(struct rfkill *rfkill)
+{
+	if (rfkill == ERR_PTR(-ENODEV))
+		return 0;
+	return -EINVAL;
+}
+
+static inline void rfkill_pause_polling(struct rfkill *rfkill)
+{
+}
+
+static inline void rfkill_resume_polling(struct rfkill *rfkill)
+{
+}
+
+static inline void rfkill_unregister(struct rfkill *rfkill)
+{
+}
+
+static inline void rfkill_destroy(struct rfkill *rfkill)
 {
-	return (state == RFKILL_STATE_UNBLOCKED) ?
-		RFKILL_STATE_SOFT_BLOCKED : RFKILL_STATE_UNBLOCKED;
 }
 
+static inline bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
+{
+	return blocked;
+}
+
+static inline bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
+{
+	return blocked;
+}
+
+static inline void rfkill_set_global_sw_state(const enum rfkill_type type,
+					      bool blocked)
+{
+}
+#endif /* RFKILL || RFKILL_MODULE */
+
+
+#ifdef CONFIG_RFKILL_LEDS
 /**
- * rfkill_get_led_name - Get the LED trigger name for the button's LED.
+ * rfkill_get_led_trigger_name - Get the LED trigger name for the button's LED.
  * This function might return a NULL pointer if registering of the
- * LED trigger failed.
- * Use this as "default_trigger" for the LED.
+ * LED trigger failed. Use this as "default_trigger" for the LED.
  */
-static inline char *rfkill_get_led_name(struct rfkill *rfkill)
-{
-#ifdef CONFIG_RFKILL_LEDS
-	return (char *)(rfkill->led_trigger.name);
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
 #else
+static inline const char *rfkill_get_led_trigger_name(struct rfkill *rfkill)
+{
 	return NULL;
-#endif
 }
 
+void rfkill_set_led_trigger_name(struct rfkill *rfkill, const char *name)
+{
+}
+#endif
+
+#endif /* __KERNEL__ */
+
 #endif /* RFKILL_H */
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-31 11:48:54.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-31 11:48:55.000000000 +0200
@@ -1181,120 +1181,69 @@ static bool ath_is_rfkill_set(struct ath
 				  ah->rfkill_polarity;
 }
 
-/* h/w rfkill poll function */
-static void ath_rfkill_poll(struct work_struct *work)
+/* s/w rfkill handlers */
+static int ath_rfkill_set_block(void *data, bool blocked)
 {
-	struct ath_softc *sc = container_of(work, struct ath_softc,
-					    rf_kill.rfkill_poll.work);
-	bool radio_on;
-
-	if (sc->sc_flags & SC_OP_INVALID)
-		return;
-
-	radio_on = !ath_is_rfkill_set(sc);
-
-	/*
-	 * enable/disable radio only when there is a
-	 * state change in RF switch
-	 */
-	if (radio_on == !!(sc->sc_flags & SC_OP_RFKILL_HW_BLOCKED)) {
-		enum rfkill_state state;
-
-		if (sc->sc_flags & SC_OP_RFKILL_SW_BLOCKED) {
-			state = radio_on ? RFKILL_STATE_SOFT_BLOCKED
-				: RFKILL_STATE_HARD_BLOCKED;
-		} else if (radio_on) {
-			ath_radio_enable(sc);
-			state = RFKILL_STATE_UNBLOCKED;
-		} else {
-			ath_radio_disable(sc);
-			state = RFKILL_STATE_HARD_BLOCKED;
-		}
-
-		if (state == RFKILL_STATE_HARD_BLOCKED)
-			sc->sc_flags |= SC_OP_RFKILL_HW_BLOCKED;
-		else
-			sc->sc_flags &= ~SC_OP_RFKILL_HW_BLOCKED;
+	struct ath_softc *sc = data;
 
-		rfkill_force_state(sc->rf_kill.rfkill, state);
-	}
+	if (blocked)
+		ath_radio_disable(sc);
+	else
+		ath_radio_enable(sc);
 
-	queue_delayed_work(sc->hw->workqueue, &sc->rf_kill.rfkill_poll,
-			   msecs_to_jiffies(ATH_RFKILL_POLL_INTERVAL));
+	return 0;
 }
 
-/* s/w rfkill handler */
-static int ath_sw_toggle_radio(void *data, enum rfkill_state state)
+static bool ath_rfkill_poll_state(void *data)
 {
 	struct ath_softc *sc = data;
+	bool ret = !!ath_is_rfkill_set(sc);
 
-	switch (state) {
-	case RFKILL_STATE_SOFT_BLOCKED:
-		if (!(sc->sc_flags & (SC_OP_RFKILL_HW_BLOCKED |
-		    SC_OP_RFKILL_SW_BLOCKED)))
-			ath_radio_disable(sc);
-		sc->sc_flags |= SC_OP_RFKILL_SW_BLOCKED;
-		return 0;
-	case RFKILL_STATE_UNBLOCKED:
-		if ((sc->sc_flags & SC_OP_RFKILL_SW_BLOCKED)) {
-			sc->sc_flags &= ~SC_OP_RFKILL_SW_BLOCKED;
-			if (sc->sc_flags & SC_OP_RFKILL_HW_BLOCKED) {
-				DPRINTF(sc, ATH_DBG_FATAL, "Can't turn on the"
-					"radio as it is disabled by h/w\n");
-				return -EPERM;
-			}
-			ath_radio_enable(sc);
-		}
-		return 0;
-	default:
-		return -EINVAL;
-	}
+	if (ret)
+		ath_radio_disable(sc);
+
+	return ret;
 }
 
 /* Init s/w rfkill */
 static int ath_init_sw_rfkill(struct ath_softc *sc)
 {
-	sc->rf_kill.rfkill = rfkill_allocate(wiphy_dev(sc->hw->wiphy),
-					     RFKILL_TYPE_WLAN);
+	sc->rf_kill.ops.set_block = ath_rfkill_set_block;
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		sc->rf_kill.ops.poll_hw_block = ath_rfkill_poll_state;
+
+	snprintf(sc->rf_kill.rfkill_name, sizeof(sc->rf_kill.rfkill_name),
+		"ath9k-%s::rfkill", wiphy_name(sc->hw->wiphy));
+
+	sc->rf_kill.rfkill = rfkill_alloc(sc->rf_kill.rfkill_name,
+					  wiphy_dev(sc->hw->wiphy),
+					  RFKILL_TYPE_WLAN,
+					  &sc->rf_kill.ops, sc);
 	if (!sc->rf_kill.rfkill) {
 		DPRINTF(sc, ATH_DBG_FATAL, "Failed to allocate rfkill\n");
 		return -ENOMEM;
 	}
 
-	snprintf(sc->rf_kill.rfkill_name, sizeof(sc->rf_kill.rfkill_name),
-		"ath9k-%s::rfkill", wiphy_name(sc->hw->wiphy));
-	sc->rf_kill.rfkill->name = sc->rf_kill.rfkill_name;
-	sc->rf_kill.rfkill->data = sc;
-	sc->rf_kill.rfkill->toggle_radio = ath_sw_toggle_radio;
-	sc->rf_kill.rfkill->state = RFKILL_STATE_UNBLOCKED;
-
 	return 0;
 }
 
 /* Deinitialize rfkill */
 static void ath_deinit_rfkill(struct ath_softc *sc)
 {
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
-
 	if (sc->sc_flags & SC_OP_RFKILL_REGISTERED) {
 		rfkill_unregister(sc->rf_kill.rfkill);
+		rfkill_destroy(sc->rf_kill.rfkill);
 		sc->sc_flags &= ~SC_OP_RFKILL_REGISTERED;
-		sc->rf_kill.rfkill = NULL;
 	}
 }
 
 static int ath_start_rfkill_poll(struct ath_softc *sc)
 {
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		queue_delayed_work(sc->hw->workqueue,
-				   &sc->rf_kill.rfkill_poll, 0);
-
 	if (!(sc->sc_flags & SC_OP_RFKILL_REGISTERED)) {
 		if (rfkill_register(sc->rf_kill.rfkill)) {
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"Unable to register rfkill\n");
-			rfkill_free(sc->rf_kill.rfkill);
+			rfkill_destroy(sc->rf_kill.rfkill);
 
 			/* Deinitialize the device */
 			ath_cleanup(sc);
@@ -1655,10 +1604,6 @@ int ath_attach(u16 devid, struct ath_sof
 		goto error_attach;
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	/* Initialze h/w Rfkill */
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		INIT_DELAYED_WORK(&sc->rf_kill.rfkill_poll, ath_rfkill_poll);
-
 	/* Initialize s/w rfkill */
 	error = ath_init_sw_rfkill(sc);
 	if (error)
@@ -2170,10 +2115,8 @@ static void ath9k_stop(struct ieee80211_
 	} else
 		sc->rx.rxlink = NULL;
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
-#endif
+	rfkill_pause_polling(sc->rf_kill.rfkill);
+
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(sc->sc_ah);
 	ath9k_hw_configpcipowersave(sc->sc_ah, 1);
--- wireless-testing.orig/drivers/platform/x86/eeepc-laptop.c	2009-03-31 11:13:09.000000000 +0200
+++ wireless-testing/drivers/platform/x86/eeepc-laptop.c	2009-03-31 11:48:55.000000000 +0200
@@ -296,39 +296,15 @@ static int update_bl_status(struct backl
  * Rfkill helpers
  */
 
-static int eeepc_wlan_rfkill_set(void *data, enum rfkill_state state)
+static int eeepc_rfkill_set(void *data, bool blocked)
 {
-	if (state == RFKILL_STATE_SOFT_BLOCKED)
-		return set_acpi(CM_ASL_WLAN, 0);
-	else
-		return set_acpi(CM_ASL_WLAN, 1);
-}
-
-static int eeepc_wlan_rfkill_state(void *data, enum rfkill_state *state)
-{
-	if (get_acpi(CM_ASL_WLAN) == 1)
-		*state = RFKILL_STATE_UNBLOCKED;
-	else
-		*state = RFKILL_STATE_SOFT_BLOCKED;
-	return 0;
+	unsigned long asl = (unsigned long)data;
+	return set_acpi(asl, !blocked);
 }
 
-static int eeepc_bluetooth_rfkill_set(void *data, enum rfkill_state state)
-{
-	if (state == RFKILL_STATE_SOFT_BLOCKED)
-		return set_acpi(CM_ASL_BLUETOOTH, 0);
-	else
-		return set_acpi(CM_ASL_BLUETOOTH, 1);
-}
-
-static int eeepc_bluetooth_rfkill_state(void *data, enum rfkill_state *state)
-{
-	if (get_acpi(CM_ASL_BLUETOOTH) == 1)
-		*state = RFKILL_STATE_UNBLOCKED;
-	else
-		*state = RFKILL_STATE_SOFT_BLOCKED;
-	return 0;
-}
+static const struct rfkill_ops eeepc_rfkill_ops = {
+	.set_block = eeepc_rfkill_set,
+};
 
 /*
  * Sys helpers
@@ -650,26 +626,17 @@ static int eeepc_hotk_add(struct acpi_de
 		printk(EEEPC_ERR "Error installing notify handler\n");
 
 	if (get_acpi(CM_ASL_WLAN) != -1) {
-		ehotk->eeepc_wlan_rfkill = rfkill_allocate(&device->dev,
-							   RFKILL_TYPE_WLAN);
+		ehotk->eeepc_wlan_rfkill = rfkill_alloc("eeepc-wlan",
+							&device->dev,
+							RFKILL_TYPE_WLAN,
+							&eeepc_rfkill_ops,
+							(void *)CM_ASL_WLAN);
 
 		if (!ehotk->eeepc_wlan_rfkill)
 			goto wlan_fail;
 
-		ehotk->eeepc_wlan_rfkill->name = "eeepc-wlan";
-		ehotk->eeepc_wlan_rfkill->toggle_radio = eeepc_wlan_rfkill_set;
-		ehotk->eeepc_wlan_rfkill->get_state = eeepc_wlan_rfkill_state;
-		if (get_acpi(CM_ASL_WLAN) == 1) {
-			ehotk->eeepc_wlan_rfkill->state =
-				RFKILL_STATE_UNBLOCKED;
-			rfkill_set_default(RFKILL_TYPE_WLAN,
-					   RFKILL_STATE_UNBLOCKED);
-		} else {
-			ehotk->eeepc_wlan_rfkill->state =
-				RFKILL_STATE_SOFT_BLOCKED;
-			rfkill_set_default(RFKILL_TYPE_WLAN,
-					   RFKILL_STATE_SOFT_BLOCKED);
-		}
+		rfkill_set_sw_state(ehotk->eeepc_wlan_rfkill,
+				    get_acpi(CM_ASL_WLAN) != 1);
 		result = rfkill_register(ehotk->eeepc_wlan_rfkill);
 		if (result)
 			goto wlan_fail;
@@ -677,28 +644,17 @@ static int eeepc_hotk_add(struct acpi_de
 
 	if (get_acpi(CM_ASL_BLUETOOTH) != -1) {
 		ehotk->eeepc_bluetooth_rfkill =
-			rfkill_allocate(&device->dev, RFKILL_TYPE_BLUETOOTH);
+			rfkill_alloc("eeepc-wlan",
+				     &device->dev,
+				     RFKILL_TYPE_WLAN,
+				     &eeepc_rfkill_ops,
+				     (void *)CM_ASL_BLUETOOTH);
 
 		if (!ehotk->eeepc_bluetooth_rfkill)
 			goto bluetooth_fail;
 
-		ehotk->eeepc_bluetooth_rfkill->name = "eeepc-bluetooth";
-		ehotk->eeepc_bluetooth_rfkill->toggle_radio =
-			eeepc_bluetooth_rfkill_set;
-		ehotk->eeepc_bluetooth_rfkill->get_state =
-			eeepc_bluetooth_rfkill_state;
-		if (get_acpi(CM_ASL_BLUETOOTH) == 1) {
-			ehotk->eeepc_bluetooth_rfkill->state =
-				RFKILL_STATE_UNBLOCKED;
-			rfkill_set_default(RFKILL_TYPE_BLUETOOTH,
-					   RFKILL_STATE_UNBLOCKED);
-		} else {
-			ehotk->eeepc_bluetooth_rfkill->state =
-				RFKILL_STATE_SOFT_BLOCKED;
-			rfkill_set_default(RFKILL_TYPE_BLUETOOTH,
-					   RFKILL_STATE_SOFT_BLOCKED);
-		}
-
+		rfkill_set_sw_state(ehotk->eeepc_bluetooth_rfkill,
+				    get_acpi(CM_ASL_BLUETOOTH) != 1);
 		result = rfkill_register(ehotk->eeepc_bluetooth_rfkill);
 		if (result)
 			goto bluetooth_fail;
@@ -710,13 +666,10 @@ static int eeepc_hotk_add(struct acpi_de
 	return 0;
 
  bluetooth_fail:
-	if (ehotk->eeepc_bluetooth_rfkill)
-		rfkill_free(ehotk->eeepc_bluetooth_rfkill);
+	rfkill_destroy(ehotk->eeepc_bluetooth_rfkill);
 	rfkill_unregister(ehotk->eeepc_wlan_rfkill);
-	ehotk->eeepc_wlan_rfkill = NULL;
  wlan_fail:
-	if (ehotk->eeepc_wlan_rfkill)
-		rfkill_free(ehotk->eeepc_wlan_rfkill);
+	rfkill_destroy(ehotk->eeepc_wlan_rfkill);
  ehotk_fail:
 	kfree(ehotk);
 	ehotk = NULL;
--- wireless-testing.orig/net/rfkill/rfkill.c	2009-03-31 11:48:54.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,843 +0,0 @@
-/*
- * Copyright (C) 2006 - 2007 Ivo van Doorn
- * Copyright (C) 2007 Dmitry Torokhov
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/workqueue.h>
-#include <linux/capability.h>
-#include <linux/list.h>
-#include <linux/mutex.h>
-#include <linux/rfkill.h>
-
-/* Get declaration of rfkill_switch_all() to shut up sparse. */
-#include "rfkill-input.h"
-
-
-MODULE_AUTHOR("Ivo van Doorn <IvDoorn@gmail.com>");
-MODULE_VERSION("1.0");
-MODULE_DESCRIPTION("RF switch support");
-MODULE_LICENSE("GPL");
-
-static LIST_HEAD(rfkill_list);	/* list of registered rf switches */
-static DEFINE_MUTEX(rfkill_global_mutex);
-
-static unsigned int rfkill_default_state = RFKILL_STATE_UNBLOCKED;
-module_param_named(default_state, rfkill_default_state, uint, 0444);
-MODULE_PARM_DESC(default_state,
-		 "Default initial state for all radio types, 0 = radio off");
-
-struct rfkill_gsw_state {
-	enum rfkill_state current_state;
-	enum rfkill_state default_state;
-};
-
-static struct rfkill_gsw_state rfkill_global_states[RFKILL_TYPE_MAX];
-static unsigned long rfkill_states_lockdflt[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
-static bool rfkill_epo_lock_active;
-
-
-#ifdef CONFIG_RFKILL_LEDS
-static void rfkill_led_trigger(struct rfkill *rfkill,
-			       enum rfkill_state state)
-{
-	struct led_trigger *led = &rfkill->led_trigger;
-
-	if (!led->name)
-		return;
-	if (state != RFKILL_STATE_UNBLOCKED)
-		led_trigger_event(led, LED_OFF);
-	else
-		led_trigger_event(led, LED_FULL);
-}
-
-static void rfkill_led_trigger_activate(struct led_classdev *led)
-{
-	struct rfkill *rfkill = container_of(led->trigger,
-			struct rfkill, led_trigger);
-
-	rfkill_led_trigger(rfkill, rfkill->state);
-}
-#endif /* CONFIG_RFKILL_LEDS */
-
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
-/**
- * rfkill_toggle_radio - wrapper for toggle_radio hook
- * @rfkill: the rfkill struct to use
- * @force: calls toggle_radio even if cache says it is not needed,
- *	and also makes sure notifications of the state will be
- *	sent even if it didn't change
- * @state: the new state to call toggle_radio() with
- *
- * Calls rfkill->toggle_radio, enforcing the API for toggle_radio
- * calls and handling all the red tape such as issuing notifications
- * if the call is successful.
- *
- * Suspended devices are not touched at all, and -EAGAIN is returned.
- *
- * Note that the @force parameter cannot override a (possibly cached)
- * state of RFKILL_STATE_HARD_BLOCKED.  Any device making use of
- * RFKILL_STATE_HARD_BLOCKED implements either get_state() or
- * rfkill_force_state(), so the cache either is bypassed or valid.
- *
- * Note that we do call toggle_radio for RFKILL_STATE_SOFT_BLOCKED
- * even if the radio is in RFKILL_STATE_HARD_BLOCKED state, so as to
- * give the driver a hint that it should double-BLOCK the transmitter.
- *
- * Caller must have acquired rfkill->mutex.
- */
-static int rfkill_toggle_radio(struct rfkill *rfkill,
-				enum rfkill_state state,
-				int force)
-{
-	int retval = 0;
-	enum rfkill_state oldstate, newstate;
-
-	if (unlikely(rfkill->dev.power.power_state.event & PM_EVENT_SLEEP))
-		return -EBUSY;
-
-	oldstate = rfkill->state;
-
-	if (rfkill->get_state && !force &&
-	    !rfkill->get_state(rfkill->data, &newstate))
-		rfkill->state = newstate;
-
-	switch (state) {
-	case RFKILL_STATE_HARD_BLOCKED:
-		/* typically happens when refreshing hardware state,
-		 * such as on resume */
-		state = RFKILL_STATE_SOFT_BLOCKED;
-		break;
-	case RFKILL_STATE_UNBLOCKED:
-		/* force can't override this, only rfkill_force_state() can */
-		if (rfkill->state == RFKILL_STATE_HARD_BLOCKED)
-			return -EPERM;
-		break;
-	case RFKILL_STATE_SOFT_BLOCKED:
-		/* nothing to do, we want to give drivers the hint to double
-		 * BLOCK even a transmitter that is already in state
-		 * RFKILL_STATE_HARD_BLOCKED */
-		break;
-	default:
-		WARN(1, KERN_WARNING
-			"rfkill: illegal state %d passed as parameter "
-			"to rfkill_toggle_radio\n", state);
-		return -EINVAL;
-	}
-
-	if (force || state != rfkill->state) {
-		retval = rfkill->toggle_radio(rfkill->data, state);
-		/* never allow a HARD->SOFT downgrade! */
-		if (!retval && rfkill->state != RFKILL_STATE_HARD_BLOCKED)
-			rfkill->state = state;
-	}
-
-	if (force || rfkill->state != oldstate)
-		rfkill_uevent(rfkill);
-
-	return retval;
-}
-
-/**
- * __rfkill_switch_all - Toggle state of all switches of given type
- * @type: type of interfaces to be affected
- * @state: the new state
- *
- * This function toggles the state of all switches of given type,
- * unless a specific switch is claimed by userspace (in which case,
- * that switch is left alone) or suspended.
- *
- * Caller must have acquired rfkill_global_mutex.
- */
-static void __rfkill_switch_all(const enum rfkill_type type,
-				const enum rfkill_state state)
-{
-	struct rfkill *rfkill;
-
-	if (WARN((state >= RFKILL_STATE_MAX || type >= RFKILL_TYPE_MAX),
-			KERN_WARNING
-			"rfkill: illegal state %d or type %d "
-			"passed as parameter to __rfkill_switch_all\n",
-			state, type))
-		return;
-
-	rfkill_global_states[type].current_state = state;
-	list_for_each_entry(rfkill, &rfkill_list, node) {
-		if (rfkill->type == type) {
-			mutex_lock(&rfkill->mutex);
-			rfkill_toggle_radio(rfkill, state, 0);
-			mutex_unlock(&rfkill->mutex);
-		}
-	}
-}
-
-/**
- * rfkill_switch_all - Toggle state of all switches of given type
- * @type: type of interfaces to be affected
- * @state: the new state
- *
- * Acquires rfkill_global_mutex and calls __rfkill_switch_all(@type, @state).
- * Please refer to __rfkill_switch_all() for details.
- *
- * Does nothing if the EPO lock is active.
- */
-void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
-{
-	mutex_lock(&rfkill_global_mutex);
-	if (!rfkill_epo_lock_active)
-		__rfkill_switch_all(type, state);
-	mutex_unlock(&rfkill_global_mutex);
-}
-EXPORT_SYMBOL(rfkill_switch_all);
-
-/**
- * rfkill_epo - emergency power off all transmitters
- *
- * This kicks all non-suspended rfkill devices to RFKILL_STATE_SOFT_BLOCKED,
- * ignoring everything in its path but rfkill_global_mutex and rfkill->mutex.
- *
- * The global state before the EPO is saved and can be restored later
- * using rfkill_restore_states().
- */
-void rfkill_epo(void)
-{
-	struct rfkill *rfkill;
-	int i;
-
-	mutex_lock(&rfkill_global_mutex);
-
-	rfkill_epo_lock_active = true;
-	list_for_each_entry(rfkill, &rfkill_list, node) {
-		mutex_lock(&rfkill->mutex);
-		rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
-		mutex_unlock(&rfkill->mutex);
-	}
-	for (i = 0; i < RFKILL_TYPE_MAX; i++) {
-		rfkill_global_states[i].default_state =
-				rfkill_global_states[i].current_state;
-		rfkill_global_states[i].current_state =
-				RFKILL_STATE_SOFT_BLOCKED;
-	}
-	mutex_unlock(&rfkill_global_mutex);
-}
-EXPORT_SYMBOL_GPL(rfkill_epo);
-
-/**
- * rfkill_restore_states - restore global states
- *
- * Restore (and sync switches to) the global state from the
- * states in rfkill_default_states.  This can undo the effects of
- * a call to rfkill_epo().
- */
-void rfkill_restore_states(void)
-{
-	int i;
-
-	mutex_lock(&rfkill_global_mutex);
-
-	rfkill_epo_lock_active = false;
-	for (i = 0; i < RFKILL_TYPE_MAX; i++)
-		__rfkill_switch_all(i, rfkill_global_states[i].default_state);
-	mutex_unlock(&rfkill_global_mutex);
-}
-EXPORT_SYMBOL_GPL(rfkill_restore_states);
-
-/**
- * rfkill_remove_epo_lock - unlock state changes
- *
- * Used by rfkill-input manually unlock state changes, when
- * the EPO switch is deactivated.
- */
-void rfkill_remove_epo_lock(void)
-{
-	mutex_lock(&rfkill_global_mutex);
-	rfkill_epo_lock_active = false;
-	mutex_unlock(&rfkill_global_mutex);
-}
-EXPORT_SYMBOL_GPL(rfkill_remove_epo_lock);
-
-/**
- * rfkill_is_epo_lock_active - returns true EPO is active
- *
- * Returns 0 (false) if there is NOT an active EPO contidion,
- * and 1 (true) if there is an active EPO contition, which
- * locks all radios in one of the BLOCKED states.
- *
- * Can be called in atomic context.
- */
-bool rfkill_is_epo_lock_active(void)
-{
-	return rfkill_epo_lock_active;
-}
-EXPORT_SYMBOL_GPL(rfkill_is_epo_lock_active);
-
-/**
- * rfkill_get_global_state - returns global state for a type
- * @type: the type to get the global state of
- *
- * Returns the current global state for a given wireless
- * device type.
- */
-enum rfkill_state rfkill_get_global_state(const enum rfkill_type type)
-{
-	return rfkill_global_states[type].current_state;
-}
-EXPORT_SYMBOL_GPL(rfkill_get_global_state);
-
-/**
- * rfkill_force_state - Force the internal rfkill radio state
- * @rfkill: pointer to the rfkill class to modify.
- * @state: the current radio state the class should be forced to.
- *
- * This function updates the internal state of the radio cached
- * by the rfkill class.  It should be used when the driver gets
- * a notification by the firmware/hardware of the current *real*
- * state of the radio rfkill switch.
- *
- * Devices which are subject to external changes on their rfkill
- * state (such as those caused by a hardware rfkill line) MUST
- * have their driver arrange to call rfkill_force_state() as soon
- * as possible after such a change.
- *
- * This function may not be called from an atomic context.
- */
-int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state)
-{
-	enum rfkill_state oldstate;
-
-	BUG_ON(!rfkill);
-	if (WARN((state >= RFKILL_STATE_MAX),
-			KERN_WARNING
-			"rfkill: illegal state %d passed as parameter "
-			"to rfkill_force_state\n", state))
-		return -EINVAL;
-
-	mutex_lock(&rfkill->mutex);
-
-	oldstate = rfkill->state;
-	rfkill->state = state;
-
-	if (state != oldstate)
-		rfkill_uevent(rfkill);
-
-	mutex_unlock(&rfkill->mutex);
-
-	return 0;
-}
-EXPORT_SYMBOL(rfkill_force_state);
-
-static ssize_t rfkill_name_show(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
-{
-	struct rfkill *rfkill = to_rfkill(dev);
-
-	return sprintf(buf, "%s\n", rfkill->name);
-}
-
-static const char *rfkill_get_type_str(enum rfkill_type type)
-{
-	switch (type) {
-	case RFKILL_TYPE_WLAN:
-		return "wlan";
-	case RFKILL_TYPE_BLUETOOTH:
-		return "bluetooth";
-	case RFKILL_TYPE_UWB:
-		return "ultrawideband";
-	case RFKILL_TYPE_WIMAX:
-		return "wimax";
-	case RFKILL_TYPE_WWAN:
-		return "wwan";
-	default:
-		BUG();
-	}
-}
-
-static ssize_t rfkill_type_show(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
-{
-	struct rfkill *rfkill = to_rfkill(dev);
-
-	return sprintf(buf, "%s\n", rfkill_get_type_str(rfkill->type));
-}
-
-static ssize_t rfkill_state_show(struct device *dev,
-				 struct device_attribute *attr,
-				 char *buf)
-{
-	struct rfkill *rfkill = to_rfkill(dev);
-
-	update_rfkill_state(rfkill);
-	return sprintf(buf, "%d\n", rfkill->state);
-}
-
-static ssize_t rfkill_state_store(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t count)
-{
-	struct rfkill *rfkill = to_rfkill(dev);
-	unsigned long state;
-	int error;
-
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
-	error = strict_strtoul(buf, 0, &state);
-	if (error)
-		return error;
-
-	/* RFKILL_STATE_HARD_BLOCKED is illegal here... */
-	if (state != RFKILL_STATE_UNBLOCKED &&
-	    state != RFKILL_STATE_SOFT_BLOCKED)
-		return -EINVAL;
-
-	error = mutex_lock_killable(&rfkill->mutex);
-	if (error)
-		return error;
-
-	if (!rfkill_epo_lock_active)
-		error = rfkill_toggle_radio(rfkill, state, 0);
-	else
-		error = -EPERM;
-
-	mutex_unlock(&rfkill->mutex);
-
-	return error ? error : count;
-}
-
-static ssize_t rfkill_claim_show(struct device *dev,
-				 struct device_attribute *attr,
-				 char *buf)
-{
-	return sprintf(buf, "%d\n", 0);
-}
-
-static ssize_t rfkill_claim_store(struct device *dev,
-				  struct device_attribute *attr,
-				  const char *buf, size_t count)
-{
-	return -EOPNOTSUPP;
-}
-
-static struct device_attribute rfkill_dev_attrs[] = {
-	__ATTR(name, S_IRUGO, rfkill_name_show, NULL),
-	__ATTR(type, S_IRUGO, rfkill_type_show, NULL),
-	__ATTR(state, S_IRUGO|S_IWUSR, rfkill_state_show, rfkill_state_store),
-	__ATTR(claim, S_IRUGO|S_IWUSR, rfkill_claim_show, rfkill_claim_store),
-	__ATTR_NULL
-};
-
-static void rfkill_release(struct device *dev)
-{
-	struct rfkill *rfkill = to_rfkill(dev);
-
-	kfree(rfkill);
-	module_put(THIS_MODULE);
-}
-
-#ifdef CONFIG_PM
-static int rfkill_suspend(struct device *dev, pm_message_t state)
-{
-	struct rfkill *rfkill = to_rfkill(dev);
-
-	/* mark class device as suspended */
-	if (dev->power.power_state.event != state.event)
-		dev->power.power_state = state;
-
-	/* store state for the resume handler */
-	rfkill->state_for_resume = rfkill->state;
-
-	return 0;
-}
-
-static int rfkill_resume(struct device *dev)
-{
-	struct rfkill *rfkill = to_rfkill(dev);
-	enum rfkill_state newstate;
-
-	if (dev->power.power_state.event != PM_EVENT_ON) {
-		mutex_lock(&rfkill->mutex);
-
-		dev->power.power_state.event = PM_EVENT_ON;
-
-		/*
-		 * rfkill->state could have been modified before we got
-		 * called, and won't be updated by rfkill_toggle_radio()
-		 * in force mode.  Sync it FIRST.
-		 */
-		if (rfkill->get_state &&
-		    !rfkill->get_state(rfkill->data, &newstate))
-			rfkill->state = newstate;
-
-		/*
-		 * If we are under EPO, kick transmitter offline,
-		 * otherwise restore to pre-suspend state.
-		 *
-		 * Issue a notification in any case
-		 */
-		rfkill_toggle_radio(rfkill,
-				rfkill_epo_lock_active ?
-					RFKILL_STATE_SOFT_BLOCKED :
-					rfkill->state_for_resume,
-				1);
-
-		mutex_unlock(&rfkill->mutex);
-	}
-
-	return 0;
-}
-#else
-#define rfkill_suspend NULL
-#define rfkill_resume NULL
-#endif
-
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
-static struct class rfkill_class = {
-	.name		= "rfkill",
-	.dev_release	= rfkill_release,
-	.dev_attrs	= rfkill_dev_attrs,
-	.suspend	= rfkill_suspend,
-	.resume		= rfkill_resume,
-	.dev_uevent	= rfkill_dev_uevent,
-};
-
-static int rfkill_check_duplicity(const struct rfkill *rfkill)
-{
-	struct rfkill *p;
-	unsigned long seen[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
-
-	memset(seen, 0, sizeof(seen));
-
-	list_for_each_entry(p, &rfkill_list, node) {
-		if (WARN((p == rfkill), KERN_WARNING
-				"rfkill: illegal attempt to register "
-				"an already registered rfkill struct\n"))
-			return -EEXIST;
-		set_bit(p->type, seen);
-	}
-
-	/* 0: first switch of its kind */
-	return (test_bit(rfkill->type, seen)) ? 1 : 0;
-}
-
-static int rfkill_add_switch(struct rfkill *rfkill)
-{
-	int error;
-
-	mutex_lock(&rfkill_global_mutex);
-
-	error = rfkill_check_duplicity(rfkill);
-	if (error < 0)
-		goto unlock_out;
-
-	if (!error) {
-		/* lock default after first use */
-		set_bit(rfkill->type, rfkill_states_lockdflt);
-		rfkill_global_states[rfkill->type].current_state =
-			rfkill_global_states[rfkill->type].default_state;
-	}
-
-	rfkill_toggle_radio(rfkill,
-			    rfkill_global_states[rfkill->type].current_state,
-			    0);
-
-	list_add_tail(&rfkill->node, &rfkill_list);
-
-	error = 0;
-unlock_out:
-	mutex_unlock(&rfkill_global_mutex);
-
-	return error;
-}
-
-static void rfkill_remove_switch(struct rfkill *rfkill)
-{
-	mutex_lock(&rfkill_global_mutex);
-	list_del_init(&rfkill->node);
-	mutex_unlock(&rfkill_global_mutex);
-
-	mutex_lock(&rfkill->mutex);
-	rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
-	mutex_unlock(&rfkill->mutex);
-}
-
-/**
- * rfkill_allocate - allocate memory for rfkill structure.
- * @parent: device that has rf switch on it
- * @type: type of the switch (RFKILL_TYPE_*)
- *
- * This function should be called by the network driver when it needs
- * rfkill structure.  Once the structure is allocated the driver should
- * finish its initialization by setting the name, private data, enable_radio
- * and disable_radio methods and then register it with rfkill_register().
- *
- * NOTE: If registration fails the structure shoudl be freed by calling
- * rfkill_free() otherwise rfkill_unregister() should be used.
- */
-struct rfkill * __must_check rfkill_allocate(struct device *parent,
-					     enum rfkill_type type)
-{
-	struct rfkill *rfkill;
-	struct device *dev;
-
-	if (WARN((type >= RFKILL_TYPE_MAX),
-			KERN_WARNING
-			"rfkill: illegal type %d passed as parameter "
-			"to rfkill_allocate\n", type))
-		return NULL;
-
-	rfkill = kzalloc(sizeof(struct rfkill), GFP_KERNEL);
-	if (!rfkill)
-		return NULL;
-
-	mutex_init(&rfkill->mutex);
-	INIT_LIST_HEAD(&rfkill->node);
-	rfkill->type = type;
-
-	dev = &rfkill->dev;
-	dev->class = &rfkill_class;
-	dev->parent = parent;
-	device_initialize(dev);
-
-	__module_get(THIS_MODULE);
-
-	return rfkill;
-}
-EXPORT_SYMBOL(rfkill_allocate);
-
-/**
- * rfkill_free - Mark rfkill structure for deletion
- * @rfkill: rfkill structure to be destroyed
- *
- * Decrements reference count of the rfkill structure so it is destroyed.
- * Note that rfkill_free() should _not_ be called after rfkill_unregister().
- */
-void rfkill_free(struct rfkill *rfkill)
-{
-	if (rfkill)
-		put_device(&rfkill->dev);
-}
-EXPORT_SYMBOL(rfkill_free);
-
-static void rfkill_led_trigger_register(struct rfkill *rfkill)
-{
-#ifdef CONFIG_RFKILL_LEDS
-	int error;
-
-	if (!rfkill->led_trigger.name)
-		rfkill->led_trigger.name = dev_name(&rfkill->dev);
-	if (!rfkill->led_trigger.activate)
-		rfkill->led_trigger.activate = rfkill_led_trigger_activate;
-	error = led_trigger_register(&rfkill->led_trigger);
-	if (error)
-		rfkill->led_trigger.name = NULL;
-#endif /* CONFIG_RFKILL_LEDS */
-}
-
-static void rfkill_led_trigger_unregister(struct rfkill *rfkill)
-{
-#ifdef CONFIG_RFKILL_LEDS
-	if (rfkill->led_trigger.name) {
-		led_trigger_unregister(&rfkill->led_trigger);
-		rfkill->led_trigger.name = NULL;
-	}
-#endif
-}
-
-/**
- * rfkill_register - Register a rfkill structure.
- * @rfkill: rfkill structure to be registered
- *
- * This function should be called by the network driver when the rfkill
- * structure needs to be registered. Immediately from registration the
- * switch driver should be able to service calls to toggle_radio.
- */
-int __must_check rfkill_register(struct rfkill *rfkill)
-{
-	static atomic_t rfkill_no = ATOMIC_INIT(0);
-	struct device *dev = &rfkill->dev;
-	int error;
-
-	if (WARN((!rfkill || !rfkill->toggle_radio ||
-			rfkill->type >= RFKILL_TYPE_MAX ||
-			rfkill->state >= RFKILL_STATE_MAX),
-			KERN_WARNING
-			"rfkill: attempt to register a "
-			"badly initialized rfkill struct\n"))
-		return -EINVAL;
-
-	dev_set_name(dev, "rfkill%ld", (long)atomic_inc_return(&rfkill_no) - 1);
-
-	rfkill_led_trigger_register(rfkill);
-
-	error = rfkill_add_switch(rfkill);
-	if (error) {
-		rfkill_led_trigger_unregister(rfkill);
-		return error;
-	}
-
-	error = device_add(dev);
-	if (error) {
-		rfkill_remove_switch(rfkill);
-		rfkill_led_trigger_unregister(rfkill);
-		return error;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(rfkill_register);
-
-/**
- * rfkill_unregister - Unregister a rfkill structure.
- * @rfkill: rfkill structure to be unregistered
- *
- * This function should be called by the network driver during device
- * teardown to destroy rfkill structure. Note that rfkill_free() should
- * _not_ be called after rfkill_unregister().
- */
-void rfkill_unregister(struct rfkill *rfkill)
-{
-	BUG_ON(!rfkill);
-	device_del(&rfkill->dev);
-	rfkill_remove_switch(rfkill);
-	rfkill_led_trigger_unregister(rfkill);
-	put_device(&rfkill->dev);
-}
-EXPORT_SYMBOL(rfkill_unregister);
-
-/**
- * rfkill_set_default - set initial value for a switch type
- * @type - the type of switch to set the default state of
- * @state - the new default state for that group of switches
- *
- * Sets the initial state rfkill should use for a given type.
- * The following initial states are allowed: RFKILL_STATE_SOFT_BLOCKED
- * and RFKILL_STATE_UNBLOCKED.
- *
- * This function is meant to be used by platform drivers for platforms
- * that can save switch state across power down/reboot.
- *
- * The default state for each switch type can be changed exactly once.
- * After a switch of that type is registered, the default state cannot
- * be changed anymore.  This guards against multiple drivers it the
- * same platform trying to set the initial switch default state, which
- * is not allowed.
- *
- * Returns -EPERM if the state has already been set once or is in use,
- * so drivers likely want to either ignore or at most printk(KERN_NOTICE)
- * if this function returns -EPERM.
- *
- * Returns 0 if the new default state was set, or an error if it
- * could not be set.
- */
-int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
-{
-	int error;
-
-	if (WARN((type >= RFKILL_TYPE_MAX ||
-			(state != RFKILL_STATE_SOFT_BLOCKED &&
-			 state != RFKILL_STATE_UNBLOCKED)),
-			KERN_WARNING
-			"rfkill: illegal state %d or type %d passed as "
-			"parameter to rfkill_set_default\n", state, type))
-		return -EINVAL;
-
-	mutex_lock(&rfkill_global_mutex);
-
-	if (!test_and_set_bit(type, rfkill_states_lockdflt)) {
-		rfkill_global_states[type].default_state = state;
-		rfkill_global_states[type].current_state = state;
-		error = 0;
-	} else
-		error = -EPERM;
-
-	mutex_unlock(&rfkill_global_mutex);
-	return error;
-}
-EXPORT_SYMBOL_GPL(rfkill_set_default);
-
-/*
- * Rfkill module initialization/deinitialization.
- */
-static int __init rfkill_init(void)
-{
-	int error;
-	int i;
-
-	/* RFKILL_STATE_HARD_BLOCKED is illegal here... */
-	if (rfkill_default_state != RFKILL_STATE_SOFT_BLOCKED &&
-	    rfkill_default_state != RFKILL_STATE_UNBLOCKED)
-		return -EINVAL;
-
-	for (i = 0; i < RFKILL_TYPE_MAX; i++)
-		rfkill_global_states[i].default_state = rfkill_default_state;
-
-	error = class_register(&rfkill_class);
-	if (error) {
-		printk(KERN_ERR "rfkill: unable to register rfkill class\n");
-		return error;
-	}
-
-	return 0;
-}
-
-static void __exit rfkill_exit(void)
-{
-	class_unregister(&rfkill_class);
-}
-
-subsys_initcall(rfkill_init);
-module_exit(rfkill_exit);
--- wireless-testing.orig/net/rfkill/rfkill-input.h	2009-03-31 11:13:08.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,21 +0,0 @@
-/*
- * Copyright (C) 2007 Ivo van Doorn
- */
-
-/*
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
- */
-
-#ifndef __RFKILL_INPUT_H
-#define __RFKILL_INPUT_H
-
-void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state);
-void rfkill_epo(void);
-void rfkill_restore_states(void);
-void rfkill_remove_epo_lock(void);
-bool rfkill_is_epo_lock_active(void);
-enum rfkill_state rfkill_get_global_state(const enum rfkill_type type);
-
-#endif /* __RFKILL_INPUT_H */
--- wireless-testing.orig/net/rfkill/rfkill-input.c	2009-03-31 11:48:53.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,392 +0,0 @@
-/*
- * Input layer to RF Kill interface connector
- *
- * Copyright (c) 2007 Dmitry Torokhov
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
- *
- * If you ever run into a situation in which you have a SW_ type rfkill
- * input device, then you can revive code that was removed in the patch
- * "rfkill-input: remove unused code".
- */
-
-#include <linux/module.h>
-#include <linux/input.h>
-#include <linux/slab.h>
-#include <linux/workqueue.h>
-#include <linux/init.h>
-#include <linux/rfkill.h>
-#include <linux/sched.h>
-
-#include "rfkill-input.h"
-
-MODULE_AUTHOR("Dmitry Torokhov <dtor@mail.ru>");
-MODULE_DESCRIPTION("Input layer to RF switch connector");
-MODULE_LICENSE("GPL");
-
-enum rfkill_input_master_mode {
-	RFKILL_INPUT_MASTER_DONOTHING = 0,
-	RFKILL_INPUT_MASTER_RESTORE = 1,
-	RFKILL_INPUT_MASTER_UNBLOCKALL = 2,
-	RFKILL_INPUT_MASTER_MAX,	/* marker */
-};
-
-/* Delay (in ms) between consecutive switch ops */
-#define RFKILL_OPS_DELAY 200
-
-static enum rfkill_input_master_mode rfkill_master_switch_mode =
-					RFKILL_INPUT_MASTER_UNBLOCKALL;
-module_param_named(master_switch_mode, rfkill_master_switch_mode, uint, 0);
-MODULE_PARM_DESC(master_switch_mode,
-	"SW_RFKILL_ALL ON should: 0=do nothing; 1=restore; 2=unblock all");
-
-enum rfkill_global_sched_op {
-	RFKILL_GLOBAL_OP_EPO = 0,
-	RFKILL_GLOBAL_OP_RESTORE,
-	RFKILL_GLOBAL_OP_UNLOCK,
-	RFKILL_GLOBAL_OP_UNBLOCK,
-};
-
-struct rfkill_task {
-	struct delayed_work dwork;
-
-	/* ensures that task is serialized */
-	struct mutex mutex;
-
-	/* protects everything below */
-	spinlock_t lock;
-
-	/* pending regular switch operations (1=pending) */
-	unsigned long sw_pending[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
-
-	/* should the state be complemented (1=yes) */
-	unsigned long sw_togglestate[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
-
-	bool global_op_pending;
-	enum rfkill_global_sched_op op;
-
-	/* last time it was scheduled */
-	unsigned long last_scheduled;
-};
-
-static void __rfkill_handle_global_op(enum rfkill_global_sched_op op)
-{
-	unsigned int i;
-
-	switch (op) {
-	case RFKILL_GLOBAL_OP_EPO:
-		rfkill_epo();
-		break;
-	case RFKILL_GLOBAL_OP_RESTORE:
-		rfkill_restore_states();
-		break;
-	case RFKILL_GLOBAL_OP_UNLOCK:
-		rfkill_remove_epo_lock();
-		break;
-	case RFKILL_GLOBAL_OP_UNBLOCK:
-		rfkill_remove_epo_lock();
-		for (i = 0; i < RFKILL_TYPE_MAX; i++)
-			rfkill_switch_all(i, RFKILL_STATE_UNBLOCKED);
-		break;
-	default:
-		/* memory corruption or bug, fail safely */
-		rfkill_epo();
-		WARN(1, "Unknown requested operation %d! "
-			"rfkill Emergency Power Off activated\n",
-			op);
-	}
-}
-
-static void __rfkill_handle_normal_op(const enum rfkill_type type,
-			const bool c)
-{
-	enum rfkill_state state;
-
-	state = rfkill_get_global_state(type);
-	if (c)
-		state = rfkill_state_complement(state);
-
-	rfkill_switch_all(type, state);
-}
-
-static void rfkill_task_handler(struct work_struct *work)
-{
-	struct rfkill_task *task = container_of(work,
-					struct rfkill_task, dwork.work);
-	bool doit = true;
-
-	mutex_lock(&task->mutex);
-
-	spin_lock_irq(&task->lock);
-	while (doit) {
-		if (task->global_op_pending) {
-			enum rfkill_global_sched_op op = task->op;
-			task->global_op_pending = false;
-			memset(task->sw_pending, 0, sizeof(task->sw_pending));
-			spin_unlock_irq(&task->lock);
-
-			__rfkill_handle_global_op(op);
-
-			/* make sure we do at least one pass with
-			 * !task->global_op_pending */
-			spin_lock_irq(&task->lock);
-			continue;
-		} else if (!rfkill_is_epo_lock_active()) {
-			unsigned int i = 0;
-
-			while (!task->global_op_pending &&
-						i < RFKILL_TYPE_MAX) {
-				if (test_and_clear_bit(i, task->sw_pending)) {
-					bool c;
-					c = test_and_clear_bit(i,
-							task->sw_togglestate);
-					spin_unlock_irq(&task->lock);
-
-					__rfkill_handle_normal_op(i, c);
-
-					spin_lock_irq(&task->lock);
-				}
-				i++;
-			}
-		}
-		doit = task->global_op_pending;
-	}
-	spin_unlock_irq(&task->lock);
-
-	mutex_unlock(&task->mutex);
-}
-
-static struct rfkill_task rfkill_task = {
-	.dwork = __DELAYED_WORK_INITIALIZER(rfkill_task.dwork,
-				rfkill_task_handler),
-	.mutex = __MUTEX_INITIALIZER(rfkill_task.mutex),
-	.lock = __SPIN_LOCK_UNLOCKED(rfkill_task.lock),
-};
-
-static unsigned long rfkill_ratelimit(const unsigned long last)
-{
-	const unsigned long delay = msecs_to_jiffies(RFKILL_OPS_DELAY);
-	return (time_after(jiffies, last + delay)) ? 0 : delay;
-}
-
-static void rfkill_schedule_ratelimited(void)
-{
-	if (!delayed_work_pending(&rfkill_task.dwork)) {
-		schedule_delayed_work(&rfkill_task.dwork,
-				rfkill_ratelimit(rfkill_task.last_scheduled));
-		rfkill_task.last_scheduled = jiffies;
-	}
-}
-
-static void rfkill_schedule_global_op(enum rfkill_global_sched_op op)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&rfkill_task.lock, flags);
-	rfkill_task.op = op;
-	rfkill_task.global_op_pending = true;
-	if (op == RFKILL_GLOBAL_OP_EPO && !rfkill_is_epo_lock_active()) {
-		/* bypass the limiter for EPO */
-		cancel_delayed_work(&rfkill_task.dwork);
-		schedule_delayed_work(&rfkill_task.dwork, 0);
-		rfkill_task.last_scheduled = jiffies;
-	} else
-		rfkill_schedule_ratelimited();
-	spin_unlock_irqrestore(&rfkill_task.lock, flags);
-}
-
-static void rfkill_schedule_toggle(enum rfkill_type type)
-{
-	unsigned long flags;
-
-	if (rfkill_is_epo_lock_active())
-		return;
-
-	spin_lock_irqsave(&rfkill_task.lock, flags);
-	if (!rfkill_task.global_op_pending) {
-		set_bit(type, rfkill_task.sw_pending);
-		change_bit(type, rfkill_task.sw_togglestate);
-		rfkill_schedule_ratelimited();
-	}
-	spin_unlock_irqrestore(&rfkill_task.lock, flags);
-}
-
-static void rfkill_schedule_evsw_rfkillall(int state)
-{
-	if (state) {
-		switch (rfkill_master_switch_mode) {
-		case RFKILL_INPUT_MASTER_UNBLOCKALL:
-			rfkill_schedule_global_op(RFKILL_GLOBAL_OP_UNBLOCK);
-			break;
-		case RFKILL_INPUT_MASTER_RESTORE:
-			rfkill_schedule_global_op(RFKILL_GLOBAL_OP_RESTORE);
-			break;
-		case RFKILL_INPUT_MASTER_DONOTHING:
-			rfkill_schedule_global_op(RFKILL_GLOBAL_OP_UNLOCK);
-			break;
-		default:
-			/* memory corruption or driver bug! fail safely */
-			rfkill_schedule_global_op(RFKILL_GLOBAL_OP_EPO);
-			WARN(1, "Unknown rfkill_master_switch_mode (%d), "
-				"driver bug or memory corruption detected!\n",
-				rfkill_master_switch_mode);
-			break;
-		}
-	} else
-		rfkill_schedule_global_op(RFKILL_GLOBAL_OP_EPO);
-}
-
-static void rfkill_event(struct input_handle *handle, unsigned int type,
-			unsigned int code, int data)
-{
-	if (type == EV_KEY && data == 1) {
-		enum rfkill_type t;
-
-		switch (code) {
-		case KEY_WLAN:
-			t = RFKILL_TYPE_WLAN;
-			break;
-		case KEY_BLUETOOTH:
-			t = RFKILL_TYPE_BLUETOOTH;
-			break;
-		case KEY_UWB:
-			t = RFKILL_TYPE_UWB;
-			break;
-		case KEY_WIMAX:
-			t = RFKILL_TYPE_WIMAX;
-			break;
-		default:
-			return;
-		}
-		rfkill_schedule_toggle(t);
-		return;
-	} else if (type == EV_SW) {
-		switch (code) {
-		case SW_RFKILL_ALL:
-			rfkill_schedule_evsw_rfkillall(data);
-			return;
-		default:
-			return;
-		}
-	}
-}
-
-static int rfkill_connect(struct input_handler *handler, struct input_dev *dev,
-			  const struct input_device_id *id)
-{
-	struct input_handle *handle;
-	int error;
-
-	handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL);
-	if (!handle)
-		return -ENOMEM;
-
-	handle->dev = dev;
-	handle->handler = handler;
-	handle->name = "rfkill";
-
-	/* causes rfkill_start() to be called */
-	error = input_register_handle(handle);
-	if (error)
-		goto err_free_handle;
-
-	error = input_open_device(handle);
-	if (error)
-		goto err_unregister_handle;
-
-	return 0;
-
- err_unregister_handle:
-	input_unregister_handle(handle);
- err_free_handle:
-	kfree(handle);
-	return error;
-}
-
-static void rfkill_start(struct input_handle *handle)
-{
-	/* Take event_lock to guard against configuration changes, we
-	 * should be able to deal with concurrency with rfkill_event()
-	 * just fine (which event_lock will also avoid). */
-	spin_lock_irq(&handle->dev->event_lock);
-
-	if (test_bit(EV_SW, handle->dev->evbit)) {
-		if (test_bit(SW_RFKILL_ALL, handle->dev->swbit))
-			rfkill_schedule_evsw_rfkillall(test_bit(SW_RFKILL_ALL,
-							handle->dev->sw));
-		/* add resync for further EV_SW events here */
-	}
-
-	spin_unlock_irq(&handle->dev->event_lock);
-}
-
-static void rfkill_disconnect(struct input_handle *handle)
-{
-	input_close_device(handle);
-	input_unregister_handle(handle);
-	kfree(handle);
-}
-
-static const struct input_device_id rfkill_ids[] = {
-	{
-		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
-		.evbit = { BIT_MASK(EV_KEY) },
-		.keybit = { [BIT_WORD(KEY_WLAN)] = BIT_MASK(KEY_WLAN) },
-	},
-	{
-		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
-		.evbit = { BIT_MASK(EV_KEY) },
-		.keybit = { [BIT_WORD(KEY_BLUETOOTH)] = BIT_MASK(KEY_BLUETOOTH) },
-	},
-	{
-		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
-		.evbit = { BIT_MASK(EV_KEY) },
-		.keybit = { [BIT_WORD(KEY_UWB)] = BIT_MASK(KEY_UWB) },
-	},
-	{
-		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
-		.evbit = { BIT_MASK(EV_KEY) },
-		.keybit = { [BIT_WORD(KEY_WIMAX)] = BIT_MASK(KEY_WIMAX) },
-	},
-	{
-		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_SWBIT,
-		.evbit = { BIT(EV_SW) },
-		.swbit = { [BIT_WORD(SW_RFKILL_ALL)] = BIT_MASK(SW_RFKILL_ALL) },
-	},
-	{ }
-};
-
-static struct input_handler rfkill_handler = {
-	.event =	rfkill_event,
-	.connect =	rfkill_connect,
-	.disconnect =	rfkill_disconnect,
-	.start =	rfkill_start,
-	.name =		"rfkill",
-	.id_table =	rfkill_ids,
-};
-
-static int __init rfkill_handler_init(void)
-{
-	if (rfkill_master_switch_mode >= RFKILL_INPUT_MASTER_MAX)
-		return -EINVAL;
-
-	/*
-	 * The penalty to not doing this is a possible RFKILL_OPS_DELAY delay
-	 * at the first use.  Acceptable, but if we can avoid it, why not?
-	 */
-	rfkill_task.last_scheduled =
-			jiffies - msecs_to_jiffies(RFKILL_OPS_DELAY) - 1;
-	return input_register_handler(&rfkill_handler);
-}
-
-static void __exit rfkill_handler_exit(void)
-{
-	input_unregister_handler(&rfkill_handler);
-	cancel_delayed_work_sync(&rfkill_task.dwork);
-	rfkill_remove_epo_lock();
-}
-
-module_init(rfkill_handler_init);
-module_exit(rfkill_handler_exit);
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-03-31 11:13:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-03-31 11:48:55.000000000 +0200
@@ -3492,7 +3492,7 @@ static int b43_op_config(struct ieee8021
 
 	if (!!conf->radio_enabled != phy->radio_on) {
 		if (conf->radio_enabled) {
-			b43_software_rfkill(dev, RFKILL_STATE_UNBLOCKED);
+			b43_software_rfkill(dev, false);
 			b43info(dev->wl, "Radio turned on by software\n");
 			if (!dev->radio_hw_enable) {
 				b43info(dev->wl, "The hardware RF-kill button "
@@ -3500,7 +3500,7 @@ static int b43_op_config(struct ieee8021
 					"Press the button to turn it on.\n");
 			}
 		} else {
-			b43_software_rfkill(dev, RFKILL_STATE_SOFT_BLOCKED);
+			b43_software_rfkill(dev, true);
 			b43info(dev->wl, "Radio turned off by software\n");
 		}
 	}
--- wireless-testing.orig/drivers/net/wireless/b43/phy_a.c	2009-03-31 11:13:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_a.c	2009-03-31 11:48:55.000000000 +0200
@@ -480,11 +480,11 @@ static bool b43_aphy_op_supports_hwpctl(
 }
 
 static void b43_aphy_op_software_rfkill(struct b43_wldev *dev,
-					enum rfkill_state state)
+					bool blocked)
 {
 	struct b43_phy *phy = &dev->phy;
 
-	if (state == RFKILL_STATE_UNBLOCKED) {
+	if (!blocked) {
 		if (phy->radio_on)
 			return;
 		b43_radio_write16(dev, 0x0004, 0x00C0);
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.c	2009-03-31 11:13:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.c	2009-03-31 11:48:55.000000000 +0200
@@ -84,7 +84,7 @@ int b43_phy_init(struct b43_wldev *dev)
 
 	phy->channel = ops->get_default_chan(dev);
 
-	ops->software_rfkill(dev, RFKILL_STATE_UNBLOCKED);
+	ops->software_rfkill(dev, false);
 	err = ops->init(dev);
 	if (err) {
 		b43err(dev->wl, "PHY init failed\n");
@@ -104,7 +104,7 @@ err_phy_exit:
 	if (ops->exit)
 		ops->exit(dev);
 err_block_rf:
-	ops->software_rfkill(dev, RFKILL_STATE_SOFT_BLOCKED);
+	ops->software_rfkill(dev, true);
 
 	return err;
 }
@@ -113,7 +113,7 @@ void b43_phy_exit(struct b43_wldev *dev)
 {
 	const struct b43_phy_operations *ops = dev->phy.ops;
 
-	ops->software_rfkill(dev, RFKILL_STATE_SOFT_BLOCKED);
+	ops->software_rfkill(dev, true);
 	if (ops->exit)
 		ops->exit(dev);
 }
@@ -287,18 +287,13 @@ err_restore_cookie:
 	return err;
 }
 
-void b43_software_rfkill(struct b43_wldev *dev, enum rfkill_state state)
+void b43_software_rfkill(struct b43_wldev *dev, bool blocked)
 {
 	struct b43_phy *phy = &dev->phy;
 
-	if (state == RFKILL_STATE_HARD_BLOCKED) {
-		/* We cannot hardware-block the device */
-		state = RFKILL_STATE_SOFT_BLOCKED;
-	}
-
 	b43_mac_suspend(dev);
-	phy->ops->software_rfkill(dev, state);
-	phy->radio_on = (state == RFKILL_STATE_UNBLOCKED);
+	phy->ops->software_rfkill(dev, blocked);
+	phy->radio_on = !blocked;
 	b43_mac_enable(dev);
 }
 
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.h	2009-03-31 11:13:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.h	2009-03-31 11:48:55.000000000 +0200
@@ -159,7 +159,7 @@ struct b43_phy_operations {
 
 	/* Radio */
 	bool (*supports_hwpctl)(struct b43_wldev *dev);
-	void (*software_rfkill)(struct b43_wldev *dev, enum rfkill_state state);
+	void (*software_rfkill)(struct b43_wldev *dev, bool blocked);
 	void (*switch_analog)(struct b43_wldev *dev, bool on);
 	int (*switch_channel)(struct b43_wldev *dev, unsigned int new_channel);
 	unsigned int (*get_default_chan)(struct b43_wldev *dev);
@@ -362,7 +362,7 @@ int b43_switch_channel(struct b43_wldev 
 /**
  * b43_software_rfkill - Turn the radio ON or OFF in software.
  */
-void b43_software_rfkill(struct b43_wldev *dev, enum rfkill_state state);
+void b43_software_rfkill(struct b43_wldev *dev, bool blocked);
 
 /**
  * b43_phy_txpower_check - Check TX power output.
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.c	2009-03-31 11:13:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_g.c	2009-03-31 11:48:55.000000000 +0200
@@ -2592,7 +2592,7 @@ static bool b43_gphy_op_supports_hwpctl(
 }
 
 static void b43_gphy_op_software_rfkill(struct b43_wldev *dev,
-					enum rfkill_state state)
+					bool blocked)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
@@ -2600,7 +2600,7 @@ static void b43_gphy_op_software_rfkill(
 
 	might_sleep();
 
-	if (state == RFKILL_STATE_UNBLOCKED) {
+	if (!blocked) {
 		/* Turn radio ON */
 		if (phy->radio_on)
 			return;
--- wireless-testing.orig/drivers/net/wireless/b43/phy_n.c	2009-03-31 11:13:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_n.c	2009-03-31 11:48:55.000000000 +0200
@@ -579,7 +579,7 @@ static void b43_nphy_op_radio_write(stru
 }
 
 static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
-					enum rfkill_state state)
+					bool blocked)
 {//TODO
 }
 
--- wireless-testing.orig/drivers/net/wireless/b43/rfkill.c	2009-03-31 11:48:54.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/rfkill.c	2009-03-31 16:06:43.000000000 +0200
@@ -45,83 +45,68 @@ static bool b43_is_hw_radio_enabled(stru
 }
 
 /* The poll callback for the hardware button. */
-static void b43_rfkill_poll(struct input_polled_dev *poll_dev)
+static bool b43_rfkill_poll(void *data)
 {
-	struct b43_wldev *dev = poll_dev->private;
+	struct b43_wldev *dev = data;
 	struct b43_wl *wl = dev->wl;
 	bool enabled;
-	bool report_change = 0;
 
 	mutex_lock(&wl->mutex);
 	if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED)) {
 		mutex_unlock(&wl->mutex);
-		return;
+		return false;
 	}
 	enabled = b43_is_hw_radio_enabled(dev);
 	if (unlikely(enabled != dev->radio_hw_enable)) {
 		dev->radio_hw_enable = enabled;
-		report_change = 1;
 		b43info(wl, "Radio hardware status changed to %s\n",
 			enabled ? "ENABLED" : "DISABLED");
 	}
 	mutex_unlock(&wl->mutex);
 
-	/* send the radio switch event to the system - note both a key press
-	 * and a release are required */
-	if (unlikely(report_change)) {
-		input_report_key(poll_dev->input, KEY_WLAN, 1);
-		input_report_key(poll_dev->input, KEY_WLAN, 0);
-	}
+	return !enabled;
 }
 
 /* Called when the RFKILL toggled in software. */
-static int b43_rfkill_soft_toggle(void *data, enum rfkill_state state)
+static int b43_rfkill_soft_set(void *data, bool blocked)
 {
 	struct b43_wldev *dev = data;
 	struct b43_wl *wl = dev->wl;
-	int err = -EBUSY;
+	int err = -EINVAL;
 
-	if (!wl->rfkill.registered)
-		return 0;
+	if (WARN_ON(!wl->rfkill.registered))
+		return -EINVAL;
 
 	mutex_lock(&wl->mutex);
+
 	if (b43_status(dev) < B43_STAT_INITIALIZED)
 		goto out_unlock;
+
+	if (WARN_ON(!dev->radio_hw_enable && !blocked))
+		goto out_unlock;
+
+	if (!blocked != dev->phy.radio_on)
+		b43_software_rfkill(dev, blocked);
 	err = 0;
-	switch (state) {
-	case RFKILL_STATE_UNBLOCKED:
-		if (!dev->radio_hw_enable) {
-			/* No luck. We can't toggle the hardware RF-kill
-			 * button from software. */
-			err = -EBUSY;
-			goto out_unlock;
-		}
-		if (!dev->phy.radio_on)
-			b43_software_rfkill(dev, state);
-		break;
-	case RFKILL_STATE_SOFT_BLOCKED:
-		if (dev->phy.radio_on)
-			b43_software_rfkill(dev, state);
-		break;
-	default:
-		b43warn(wl, "Received unexpected rfkill state %d.\n", state);
-		break;
-	}
 out_unlock:
 	mutex_unlock(&wl->mutex);
-
 	return err;
 }
 
-char *b43_rfkill_led_name(struct b43_wldev *dev)
+const char *b43_rfkill_led_name(struct b43_wldev *dev)
 {
 	struct b43_rfkill *rfk = &(dev->wl->rfkill);
 
 	if (!rfk->registered)
 		return NULL;
-	return rfkill_get_led_name(rfk->rfkill);
+	return rfkill_get_led_trigger_name(rfk->rfkill);
 }
 
+static const struct rfkill_ops b43_rfkill_ops = {
+	.set_block = b43_rfkill_soft_set,
+	.poll_hw_block = b43_rfkill_poll,
+};
+
 void b43_rfkill_init(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
@@ -130,65 +115,26 @@ void b43_rfkill_init(struct b43_wldev *d
 
 	rfk->registered = 0;
 
-	rfk->rfkill = rfkill_allocate(dev->dev->dev, RFKILL_TYPE_WLAN);
-	if (!rfk->rfkill)
-		goto out_error;
 	snprintf(rfk->name, sizeof(rfk->name),
 		 "b43-%s", wiphy_name(wl->hw->wiphy));
-	rfk->rfkill->name = rfk->name;
-	rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
-	rfk->rfkill->data = dev;
-	rfk->rfkill->toggle_radio = b43_rfkill_soft_toggle;
-
-	rfk->poll_dev = input_allocate_polled_device();
-	if (!rfk->poll_dev) {
-		rfkill_free(rfk->rfkill);
-		goto err_freed_rfk;
-	}
 
-	rfk->poll_dev->private = dev;
-	rfk->poll_dev->poll = b43_rfkill_poll;
-	rfk->poll_dev->poll_interval = 1000; /* msecs */
-
-	rfk->poll_dev->input->name = rfk->name;
-	rfk->poll_dev->input->id.bustype = BUS_HOST;
-	rfk->poll_dev->input->id.vendor = dev->dev->bus->boardinfo.vendor;
-	rfk->poll_dev->input->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_WLAN, rfk->poll_dev->input->keybit);
+	rfk->rfkill = rfkill_alloc(rfk->name,
+				   dev->dev->dev,
+				   RFKILL_TYPE_WLAN,
+				   &b43_rfkill_ops, dev);
+	if (!rfk->rfkill)
+		goto out_error;
 
 	err = rfkill_register(rfk->rfkill);
 	if (err)
-		goto err_free_polldev;
-
-#ifdef CONFIG_RFKILL_INPUT_MODULE
-	/* B43 RF-kill isn't useful without the rfkill-input subsystem.
-	 * Try to load the module. */
-	err = request_module("rfkill-input");
-	if (err)
-		b43warn(wl, "Failed to load the rfkill-input module. "
-			"The built-in radio LED will not work.\n");
-#endif /* CONFIG_RFKILL_INPUT */
-
-#if !defined(CONFIG_RFKILL_INPUT) && !defined(CONFIG_RFKILL_INPUT_MODULE)
-	b43warn(wl, "The rfkill-input subsystem is not available. "
-		"The built-in radio LED will not work.\n");
-#endif
-
-	err = input_register_polled_device(rfk->poll_dev);
-	if (err)
-		goto err_unreg_rfk;
+		goto err_free;
 
 	rfk->registered = 1;
 
 	return;
-err_unreg_rfk:
-	rfkill_unregister(rfk->rfkill);
-err_free_polldev:
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
-err_freed_rfk:
-	rfk->rfkill = NULL;
-out_error:
+ err_free:
+	rfkill_destroy(rfk->rfkill);
+ out_error:
 	rfk->registered = 0;
 	b43warn(wl, "RF-kill button init failed\n");
 }
@@ -201,9 +147,7 @@ void b43_rfkill_exit(struct b43_wldev *d
 		return;
 	rfk->registered = 0;
 
-	input_unregister_polled_device(rfk->poll_dev);
 	rfkill_unregister(rfk->rfkill);
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
+	rfkill_destroy(rfk->rfkill);
 	rfk->rfkill = NULL;
 }
--- wireless-testing.orig/drivers/net/wireless/b43legacy/rfkill.c	2009-03-31 11:48:54.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/rfkill.c	2009-03-31 16:06:52.000000000 +0200
@@ -45,86 +45,73 @@ static bool b43legacy_is_hw_radio_enable
 }
 
 /* The poll callback for the hardware button. */
-static void b43legacy_rfkill_poll(struct input_polled_dev *poll_dev)
+static bool b43legacy_rfkill_poll(void *data)
 {
-	struct b43legacy_wldev *dev = poll_dev->private;
+	struct b43legacy_wldev *dev = data;
 	struct b43legacy_wl *wl = dev->wl;
 	bool enabled;
-	bool report_change = 0;
 
 	mutex_lock(&wl->mutex);
 	if (unlikely(b43legacy_status(dev) < B43legacy_STAT_INITIALIZED)) {
 		mutex_unlock(&wl->mutex);
-		return;
+		return false;
 	}
 	enabled = b43legacy_is_hw_radio_enabled(dev);
 	if (unlikely(enabled != dev->radio_hw_enable)) {
 		dev->radio_hw_enable = enabled;
-		report_change = 1;
 		b43legacyinfo(wl, "Radio hardware status changed to %s\n",
 			enabled ? "ENABLED" : "DISABLED");
 	}
 	mutex_unlock(&wl->mutex);
 
-	/* send the radio switch event to the system - note both a key press
-	 * and a release are required */
-	if (unlikely(report_change)) {
-		input_report_key(poll_dev->input, KEY_WLAN, 1);
-		input_report_key(poll_dev->input, KEY_WLAN, 0);
-	}
+	return !enabled;
 }
 
 /* Called when the RFKILL toggled in software.
  * This is called without locking. */
-static int b43legacy_rfkill_soft_toggle(void *data, enum rfkill_state state)
+static int b43legacy_rfkill_soft_set(void *data, bool blocked)
 {
 	struct b43legacy_wldev *dev = data;
 	struct b43legacy_wl *wl = dev->wl;
-	int err = -EBUSY;
+	int ret = -EINVAL;
 
 	if (!wl->rfkill.registered)
-		return 0;
+		return -EINVAL;
 
 	mutex_lock(&wl->mutex);
 	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED)
 		goto out_unlock;
-	err = 0;
-	switch (state) {
-	case RFKILL_STATE_UNBLOCKED:
-		if (!dev->radio_hw_enable) {
-			/* No luck. We can't toggle the hardware RF-kill
-			 * button from software. */
-			err = -EBUSY;
-			goto out_unlock;
-		}
-		if (!dev->phy.radio_on)
+
+	if (WARN_ON(!blocked && !dev->radio_hw_enable))
+		goto out_unlock;
+
+	if (!blocked != dev->phy.radio_on) {
+		if (!blocked)
 			b43legacy_radio_turn_on(dev);
-		break;
-	case RFKILL_STATE_SOFT_BLOCKED:
-		if (dev->phy.radio_on)
+		else
 			b43legacy_radio_turn_off(dev, 0);
-		break;
-	default:
-		b43legacywarn(wl, "Received unexpected rfkill state %d.\n",
-			      state);
-		break;
 	}
+	ret = 0;
 
 out_unlock:
 	mutex_unlock(&wl->mutex);
-
-	return err;
+	return ret;
 }
 
-char *b43legacy_rfkill_led_name(struct b43legacy_wldev *dev)
+const char *b43legacy_rfkill_led_name(struct b43legacy_wldev *dev)
 {
 	struct b43legacy_rfkill *rfk = &(dev->wl->rfkill);
 
 	if (!rfk->registered)
 		return NULL;
-	return rfkill_get_led_name(rfk->rfkill);
+	return rfkill_get_led_trigger_name(rfk->rfkill);
 }
 
+static const struct rfkill_ops b43legacy_rfkill_ops = {
+	.set_block = b43legacy_rfkill_soft_set,
+	.poll_hw_block = b43legacy_rfkill_poll,
+};
+
 void b43legacy_rfkill_init(struct b43legacy_wldev *dev)
 {
 	struct b43legacy_wl *wl = dev->wl;
@@ -133,60 +120,25 @@ void b43legacy_rfkill_init(struct b43leg
 
 	rfk->registered = 0;
 
-	rfk->rfkill = rfkill_allocate(dev->dev->dev, RFKILL_TYPE_WLAN);
-	if (!rfk->rfkill)
-		goto out_error;
 	snprintf(rfk->name, sizeof(rfk->name),
 		 "b43legacy-%s", wiphy_name(wl->hw->wiphy));
-	rfk->rfkill->name = rfk->name;
-	rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
-	rfk->rfkill->data = dev;
-	rfk->rfkill->toggle_radio = b43legacy_rfkill_soft_toggle;
-
-	rfk->poll_dev = input_allocate_polled_device();
-	if (!rfk->poll_dev) {
-		rfkill_free(rfk->rfkill);
-		goto err_freed_rfk;
-	}
-
-	rfk->poll_dev->private = dev;
-	rfk->poll_dev->poll = b43legacy_rfkill_poll;
-	rfk->poll_dev->poll_interval = 1000; /* msecs */
-
-	rfk->poll_dev->input->name = rfk->name;
-	rfk->poll_dev->input->id.bustype = BUS_HOST;
-	rfk->poll_dev->input->id.vendor = dev->dev->bus->boardinfo.vendor;
-	rfk->poll_dev->input->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_WLAN, rfk->poll_dev->input->keybit);
+	rfk->rfkill = rfkill_alloc(rfk->name,
+				   dev->dev->dev,
+				   RFKILL_TYPE_WLAN,
+				   &b43legacy_rfkill_ops, dev);
+	if (!rfk->rfkill)
+		goto out_error;
 
 	err = rfkill_register(rfk->rfkill);
 	if (err)
-		goto err_free_polldev;
-
-#ifdef CONFIG_RFKILL_INPUT_MODULE
-	/* B43legacy RF-kill isn't useful without the rfkill-input subsystem.
-	 * Try to load the module. */
-	err = request_module("rfkill-input");
-	if (err)
-		b43legacywarn(wl, "Failed to load the rfkill-input module."
-			"The built-in radio LED will not work.\n");
-#endif /* CONFIG_RFKILL_INPUT */
-
-	err = input_register_polled_device(rfk->poll_dev);
-	if (err)
-		goto err_unreg_rfk;
+		goto err_free;
 
 	rfk->registered = 1;
 
 	return;
-err_unreg_rfk:
-	rfkill_unregister(rfk->rfkill);
-err_free_polldev:
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
-err_freed_rfk:
-	rfk->rfkill = NULL;
-out_error:
+ err_free:
+	rfkill_destroy(rfk->rfkill);
+ out_error:
 	rfk->registered = 0;
 	b43legacywarn(wl, "RF-kill button init failed\n");
 }
@@ -199,10 +151,8 @@ void b43legacy_rfkill_exit(struct b43leg
 		return;
 	rfk->registered = 0;
 
-	input_unregister_polled_device(rfk->poll_dev);
 	rfkill_unregister(rfk->rfkill);
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
+	rfkill_destroy(rfk->rfkill);
 	rfk->rfkill = NULL;
 }
 
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-rfkill.c	2009-03-31 11:48:54.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-rfkill.c	2009-03-31 11:48:55.000000000 +0200
@@ -36,42 +36,37 @@
 #include "iwl-core.h"
 
 /* software rf-kill from user */
-static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
+static int iwl_rfkill_soft_rf_kill(void *data, bool blocked)
 {
 	struct iwl_priv *priv = data;
-	int err = 0;
 
 	if (!priv->rfkill)
-		return 0;
+		return -EINVAL;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return 0;
 
-	IWL_DEBUG_RF_KILL(priv, "we received soft RFKILL set to state %d\n", state);
+	IWL_DEBUG_RF_KILL(priv, "received soft RFKILL: block=%d\n", blocked);
+
 	mutex_lock(&priv->mutex);
 
-	switch (state) {
-	case RFKILL_STATE_UNBLOCKED:
-		if (iwl_is_rfkill_hw(priv)) {
-			err = -EBUSY;
-			goto out_unlock;
-		}
+	if (WARN_ON(iwl_is_rfkill_hw(priv)))
+		goto out_unlock;
+
+	if (!blocked)
 		iwl_radio_kill_sw_enable_radio(priv);
-		break;
-	case RFKILL_STATE_SOFT_BLOCKED:
+	else
 		iwl_radio_kill_sw_disable_radio(priv);
-		break;
-	default:
-		IWL_WARN(priv, "we received unexpected RFKILL state %d\n",
-			state);
-		break;
-	}
+
 out_unlock:
 	mutex_unlock(&priv->mutex);
-
-	return err;
+	return 0;
 }
 
+static const struct rfkill_ops iwl_rfkill_ops = {
+	.set_block = iwl_rfkill_soft_rf_kill,
+};
+
 int iwl_rfkill_init(struct iwl_priv *priv)
 {
 	struct device *device = wiphy_dev(priv->hw->wiphy);
@@ -80,21 +75,16 @@ int iwl_rfkill_init(struct iwl_priv *pri
 	BUG_ON(device == NULL);
 
 	IWL_DEBUG_RF_KILL(priv, "Initializing RFKILL.\n");
-	priv->rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
+	priv->rfkill = rfkill_alloc(priv->cfg->name,
+				    device,
+				    RFKILL_TYPE_WLAN,
+				    &iwl_rfkill_ops, priv);
 	if (!priv->rfkill) {
 		IWL_ERR(priv, "Unable to allocate RFKILL device.\n");
 		ret = -ENOMEM;
 		goto error;
 	}
 
-	priv->rfkill->name = priv->cfg->name;
-	priv->rfkill->data = priv;
-	priv->rfkill->state = RFKILL_STATE_UNBLOCKED;
-	priv->rfkill->toggle_radio = iwl_rfkill_soft_rf_kill;
-
-	priv->rfkill->dev.class->suspend = NULL;
-	priv->rfkill->dev.class->resume = NULL;
-
 	ret = rfkill_register(priv->rfkill);
 	if (ret) {
 		IWL_ERR(priv, "Unable to register RFKILL: %d\n", ret);
@@ -102,11 +92,10 @@ int iwl_rfkill_init(struct iwl_priv *pri
 	}
 
 	IWL_DEBUG_RF_KILL(priv, "RFKILL initialization complete.\n");
-	return ret;
+	return 0;
 
 free_rfkill:
-	if (priv->rfkill != NULL)
-		rfkill_free(priv->rfkill);
+	rfkill_destroy(priv->rfkill);
 	priv->rfkill = NULL;
 
 error:
@@ -118,8 +107,10 @@ EXPORT_SYMBOL(iwl_rfkill_init);
 void iwl_rfkill_unregister(struct iwl_priv *priv)
 {
 
-	if (priv->rfkill)
+	if (priv->rfkill) {
 		rfkill_unregister(priv->rfkill);
+		rfkill_destroy(priv->rfkill);
+	}
 
 	priv->rfkill = NULL;
 }
@@ -131,14 +122,10 @@ void iwl_rfkill_set_hw_state(struct iwl_
 	if (!priv->rfkill)
 		return;
 
-	if (iwl_is_rfkill_hw(priv)) {
-		rfkill_force_state(priv->rfkill, RFKILL_STATE_HARD_BLOCKED);
-		return;
-	}
-
-	if (!iwl_is_rfkill_sw(priv))
-		rfkill_force_state(priv->rfkill, RFKILL_STATE_UNBLOCKED);
+	if (rfkill_set_hw_state(priv->rfkill,
+				!!iwl_is_rfkill_hw(priv)))
+		iwl_radio_kill_sw_disable_radio(priv);
 	else
-		rfkill_force_state(priv->rfkill, RFKILL_STATE_SOFT_BLOCKED);
+		iwl_radio_kill_sw_enable_radio(priv);
 }
 EXPORT_SYMBOL(iwl_rfkill_set_hw_state);
--- wireless-testing.orig/Documentation/rfkill.txt	2009-03-31 11:48:54.000000000 +0200
+++ wireless-testing/Documentation/rfkill.txt	2009-03-31 20:36:33.000000000 +0200
@@ -1,571 +1,132 @@
-rfkill - RF switch subsystem support
-====================================
+rfkill - RF kill switch support
+===============================
 
-1 Introduction
-2 Implementation details
-3 Kernel driver guidelines
-3.1 wireless device drivers
-3.2 platform/switch drivers
-3.3 input device drivers
-4 Kernel API
-5 Userspace support
-
-
-1. Introduction:
-
-The rfkill switch subsystem exists to add a generic interface to circuitry that
-can enable or disable the signal output of a wireless *transmitter* of any
-type.  By far, the most common use is to disable radio-frequency transmitters.
-
-Note that disabling the signal output means that the the transmitter is to be
-made to not emit any energy when "blocked".  rfkill is not about blocking data
-transmissions, it is about blocking energy emission.
-
-The rfkill subsystem offers support for keys and switches often found on
-laptops to enable wireless devices like WiFi and Bluetooth, so that these keys
-and switches actually perform an action in all wireless devices of a given type
-attached to the system.
-
-The buttons to enable and disable the wireless transmitters are important in
-situations where the user is for example using his laptop on a location where
-radio-frequency transmitters _must_ be disabled (e.g. airplanes).
-
-Because of this requirement, userspace support for the keys should not be made
-mandatory.  Because userspace might want to perform some additional smarter
-tasks when the key is pressed, rfkill provides userspace the possibility to
-take over the task to handle the key events.
+1. Introduction
+2. Implementation details
+3. Kernel driver guidelines
+4. Kernel API
+5. Userspace support
 
-===============================================================================
-2: Implementation details
+
+1. Introduction
+
+The rfkill subsystem provides a generic interface to disabling any radio
+transmitter in the system. When a transmitter is blocked, it shall not
+radiate any power.
+
+The subsystem also provides the ability to react on button presses and
+disable all transmitters of a certain type (or all). This is intended for
+situations where transmitters need to be turned off, for example on
+aircraft.
+
+
+
+2. Implementation details
 
 The rfkill subsystem is composed of various components: the rfkill class, the
 rfkill-input module (an input layer handler), and some specific input layer
 events.
 
-The rfkill class provides kernel drivers with an interface that allows them to
-know when they should enable or disable a wireless network device transmitter.
-This is enabled by the CONFIG_RFKILL Kconfig option.
-
-The rfkill class support makes sure userspace will be notified of all state
-changes on rfkill devices through uevents.  It provides a notification chain
-for interested parties in the kernel to also get notified of rfkill state
-changes in other drivers.  It creates several sysfs entries which can be used
-by userspace.  See section "Userspace support".
-
-The rfkill-input module provides the kernel with the ability to implement a
-basic response when the user presses a key or button (or toggles a switch)
-related to rfkill functionality.  It is an in-kernel implementation of default
-policy of reacting to rfkill-related input events and neither mandatory nor
-required for wireless drivers to operate.  It is enabled by the
-CONFIG_RFKILL_INPUT Kconfig option.
-
-rfkill-input is a rfkill-related events input layer handler.  This handler will
-listen to all rfkill key events and will change the rfkill state of the
-wireless devices accordingly.  With this option enabled userspace could either
-do nothing or simply perform monitoring tasks.
-
-The rfkill-input module also provides EPO (emergency power-off) functionality
-for all wireless transmitters.  This function cannot be overridden, and it is
-always active.  rfkill EPO is related to *_RFKILL_ALL input layer events.
-
-
-Important terms for the rfkill subsystem:
-
-In order to avoid confusion, we avoid the term "switch" in rfkill when it is
-referring to an electronic control circuit that enables or disables a
-transmitter.  We reserve it for the physical device a human manipulates
-(which is an input device, by the way):
-
-rfkill switch:
-
-	A physical device a human manipulates.  Its state can be perceived by
-	the kernel either directly (through a GPIO pin, ACPI GPE) or by its
-	effect on a rfkill line of a wireless device.
-
-rfkill controller:
-
-	A hardware circuit that controls the state of a rfkill line, which a
-	kernel driver can interact with *to modify* that state (i.e. it has
-	either write-only or read/write access).
-
-rfkill line:
-
-	An input channel (hardware or software) of a wireless device, which
-	causes a wireless transmitter to stop emitting energy (BLOCK) when it
-	is active.  Point of view is extremely important here: rfkill lines are
-	always seen from the PoV of a wireless device (and its driver).
-
-soft rfkill line/software rfkill line:
-
-	A rfkill line the wireless device driver can directly change the state
-	of.  Related to rfkill_state RFKILL_STATE_SOFT_BLOCKED.
-
-hard rfkill line/hardware rfkill line:
-
-	A rfkill line that works fully in hardware or firmware, and that cannot
-	be overridden by the kernel driver.  The hardware device or the
-	firmware just exports its status to the driver, but it is read-only.
-	Related to rfkill_state RFKILL_STATE_HARD_BLOCKED.
-
-The enum rfkill_state describes the rfkill state of a transmitter:
-
-When a rfkill line or rfkill controller is in the RFKILL_STATE_UNBLOCKED state,
-the wireless transmitter (radio TX circuit for example) is *enabled*.  When the
-it is in the RFKILL_STATE_SOFT_BLOCKED or RFKILL_STATE_HARD_BLOCKED, the
-wireless transmitter is to be *blocked* from operating.
-
-RFKILL_STATE_SOFT_BLOCKED indicates that a call to toggle_radio() can change
-that state.  RFKILL_STATE_HARD_BLOCKED indicates that a call to toggle_radio()
-will not be able to change the state and will return with a suitable error if
-attempts are made to set the state to RFKILL_STATE_UNBLOCKED.
-
-RFKILL_STATE_HARD_BLOCKED is used by drivers to signal that the device is
-locked in the BLOCKED state by a hardwire rfkill line (typically an input pin
-that, when active, forces the transmitter to be disabled) which the driver
-CANNOT override.
-
-Full rfkill functionality requires two different subsystems to cooperate: the
-input layer and the rfkill class.  The input layer issues *commands* to the
-entire system requesting that devices registered to the rfkill class change
-state.  The way this interaction happens is not complex, but it is not obvious
-either:
-
-Kernel Input layer:
-
-	* Generates KEY_WWAN, KEY_WLAN, KEY_BLUETOOTH, SW_RFKILL_ALL, and
-	  other such events when the user presses certain keys, buttons, or
-	  toggles certain physical switches.
-
-	THE INPUT LAYER IS NEVER USED TO PROPAGATE STATUS, NOTIFICATIONS OR THE
-	KIND OF STUFF AN ON-SCREEN-DISPLAY APPLICATION WOULD REPORT.  It is
-	used to issue *commands* for the system to change behaviour, and these
-	commands may or may not be carried out by some kernel driver or
-	userspace application.  It follows that doing user feedback based only
-	on input events is broken, as there is no guarantee that an input event
-	will be acted upon.
-
-	Most wireless communication device drivers implementing rfkill
-	functionality MUST NOT generate these events, and have no reason to
-	register themselves with the input layer.  Doing otherwise is a common
-	misconception.  There is an API to propagate rfkill status change
-	information, and it is NOT the input layer.
-
-rfkill class:
-
-	* Calls a hook in a driver to effectively change the wireless
-	  transmitter state;
-	* Keeps track of the wireless transmitter state (with help from
-	  the driver);
-	* Generates userspace notifications (uevents) and a call to a
-	  notification chain (kernel) when there is a wireless transmitter
-	  state change;
-	* Connects a wireless communications driver with the common rfkill
-	  control system, which, for example, allows actions such as
-	  "switch all bluetooth devices offline" to be carried out by
-	  userspace or by rfkill-input.
-
-	THE RFKILL CLASS NEVER ISSUES INPUT EVENTS.  THE RFKILL CLASS DOES
-	NOT LISTEN TO INPUT EVENTS.  NO DRIVER USING THE RFKILL CLASS SHALL
-	EVER LISTEN TO, OR ACT ON RFKILL INPUT EVENTS.  Doing otherwise is
-	a layering violation.
-
-	Most wireless data communication drivers in the kernel have just to
-	implement the rfkill class API to work properly.  Interfacing to the
-	input layer is not often required (and is very often a *bug*) on
-	wireless drivers.
-
-	Platform drivers often have to attach to the input layer to *issue*
-	(but never to listen to) rfkill events for rfkill switches, and also to
-	the rfkill class to export a control interface for the platform rfkill
-	controllers to the rfkill subsystem.  This does NOT mean the rfkill
-	switch is attached to a rfkill class (doing so is almost always wrong).
-	It just means the same kernel module is the driver for different
-	devices (rfkill switches and rfkill controllers).
-
-
-Userspace input handlers (uevents) or kernel input handlers (rfkill-input):
-
-	* Implements the policy of what should happen when one of the input
-	  layer events related to rfkill operation is received.
-	* Uses the sysfs interface (userspace) or private rfkill API calls
-	  to tell the devices registered with the rfkill class to change
-	  their state (i.e. translates the input layer event into real
-	  action).
-
-	* rfkill-input implements EPO by handling EV_SW SW_RFKILL_ALL 0
-	  (power off all transmitters) in a special way: it ignores any
-	  overrides and local state cache and forces all transmitters to the
-	  RFKILL_STATE_SOFT_BLOCKED state (including those which are already
-	  supposed to be BLOCKED).
-	* rfkill EPO will remain active until rfkill-input receives an
-	  EV_SW SW_RFKILL_ALL 1 event.  While the EPO is active, transmitters
-	  are locked in the blocked state (rfkill will refuse to unblock them).
-	* rfkill-input implements different policies that the user can
-	  select for handling EV_SW SW_RFKILL_ALL 1.  It will unlock rfkill,
-	  and either do nothing (leave transmitters blocked, but now unlocked),
-	  restore the transmitters to their state before the EPO, or unblock
-	  them all.
-
-Userspace uevent handler or kernel platform-specific drivers hooked to the
-rfkill notifier chain:
-
-	* Taps into the rfkill notifier chain or to KOBJ_CHANGE uevents,
-	  in order to know when a device that is registered with the rfkill
-	  class changes state;
-	* Issues feedback notifications to the user;
-	* In the rare platforms where this is required, synthesizes an input
-	  event to command all *OTHER* rfkill devices to also change their
-	  statues when a specific rfkill device changes state.
-
-
-===============================================================================
-3: Kernel driver guidelines
-
-Remember: point-of-view is everything for a driver that connects to the rfkill
-subsystem.  All the details below must be measured/perceived from the point of
-view of the specific driver being modified.
-
-The first thing one needs to know is whether his driver should be talking to
-the rfkill class or to the input layer.  In rare cases (platform drivers), it
-could happen that you need to do both, as platform drivers often handle a
-variety of devices in the same driver.
-
-Do not mistake input devices for rfkill controllers.  The only type of "rfkill
-switch" device that is to be registered with the rfkill class are those
-directly controlling the circuits that cause a wireless transmitter to stop
-working (or the software equivalent of them), i.e. what we call a rfkill
-controller.  Every other kind of "rfkill switch" is just an input device and
-MUST NOT be registered with the rfkill class.
-
-A driver should register a device with the rfkill class when ALL of the
-following conditions are met (they define a rfkill controller):
-
-1. The device is/controls a data communications wireless transmitter;
-
-2. The kernel can interact with the hardware/firmware to CHANGE the wireless
-   transmitter state (block/unblock TX operation);
-
-3. The transmitter can be made to not emit any energy when "blocked":
-   rfkill is not about blocking data transmissions, it is about blocking
-   energy emission;
-
-A driver should register a device with the input subsystem to issue
-rfkill-related events (KEY_WLAN, KEY_BLUETOOTH, KEY_WWAN, KEY_WIMAX,
-SW_RFKILL_ALL, etc) when ALL of the folowing conditions are met:
-
-1. It is directly related to some physical device the user interacts with, to
-   command the O.S./firmware/hardware to enable/disable a data communications
-   wireless transmitter.
-
-   Examples of the physical device are: buttons, keys and switches the user
-   will press/touch/slide/switch to enable or disable the wireless
-   communication device.
-
-2. It is NOT slaved to another device, i.e. there is no other device that
-   issues rfkill-related input events in preference to this one.
-
-   Please refer to the corner cases and examples section for more details.
-
-When in doubt, do not issue input events.  For drivers that should generate
-input events in some platforms, but not in others (e.g. b43), the best solution
-is to NEVER generate input events in the first place.  That work should be
-deferred to a platform-specific kernel module (which will know when to generate
-events through the rfkill notifier chain) or to userspace.  This avoids the
-usual maintenance problems with DMI whitelisting.
-
-
-Corner cases and examples:
-====================================
-
-1. If the device is an input device that, because of hardware or firmware,
-causes wireless transmitters to be blocked regardless of the kernel's will, it
-is still just an input device, and NOT to be registered with the rfkill class.
-
-2. If the wireless transmitter switch control is read-only, it is an input
-device and not to be registered with the rfkill class (and maybe not to be made
-an input layer event source either, see below).
-
-3. If there is some other device driver *closer* to the actual hardware the
-user interacted with (the button/switch/key) to issue an input event, THAT is
-the device driver that should be issuing input events.
-
-E.g:
-  [RFKILL slider switch] -- [GPIO hardware] -- [WLAN card rf-kill input]
-                           (platform driver)    (wireless card driver)
-
-The user is closer to the RFKILL slide switch plaform driver, so the driver
-which must issue input events is the platform driver looking at the GPIO
-hardware, and NEVER the wireless card driver (which is just a slave).  It is
-very likely that there are other leaves than just the WLAN card rf-kill input
-(e.g. a bluetooth card, etc)...
-
-On the other hand, some embedded devices do this:
-
-  [RFKILL slider switch] -- [WLAN card rf-kill input]
-                             (wireless card driver)
-
-In this situation, the wireless card driver *could* register itself as an input
-device and issue rf-kill related input events... but in order to AVOID the need
-for DMI whitelisting, the wireless card driver does NOT do it.  Userspace (HAL)
-or a platform driver (that exists only on these embedded devices) will do the
-dirty job of issuing the input events.
-
-
-COMMON MISTAKES in kernel drivers, related to rfkill:
-====================================
-
-1. NEVER confuse input device keys and buttons with input device switches.
-
-  1a. Switches are always set or reset.  They report the current state
-      (on position or off position).
-
-  1b. Keys and buttons are either in the pressed or not-pressed state, and
-      that's it.  A "button" that latches down when you press it, and
-      unlatches when you press it again is in fact a switch as far as input
-      devices go.
-
-Add the SW_* events you need for switches, do NOT try to emulate a button using
-KEY_* events just because there is no such SW_* event yet.  Do NOT try to use,
-for example, KEY_BLUETOOTH when you should be using SW_BLUETOOTH instead.
-
-2. Input device switches (sources of EV_SW events) DO store their current state
-(so you *must* initialize it by issuing a gratuitous input layer event on
-driver start-up and also when resuming from sleep), and that state CAN be
-queried from userspace through IOCTLs.  There is no sysfs interface for this,
-but that doesn't mean you should break things trying to hook it to the rfkill
-class to get a sysfs interface :-)
-
-3. Do not issue *_RFKILL_ALL events by default, unless you are sure it is the
-correct event for your switch/button.  These events are emergency power-off
-events when they are trying to turn the transmitters off.  An example of an
-input device which SHOULD generate *_RFKILL_ALL events is the wireless-kill
-switch in a laptop which is NOT a hotkey, but a real sliding/rocker switch.
-An example of an input device which SHOULD NOT generate *_RFKILL_ALL events by
-default, is any sort of hot key that is type-specific (e.g. the one for WLAN).
-
-
-3.1 Guidelines for wireless device drivers
-------------------------------------------
-
-(in this text, rfkill->foo means the foo field of struct rfkill).
-
-1. Each independent transmitter in a wireless device (usually there is only one
-transmitter per device) should have a SINGLE rfkill class attached to it.
-
-2. If the device does not have any sort of hardware assistance to allow the
-driver to rfkill the device, the driver should emulate it by taking all actions
-required to silence the transmitter.
-
-3. If it is impossible to silence the transmitter (i.e. it still emits energy,
-even if it is just in brief pulses, when there is no data to transmit and there
-is no hardware support to turn it off) do NOT lie to the users.  Do not attach
-it to a rfkill class.  The rfkill subsystem does not deal with data
-transmission, it deals with energy emission.  If the transmitter is emitting
-energy, it is not blocked in rfkill terms.
-
-4. It doesn't matter if the device has multiple rfkill input lines affecting
-the same transmitter, their combined state is to be exported as a single state
-per transmitter (see rule 1).
-
-This rule exists because users of the rfkill subsystem expect to get (and set,
-when possible) the overall transmitter rfkill state, not of a particular rfkill
-line.
-
-5. The wireless device driver MUST NOT leave the transmitter enabled during
-suspend and hibernation unless:
-
-	5.1. The transmitter has to be enabled for some sort of functionality
-	like wake-on-wireless-packet or autonomous packed forwarding in a mesh
-	network, and that functionality is enabled for this suspend/hibernation
-	cycle.
-
-AND
-
-	5.2. The device was not on a user-requested BLOCKED state before
-	the suspend (i.e. the driver must NOT unblock a device, not even
-	to support wake-on-wireless-packet or remain in the mesh).
-
-In other words, there is absolutely no allowed scenario where a driver can
-automatically take action to unblock a rfkill controller (obviously, this deals
-with scenarios where soft-blocking or both soft and hard blocking is happening.
-Scenarios where hardware rfkill lines are the only ones blocking the
-transmitter are outside of this rule, since the wireless device driver does not
-control its input hardware rfkill lines in the first place).
-
-6. During resume, rfkill will try to restore its previous state.
-
-7. After a rfkill class is suspended, it will *not* call rfkill->toggle_radio
-until it is resumed.
-
-
-Example of a WLAN wireless driver connected to the rfkill subsystem:
---------------------------------------------------------------------
-
-A certain WLAN card has one input pin that causes it to block the transmitter
-and makes the status of that input pin available (only for reading!) to the
-kernel driver.  This is a hard rfkill input line (it cannot be overridden by
-the kernel driver).
-
-The card also has one PCI register that, if manipulated by the driver, causes
-it to block the transmitter.  This is a soft rfkill input line.
-
-It has also a thermal protection circuitry that shuts down its transmitter if
-the card overheats, and makes the status of that protection available (only for
-reading!) to the kernel driver.  This is also a hard rfkill input line.
-
-If either one of these rfkill lines are active, the transmitter is blocked by
-the hardware and forced offline.
-
-The driver should allocate and attach to its struct device *ONE* instance of
-the rfkill class (there is only one transmitter).
-
-It can implement the get_state() hook, and return RFKILL_STATE_HARD_BLOCKED if
-either one of its two hard rfkill input lines are active.  If the two hard
-rfkill lines are inactive, it must return RFKILL_STATE_SOFT_BLOCKED if its soft
-rfkill input line is active.  Only if none of the rfkill input lines are
-active, will it return RFKILL_STATE_UNBLOCKED.
-
-Since the device has a hardware rfkill line, it IS subject to state changes
-external to rfkill.  Therefore, the driver must make sure that it calls
-rfkill_force_state() to keep the status always up-to-date, and it must do a
-rfkill_force_state() on resume from sleep.
-
-Every time the driver gets a notification from the card that one of its rfkill
-lines changed state (polling might be needed on badly designed cards that don't
-generate interrupts for such events), it recomputes the rfkill state as per
-above, and calls rfkill_force_state() to update it.
-
-The driver should implement the toggle_radio() hook, that:
-
-1. Returns an error if one of the hardware rfkill lines are active, and the
-caller asked for RFKILL_STATE_UNBLOCKED.
-
-2. Activates the soft rfkill line if the caller asked for state
-RFKILL_STATE_SOFT_BLOCKED.  It should do this even if one of the hard rfkill
-lines are active, effectively double-blocking the transmitter.
+The rfkill class is provided for kernel drivers to register their radio
+transmitter with the kernel, provide methods for turning it on and off and,
+optionally, letting the system know about hardware-disabled states that may
+be implemented on the device. This code is enabled with the CONFIG_RFKILL
+Kconfig option, which drivers can "select".
 
-3. Deactivates the soft rfkill line if none of the hardware rfkill lines are
-active and the caller asked for RFKILL_STATE_UNBLOCKED.
+The rfkill class code also notifies userspace of state changes, this is
+achieved via uevents. It also provides some sysfs files for userspace to
+check the status of radio transmitters. See the "Userspace support" section
+below.
 
-===============================================================================
-4: Kernel API
 
-To build a driver with rfkill subsystem support, the driver should depend on
-(or select) the Kconfig symbol RFKILL; it should _not_ depend on RKFILL_INPUT.
+The rfkill-input code implements a basic response to rfkill buttons -- it
+implements turning on/off all devices of a certain class (or all).
 
-The hardware the driver talks to may be write-only (where the current state
-of the hardware is unknown), or read-write (where the hardware can be queried
-about its current state).
+When the device is hard-blocked (either by a call to rfkill_set_hw_state()
+or from query_hw_block) then set_block() will not be invoked. When the device
+is hard-unblocked again, rfkill drivers need to take into account the return
+value from rfkill_set_hw_state() -- it indicates whether the device is still
+soft-blocked or not. Some devices can actually keep track of soft blocks,
+for those you can call rfkill_has_sw_block_memory() and will then get soft
+block notifications while hard-blocked.
 
-The rfkill class will call the get_state hook of a device every time it needs
-to know the *real* current state of the hardware.  This can happen often, but
-it does not do any polling, so it is not enough on hardware that is subject
-to state changes outside of the rfkill subsystem.
-
-Therefore, calling rfkill_force_state() when a state change happens is
-mandatory when the device has a hardware rfkill line, or when something else
-like the firmware could cause its state to be changed without going through the
-rfkill class.
-
-Some hardware provides events when its status changes.  In these cases, it is
-best for the driver to not provide a get_state hook, and instead register the
-rfkill class *already* with the correct status, and keep it updated using
-rfkill_force_state() when it gets an event from the hardware.
-
-rfkill_force_state() must be used on the device resume handlers to update the
-rfkill status, should there be any chance of the device status changing during
-the sleep.
-
-There is no provision for a statically-allocated rfkill struct.  You must
-use rfkill_allocate() to allocate one.
-
-You should:
-	- rfkill_allocate()
-	- modify rfkill fields (flags, name)
-	- modify state to the current hardware state (THIS IS THE ONLY TIME
-	  YOU CAN ACCESS state DIRECTLY)
-	- rfkill_register()
-
-The only way to set a device to the RFKILL_STATE_HARD_BLOCKED state is through
-a suitable return of get_state() or through rfkill_force_state().
-
-When a device is in the RFKILL_STATE_HARD_BLOCKED state, the only way to switch
-it to a different state is through a suitable return of get_state() or through
-rfkill_force_state().
-
-If toggle_radio() is called to set a device to state RFKILL_STATE_SOFT_BLOCKED
-when that device is already at the RFKILL_STATE_HARD_BLOCKED state, it should
-not return an error.  Instead, it should try to double-block the transmitter,
-so that its state will change from RFKILL_STATE_HARD_BLOCKED to
-RFKILL_STATE_SOFT_BLOCKED should the hardware blocking cease.
 
-Please refer to the source for more documentation.
+The entire functionality is spread over more than one subsystem:
 
-===============================================================================
-5: Userspace support
+ * The kernel input layer generates KEY_WWAN, KEY_WLAN etc. and
+   SW_RFKILL_ALL -- when the user presses a button. Drivers for radio
+   transmitters generally do not register to the input layer, unless the
+   device really provides an input device (i.e. a button that has no
+   effect other than generating a button press event)
 
-rfkill devices issue uevents (with an action of "change"), with the following
-environment variables set:
+ * The rfkill-input code hooks up to these events and switches the soft-block
+   of the various radio transmitters, depending on the button type.
 
-RFKILL_NAME
-RFKILL_STATE
-RFKILL_TYPE
+ * The rfkill drivers turn off/on their transmitters as requested.
 
-The ABI for these variables is defined by the sysfs attributes.  It is best
-to take a quick look at the source to make sure of the possible values.
+ * The rfkill class will generate userspace notifications (uevents) to tell
+   userspace what the current state is.
 
-It is expected that HAL will trap those, and bridge them to DBUS, etc.  These
-events CAN and SHOULD be used to give feedback to the user about the rfkill
-status of the system.
 
-Input devices may issue events that are related to rfkill.  These are the
-various KEY_* events and SW_* events supported by rfkill-input.c.
 
-Userspace may not change the state of an rfkill switch in response to an
-input event, it should refrain from changing states entirely.
+3. Kernel driver guidelines
 
-Userspace cannot assume it is the only source of control for rfkill switches.
-Their state can change due to firmware actions, direct user actions, and the
-rfkill-input EPO override for *_RFKILL_ALL.
 
-When rfkill-input is not active, userspace must initiate a rfkill status
-change by writing to the "state" attribute in order for anything to happen.
+Drivers for radio transmitters normally implement only the rfkill class.
+These drivers may not unblock the transmitter based on own decisions, they
+should act on information provided by the rfkill class only.
 
-Take particular care to implement EV_SW SW_RFKILL_ALL properly.  When that
-switch is set to OFF, *every* rfkill device *MUST* be immediately put into the
-RFKILL_STATE_SOFT_BLOCKED state, no questions asked.
+Platform drivers might implement input devices if the rfkill button is just
+that, a button. If that button influences the hardware then you need to
+implement an rfkill class instead. This also applies if the platform provides
+a way to turn on/off the transmitter(s).
 
-The following sysfs entries will be created:
+During suspend/hibernation, transmitters should only be left enabled when
+wake-on wlan or similar functionality requires it and the device wasn't
+blocked before suspend/hibernate. Note that it may be necessary to update
+the rfkill subsystem's idea of what the current state is at resume time if
+the state may have changed over suspend.
+
+
+
+4. Kernel API
+
+To build a driver with rfkill subsystem support, the driver should depend on
+(or select) the Kconfig symbol RFKILL.
+
+The hardware the driver talks to may be write-only (where the current state
+of the hardware is unknown), or read-write (where the hardware can be queried
+about its current state).
+
+Calling rfkill_set_hw_state() when a state change happens is required from
+rfkill drivers that control devices that can be hard-blocked unless they also
+assign the poll_hw_block() callback (then the rfkill core will poll the
+device). Don't do this unless you cannot get the event in any other way.
+
+
+
+5. Userspace support
+
+The following sysfs entries exist for every rfkill device:
 
 	name: Name assigned by driver to this key (interface or driver name).
 	type: Name of the key type ("wlan", "bluetooth", etc).
 	state: Current state of the transmitter
 		0: RFKILL_STATE_SOFT_BLOCKED
-			transmitter is forced off, but one can override it
-			by a write to the state attribute;
+			transmitter is turned off by software
 		1: RFKILL_STATE_UNBLOCKED
-			transmiter is NOT forced off, and may operate if
-			all other conditions for such operation are met
-			(such as interface is up and configured, etc);
+			transmiter is (potentially) active
 		2: RFKILL_STATE_HARD_BLOCKED
 			transmitter is forced off by something outside of
-			the driver's control.  One cannot set a device to
-			this state through writes to the state attribute;
-	claim: 1: Userspace handles events, 0: Kernel handles events
-
-Both the "state" and "claim" entries are also writable. For the "state" entry
-this means that when 1 or 0 is written, the device rfkill state (if not yet in
-the requested state), will be will be toggled accordingly.
-
-For the "claim" entry writing 1 to it means that the kernel no longer handles
-key events even though RFKILL_INPUT input was enabled. When "claim" has been
-set to 0, userspace should make sure that it listens for the input events or
-check the sysfs "state" entry regularly to correctly perform the required tasks
-when the rkfill key is pressed.
-
-A note about input devices and EV_SW events:
-
-In order to know the current state of an input device switch (like
-SW_RFKILL_ALL), you will need to use an IOCTL.  That information is not
-available through sysfs in a generic way at this time, and it is not available
-through the rfkill class AT ALL.
+			the driver's control.
+	claim: 0: Kernel handles events (currently always reads that value)
+
+rfkill devices also issue uevents (with an action of "change"), with the
+following environment variables set:
+
+RFKILL_NAME
+RFKILL_STATE
+RFKILL_TYPE
+
+The contents of these variables corresponds to the "name", "state" and
+"type" sysfs files explained above.
--- wireless-testing.orig/net/rfkill/Kconfig	2009-03-31 11:13:07.000000000 +0200
+++ wireless-testing/net/rfkill/Kconfig	2009-03-31 11:48:55.000000000 +0200
@@ -10,22 +10,8 @@ menuconfig RFKILL
 	  To compile this driver as a module, choose M here: the
 	  module will be called rfkill.
 
-config RFKILL_INPUT
-	tristate "Input layer to RF switch connector"
-	depends on RFKILL && INPUT
-	help
-	  Say Y here if you want kernel automatically toggle state
-	  of RF switches on and off when user presses appropriate
-	  button or a key on the keyboard. Without this module you
-	  need a some kind of userspace application to control
-	  state of the switches.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called rfkill-input.
-
 # LED trigger support
 config RFKILL_LEDS
 	bool
 	depends on RFKILL && LEDS_TRIGGERS
 	default y
-
--- wireless-testing.orig/net/rfkill/Makefile	2009-03-31 11:13:07.000000000 +0200
+++ wireless-testing/net/rfkill/Makefile	2009-03-31 11:48:55.000000000 +0200
@@ -2,5 +2,5 @@
 # Makefile for the RF switch subsystem.
 #
 
-obj-$(CONFIG_RFKILL)			+= rfkill.o
-obj-$(CONFIG_RFKILL_INPUT)		+= rfkill-input.o
+rfkill-y			+= core.o input.o
+obj-$(CONFIG_RFKILL)		+= rfkill.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/rfkill/core.c	2009-03-31 20:59:29.000000000 +0200
@@ -0,0 +1,780 @@
+/*
+ * Copyright (C) 2006 - 2007 Ivo van Doorn
+ * Copyright (C) 2007 Dmitry Torokhov
+ * Copyright 2009 Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the
+ * Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/workqueue.h>
+#include <linux/capability.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/rfkill.h>
+
+#include "rfkill.h"
+
+#define POLL_INTERVAL		(5 * HZ)
+
+struct rfkill {
+	const char		*name;
+	enum rfkill_type	type;
+
+	unsigned long		blocked;
+
+	bool			registered;
+	bool			has_sw_block_memory;
+
+	const struct rfkill_ops	*ops;
+	void			*data;
+
+#ifdef CONFIG_RFKILL_LEDS
+	struct led_trigger	led_trigger;
+	const char		*ledtrigname;
+#endif
+
+	struct device		dev;
+	struct list_head	node;
+
+	struct delayed_work	poll_work;
+	struct work_struct	uevent_work;
+};
+#define to_rfkill(d)	container_of(d, struct rfkill, dev)
+
+
+
+MODULE_AUTHOR("Ivo van Doorn <IvDoorn@gmail.com>");
+MODULE_AUTHOR("Johannes Berg <johannes@sipsolutions.net>");
+MODULE_DESCRIPTION("RF switch support");
+MODULE_LICENSE("GPL");
+
+
+static LIST_HEAD(rfkill_list);	/* list of registered rf switches */
+static DEFINE_MUTEX(rfkill_global_mutex);
+
+static unsigned int rfkill_default_state = 1;
+module_param_named(default_state, rfkill_default_state, uint, 0444);
+MODULE_PARM_DESC(default_state,
+		 "Default initial state for all radio types, 0 = radio off");
+
+static struct {
+	bool cur, def;
+} rfkill_global_states[NUM_RFKILL_TYPES];
+
+static unsigned long rfkill_states_default_locked;
+
+static bool rfkill_epo_lock_active;
+
+
+#ifdef CONFIG_RFKILL_LEDS
+static void rfkill_led_trigger_activate(struct led_classdev *led)
+{
+	struct rfkill *rfkill;
+	struct led_trigger *trigger;
+
+	rfkill = container_of(led->trigger, struct rfkill, led_trigger);
+	trigger = &rfkill->led_trigger;
+
+	if (rfkill->blocked)
+		led_trigger_event(trigger, LED_OFF);
+	else
+		led_trigger_event(trigger, LED_FULL);
+}
+
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
+static int rfkill_led_trigger_register(struct rfkill *rfkill)
+{
+	rfkill->led_trigger.name = rfkill->ledtrigname
+					? : dev_name(&rfkill->dev);
+	rfkill->led_trigger.activate = rfkill_led_trigger_activate;
+	return led_trigger_register(&rfkill->led_trigger);
+}
+
+static void rfkill_led_trigger_unregister(struct rfkill *rfkill)
+{
+	led_trigger_unregister(&rfkill->led_trigger);
+}
+#else
+static inline int rfkill_led_trigger_register(struct rfkill *rfkill)
+{
+	return 0;
+}
+
+static inline void rfkill_led_trigger_unregister(struct rfkill *rfkill)
+{
+}
+#endif /* CONFIG_RFKILL_LEDS */
+
+static void rfkill_uevent(struct rfkill *rfkill)
+{
+	if (!rfkill->registered)
+		return;
+
+	kobject_uevent(&rfkill->dev.kobj, KOBJ_CHANGE);
+}
+
+static bool __rfkill_set_hw_state(struct rfkill *rfkill,
+				  bool blocked, bool *change)
+{
+	bool prev;
+
+	BUG_ON(!rfkill);
+
+	if (blocked)
+		prev = !!test_and_set_bit(RFKILL_BLOCK_HW_BIT,
+					  &rfkill->blocked);
+	else
+		prev = !!test_and_clear_bit(RFKILL_BLOCK_HW_BIT,
+					    &rfkill->blocked);
+
+	*change = prev != blocked;
+
+	return blocked || !!test_bit(RFKILL_BLOCK_SW_BIT, &rfkill->blocked);
+}
+
+/**
+ * rfkill_set_block - wrapper for set_block method
+ *
+ * @rfkill: the rfkill struct to use
+ * @blocked: the new software state
+ *
+ * Calls the set_block method (when applicable) and handles notifications
+ * etc. as well.
+ */
+static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
+{
+	bool prev, change;
+
+	/*
+	 * Some platforms (...!) generate input events which affect the
+	 * _hard_ kill state -- whenever something tries to change the
+	 * current software state query the hardware state too.
+	 */
+	if (rfkill->ops->query_hw_block) {
+		__rfkill_set_hw_state(
+			rfkill,
+			rfkill->ops->query_hw_block(rfkill->data),
+			&change);
+		if (change)
+			rfkill_uevent(rfkill);
+	}
+
+	if (blocked)
+		prev = !!test_and_set_bit(RFKILL_BLOCK_SW_BIT,
+					  &rfkill->blocked);
+	else
+		prev = !!test_and_clear_bit(RFKILL_BLOCK_SW_BIT,
+					    &rfkill->blocked);
+
+	/*
+	 * HW already blocked, so nothing changes for now
+	 * (unless device has memory for software blocks)
+	 */
+	if (!rfkill->has_sw_block_memory &&
+	    test_bit(RFKILL_BLOCK_HW_BIT, &rfkill->blocked))
+		return;
+
+	if (unlikely(rfkill->dev.power.power_state.event & PM_EVENT_SLEEP))
+		return;
+
+	if (rfkill->ops->set_block(rfkill->data, blocked)) {
+		/* failed -- reset status */
+		if (prev)
+			set_bit(RFKILL_BLOCK_SW_BIT, &rfkill->blocked);
+		else
+			clear_bit(RFKILL_BLOCK_SW_BIT, &rfkill->blocked);
+	}
+
+	rfkill_uevent(rfkill);
+}
+
+/**
+ * __rfkill_switch_all - Toggle state of all switches of given type
+ * @type: type of interfaces to be affected
+ * @state: the new state
+ *
+ * This function sets the state of all switches of given type,
+ * unless a specific switch is claimed by userspace (in which case,
+ * that switch is left alone) or suspended.
+ *
+ * Caller must have acquired rfkill_global_mutex.
+ */
+static void __rfkill_switch_all(const enum rfkill_type type, bool blocked)
+{
+	struct rfkill *rfkill;
+
+	rfkill_global_states[type].cur = blocked;
+	list_for_each_entry(rfkill, &rfkill_list, node) {
+		if (rfkill->type != type)
+			continue;
+
+		rfkill_set_block(rfkill, blocked);
+	}
+}
+
+/**
+ * rfkill_switch_all - Toggle state of all switches of given type
+ * @type: type of interfaces to be affected
+ * @state: the new state
+ *
+ * Acquires rfkill_global_mutex and calls __rfkill_switch_all(@type, @state).
+ * Please refer to __rfkill_switch_all() for details.
+ *
+ * Does nothing if the EPO lock is active.
+ */
+void rfkill_switch_all(enum rfkill_type type, bool blocked)
+{
+	mutex_lock(&rfkill_global_mutex);
+
+	if (!rfkill_epo_lock_active)
+		__rfkill_switch_all(type, blocked);
+
+	mutex_unlock(&rfkill_global_mutex);
+}
+EXPORT_SYMBOL(rfkill_switch_all);
+
+/**
+ * rfkill_epo - emergency power off all transmitters
+ *
+ * This kicks all non-suspended rfkill devices to RFKILL_STATE_SOFT_BLOCKED,
+ * ignoring everything in its path but rfkill_global_mutex and rfkill->mutex.
+ *
+ * The global state before the EPO is saved and can be restored later
+ * using rfkill_restore_states().
+ */
+void rfkill_epo(void)
+{
+	struct rfkill *rfkill;
+	int i;
+
+	mutex_lock(&rfkill_global_mutex);
+
+	rfkill_epo_lock_active = true;
+	list_for_each_entry(rfkill, &rfkill_list, node)
+		rfkill_set_block(rfkill, true);
+
+	for (i = 0; i < NUM_RFKILL_TYPES; i++) {
+		rfkill_global_states[i].def = rfkill_global_states[i].cur;
+		rfkill_global_states[i].cur = true;
+	}
+	mutex_unlock(&rfkill_global_mutex);
+}
+
+/**
+ * rfkill_restore_states - restore global states
+ *
+ * Restore (and sync switches to) the global state from the
+ * states in rfkill_default_states.  This can undo the effects of
+ * a call to rfkill_epo().
+ */
+void rfkill_restore_states(void)
+{
+	int i;
+
+	mutex_lock(&rfkill_global_mutex);
+
+	rfkill_epo_lock_active = false;
+	for (i = 0; i < NUM_RFKILL_TYPES; i++)
+		__rfkill_switch_all(i, rfkill_global_states[i].def);
+	mutex_unlock(&rfkill_global_mutex);
+}
+
+/**
+ * rfkill_remove_epo_lock - unlock state changes
+ *
+ * Used by rfkill-input manually unlock state changes, when
+ * the EPO switch is deactivated.
+ */
+void rfkill_remove_epo_lock(void)
+{
+	mutex_lock(&rfkill_global_mutex);
+	rfkill_epo_lock_active = false;
+	mutex_unlock(&rfkill_global_mutex);
+}
+
+/**
+ * rfkill_is_epo_lock_active - returns true EPO is active
+ *
+ * Returns 0 (false) if there is NOT an active EPO contidion,
+ * and 1 (true) if there is an active EPO contition, which
+ * locks all radios in one of the BLOCKED states.
+ *
+ * Can be called in atomic context.
+ */
+bool rfkill_is_epo_lock_active(void)
+{
+	return rfkill_epo_lock_active;
+}
+
+/**
+ * rfkill_get_global_sw_state - returns global state for a type
+ * @type: the type to get the global state of
+ *
+ * Returns the current global state for a given wireless
+ * device type.
+ */
+bool rfkill_get_global_sw_state(const enum rfkill_type type)
+{
+	return rfkill_global_states[type].cur;
+}
+
+void rfkill_set_global_sw_state(const enum rfkill_type type, bool blocked)
+{
+	mutex_lock(&rfkill_global_mutex);
+
+	/* don't allow unblock when epo */
+	if (rfkill_epo_lock_active && !blocked)
+		goto out;
+
+	/* too late */
+	if (rfkill_states_default_locked & BIT(type))
+		goto out;
+
+	rfkill_states_default_locked |= BIT(type);
+
+	rfkill_global_states[type].cur = blocked;
+	rfkill_global_states[type].def = blocked;
+ out:
+	mutex_unlock(&rfkill_global_mutex);
+}
+EXPORT_SYMBOL(rfkill_set_global_sw_state);
+
+
+bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
+{
+	bool ret, change;
+
+	ret = __rfkill_set_hw_state(rfkill, blocked, &change);
+
+	if (change)
+		schedule_work(&rfkill->uevent_work);
+
+	return ret;
+}
+EXPORT_SYMBOL(rfkill_set_hw_state);
+
+bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
+{
+	bool prev, hwblock;
+
+	BUG_ON(!rfkill);
+
+	if (blocked)
+		prev = !!test_and_set_bit(RFKILL_BLOCK_SW_BIT,
+					  &rfkill->blocked);
+	else
+		prev = !!test_and_clear_bit(RFKILL_BLOCK_SW_BIT,
+					    &rfkill->blocked);
+
+	hwblock = !!test_bit(RFKILL_BLOCK_HW_BIT, &rfkill->blocked);
+
+	if (prev != blocked && !hwblock)
+		schedule_work(&rfkill->uevent_work);
+
+	return blocked || hwblock;
+}
+EXPORT_SYMBOL(rfkill_set_sw_state);
+
+static ssize_t rfkill_name_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
+
+	return sprintf(buf, "%s\n", rfkill->name);
+}
+
+static const char *rfkill_get_type_str(enum rfkill_type type)
+{
+	switch (type) {
+	case RFKILL_TYPE_WLAN:
+		return "wlan";
+	case RFKILL_TYPE_BLUETOOTH:
+		return "bluetooth";
+	case RFKILL_TYPE_UWB:
+		return "ultrawideband";
+	case RFKILL_TYPE_WIMAX:
+		return "wimax";
+	case RFKILL_TYPE_WWAN:
+		return "wwan";
+	default:
+		BUG();
+	}
+
+	BUILD_BUG_ON(NUM_RFKILL_TYPES != RFKILL_TYPE_WWAN + 1);
+}
+
+static ssize_t rfkill_type_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
+
+	return sprintf(buf, "%s\n", rfkill_get_type_str(rfkill->type));
+}
+
+static u8 user_state_from_blocked(unsigned long *blocked)
+{
+	if (test_bit(RFKILL_BLOCK_HW_BIT, blocked))
+		return RFKILL_USER_STATE_HARD_BLOCKED;
+	if (test_bit(RFKILL_BLOCK_SW_BIT, blocked))
+		return RFKILL_USER_STATE_SOFT_BLOCKED;
+
+	return RFKILL_USER_STATE_UNBLOCKED;
+}
+
+static ssize_t rfkill_state_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
+
+	return sprintf(buf, "%d\n", user_state_from_blocked(&rfkill->blocked));
+}
+
+static ssize_t rfkill_state_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	/*
+	 * The intention was that userspace can only take control over
+	 * a given device when/if rfkill-input doesn't control it due
+	 * to user_claim. Since user_claim is currently unsupported,
+	 * we never support changing the state from userspace -- this
+	 * can be implemented again later.
+	 */
+
+	return -EPERM;
+}
+
+static ssize_t rfkill_claim_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	return sprintf(buf, "%d\n", 0);
+}
+
+static ssize_t rfkill_claim_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	return -EOPNOTSUPP;
+}
+
+static struct device_attribute rfkill_dev_attrs[] = {
+	__ATTR(name, S_IRUGO, rfkill_name_show, NULL),
+	__ATTR(type, S_IRUGO, rfkill_type_show, NULL),
+	__ATTR(state, S_IRUGO|S_IWUSR, rfkill_state_show, rfkill_state_store),
+	__ATTR(claim, S_IRUGO|S_IWUSR, rfkill_claim_show, rfkill_claim_store),
+	__ATTR_NULL
+};
+
+static void rfkill_release(struct device *dev)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
+
+	kfree(rfkill);
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
+			       rfkill_get_type_str(rfkill->type));
+	if (error)
+		return error;
+	error = add_uevent_var(env, "RFKILL_STATE=%d",
+			       user_state_from_blocked(&rfkill->blocked));
+	return error;
+}
+
+void rfkill_pause_polling(struct rfkill *rfkill)
+{
+	BUG_ON(!rfkill);
+
+	if (!rfkill->ops->poll_hw_block)
+		return;
+
+	cancel_delayed_work_sync(&rfkill->poll_work);
+}
+EXPORT_SYMBOL(rfkill_pause_polling);
+
+void rfkill_resume_polling(struct rfkill *rfkill)
+{
+	BUG_ON(!rfkill);
+
+	if (!rfkill->ops->poll_hw_block)
+		return;
+
+	schedule_work(&rfkill->poll_work.work);
+}
+EXPORT_SYMBOL(rfkill_resume_polling);
+
+static int rfkill_suspend(struct device *dev, pm_message_t state)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
+
+	rfkill_pause_polling(rfkill);
+
+	return 0;
+}
+
+static int rfkill_resume(struct device *dev)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
+
+	rfkill_resume_polling(rfkill);
+
+	return 0;
+}
+
+static struct class rfkill_class = {
+	.name		= "rfkill",
+	.dev_release	= rfkill_release,
+	.dev_attrs	= rfkill_dev_attrs,
+	.dev_uevent	= rfkill_dev_uevent,
+	.suspend	= rfkill_suspend,
+	.resume		= rfkill_resume,
+};
+
+
+struct rfkill * __must_check rfkill_alloc(const char *name,
+					  struct device *parent,
+					  const enum rfkill_type type,
+					  const struct rfkill_ops *ops,
+					  void *ops_data)
+{
+	struct rfkill *rfkill;
+	struct device *dev;
+
+	if (WARN_ON(!ops))
+		return NULL;
+
+	if (WARN_ON(!ops->set_block))
+		return NULL;
+
+	if (WARN_ON(!name))
+		return NULL;
+
+	if (WARN_ON(type >= NUM_RFKILL_TYPES))
+		return NULL;
+
+	rfkill = kzalloc(sizeof(*rfkill), GFP_KERNEL);
+	if (!rfkill)
+		return NULL;
+
+	INIT_LIST_HEAD(&rfkill->node);
+	rfkill->type = type;
+	rfkill->name = name;
+	rfkill->ops = ops;
+	rfkill->data = ops_data;
+
+	dev = &rfkill->dev;
+	dev->class = &rfkill_class;
+	dev->parent = parent;
+	device_initialize(dev);
+
+	return rfkill;
+}
+EXPORT_SYMBOL(rfkill_alloc);
+
+static void rfkill_poll(struct work_struct *work)
+{
+	struct rfkill *rfkill;
+	bool change, hwblocked;
+
+	rfkill = container_of(work, struct rfkill, poll_work.work);
+
+	/* poll hardware state */
+	hwblocked = rfkill->ops->poll_hw_block(rfkill->data);
+
+	/*
+	 * Set hardware state and tell driver to unblock if
+	 * it wasn't software-blocked -- driver doesn't need
+	 * to keep track of the current software block state
+	 * that way.
+	 * If that fails set the software block bit.
+	 */
+	if (!__rfkill_set_hw_state(rfkill, hwblocked, &change))
+		if (rfkill->ops->set_block(rfkill->data, false)) {
+			change = true;
+			set_bit(RFKILL_BLOCK_SW_BIT, &rfkill->blocked);
+		}
+
+	if (change)
+		rfkill_uevent(rfkill);
+
+	schedule_delayed_work(&rfkill->poll_work,
+		round_jiffies_relative(POLL_INTERVAL));
+}
+
+static void rfkill_uevent_work(struct work_struct *work)
+{
+	struct rfkill *rfkill;
+
+	rfkill = container_of(work, struct rfkill, uevent_work);
+
+	rfkill_uevent(rfkill);
+}
+
+void rfkill_has_sw_block_memory(struct rfkill *rfkill)
+{
+	BUG_ON(!rfkill);
+	BUG_ON(rfkill->registered);
+
+	rfkill->has_sw_block_memory = true;
+}
+EXPORT_SYMBOL(rfkill_has_sw_block_memory);
+
+int __must_check rfkill_register(struct rfkill *rfkill)
+{
+	static unsigned long rfkill_no = 0;
+	struct device *dev = &rfkill->dev;
+	int error;
+
+	BUG_ON(!rfkill);
+
+	mutex_lock(&rfkill_global_mutex);
+
+	if (rfkill->registered) {
+		error = -EALREADY;
+		goto unlock;
+	}
+
+	dev_set_name(dev, "rfkill%lu", rfkill_no);
+	rfkill_no++;
+
+	if (!(rfkill_states_default_locked & BIT(rfkill->type))) {
+		/* first of its kind */
+		BUILD_BUG_ON(NUM_RFKILL_TYPES >
+			sizeof(rfkill_states_default_locked) * 8);
+		rfkill_states_default_locked |= BIT(rfkill->type);
+		rfkill_global_states[rfkill->type].cur =
+			rfkill_global_states[rfkill->type].def;
+	}
+
+	list_add_tail(&rfkill->node, &rfkill_list);
+
+	error = device_add(dev);
+	if (error)
+		goto remove;
+
+	error = rfkill_led_trigger_register(rfkill);
+	if (error)
+		goto devdel;
+
+	rfkill->registered = true;
+
+	if (rfkill->ops->poll_hw_block) {
+		INIT_DELAYED_WORK(&rfkill->poll_work, rfkill_poll);
+		schedule_delayed_work(&rfkill->poll_work,
+			round_jiffies_relative(POLL_INTERVAL));
+	}
+
+	INIT_WORK(&rfkill->uevent_work, rfkill_uevent_work);
+
+	rfkill_set_block(rfkill, rfkill_global_states[rfkill->type].cur);
+
+	mutex_unlock(&rfkill_global_mutex);
+	return 0;
+
+ devdel:
+	device_del(&rfkill->dev);
+ remove:
+	list_del_init(&rfkill->node);
+ unlock:
+ 	mutex_unlock(&rfkill_global_mutex);
+	return error;
+}
+EXPORT_SYMBOL(rfkill_register);
+
+void rfkill_unregister(struct rfkill *rfkill)
+{
+	BUG_ON(!rfkill);
+
+	if (rfkill->ops->poll_hw_block)
+		cancel_delayed_work_sync(&rfkill->poll_work);
+
+	cancel_work_sync(&rfkill->uevent_work);
+
+	rfkill->registered = false;
+
+	device_del(&rfkill->dev);
+
+	mutex_lock(&rfkill_global_mutex);
+	list_del_init(&rfkill->node);
+	mutex_unlock(&rfkill_global_mutex);
+
+	rfkill_led_trigger_unregister(rfkill);
+}
+EXPORT_SYMBOL(rfkill_unregister);
+
+void rfkill_destroy(struct rfkill *rfkill)
+{
+	if (rfkill)
+		put_device(&rfkill->dev);
+}
+EXPORT_SYMBOL(rfkill_destroy);
+
+
+static int __init rfkill_init(void)
+{
+	int error;
+	int i;
+
+	for (i = 0; i < NUM_RFKILL_TYPES; i++)
+		rfkill_global_states[i].def = !rfkill_default_state;
+
+	error = class_register(&rfkill_class);
+	if (error)
+		goto out;
+
+	error = rfkill_handler_init();
+	if (error)
+		class_unregister(&rfkill_class);
+
+ out:
+	return error;
+}
+subsys_initcall(rfkill_init);
+
+static void __exit rfkill_exit(void)
+{
+	rfkill_handler_exit();
+	class_unregister(&rfkill_class);
+}
+module_exit(rfkill_exit);
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/rfkill/input.c	2009-03-31 15:28:20.000000000 +0200
@@ -0,0 +1,342 @@
+/*
+ * Input layer to RF Kill interface connector
+ *
+ * Copyright (c) 2007 Dmitry Torokhov
+ * Copyright 2009 Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * If you ever run into a situation in which you have a SW_ type rfkill
+ * input device, then you can revive code that was removed in the patch
+ * "rfkill-input: remove unused code".
+ */
+
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/init.h>
+#include <linux/rfkill.h>
+#include <linux/sched.h>
+
+#include "rfkill.h"
+
+enum rfkill_input_master_mode {
+	RFKILL_INPUT_MASTER_UNLOCK = 0,
+	RFKILL_INPUT_MASTER_RESTORE = 1,
+	RFKILL_INPUT_MASTER_UNBLOCKALL = 2,
+	NUM_RFKILL_INPUT_MASTER_MODES
+};
+
+/* Delay (in ms) between consecutive switch ops */
+#define RFKILL_OPS_DELAY 200
+
+static enum rfkill_input_master_mode rfkill_master_switch_mode =
+					RFKILL_INPUT_MASTER_UNBLOCKALL;
+module_param_named(master_switch_mode, rfkill_master_switch_mode, uint, 0);
+MODULE_PARM_DESC(master_switch_mode,
+	"SW_RFKILL_ALL ON should: 0=do nothing (only unlock); 1=restore; 2=unblock all");
+
+static spinlock_t rfkill_op_lock;
+static bool rfkill_op_pending;
+static unsigned long rfkill_sw_pending[BITS_TO_LONGS(NUM_RFKILL_TYPES)];
+static unsigned long rfkill_sw_state[BITS_TO_LONGS(NUM_RFKILL_TYPES)];
+
+enum rfkill_sched_op {
+	RFKILL_GLOBAL_OP_EPO = 0,
+	RFKILL_GLOBAL_OP_RESTORE,
+	RFKILL_GLOBAL_OP_UNLOCK,
+	RFKILL_GLOBAL_OP_UNBLOCK,
+};
+
+static enum rfkill_sched_op rfkill_master_switch_op;
+static enum rfkill_sched_op rfkill_op;
+
+static void __rfkill_handle_global_op(enum rfkill_sched_op op)
+{
+	unsigned int i;
+
+	switch (op) {
+	case RFKILL_GLOBAL_OP_EPO:
+		rfkill_epo();
+		break;
+	case RFKILL_GLOBAL_OP_RESTORE:
+		rfkill_restore_states();
+		break;
+	case RFKILL_GLOBAL_OP_UNLOCK:
+		rfkill_remove_epo_lock();
+		break;
+	case RFKILL_GLOBAL_OP_UNBLOCK:
+		rfkill_remove_epo_lock();
+		for (i = 0; i < NUM_RFKILL_TYPES; i++)
+			rfkill_switch_all(i, false);
+		break;
+	default:
+		/* memory corruption or bug, fail safely */
+		rfkill_epo();
+		WARN(1, "Unknown requested operation %d! "
+			"rfkill Emergency Power Off activated\n",
+			op);
+	}
+}
+
+static void __rfkill_handle_normal_op(const enum rfkill_type type,
+				      const bool complement)
+{
+	bool blocked;
+
+	blocked = rfkill_get_global_sw_state(type);
+	if (complement)
+		blocked = !blocked;
+
+	rfkill_switch_all(type, blocked);
+}
+
+static void rfkill_op_handler(struct work_struct *work)
+{
+	unsigned int i;
+	bool c;
+
+	spin_lock_irq(&rfkill_op_lock);
+	do {
+		if (rfkill_op_pending) {
+			enum rfkill_sched_op op = rfkill_op;
+			rfkill_op_pending = false;
+			memset(rfkill_sw_pending, 0,
+				sizeof(rfkill_sw_pending));
+			spin_unlock_irq(&rfkill_op_lock);
+
+			__rfkill_handle_global_op(op);
+
+			spin_lock_irq(&rfkill_op_lock);
+
+			/*
+			 * handle global ops first -- during unlocked period
+			 * we might have gotten a new global op.
+			 */
+			if (rfkill_op_pending)
+				continue;
+		}
+
+		if (rfkill_is_epo_lock_active())
+			continue;
+
+		for (i = 0; i < NUM_RFKILL_TYPES; i++) {
+			if (!__test_and_clear_bit(i, rfkill_sw_pending))
+				break;
+			c = __test_and_clear_bit(i, rfkill_sw_state);
+			spin_unlock_irq(&rfkill_op_lock);
+
+			__rfkill_handle_normal_op(i, c);
+
+			spin_lock_irq(&rfkill_op_lock);
+		}
+	} while (rfkill_op_pending);
+	spin_unlock_irq(&rfkill_op_lock);
+}
+
+static DECLARE_DELAYED_WORK(rfkill_op_work, rfkill_op_handler);
+static unsigned long rfkill_last_scheduled;
+
+static unsigned long rfkill_ratelimit(const unsigned long last)
+{
+	const unsigned long delay = msecs_to_jiffies(RFKILL_OPS_DELAY);
+	return (time_after(jiffies, last + delay)) ? 0 : delay;
+}
+
+static void rfkill_schedule_ratelimited(void)
+{
+	if (delayed_work_pending(&rfkill_op_work))
+		return;
+	schedule_delayed_work(&rfkill_op_work,
+			      rfkill_ratelimit(rfkill_last_scheduled));
+	rfkill_last_scheduled = jiffies;
+}
+
+static void rfkill_schedule_global_op(enum rfkill_sched_op op)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rfkill_op_lock, flags);
+	rfkill_op = op;
+	rfkill_op_pending = true;
+	if (op == RFKILL_GLOBAL_OP_EPO && !rfkill_is_epo_lock_active()) {
+		/* bypass the limiter for EPO */
+		cancel_delayed_work(&rfkill_op_work);
+		schedule_delayed_work(&rfkill_op_work, 0);
+		rfkill_last_scheduled = jiffies;
+	} else
+		rfkill_schedule_ratelimited();
+	spin_unlock_irqrestore(&rfkill_op_lock, flags);
+}
+
+static void rfkill_schedule_toggle(enum rfkill_type type)
+{
+	unsigned long flags;
+
+	if (rfkill_is_epo_lock_active())
+		return;
+
+	spin_lock_irqsave(&rfkill_op_lock, flags);
+	if (!rfkill_op_pending) {
+		__set_bit(type, rfkill_sw_pending);
+		__change_bit(type, rfkill_sw_state);
+		rfkill_schedule_ratelimited();
+	}
+	spin_unlock_irqrestore(&rfkill_op_lock, flags);
+}
+
+static void rfkill_schedule_evsw_rfkillall(int state)
+{
+	if (state)
+		rfkill_schedule_global_op(rfkill_master_switch_op);
+	else
+		rfkill_schedule_global_op(RFKILL_GLOBAL_OP_EPO);
+}
+
+static void rfkill_event(struct input_handle *handle, unsigned int type,
+			unsigned int code, int data)
+{
+	if (type == EV_KEY && data == 1) {
+		switch (code) {
+		case KEY_WLAN:
+			rfkill_schedule_toggle(RFKILL_TYPE_WLAN);
+			break;
+		case KEY_BLUETOOTH:
+			rfkill_schedule_toggle(RFKILL_TYPE_BLUETOOTH);
+			break;
+		case KEY_UWB:
+			rfkill_schedule_toggle(RFKILL_TYPE_UWB);
+			break;
+		case KEY_WIMAX:
+			rfkill_schedule_toggle(RFKILL_TYPE_WIMAX);
+			break;
+		}
+	} else if (type == EV_SW && code == SW_RFKILL_ALL)
+		rfkill_schedule_evsw_rfkillall(data);
+}
+
+static int rfkill_connect(struct input_handler *handler, struct input_dev *dev,
+			  const struct input_device_id *id)
+{
+	struct input_handle *handle;
+	int error;
+
+	handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	handle->dev = dev;
+	handle->handler = handler;
+	handle->name = "rfkill";
+
+	/* causes rfkill_start() to be called */
+	error = input_register_handle(handle);
+	if (error)
+		goto err_free_handle;
+
+	error = input_open_device(handle);
+	if (error)
+		goto err_unregister_handle;
+
+	return 0;
+
+ err_unregister_handle:
+	input_unregister_handle(handle);
+ err_free_handle:
+	kfree(handle);
+	return error;
+}
+
+static void rfkill_start(struct input_handle *handle)
+{
+	/*
+	 * Take event_lock to guard against configuration changes, we
+	 * should be able to deal with concurrency with rfkill_event()
+	 * just fine (which event_lock will also avoid).
+	 */
+	spin_lock_irq(&handle->dev->event_lock);
+
+	if (test_bit(EV_SW, handle->dev->evbit) &&
+	    test_bit(SW_RFKILL_ALL, handle->dev->swbit))
+		rfkill_schedule_evsw_rfkillall(test_bit(SW_RFKILL_ALL,
+							handle->dev->sw));
+
+	spin_unlock_irq(&handle->dev->event_lock);
+}
+
+static void rfkill_disconnect(struct input_handle *handle)
+{
+	input_close_device(handle);
+	input_unregister_handle(handle);
+	kfree(handle);
+}
+
+static const struct input_device_id rfkill_ids[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
+		.evbit = { BIT_MASK(EV_KEY) },
+		.keybit = { [BIT_WORD(KEY_WLAN)] = BIT_MASK(KEY_WLAN) },
+	},
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
+		.evbit = { BIT_MASK(EV_KEY) },
+		.keybit = { [BIT_WORD(KEY_BLUETOOTH)] = BIT_MASK(KEY_BLUETOOTH) },
+	},
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
+		.evbit = { BIT_MASK(EV_KEY) },
+		.keybit = { [BIT_WORD(KEY_UWB)] = BIT_MASK(KEY_UWB) },
+	},
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
+		.evbit = { BIT_MASK(EV_KEY) },
+		.keybit = { [BIT_WORD(KEY_WIMAX)] = BIT_MASK(KEY_WIMAX) },
+	},
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_SWBIT,
+		.evbit = { BIT(EV_SW) },
+		.swbit = { [BIT_WORD(SW_RFKILL_ALL)] = BIT_MASK(SW_RFKILL_ALL) },
+	},
+	{ }
+};
+
+static struct input_handler rfkill_handler = {
+	.name =	"rfkill",
+	.event = rfkill_event,
+	.connect = rfkill_connect,
+	.start = rfkill_start,
+	.disconnect = rfkill_disconnect,
+	.id_table = rfkill_ids,
+};
+
+int __init rfkill_handler_init(void)
+{
+	switch (rfkill_master_switch_mode) {
+	case RFKILL_INPUT_MASTER_UNBLOCKALL:
+		rfkill_master_switch_op = RFKILL_GLOBAL_OP_UNBLOCK;
+		break;
+	case RFKILL_INPUT_MASTER_RESTORE:
+		rfkill_master_switch_op = RFKILL_GLOBAL_OP_RESTORE;
+		break;
+	case RFKILL_INPUT_MASTER_UNLOCK:
+		rfkill_master_switch_op = RFKILL_GLOBAL_OP_UNLOCK;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	spin_lock_init(&rfkill_op_lock);
+
+	/* Avoid delay at first schedule */
+	rfkill_last_scheduled =
+			jiffies - msecs_to_jiffies(RFKILL_OPS_DELAY) - 1;
+	return input_register_handler(&rfkill_handler);
+}
+
+void __exit rfkill_handler_exit(void)
+{
+	input_unregister_handler(&rfkill_handler);
+	cancel_delayed_work_sync(&rfkill_op_work);
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/rfkill/rfkill.h	2009-03-31 11:48:55.000000000 +0200
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2007 Ivo van Doorn
+ * Copyright 2009 Johannes Berg <johannes@sipsolutions.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#ifndef __RFKILL_INPUT_H
+#define __RFKILL_INPUT_H
+
+/* core code */
+void rfkill_switch_all(const enum rfkill_type type, bool blocked);
+void rfkill_epo(void);
+void rfkill_restore_states(void);
+void rfkill_remove_epo_lock(void);
+bool rfkill_is_epo_lock_active(void);
+bool rfkill_get_global_sw_state(const enum rfkill_type type);
+
+/* input handler */
+int rfkill_handler_init(void);
+void rfkill_handler_exit(void);
+
+#endif /* __RFKILL_INPUT_H */
--- wireless-testing.orig/MAINTAINERS	2009-03-31 11:13:09.000000000 +0200
+++ wireless-testing/MAINTAINERS	2009-03-31 11:48:55.000000000 +0200
@@ -3667,9 +3667,9 @@ L:	reiserfs-devel@vger.kernel.org
 S:	Supported
 
 RFKILL
-P:	Ivo van Doorn
-M:	IvDoorn@gmail.com
-L:	netdev@vger.kernel.org
+P:	Johannes Berg
+M:	johannes@sipsolutions.net
+L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	net/rfkill
 
--- wireless-testing.orig/include/linux/Kbuild	2009-03-31 11:13:09.000000000 +0200
+++ wireless-testing/include/linux/Kbuild	2009-03-31 11:48:55.000000000 +0200
@@ -310,6 +310,7 @@ unifdef-y += ptrace.h
 unifdef-y += qnx4_fs.h
 unifdef-y += quota.h
 unifdef-y += random.h
+unifdef-y += rfkill.h
 unifdef-y += irqnr.h
 unifdef-y += reboot.h
 unifdef-y += reiserfs_fs.h
--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-03-31 11:13:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-03-31 11:48:55.000000000 +0200
@@ -486,12 +486,9 @@ struct ath_led {
 	bool registered;
 };
 
-/* Rfkill */
-#define ATH_RFKILL_POLL_INTERVAL	2000 /* msecs */
-
 struct ath_rfkill {
 	struct rfkill *rfkill;
-	struct delayed_work rfkill_poll;
+	struct rfkill_ops ops;
 	char rfkill_name[32];
 };
 
@@ -536,8 +533,6 @@ struct ath_rfkill {
 #define SC_OP_RXFLUSH           BIT(8)
 #define SC_OP_LED_ASSOCIATED    BIT(9)
 #define SC_OP_RFKILL_REGISTERED BIT(10)
-#define SC_OP_RFKILL_SW_BLOCKED BIT(11)
-#define SC_OP_RFKILL_HW_BLOCKED BIT(12)
 #define SC_OP_WAIT_FOR_BEACON   BIT(13)
 #define SC_OP_LED_ON            BIT(14)
 #define SC_OP_SCANNING          BIT(15)
--- wireless-testing.orig/drivers/net/wireless/ath9k/pci.c	2009-03-31 11:13:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/pci.c	2009-03-31 11:48:55.000000000 +0200
@@ -227,11 +227,6 @@ static int ath_pci_suspend(struct pci_de
 
 	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
-#endif
-
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
@@ -256,16 +251,6 @@ static int ath_pci_resume(struct pci_dev
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	/*
-	 * check the h/w rfkill state on resume
-	 * and start the rfkill poll timer
-	 */
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		queue_delayed_work(sc->hw->workqueue,
-				   &sc->rf_kill.rfkill_poll, 0);
-#endif
-
 	return 0;
 }
 
--- wireless-testing.orig/drivers/net/wireless/b43/Kconfig	2009-03-31 11:48:45.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/Kconfig	2009-03-31 11:48:55.000000000 +0200
@@ -103,7 +103,7 @@ config B43_LEDS
 # if it's possible.
 config B43_RFKILL
 	bool
-	depends on B43 && (RFKILL = y || RFKILL = B43) && RFKILL_INPUT && (INPUT_POLLDEV = y || INPUT_POLLDEV = B43)
+	depends on B43 && (RFKILL = y || RFKILL = B43)
 	default y
 
 config B43_DEBUG
--- wireless-testing.orig/drivers/net/wireless/b43/rfkill.h	2009-03-31 11:13:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/rfkill.h	2009-03-31 11:48:55.000000000 +0200
@@ -7,14 +7,11 @@ struct b43_wldev;
 #ifdef CONFIG_B43_RFKILL
 
 #include <linux/rfkill.h>
-#include <linux/input-polldev.h>
 
 
 struct b43_rfkill {
 	/* The RFKILL subsystem data structure */
 	struct rfkill *rfkill;
-	/* The poll device for the RFKILL input button */
-	struct input_polled_dev *poll_dev;
 	/* Did initialization succeed? Used for freeing. */
 	bool registered;
 	/* The unique name of this rfkill switch */
@@ -26,7 +23,7 @@ struct b43_rfkill {
 void b43_rfkill_init(struct b43_wldev *dev);
 void b43_rfkill_exit(struct b43_wldev *dev);
 
-char * b43_rfkill_led_name(struct b43_wldev *dev);
+const char *b43_rfkill_led_name(struct b43_wldev *dev);
 
 
 #else /* CONFIG_B43_RFKILL */
--- wireless-testing.orig/drivers/net/wireless/b43legacy/Kconfig	2009-03-31 11:13:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/Kconfig	2009-03-31 11:48:55.000000000 +0200
@@ -48,7 +48,7 @@ config B43LEGACY_LEDS
 # if it's possible.
 config B43LEGACY_RFKILL
 	bool
-	depends on B43LEGACY && (RFKILL = y || RFKILL = B43LEGACY) && RFKILL_INPUT && (INPUT_POLLDEV = y || INPUT_POLLDEV = B43LEGACY)
+	depends on B43LEGACY && (RFKILL = y || RFKILL = B43LEGACY)
 	default y
 
 config B43LEGACY_DEBUG
--- wireless-testing.orig/drivers/net/wireless/b43legacy/leds.c	2009-03-31 11:13:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/leds.c	2009-03-31 11:48:55.000000000 +0200
@@ -86,7 +86,8 @@ static void b43legacy_led_brightness_set
 
 static int b43legacy_register_led(struct b43legacy_wldev *dev,
 				  struct b43legacy_led *led,
-				  const char *name, char *default_trigger,
+				  const char *name,
+				  const char *default_trigger,
 				  u8 led_index, bool activelow)
 {
 	int err;
--- wireless-testing.orig/drivers/net/wireless/b43legacy/rfkill.h	2009-03-31 11:13:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/rfkill.h	2009-03-31 11:48:55.000000000 +0200
@@ -6,16 +6,12 @@ struct b43legacy_wldev;
 #ifdef CONFIG_B43LEGACY_RFKILL
 
 #include <linux/rfkill.h>
-#include <linux/workqueue.h>
-#include <linux/input-polldev.h>
 
 
 
 struct b43legacy_rfkill {
 	/* The RFKILL subsystem data structure */
 	struct rfkill *rfkill;
-	/* The poll device for the RFKILL input button */
-	struct input_polled_dev *poll_dev;
 	/* Did initialization succeed? Used for freeing. */
 	bool registered;
 	/* The unique name of this rfkill switch */
@@ -27,7 +23,7 @@ struct b43legacy_rfkill {
 void b43legacy_rfkill_init(struct b43legacy_wldev *dev);
 void b43legacy_rfkill_exit(struct b43legacy_wldev *dev);
 
-char *b43legacy_rfkill_led_name(struct b43legacy_wldev *dev);
+const char *b43legacy_rfkill_led_name(struct b43legacy_wldev *dev);
 
 
 #else /* CONFIG_B43LEGACY_RFKILL */
--- wireless-testing.orig/drivers/net/wireless/b43/leds.c	2009-03-31 11:13:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/leds.c	2009-03-31 11:48:55.000000000 +0200
@@ -87,7 +87,7 @@ static void b43_led_brightness_set(struc
 }
 
 static int b43_register_led(struct b43_wldev *dev, struct b43_led *led,
-			    const char *name, char *default_trigger,
+			    const char *name, const char *default_trigger,
 			    u8 led_index, bool activelow)
 {
 	int err;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/Kconfig	2009-03-31 11:13:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/Kconfig	2009-03-31 11:48:55.000000000 +0200
@@ -5,15 +5,14 @@ config IWLWIFI
 	select FW_LOADER
 	select MAC80211_LEDS if IWLWIFI_LEDS
 	select LEDS_CLASS if IWLWIFI_LEDS
-	select RFKILL if IWLWIFI_RFKILL
 
 config IWLWIFI_LEDS
 	bool "Enable LED support in iwlagn and iwl3945 drivers"
 	depends on IWLWIFI
 
 config IWLWIFI_RFKILL
-	bool "Enable RF kill support in iwlagn and iwl3945 drivers"
-	depends on IWLWIFI
+	def_bool y
+	depends on IWLWIFI && RFKILL
 
 config IWLWIFI_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwlagn driver"
--- wireless-testing.orig/drivers/net/wireless/b43/phy_lp.c	2009-03-31 11:13:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_lp.c	2009-03-31 11:48:55.000000000 +0200
@@ -488,7 +488,7 @@ static void b43_lpphy_op_radio_write(str
 }
 
 static void b43_lpphy_op_software_rfkill(struct b43_wldev *dev,
-					 enum rfkill_state state)
+					 bool blocked)
 {
 	//TODO
 }
--- wireless-testing.orig/drivers/platform/x86/Kconfig	2009-03-31 11:13:09.000000000 +0200
+++ wireless-testing/drivers/platform/x86/Kconfig	2009-03-31 11:48:55.000000000 +0200
@@ -21,7 +21,6 @@ config ACER_WMI
 	depends on NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on SERIO_I8042
-	depends on RFKILL
 	select ACPI_WMI
 	---help---
 	  This is a driver for newer Acer (and Wistron) laptops. It adds
@@ -60,7 +59,6 @@ config DELL_LAPTOP
 	depends on DCDBAS
 	depends on EXPERIMENTAL
 	depends on BACKLIGHT_CLASS_DEVICE
-	depends on RFKILL
 	depends on POWER_SUPPLY
 	default n
 	---help---
@@ -107,7 +105,6 @@ config HP_WMI
 	tristate "HP WMI extras"
 	depends on ACPI_WMI
 	depends on INPUT
-	depends on RFKILL
 	help
 	 Say Y here if you want to support WMI-based hotkeys on HP laptops and
 	 to read data from WMI such as docking or ambient light sensor state.
@@ -192,7 +189,6 @@ config THINKPAD_ACPI
 	select NEW_LEDS
 	select LEDS_CLASS
 	select NET
-	select RFKILL
 	---help---
 	  This is a driver for the IBM and Lenovo ThinkPad laptops. It adds
 	  support for Fn-Fx key combinations, Bluetooth control, video
@@ -305,7 +301,6 @@ config EEEPC_LAPTOP
 	depends on EXPERIMENTAL
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
-	select RFKILL
 	---help---
 	  This driver supports the Fn-Fx keys on Eee PC laptops.
 	  It also adds the ability to switch camera/wlan on/off.
@@ -372,7 +367,6 @@ config ACPI_TOSHIBA
 	depends on INPUT
 	select INPUT_POLLDEV
 	select NET
-	select RFKILL
 	select BACKLIGHT_CLASS_DEVICE
 	---help---
 	  This driver adds support for access to certain system settings
--- wireless-testing.orig/drivers/platform/x86/acer-wmi.c	2009-03-31 11:48:54.000000000 +0200
+++ wireless-testing/drivers/platform/x86/acer-wmi.c	2009-03-31 11:48:55.000000000 +0200
@@ -939,58 +939,50 @@ static void acer_rfkill_update(struct wo
 
 	status = get_u32(&state, ACER_CAP_WIRELESS);
 	if (ACPI_SUCCESS(status))
-		rfkill_force_state(wireless_rfkill, state ?
-			RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED);
+		rfkill_set_sw_state(wireless_rfkill, !!state);
 
 	if (has_cap(ACER_CAP_BLUETOOTH)) {
 		status = get_u32(&state, ACER_CAP_BLUETOOTH);
 		if (ACPI_SUCCESS(status))
-			rfkill_force_state(bluetooth_rfkill, state ?
-				RFKILL_STATE_UNBLOCKED :
-				RFKILL_STATE_SOFT_BLOCKED);
+			rfkill_set_sw_state(bluetooth_rfkill, !!state);
 	}
 
 	schedule_delayed_work(&acer_rfkill_work, round_jiffies_relative(HZ));
 }
 
-static int acer_rfkill_set(void *data, enum rfkill_state state)
+static int acer_rfkill_set(void *data, bool blocked)
 {
 	acpi_status status;
-	u32 *cap = data;
-	status = set_u32((u32) (state == RFKILL_STATE_UNBLOCKED), *cap);
+	u32 cap = (unsigned long)data;
+	status = set_u32(!!blocked, cap);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 	return 0;
 }
 
-static struct rfkill * acer_rfkill_register(struct device *dev,
-enum rfkill_type type, char *name, u32 cap)
+static const struct rfkill_ops acer_rfkill_ops = {
+	.set_block = acer_rfkill_set,
+};
+
+static struct rfkill *acer_rfkill_register(struct device *dev,
+					   enum rfkill_type type,
+					   char *name, u32 cap)
 {
 	int err;
 	u32 state;
-	u32 *data;
 	struct rfkill *rfkill_dev;
 
-	rfkill_dev = rfkill_allocate(dev, type);
+	rfkill_dev = rfkill_alloc(name, dev, type,
+				  &acer_rfkill_ops,
+				  (void *)(unsigned long)cap);
 	if (!rfkill_dev)
 		return ERR_PTR(-ENOMEM);
-	rfkill_dev->name = name;
 	get_u32(&state, cap);
-	rfkill_dev->state = state ? RFKILL_STATE_UNBLOCKED :
-		RFKILL_STATE_SOFT_BLOCKED;
-	data = kzalloc(sizeof(u32), GFP_KERNEL);
-	if (!data) {
-		rfkill_free(rfkill_dev);
-		return ERR_PTR(-ENOMEM);
-	}
-	*data = cap;
-	rfkill_dev->data = data;
-	rfkill_dev->toggle_radio = acer_rfkill_set;
+	rfkill_set_sw_state(rfkill_dev, !state);
 
 	err = rfkill_register(rfkill_dev);
 	if (err) {
-		kfree(rfkill_dev->data);
-		rfkill_free(rfkill_dev);
+		rfkill_destroy(rfkill_dev);
 		return ERR_PTR(err);
 	}
 	return rfkill_dev;
@@ -1008,8 +1000,8 @@ static int acer_rfkill_init(struct devic
 			RFKILL_TYPE_BLUETOOTH, "acer-bluetooth",
 			ACER_CAP_BLUETOOTH);
 		if (IS_ERR(bluetooth_rfkill)) {
-			kfree(wireless_rfkill->data);
 			rfkill_unregister(wireless_rfkill);
+			rfkill_destroy(wireless_rfkill);
 			return PTR_ERR(bluetooth_rfkill);
 		}
 	}
@@ -1022,11 +1014,13 @@ static int acer_rfkill_init(struct devic
 static void acer_rfkill_exit(void)
 {
 	cancel_delayed_work_sync(&acer_rfkill_work);
-	kfree(wireless_rfkill->data);
+
 	rfkill_unregister(wireless_rfkill);
+	rfkill_destroy(wireless_rfkill);
+
 	if (has_cap(ACER_CAP_BLUETOOTH)) {
-		kfree(bluetooth_rfkill->data);
 		rfkill_unregister(bluetooth_rfkill);
+		rfkill_destroy(bluetooth_rfkill);
 	}
 	return;
 }
--- wireless-testing.orig/drivers/platform/x86/dell-laptop.c	2009-03-31 11:13:09.000000000 +0200
+++ wireless-testing/drivers/platform/x86/dell-laptop.c	2009-03-31 20:37:43.000000000 +0200
@@ -174,10 +174,11 @@ dell_send_request(struct calling_interfa
    result[3]: NVRAM format version number
 */
 
-static int dell_rfkill_set(int radio, enum rfkill_state state)
+static int dell_rfkill_set(void *data, bool blocked)
 {
 	struct calling_interface_buffer buffer;
-	int disable = (state == RFKILL_STATE_UNBLOCKED) ? 0 : 1;
+	int disable = blocked ? 0 : 1;
+	unsigned long radio = (unsigned long)data;
 
 	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
 	buffer.input[0] = (1 | (radio<<8) | (disable << 16));
@@ -186,56 +187,26 @@ static int dell_rfkill_set(int radio, en
 	return 0;
 }
 
-static int dell_wifi_set(void *data, enum rfkill_state state)
-{
-	return dell_rfkill_set(1, state);
-}
-
-static int dell_bluetooth_set(void *data, enum rfkill_state state)
-{
-	return dell_rfkill_set(2, state);
-}
-
-static int dell_wwan_set(void *data, enum rfkill_state state)
-{
-	return dell_rfkill_set(3, state);
-}
-
-static int dell_rfkill_get(int bit, enum rfkill_state *state)
+static bool dell_rfkill_query(void *data)
 {
 	struct calling_interface_buffer buffer;
 	int status;
-	int new_state = RFKILL_STATE_HARD_BLOCKED;
+	int bit = (unsigned long)data + 16;
 
 	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
 	dell_send_request(&buffer, 17, 11);
 	status = buffer.output[1];
 
-	if (status & (1<<16))
-		new_state = RFKILL_STATE_SOFT_BLOCKED;
-
-	if (status & (1<<bit))
-		*state = new_state;
-	else
-		*state = RFKILL_STATE_UNBLOCKED;
-
-	return 0;
-}
+	if (status & BIT(bit))
+		return !!(status & BIT(16));
 
-static int dell_wifi_get(void *data, enum rfkill_state *state)
-{
-	return dell_rfkill_get(17, state);
+	return false;
 }
 
-static int dell_bluetooth_get(void *data, enum rfkill_state *state)
-{
-	return dell_rfkill_get(18, state);
-}
-
-static int dell_wwan_get(void *data, enum rfkill_state *state)
-{
-	return dell_rfkill_get(19, state);
-}
+static const struct rfkill_ops dell_rfkill_ops = {
+	.set_block = dell_rfkill_set,
+	.query_hw_block = dell_rfkill_query,
+};
 
 static int dell_setup_rfkill(void)
 {
@@ -248,36 +219,37 @@ static int dell_setup_rfkill(void)
 	status = buffer.output[1];
 
 	if ((status & (1<<2|1<<8)) == (1<<2|1<<8)) {
-		wifi_rfkill = rfkill_allocate(NULL, RFKILL_TYPE_WLAN);
-		if (!wifi_rfkill)
+		wifi_rfkill = rfkill_alloc("dell-wifi", NULL, RFKILL_TYPE_WLAN,
+					   &dell_rfkill_ops, (void *) 1);
+		if (!wifi_rfkill) {
+			ret = -ENOMEM;
 			goto err_wifi;
-		wifi_rfkill->name = "dell-wifi";
-		wifi_rfkill->toggle_radio = dell_wifi_set;
-		wifi_rfkill->get_state = dell_wifi_get;
+		}
 		ret = rfkill_register(wifi_rfkill);
 		if (ret)
 			goto err_wifi;
 	}
 
 	if ((status & (1<<3|1<<9)) == (1<<3|1<<9)) {
-		bluetooth_rfkill = rfkill_allocate(NULL, RFKILL_TYPE_BLUETOOTH);
-		if (!bluetooth_rfkill)
+		bluetooth_rfkill = rfkill_alloc("dell-bluetooth", NULL,
+						RFKILL_TYPE_BLUETOOTH,
+						&dell_rfkill_ops, (void *) 2);
+		if (!bluetooth_rfkill) {
+			ret = -ENOMEM;
 			goto err_bluetooth;
-		bluetooth_rfkill->name = "dell-bluetooth";
-		bluetooth_rfkill->toggle_radio = dell_bluetooth_set;
-		bluetooth_rfkill->get_state = dell_bluetooth_get;
+		}
 		ret = rfkill_register(bluetooth_rfkill);
 		if (ret)
 			goto err_bluetooth;
 	}
 
 	if ((status & (1<<4|1<<10)) == (1<<4|1<<10)) {
-		wwan_rfkill = rfkill_allocate(NULL, RFKILL_TYPE_WWAN);
-		if (!wwan_rfkill)
+		wwan_rfkill = rfkill_alloc("dell-wwan", NULL, RFKILL_TYPE_WWAN,
+					   &dell_rfkill_ops, (void *) 3);
+		if (!wwan_rfkill) {
+			ret = -ENOMEM;
 			goto err_wwan;
-		wwan_rfkill->name = "dell-wwan";
-		wwan_rfkill->toggle_radio = dell_wwan_set;
-		wwan_rfkill->get_state = dell_wwan_get;
+		}
 		ret = rfkill_register(wwan_rfkill);
 		if (ret)
 			goto err_wwan;
@@ -285,22 +257,15 @@ static int dell_setup_rfkill(void)
 
 	return 0;
 err_wwan:
-	if (wwan_rfkill)
-		rfkill_free(wwan_rfkill);
-	if (bluetooth_rfkill) {
+	rfkill_destroy(wwan_rfkill);
+	if (bluetooth_rfkill)
 		rfkill_unregister(bluetooth_rfkill);
-		bluetooth_rfkill = NULL;
-	}
 err_bluetooth:
-	if (bluetooth_rfkill)
-		rfkill_free(bluetooth_rfkill);
-	if (wifi_rfkill) {
+	rfkill_destroy(bluetooth_rfkill);
+	if (wifi_rfkill)
 		rfkill_unregister(wifi_rfkill);
-		wifi_rfkill = NULL;
-	}
 err_wifi:
-	if (wifi_rfkill)
-		rfkill_free(wifi_rfkill);
+	rfkill_destroy(wifi_rfkill);
 
 	return ret;
 }
--- wireless-testing.orig/drivers/platform/x86/hp-wmi.c	2009-03-31 11:48:54.000000000 +0200
+++ wireless-testing/drivers/platform/x86/hp-wmi.c	2009-03-31 11:48:55.000000000 +0200
@@ -152,58 +152,46 @@ static int hp_wmi_dock_state(void)
 	return hp_wmi_perform_query(HPWMI_DOCK_QUERY, 0, 0);
 }
 
-static int hp_wmi_wifi_set(void *data, enum rfkill_state state)
+static int hp_wmi_set_block(void *data, bool blocked)
 {
-	if (state)
-		return hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 1, 0x101);
-	else
-		return hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 1, 0x100);
-}
+	unsigned long b = (unsigned long) data;
+	int query = BIT(b + 8) | ((!!blocked) << b);
 
-static int hp_wmi_bluetooth_set(void *data, enum rfkill_state state)
-{
-	if (state)
-		return hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 1, 0x202);
-	else
-		return hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 1, 0x200);
+	return hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 1, query);
 }
 
-static int hp_wmi_wwan_set(void *data, enum rfkill_state state)
-{
-	if (state)
-		return hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 1, 0x404);
-	else
-		return hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 1, 0x400);
-}
+static const struct rfkill_ops hp_wmi_rfkill_ops = {
+	.set_block = hp_wmi_set_block,
+};
 
-static int hp_wmi_wifi_state(void)
+static bool hp_wmi_wifi_state(void)
 {
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
 
 	if (wireless & 0x100)
-		return RFKILL_STATE_UNBLOCKED;
+		return false;
 	else
-		return RFKILL_STATE_SOFT_BLOCKED;
+		return true;
 }
 
-static int hp_wmi_bluetooth_state(void)
+static bool hp_wmi_bluetooth_state(void)
 {
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
 
 	if (wireless & 0x10000)
-		return RFKILL_STATE_UNBLOCKED;
+		return false;
 	else
-		return RFKILL_STATE_SOFT_BLOCKED;
+		return true;
 }
 
-static int hp_wmi_wwan_state(void)
+static bool hp_wmi_wwan_state(void)
 {
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
 
 	if (wireless & 0x1000000)
-		return RFKILL_STATE_UNBLOCKED;
+		return false;
 	else
-		return RFKILL_STATE_SOFT_BLOCKED;
+		return true;
 }
 
 static ssize_t show_display(struct device *dev, struct device_attribute *attr,
@@ -345,14 +333,14 @@ static void hp_wmi_notify(u32 value, voi
 			}
 		} else if (eventcode == 0x5) {
 			if (wifi_rfkill)
-				rfkill_force_state(wifi_rfkill,
-						   hp_wmi_wifi_state());
+				rfkill_set_sw_state(wifi_rfkill,
+						    hp_wmi_wifi_state());
 			if (bluetooth_rfkill)
-				rfkill_force_state(bluetooth_rfkill,
-						   hp_wmi_bluetooth_state());
+				rfkill_set_sw_state(bluetooth_rfkill,
+						    hp_wmi_bluetooth_state());
 			if (wwan_rfkill)
-				rfkill_force_state(wwan_rfkill,
-						   hp_wmi_wwan_state());
+				rfkill_set_sw_state(wwan_rfkill,
+						    hp_wmi_wwan_state());
 		} else
 			printk(KERN_INFO "HP WMI: Unknown key pressed - %x\n",
 			       eventcode);
@@ -428,31 +416,34 @@ static int __init hp_wmi_bios_setup(stru
 		goto add_sysfs_error;
 
 	if (wireless & 0x1) {
-		wifi_rfkill = rfkill_allocate(&device->dev, RFKILL_TYPE_WLAN);
-		wifi_rfkill->name = "hp-wifi";
-		wifi_rfkill->state = hp_wmi_wifi_state();
-		wifi_rfkill->toggle_radio = hp_wmi_wifi_set;
+		wifi_rfkill = rfkill_alloc("hp-wifi", &device->dev,
+					   RFKILL_TYPE_WLAN,
+					   &hp_wmi_rfkill_ops,
+					   (void *) 0);
+		rfkill_set_sw_state(wifi_rfkill, hp_wmi_wifi_state());
 		err = rfkill_register(wifi_rfkill);
 		if (err)
-			goto add_sysfs_error;
+			goto register_wifi_error;
 	}
 
 	if (wireless & 0x2) {
-		bluetooth_rfkill = rfkill_allocate(&device->dev,
-						   RFKILL_TYPE_BLUETOOTH);
-		bluetooth_rfkill->name = "hp-bluetooth";
-		bluetooth_rfkill->state = hp_wmi_bluetooth_state();
-		bluetooth_rfkill->toggle_radio = hp_wmi_bluetooth_set;
+		bluetooth_rfkill = rfkill_alloc("hp-bluetooth", &device->dev,
+						RFKILL_TYPE_BLUETOOTH,
+						&hp_wmi_rfkill_ops,
+						(void *) 1);
+		rfkill_set_sw_state(bluetooth_rfkill,
+				    hp_wmi_bluetooth_state());
 		err = rfkill_register(bluetooth_rfkill);
 		if (err)
 			goto register_bluetooth_error;
 	}
 
 	if (wireless & 0x4) {
-		wwan_rfkill = rfkill_allocate(&device->dev, RFKILL_TYPE_WWAN);
-		wwan_rfkill->name = "hp-wwan";
-		wwan_rfkill->state = hp_wmi_wwan_state();
-		wwan_rfkill->toggle_radio = hp_wmi_wwan_set;
+		wwan_rfkill = rfkill_alloc("hp-wwan", &device->dev,
+					   RFKILL_TYPE_WWAN,
+					   &hp_wmi_rfkill_ops,
+					   (void *) 2);
+		rfkill_set_sw_state(wwan_rfkill, hp_wmi_wwan_state());
 		err = rfkill_register(wwan_rfkill);
 		if (err)
 			goto register_wwan_err;
@@ -460,11 +451,15 @@ static int __init hp_wmi_bios_setup(stru
 
 	return 0;
 register_wwan_err:
+	rfkill_destroy(wwan_rfkill);
 	if (bluetooth_rfkill)
 		rfkill_unregister(bluetooth_rfkill);
 register_bluetooth_error:
+	rfkill_destroy(bluetooth_rfkill);
 	if (wifi_rfkill)
 		rfkill_unregister(wifi_rfkill);
+register_wifi_error:
+	rfkill_destroy(wifi_rfkill);
 add_sysfs_error:
 	cleanup_sysfs(device);
 	return err;
@@ -474,12 +469,18 @@ static int __exit hp_wmi_bios_remove(str
 {
 	cleanup_sysfs(device);
 
-	if (wifi_rfkill)
+	if (wifi_rfkill) {
 		rfkill_unregister(wifi_rfkill);
-	if (bluetooth_rfkill)
+		rfkill_destroy(wifi_rfkill);
+	}
+	if (bluetooth_rfkill) {
 		rfkill_unregister(bluetooth_rfkill);
-	if (wwan_rfkill)
+		rfkill_destroy(wifi_rfkill);
+	}
+	if (wwan_rfkill) {
 		rfkill_unregister(wwan_rfkill);
+		rfkill_destroy(wwan_rfkill);
+	}
 
 	return 0;
 }
--- wireless-testing.orig/drivers/platform/x86/toshiba_acpi.c	2009-03-31 11:48:54.000000000 +0200
+++ wireless-testing/drivers/platform/x86/toshiba_acpi.c	2009-03-31 11:48:55.000000000 +0200
@@ -311,28 +311,20 @@ static u32 hci_get_radio_state(bool *rad
 	return hci_result;
 }
 
-static int bt_rfkill_toggle_radio(void *data, enum rfkill_state state)
+static int bt_rfkill_set_block(void *data, bool blocked)
 {
 	u32 result1, result2;
 	u32 value;
 	bool radio_state;
 	struct toshiba_acpi_dev *dev = data;
 
-	value = (state == RFKILL_STATE_UNBLOCKED);
+	value = (blocked == false);
 
 	if (hci_get_radio_state(&radio_state) != HCI_SUCCESS)
-		return -EFAULT;
+		return -EBUSY;
 
-	switch (state) {
-	case RFKILL_STATE_UNBLOCKED:
-		if (!radio_state)
-			return -EPERM;
-		break;
-	case RFKILL_STATE_SOFT_BLOCKED:
-		break;
-	default:
-		return -EINVAL;
-	}
+	if (WARN_ON(!blocked && !radio_state))
+		return;
 
 	mutex_lock(&dev->mutex);
 	hci_write2(HCI_WIRELESS, value, HCI_WIRELESS_BT_POWER, &result1);
@@ -340,8 +332,7 @@ static int bt_rfkill_toggle_radio(void *
 	mutex_unlock(&dev->mutex);
 
 	if (result1 != HCI_SUCCESS || result2 != HCI_SUCCESS)
-		return -EFAULT;
-
+		return -EBUSY;
 	return 0;
 }
 
@@ -365,7 +356,7 @@ static void bt_poll_rfkill(struct input_
 	mutex_unlock(&dev->mutex);
 
 	if (unlikely(state_changed)) {
-		rfkill_force_state(dev->rfk_dev,
+		rfkill_set_hw_state(dev->rfk_dev,
 				   new_rfk_state ?
 				   RFKILL_STATE_SOFT_BLOCKED :
 				   RFKILL_STATE_HARD_BLOCKED);
--- wireless-testing.orig/arch/arm/mach-pxa/tosa-bt.c	2009-03-31 11:48:53.000000000 +0200
+++ wireless-testing/arch/arm/mach-pxa/tosa-bt.c	2009-03-31 16:02:49.000000000 +0200
@@ -35,21 +35,25 @@ static void tosa_bt_off(struct tosa_bt_d
 	gpio_set_value(data->gpio_reset, 0);
 }
 
-static int tosa_bt_toggle_radio(void *data, enum rfkill_state state)
+static int tosa_bt_set_block(void *data, bool blocked)
 {
-	pr_info("BT_RADIO going: %s\n",
-			state == RFKILL_STATE_UNBLOCKED ? "on" : "off");
+	pr_info("BT_RADIO going: %s\n", blocked ? "off" : "on");
 
-	if (state == RFKILL_STATE_UNBLOCKED) {
+	if (!blocked) {
 		pr_info("TOSA_BT: going ON\n");
 		tosa_bt_on(data);
 	} else {
 		pr_info("TOSA_BT: going OFF\n");
 		tosa_bt_off(data);
 	}
+
 	return 0;
 }
 
+static const struct rfkill_ops tosa_bt_rfkill_ops = {
+	.set_block = tosa_bt_set_block,
+};
+
 static int tosa_bt_probe(struct platform_device *dev)
 {
 	int rc;
@@ -70,18 +74,14 @@ static int tosa_bt_probe(struct platform
 	if (rc)
 		goto err_pwr_dir;
 
-	rfk = rfkill_allocate(&dev->dev, RFKILL_TYPE_BLUETOOTH);
+	rfk = rfkill_alloc("tosa-bt", &dev->dev, RFKILL_TYPE_BLUETOOTH,
+			   &tosa_bt_rfkill_ops, data);
 	if (!rfk) {
 		rc = -ENOMEM;
 		goto err_rfk_alloc;
 	}
 
-	rfk->name = "tosa-bt";
-	rfk->toggle_radio = tosa_bt_toggle_radio;
-	rfk->data = data;
-#ifdef CONFIG_RFKILL_LEDS
-	rfk->led_trigger.name = "tosa-bt";
-#endif
+	rfkill_set_led_trigger_name(rfk, "tosa-bt");
 
 	rc = rfkill_register(rfk);
 	if (rc)
@@ -92,9 +92,7 @@ static int tosa_bt_probe(struct platform
 	return 0;
 
 err_rfkill:
-	if (rfk)
-		rfkill_free(rfk);
-	rfk = NULL;
+	rfkill_destroy(rfk);
 err_rfk_alloc:
 	tosa_bt_off(data);
 err_pwr_dir:
@@ -113,8 +111,10 @@ static int __devexit tosa_bt_remove(stru
 
 	platform_set_drvdata(dev, NULL);
 
-	if (rfk)
+	if (rfk) {
 		rfkill_unregister(rfk);
+		rfkill_destroy(rfk);
+	}
 	rfk = NULL;
 
 	tosa_bt_off(data);
--- wireless-testing.orig/arch/arm/mach-pxa/tosa.c	2009-03-31 11:13:09.000000000 +0200
+++ wireless-testing/arch/arm/mach-pxa/tosa.c	2009-03-31 16:02:18.000000000 +0200
@@ -31,7 +31,6 @@
 #include <linux/input.h>
 #include <linux/gpio.h>
 #include <linux/pda_power.h>
-#include <linux/rfkill.h>
 #include <linux/spi/spi.h>
 
 #include <asm/setup.h>
--- wireless-testing.orig/include/net/wimax.h	2009-03-31 11:13:09.000000000 +0200
+++ wireless-testing/include/net/wimax.h	2009-03-31 11:48:55.000000000 +0200
@@ -253,7 +253,6 @@
 struct net_device;
 struct genl_info;
 struct wimax_dev;
-struct input_dev;
 
 /**
  * struct wimax_dev - Generic WiMAX device
@@ -293,8 +292,8 @@ struct input_dev;
  *     See wimax_reset()'s documentation.
  *
  * @name: [fill] A way to identify this device. We need to register a
- *     name with many subsystems (input for RFKILL, workqueue
- *     creation, etc). We can't use the network device name as that
+ *     name with many subsystems (rfkill, workqueue creation, etc).
+ *     We can't use the network device name as that
  *     might change and in some instances we don't know it yet (until
  *     we don't call register_netdev()). So we generate an unique one
  *     using the driver name and device bus id, place it here and use
@@ -316,9 +315,6 @@ struct input_dev;
  *
  * @rfkill: [private] integration into the RF-Kill infrastructure.
  *
- * @rfkill_input: [private] virtual input device to process the
- *     hardware RF Kill switches.
- *
  * @rf_sw: [private] State of the software radio switch (OFF/ON)
  *
  * @rf_hw: [private] State of the hardware radio switch (OFF/ON)
--- wireless-testing.orig/net/wimax/op-rfkill.c	2009-03-31 11:48:54.000000000 +0200
+++ wireless-testing/net/wimax/op-rfkill.c	2009-03-31 11:48:55.000000000 +0200
@@ -29,8 +29,8 @@
  * A non-polled generic rfkill device is embedded into the WiMAX
  * subsystem's representation of a device.
  *
- * FIXME: Need polled support? use a timer or add the implementation
- *     to the stack.
+ * FIXME: Need polled support? Let drivers provide a poll routine
+ *	  and hand it to rfkill ops then?
  *
  * All device drivers have to do is after wimax_dev_init(), call
  * wimax_report_rfkill_hw() and wimax_report_rfkill_sw() to update
@@ -43,7 +43,7 @@
  *   wimax_rfkill()             Kernel calling wimax_rfkill()
  *     __wimax_rf_toggle_radio()
  *
- * wimax_rfkill_toggle_radio()  RF-Kill subsytem calling
+ * wimax_rfkill_set_radio_block()  RF-Kill subsytem calling
  *   __wimax_rf_toggle_radio()
  *
  * __wimax_rf_toggle_radio()
@@ -65,15 +65,11 @@
 #include <linux/wimax.h>
 #include <linux/security.h>
 #include <linux/rfkill.h>
-#include <linux/input.h>
 #include "wimax-internal.h"
 
 #define D_SUBMODULE op_rfkill
 #include "debug-levels.h"
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-
-
 /**
  * wimax_report_rfkill_hw - Reports changes in the hardware RF switch
  *
@@ -99,7 +95,6 @@ void wimax_report_rfkill_hw(struct wimax
 	int result;
 	struct device *dev = wimax_dev_to_dev(wimax_dev);
 	enum wimax_st wimax_state;
-	enum rfkill_state rfkill_state;
 
 	d_fnstart(3, dev, "(wimax_dev %p state %u)\n", wimax_dev, state);
 	BUG_ON(state == WIMAX_RF_QUERY);
@@ -112,16 +107,15 @@ void wimax_report_rfkill_hw(struct wimax
 
 	if (state != wimax_dev->rf_hw) {
 		wimax_dev->rf_hw = state;
-		rfkill_state = state == WIMAX_RF_ON ?
-			RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED;
 		if (wimax_dev->rf_hw == WIMAX_RF_ON
 		    && wimax_dev->rf_sw == WIMAX_RF_ON)
 			wimax_state = WIMAX_ST_READY;
 		else
 			wimax_state = WIMAX_ST_RADIO_OFF;
+
+		rfkill_set_hw_state(wimax_dev->rfkill, state == WIMAX_RF_OFF);
+
 		__wimax_state_change(wimax_dev, wimax_state);
-		input_report_key(wimax_dev->rfkill_input, KEY_WIMAX,
-				 rfkill_state);
 	}
 error_not_ready:
 	mutex_unlock(&wimax_dev->mutex);
@@ -174,6 +168,7 @@ void wimax_report_rfkill_sw(struct wimax
 		else
 			wimax_state = WIMAX_ST_RADIO_OFF;
 		__wimax_state_change(wimax_dev, wimax_state);
+		rfkill_set_sw_state(wimax_dev->rfkill, state == WIMAX_RF_OFF);
 	}
 error_not_ready:
 	mutex_unlock(&wimax_dev->mutex);
@@ -249,36 +244,31 @@ out_no_change:
  *
  * NOTE: This call will block until the operation is completed.
  */
-static
-int wimax_rfkill_toggle_radio(void *data, enum rfkill_state state)
+static int wimax_rfkill_set_radio_block(void *data, bool blocked)
 {
 	int result;
 	struct wimax_dev *wimax_dev = data;
 	struct device *dev = wimax_dev_to_dev(wimax_dev);
 	enum wimax_rf_state rf_state;
 
-	d_fnstart(3, dev, "(wimax_dev %p state %u)\n", wimax_dev, state);
-	switch (state) {
-	case RFKILL_STATE_SOFT_BLOCKED:
+	d_fnstart(3, dev, "(wimax_dev %p blocked %u)\n", wimax_dev, blocked);
+	rf_state = WIMAX_RF_ON;
+	if (blocked)
 		rf_state = WIMAX_RF_OFF;
-		break;
-	case RFKILL_STATE_UNBLOCKED:
-		rf_state = WIMAX_RF_ON;
-		break;
-	default:
-		BUG();
-	}
 	mutex_lock(&wimax_dev->mutex);
 	if (wimax_dev->state <= __WIMAX_ST_QUIESCING)
-		result = 0;	/* just pretend it didn't happen */
+		result = 0;
 	else
 		result = __wimax_rf_toggle_radio(wimax_dev, rf_state);
 	mutex_unlock(&wimax_dev->mutex);
-	d_fnend(3, dev, "(wimax_dev %p state %u) = %d\n",
-		wimax_dev, state, result);
+	d_fnend(3, dev, "(wimax_dev %p blocked %u) = %d\n",
+		wimax_dev, blocked, result);
 	return result;
 }
 
+static const struct rfkill_ops wimax_rfkill_ops = {
+	.set_block = wimax_rfkill_set_radio_block,
+};
 
 /**
  * wimax_rfkill - Set the software RF switch state for a WiMAX device
@@ -322,6 +312,7 @@ int wimax_rfkill(struct wimax_dev *wimax
 		result = __wimax_rf_toggle_radio(wimax_dev, state);
 		if (result < 0)
 			goto error;
+		rfkill_set_sw_state(wimax_dev->rfkill, state == WIMAX_RF_OFF);
 		break;
 	case WIMAX_RF_QUERY:
 		break;
@@ -349,40 +340,22 @@ int wimax_rfkill_add(struct wimax_dev *w
 {
 	int result;
 	struct rfkill *rfkill;
-	struct input_dev *input_dev;
 	struct device *dev = wimax_dev_to_dev(wimax_dev);
 
 	d_fnstart(3, dev, "(wimax_dev %p)\n", wimax_dev);
 	/* Initialize RF Kill */
 	result = -ENOMEM;
-	rfkill = rfkill_allocate(dev, RFKILL_TYPE_WIMAX);
+	rfkill = rfkill_alloc(wimax_dev->name, dev, RFKILL_TYPE_WIMAX,
+			      &wimax_rfkill_ops, wimax_dev);
 	if (rfkill == NULL)
 		goto error_rfkill_allocate;
-	wimax_dev->rfkill = rfkill;
 
-	rfkill->name = wimax_dev->name;
-	rfkill->state = RFKILL_STATE_UNBLOCKED;
-	rfkill->data = wimax_dev;
-	rfkill->toggle_radio = wimax_rfkill_toggle_radio;
-
-	/* Initialize the input device for the hw key */
-	input_dev = input_allocate_device();
-	if (input_dev == NULL)
-		goto error_input_allocate;
-	wimax_dev->rfkill_input = input_dev;
-	d_printf(1, dev, "rfkill %p input %p\n", rfkill, input_dev);
-
-	input_dev->name = wimax_dev->name;
-	/* FIXME: get a real device bus ID and stuff? do we care? */
-	input_dev->id.bustype = BUS_HOST;
-	input_dev->id.vendor = 0xffff;
-	input_dev->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_WIMAX, input_dev->keybit);
+	d_printf(1, dev, "rfkill %p\n", rfkill);
+
+	rfkill_has_sw_block_memory(rfkill);
+
+	wimax_dev->rfkill = rfkill;
 
-	/* Register both */
-	result = input_register_device(wimax_dev->rfkill_input);
-	if (result < 0)
-		goto error_input_register;
 	result = rfkill_register(wimax_dev->rfkill);
 	if (result < 0)
 		goto error_rfkill_register;
@@ -394,17 +367,8 @@ int wimax_rfkill_add(struct wimax_dev *w
 	d_fnend(3, dev, "(wimax_dev %p) = 0\n", wimax_dev);
 	return 0;
 
-	/* if rfkill_register() suceeds, can't use rfkill_free() any
-	 * more, only rfkill_unregister() [it owns the refcount]; with
-	 * the input device we have the same issue--hence the if. */
 error_rfkill_register:
-	input_unregister_device(wimax_dev->rfkill_input);
-	wimax_dev->rfkill_input = NULL;
-error_input_register:
-	if (wimax_dev->rfkill_input)
-		input_free_device(wimax_dev->rfkill_input);
-error_input_allocate:
-	rfkill_free(wimax_dev->rfkill);
+	rfkill_destroy(wimax_dev->rfkill);
 error_rfkill_allocate:
 	d_fnend(3, dev, "(wimax_dev %p) = %d\n", wimax_dev, result);
 	return result;
@@ -423,45 +387,12 @@ void wimax_rfkill_rm(struct wimax_dev *w
 {
 	struct device *dev = wimax_dev_to_dev(wimax_dev);
 	d_fnstart(3, dev, "(wimax_dev %p)\n", wimax_dev);
-	rfkill_unregister(wimax_dev->rfkill);	/* frees */
-	input_unregister_device(wimax_dev->rfkill_input);
+	rfkill_unregister(wimax_dev->rfkill);
+	rfkill_destroy(wimax_dev->rfkill);
 	d_fnend(3, dev, "(wimax_dev %p)\n", wimax_dev);
 }
 
 
-#else /* #ifdef CONFIG_RFKILL */
-
-void wimax_report_rfkill_hw(struct wimax_dev *wimax_dev,
-			    enum wimax_rf_state state)
-{
-}
-EXPORT_SYMBOL_GPL(wimax_report_rfkill_hw);
-
-void wimax_report_rfkill_sw(struct wimax_dev *wimax_dev,
-			    enum wimax_rf_state state)
-{
-}
-EXPORT_SYMBOL_GPL(wimax_report_rfkill_sw);
-
-int wimax_rfkill(struct wimax_dev *wimax_dev,
-		 enum wimax_rf_state state)
-{
-	return WIMAX_RF_ON << 1 | WIMAX_RF_ON;
-}
-EXPORT_SYMBOL_GPL(wimax_rfkill);
-
-int wimax_rfkill_add(struct wimax_dev *wimax_dev)
-{
-	return 0;
-}
-
-void wimax_rfkill_rm(struct wimax_dev *wimax_dev)
-{
-}
-
-#endif /* #ifdef CONFIG_RFKILL */
-
-
 /*
  * Exporting to user space over generic netlink
  *
--- wireless-testing.orig/net/wimax/Kconfig	2009-03-31 11:13:08.000000000 +0200
+++ wireless-testing/net/wimax/Kconfig	2009-03-31 11:48:55.000000000 +0200
@@ -1,23 +1,9 @@
 #
 # WiMAX LAN device configuration
 #
-# Note the ugly 'depends on' on WIMAX: that disallows RFKILL to be a
-# module if WIMAX is to be linked in. The WiMAX code is done in such a
-# way that it doesn't require and explicit dependency on RFKILL in
-# case an embedded system wants to rip it out.
-#
-# As well, enablement of the RFKILL code means we need the INPUT layer
-# support to inject events coming from hw rfkill switches. That
-# dependency could be killed if input.h provided appropiate means to
-# work when input is disabled.
-
-comment "WiMAX Wireless Broadband support requires CONFIG_INPUT enabled"
-	depends on INPUT = n && RFKILL != n
 
 menuconfig WIMAX
 	tristate "WiMAX Wireless Broadband support"
-	depends on (y && RFKILL != m) || m
-	depends on (INPUT && RFKILL != n) || RFKILL = n
 	help
 
 	  Select to configure support for devices that provide
--- wireless-testing.orig/drivers/net/usb/hso.c	2009-03-31 11:48:53.000000000 +0200
+++ wireless-testing/drivers/net/usb/hso.c	2009-03-31 11:48:55.000000000 +0200
@@ -2474,10 +2474,10 @@ static int add_net_device(struct hso_dev
 	return 0;
 }
 
-static int hso_radio_toggle(void *data, enum rfkill_state state)
+static int hso_rfkill_set_block(void *data, bool blocked)
 {
 	struct hso_device *hso_dev = data;
-	int enabled = (state == RFKILL_STATE_UNBLOCKED);
+	int enabled = !blocked;
 	int rv;
 
 	mutex_lock(&hso_dev->mutex);
@@ -2491,6 +2491,10 @@ static int hso_radio_toggle(void *data, 
 	return rv;
 }
 
+static const struct rfkill_ops hso_rfkill_ops = {
+	.set_block = hso_rfkill_set_block,
+};
+
 /* Creates and sets up everything for rfkill */
 static void hso_create_rfkill(struct hso_device *hso_dev,
 			     struct usb_interface *interface)
@@ -2499,29 +2503,25 @@ static void hso_create_rfkill(struct hso
 	struct device *dev = &hso_net->net->dev;
 	char *rfkn;
 
-	hso_net->rfkill = rfkill_allocate(&interface_to_usbdev(interface)->dev,
-				 RFKILL_TYPE_WWAN);
-	if (!hso_net->rfkill) {
-		dev_err(dev, "%s - Out of memory\n", __func__);
-		return;
-	}
 	rfkn = kzalloc(20, GFP_KERNEL);
-	if (!rfkn) {
-		rfkill_free(hso_net->rfkill);
-		hso_net->rfkill = NULL;
+	if (!rfkn)
 		dev_err(dev, "%s - Out of memory\n", __func__);
-		return;
-	}
+
 	snprintf(rfkn, 20, "hso-%d",
 		 interface->altsetting->desc.bInterfaceNumber);
-	hso_net->rfkill->name = rfkn;
-	hso_net->rfkill->state = RFKILL_STATE_UNBLOCKED;
-	hso_net->rfkill->data = hso_dev;
-	hso_net->rfkill->toggle_radio = hso_radio_toggle;
+
+	hso_net->rfkill = rfkill_alloc(rfkn,
+				       &interface_to_usbdev(interface)->dev,
+				       RFKILL_TYPE_WWAN,
+				       &hso_rfkill_ops, hso_dev);
+	if (!hso_net->rfkill) {
+		dev_err(dev, "%s - Out of memory\n", __func__);
+		kfree(rfkn);
+		return;
+	}
 	if (rfkill_register(hso_net->rfkill) < 0) {
+		rfkill_destroy(hso_net->rfkill);
 		kfree(rfkn);
-		hso_net->rfkill->name = NULL;
-		rfkill_free(hso_net->rfkill);
 		hso_net->rfkill = NULL;
 		dev_err(dev, "%s - Failed to register rfkill\n", __func__);
 		return;
@@ -3160,8 +3160,10 @@ static void hso_free_interface(struct us
 			hso_stop_net_device(network_table[i]);
 			cancel_work_sync(&network_table[i]->async_put_intf);
 			cancel_work_sync(&network_table[i]->async_get_intf);
-			if (rfk)
+			if (rfk) {
 				rfkill_unregister(rfk);
+				rfkill_destroy(rfk);
+			}
 			hso_free_net_device(network_table[i]);
 		}
 	}


