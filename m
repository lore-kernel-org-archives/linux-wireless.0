Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48029 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761384AbZFJUB7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 16:01:59 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, julian.calaby@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] [compat-2.6] Backport rfkill for kernel older than 2.6.31.
Date: Wed, 10 Jun 2009 22:01:48 +0200
Message-Id: <1244664108-3997-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1244664108-3997-1-git-send-email-hauke@hauke-m.de>
References: <1244664108-3997-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Makefile                |    3 +-
 compat/compat.diff      |  841 ++++++++++++++++++++++++++++++++++++++++++++++-
 compat/compat.h         |   22 ++
 config.mk               |   13 +-
 scripts/admin-update.sh |    4 +-
 5 files changed, 874 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 78aebb3..0ab7d27 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ include $(M)/$(COMPAT_CONFIG)
 
 NOSTDINC_FLAGS := -I$(M)/include/ -include $(M)/include/net/compat.h $(CFLAGS)
 
-obj-y := net/wireless/ net/mac80211/
+obj-y := net/wireless/ net/mac80211/ net/rfkill/
 ifeq ($(ONLY_CORE),)
 obj-$(CONFIG_B44) += drivers/net/b44.o
 obj-y += drivers/ssb/ \
@@ -166,6 +166,7 @@ install: uninstall modules
 uninstall:
 	@# New location, matches upstream
 	@rm -rf $(KLIB)/$(KMODDIR)/net/mac80211/
+	@rm -rf $(KLIB)/$(KMODDIR)/net/rfkill/
 	@rm -rf $(KLIB)/$(KMODDIR)/net/wireless/
 	@rm -rf $(KLIB)/$(KMODDIR)/drivers/ssb/
 	@rm -rf $(KLIB)/$(KMODDIR)/drivers/net/usb/
diff --git a/compat/compat.diff b/compat/compat.diff
index 058a933..cbf0b9e 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -181,6 +181,147 @@
  obj-$(CONFIG_LIBERTAS)		+= libertas/
  
  obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
+--- a/drivers/net/wireless/ath/ath5k/base.h
++++ b/drivers/net/wireless/ath/ath5k/base.h
+@@ -46,7 +46,11 @@
+ #include <linux/wireless.h>
+ #include <linux/if_ether.h>
+ #include <linux/leds.h>
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ #include <linux/rfkill.h>
++#else
++#include <linux/rfkill_backport.h>
++#endif
+ 
+ #include "ath5k.h"
+ #include "debug.h"
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -21,7 +21,11 @@
+ #include <linux/device.h>
+ #include <net/mac80211.h>
+ #include <linux/leds.h>
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ #include <linux/rfkill.h>
++#else
++#include <linux/rfkill_backport.h>
++#endif
+ 
+ #include "hw.h"
+ #include "rc.h"
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -1178,7 +1178,7 @@ void ath_radio_disable(struct ath_softc *sc)
+ 	ath9k_ps_restore(sc);
+ }
+ 
+-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
++#if ((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)) || ((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL_BACKPORT) || defined(CONFIG_RFKILL_BACKPORT_MODULE))
+ 
+ /*******************/
+ /*	Rfkill	   */
+@@ -1210,7 +1210,11 @@ static void ath_rfkill_poll_state(struct rfkill *rfkill, void *data)
+ 	struct ath_softc *sc = data;
+ 	bool blocked = !!ath_is_rfkill_set(sc);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 	if (rfkill_set_hw_state(rfkill, blocked))
++#else
++	if (backport_rfkill_set_hw_state(rfkill, blocked))
++#endif
+ 		ath_radio_disable(sc);
+ 	else
+ 		ath_radio_enable(sc);
+@@ -1226,10 +1230,17 @@ static int ath_init_sw_rfkill(struct ath_softc *sc)
+ 	snprintf(sc->rf_kill.rfkill_name, sizeof(sc->rf_kill.rfkill_name),
+ 		"ath9k-%s::rfkill", wiphy_name(sc->hw->wiphy));
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 	sc->rf_kill.rfkill = rfkill_alloc(sc->rf_kill.rfkill_name,
+ 					  wiphy_dev(sc->hw->wiphy),
+ 					  RFKILL_TYPE_WLAN,
+ 					  &sc->rf_kill.ops, sc);
++#else
++	sc->rf_kill.rfkill = backport_rfkill_alloc(sc->rf_kill.rfkill_name,
++					  wiphy_dev(sc->hw->wiphy),
++					  RFKILL_TYPE_WLAN,
++					  &sc->rf_kill.ops, sc);
++#endif
+ 	if (!sc->rf_kill.rfkill) {
+ 		DPRINTF(sc, ATH_DBG_FATAL, "Failed to allocate rfkill\n");
+ 		return -ENOMEM;
+@@ -1242,8 +1253,13 @@ static int ath_init_sw_rfkill(struct ath_softc *sc)
+ static void ath_deinit_rfkill(struct ath_softc *sc)
+ {
+ 	if (sc->sc_flags & SC_OP_RFKILL_REGISTERED) {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 		rfkill_unregister(sc->rf_kill.rfkill);
+ 		rfkill_destroy(sc->rf_kill.rfkill);
++#else
++		backport_rfkill_unregister(sc->rf_kill.rfkill);
++		backport_rfkill_destroy(sc->rf_kill.rfkill);
++#endif
+ 		sc->sc_flags &= ~SC_OP_RFKILL_REGISTERED;
+ 	}
+ }
+@@ -1251,10 +1267,18 @@ static void ath_deinit_rfkill(struct ath_softc *sc)
+ static int ath_start_rfkill_poll(struct ath_softc *sc)
+ {
+ 	if (!(sc->sc_flags & SC_OP_RFKILL_REGISTERED)) {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 		if (rfkill_register(sc->rf_kill.rfkill)) {
++#else
++		if (backport_rfkill_register(sc->rf_kill.rfkill)) {
++#endif
+ 			DPRINTF(sc, ATH_DBG_FATAL,
+ 				"Unable to register rfkill\n");
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 			rfkill_destroy(sc->rf_kill.rfkill);
++#else
++			backport_rfkill_destroy(sc->rf_kill.rfkill);
++#endif
+ 
+ 			/* Deinitialize the device */
+ 			ath_cleanup(sc);
+@@ -1286,7 +1310,7 @@ void ath_detach(struct ath_softc *sc)
+ 
+ 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach ATH hw\n");
+ 
+-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
++#if ((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)) || ((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL_BACKPORT) || defined(CONFIG_RFKILL_BACKPORT_MODULE))
+ 	ath_deinit_rfkill(sc);
+ #endif
+ 	ath_deinit_leds(sc);
+@@ -1626,7 +1650,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
+ 	if (error != 0)
+ 		goto error_attach;
+ 
+-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
++#if ((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)) || ((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL_BACKPORT) || defined(CONFIG_RFKILL_BACKPORT_MODULE))
+ 	/* Initialize s/w rfkill */
+ 	error = ath_init_sw_rfkill(sc);
+ 	if (error)
+@@ -2018,7 +2042,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
+ 
+ 	ieee80211_wake_queues(hw);
+ 
+-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
++#if ((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)) || ((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) && defined(CONFIG_RFKILL_BACKPORT) || defined(CONFIG_RFKILL_BACKPORT_MODULE))
+ 	r = ath_start_rfkill_poll(sc);
+ #endif
+ 
+@@ -2159,7 +2183,11 @@ static void ath9k_stop(struct ieee80211_hw *hw)
+ 	} else
+ 		sc->rx.rxlink = NULL;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 	rfkill_pause_polling(sc->rf_kill.rfkill);
++#else
++	backport_rfkill_pause_polling(sc->rf_kill.rfkill);
++#endif
+ 
+ 	/* disable HAL and put h/w to sleep */
+ 	ath9k_hw_disable(sc->sc_ah);
 --- a/drivers/net/wireless/b43/pcmcia.c
 +++ b/drivers/net/wireless/b43/pcmcia.c
 @@ -87,7 +87,11 @@ static int __devinit b43_pcmcia_probe(struct pcmcia_device *dev)
@@ -494,6 +635,200 @@
  #include <linux/spi/spi.h>
  
  #include "wl12xx.h"
+--- a/include/linux/rfkill_backport.h
++++ b/include/linux/rfkill_backport.h
+@@ -134,7 +134,7 @@ struct rfkill_ops {
+ 	int	(*set_block)(void *data, bool blocked);
+ };
+ 
+-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
++#if defined(CONFIG_RFKILL_BACKPORT) || defined(CONFIG_RFKILL_MODULE_BACKPORT)
+ /**
+  * rfkill_alloc - allocate rfkill structure
+  * @name: name of the struct -- the string is not copied internally
+@@ -146,7 +146,7 @@ struct rfkill_ops {
+  * This function should be called by the transmitter driver to allocate an
+  * rfkill structure. Returns %NULL on failure.
+  */
+-struct rfkill * __must_check rfkill_alloc(const char *name,
++struct rfkill * __must_check backport_rfkill_alloc(const char *name,
+ 					  struct device *parent,
+ 					  const enum rfkill_type type,
+ 					  const struct rfkill_ops *ops,
+@@ -166,7 +166,7 @@ struct rfkill * __must_check rfkill_alloc(const char *name,
+  * If the hardware blocked state is not set before registration,
+  * it is assumed to be unblocked.
+  */
+-int __must_check rfkill_register(struct rfkill *rfkill);
++int __must_check backport_rfkill_register(struct rfkill *rfkill);
+ 
+ /**
+  * rfkill_pause_polling(struct rfkill *rfkill)
+@@ -175,7 +175,7 @@ int __must_check rfkill_register(struct rfkill *rfkill);
+  * NOTE: not necessary for suspend/resume -- in that case the
+  * core stops polling anyway
+  */
+-void rfkill_pause_polling(struct rfkill *rfkill);
++void backport_rfkill_pause_polling(struct rfkill *rfkill);
+ 
+ /**
+  * rfkill_resume_polling(struct rfkill *rfkill)
+@@ -184,7 +184,7 @@ void rfkill_pause_polling(struct rfkill *rfkill);
+  * NOTE: not necessary for suspend/resume -- in that case the
+  * core stops polling anyway
+  */
+-void rfkill_resume_polling(struct rfkill *rfkill);
++void backport_rfkill_resume_polling(struct rfkill *rfkill);
+ 
+ 
+ /**
+@@ -195,7 +195,7 @@ void rfkill_resume_polling(struct rfkill *rfkill);
+  * teardown to destroy rfkill structure. Until it returns, the driver
+  * needs to be able to service method calls.
+  */
+-void rfkill_unregister(struct rfkill *rfkill);
++void backport_rfkill_unregister(struct rfkill *rfkill);
+ 
+ /**
+  * rfkill_destroy - free rfkill structure
+@@ -203,7 +203,7 @@ void rfkill_unregister(struct rfkill *rfkill);
+  *
+  * Destroys the rfkill structure.
+  */
+-void rfkill_destroy(struct rfkill *rfkill);
++void backport_rfkill_destroy(struct rfkill *rfkill);
+ 
+ /**
+  * rfkill_set_hw_state - Set the internal rfkill hardware block state
+@@ -224,7 +224,7 @@ void rfkill_destroy(struct rfkill *rfkill);
+  * should be blocked) so that drivers need not keep track of the soft
+  * block state -- which they might not be able to.
+  */
+-bool __must_check rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
++bool __must_check backport_rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
+ 
+ /**
+  * rfkill_set_sw_state - Set the internal rfkill software block state
+@@ -244,7 +244,7 @@ bool __must_check rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
+  * The function returns the combined block state (true if transmitter
+  * should be blocked).
+  */
+-bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked);
++bool backport_rfkill_set_sw_state(struct rfkill *rfkill, bool blocked);
+ 
+ /**
+  * rfkill_set_states - Set the internal rfkill block states
+@@ -255,17 +255,17 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked);
+  * This function can be called in any context, even from within rfkill
+  * callbacks.
+  */
+-void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw);
++void backport_rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw);
+ 
+ /**
+  * rfkill_blocked - query rfkill block
+  *
+  * @rfkill: rfkill struct to query
+  */
+-bool rfkill_blocked(struct rfkill *rfkill);
+-#else /* !RFKILL */
++bool backport_rfkill_blocked(struct rfkill *rfkill);
++#else /* !RFKILL_BACKPORT */
+ static inline struct rfkill * __must_check
+-rfkill_alloc(const char *name,
++backport_rfkill_alloc(const char *name,
+ 	     struct device *parent,
+ 	     const enum rfkill_type type,
+ 	     const struct rfkill_ops *ops,
+@@ -274,57 +274,57 @@ rfkill_alloc(const char *name,
+ 	return ERR_PTR(-ENODEV);
+ }
+ 
+-static inline int __must_check rfkill_register(struct rfkill *rfkill)
++static inline int __must_check backport_rfkill_register(struct rfkill *rfkill)
+ {
+ 	if (rfkill == ERR_PTR(-ENODEV))
+ 		return 0;
+ 	return -EINVAL;
+ }
+ 
+-static inline void rfkill_pause_polling(struct rfkill *rfkill)
++static inline void backport_rfkill_pause_polling(struct rfkill *rfkill)
+ {
+ }
+ 
+-static inline void rfkill_resume_polling(struct rfkill *rfkill)
++static inline void backport_rfkill_resume_polling(struct rfkill *rfkill)
+ {
+ }
+ 
+-static inline void rfkill_unregister(struct rfkill *rfkill)
++static inline void backport_rfkill_unregister(struct rfkill *rfkill)
+ {
+ }
+ 
+-static inline void rfkill_destroy(struct rfkill *rfkill)
++static inline void backport_rfkill_destroy(struct rfkill *rfkill)
+ {
+ }
+ 
+-static inline bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
++static inline bool backport_rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
+ {
+ 	return blocked;
+ }
+ 
+-static inline bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
++static inline bool backport_rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
+ {
+ 	return blocked;
+ }
+ 
+-static inline void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
++static inline void backport_rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
+ {
+ }
+ 
+-static inline bool rfkill_blocked(struct rfkill *rfkill)
++static inline bool backport_rfkill_blocked(struct rfkill *rfkill)
+ {
+ 	return false;
+ }
+-#endif /* RFKILL || RFKILL_MODULE */
++#endif /* RFKILL_BACKPORT || RFKILL_BACKPORT_MODULE */
+ 
+ 
+-#ifdef CONFIG_RFKILL_LEDS
++#ifdef CONFIG_RFKILL_BACKPORT_LEDS
+ /**
+  * rfkill_get_led_trigger_name - Get the LED trigger name for the button's LED.
+  * This function might return a NULL pointer if registering of the
+  * LED trigger failed. Use this as "default_trigger" for the LED.
+  */
+-const char *rfkill_get_led_trigger_name(struct rfkill *rfkill);
++const char *backport_rfkill_get_led_trigger_name(struct rfkill *rfkill);
+ 
+ /**
+  * rfkill_set_led_trigger_name -- set the LED trigger name
+@@ -335,15 +335,15 @@ const char *rfkill_get_led_trigger_name(struct rfkill *rfkill);
+  * trigger that rfkill creates. It is optional, but if called
+  * must be called before rfkill_register() to be effective.
+  */
+-void rfkill_set_led_trigger_name(struct rfkill *rfkill, const char *name);
++void backport_rfkill_set_led_trigger_name(struct rfkill *rfkill, const char *name);
+ #else
+-static inline const char *rfkill_get_led_trigger_name(struct rfkill *rfkill)
++static inline const char *backport_rfkill_get_led_trigger_name(struct rfkill *rfkill)
+ {
+ 	return NULL;
+ }
+ 
+ static inline void
+-rfkill_set_led_trigger_name(struct rfkill *rfkill, const char *name)
++backport_rfkill_set_led_trigger_name(struct rfkill *rfkill, const char *name)
+ {
+ }
+ #endif
 --- a/include/net/cfg80211.h
 +++ b/include/net/cfg80211.h
 @@ -23,6 +23,7 @@
@@ -657,6 +992,342 @@
  
  	return queue;
  }
+--- a/net/rfkill/Makefile
++++ b/net/rfkill/Makefile
+@@ -2,6 +2,6 @@
+ # Makefile for the RF switch subsystem.
+ #
+ 
+-rfkill-y			+= core.o
+-rfkill-$(CONFIG_RFKILL_INPUT)	+= input.o
+-obj-$(CONFIG_RFKILL)		+= rfkill.o
++rfkill_backport-y			+= core.o
++rfkill_backport-$(CONFIG_RFKILL_BACKPORT_INPUT)	+= input.o
++obj-$(CONFIG_RFKILL_BACKPORT)		+= rfkill_backport.o
+--- a/net/rfkill/core.c
++++ b/net/rfkill/core.c
+@@ -26,7 +26,7 @@
+ #include <linux/capability.h>
+ #include <linux/list.h>
+ #include <linux/mutex.h>
+-#include <linux/rfkill.h>
++#include <linux/rfkill_backport.h>
+ #include <linux/spinlock.h>
+ #include <linux/miscdevice.h>
+ #include <linux/wait.h>
+@@ -62,7 +62,7 @@ struct rfkill {
+ 	const struct rfkill_ops	*ops;
+ 	void			*data;
+ 
+-#ifdef CONFIG_RFKILL_LEDS
++#ifdef CONFIG_RFKILL_BACKPORT_LEDS
+ 	struct led_trigger	led_trigger;
+ 	const char		*ledtrigname;
+ #endif
+@@ -123,7 +123,7 @@ static struct {
+ static bool rfkill_epo_lock_active;
+ 
+ 
+-#ifdef CONFIG_RFKILL_LEDS
++#ifdef CONFIG_RFKILL_BACKPORT_LEDS
+ static void rfkill_led_trigger_event(struct rfkill *rfkill)
+ {
+ 	struct led_trigger *trigger;
+@@ -148,19 +148,19 @@ static void rfkill_led_trigger_activate(struct led_classdev *led)
+ 	rfkill_led_trigger_event(rfkill);
+ }
+ 
+-const char *rfkill_get_led_trigger_name(struct rfkill *rfkill)
++const char *backport_rfkill_get_led_trigger_name(struct rfkill *rfkill)
+ {
+ 	return rfkill->led_trigger.name;
+ }
+-EXPORT_SYMBOL(rfkill_get_led_trigger_name);
++EXPORT_SYMBOL(backport_rfkill_get_led_trigger_name);
+ 
+-void rfkill_set_led_trigger_name(struct rfkill *rfkill, const char *name)
++void backport_rfkill_set_led_trigger_name(struct rfkill *rfkill, const char *name)
+ {
+ 	BUG_ON(!rfkill);
+ 
+ 	rfkill->ledtrigname = name;
+ }
+-EXPORT_SYMBOL(rfkill_set_led_trigger_name);
++EXPORT_SYMBOL(backport_rfkill_set_led_trigger_name);
+ 
+ static int rfkill_led_trigger_register(struct rfkill *rfkill)
+ {
+@@ -187,7 +187,7 @@ static inline int rfkill_led_trigger_register(struct rfkill *rfkill)
+ static inline void rfkill_led_trigger_unregister(struct rfkill *rfkill)
+ {
+ }
+-#endif /* CONFIG_RFKILL_LEDS */
++#endif /* CONFIG_RFKILL_BACKPORT_LEDS */
+ 
+ static void rfkill_fill_event(struct rfkill_event *ev, struct rfkill *rfkill,
+ 			      enum rfkill_operation op)
+@@ -317,7 +317,7 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
+ 	rfkill_event(rfkill);
+ }
+ 
+-#ifdef CONFIG_RFKILL_INPUT
++#ifdef CONFIG_RFKILL_BACKPORT_INPUT
+ static atomic_t rfkill_input_disabled = ATOMIC_INIT(0);
+ 
+ /**
+@@ -464,7 +464,7 @@ bool rfkill_get_global_sw_state(const enum rfkill_type type)
+ #endif
+ 
+ 
+-bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
++bool backport_rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
+ {
+ 	bool ret, change;
+ 
+@@ -478,7 +478,7 @@ bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
+ 
+ 	return ret;
+ }
+-EXPORT_SYMBOL(rfkill_set_hw_state);
++EXPORT_SYMBOL(backport_rfkill_set_hw_state);
+ 
+ static void __rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
+ {
+@@ -494,7 +494,7 @@ static void __rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
+ 		rfkill->state &= ~bit;
+ }
+ 
+-bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
++bool backport_rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
+ {
+ 	unsigned long flags;
+ 	bool prev, hwblock;
+@@ -519,9 +519,9 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
+ 
+ 	return blocked;
+ }
+-EXPORT_SYMBOL(rfkill_set_sw_state);
++EXPORT_SYMBOL(backport_rfkill_set_sw_state);
+ 
+-void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
++void backport_rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
+ {
+ 	unsigned long flags;
+ 	bool swprev, hwprev;
+@@ -549,7 +549,7 @@ void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
+ 		rfkill_led_trigger_event(rfkill);
+ 	}
+ }
+-EXPORT_SYMBOL(rfkill_set_states);
++EXPORT_SYMBOL(backport_rfkill_set_states);
+ 
+ static ssize_t rfkill_name_show(struct device *dev,
+ 				struct device_attribute *attr,
+@@ -690,7 +690,7 @@ static int rfkill_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
+ 	return error;
+ }
+ 
+-void rfkill_pause_polling(struct rfkill *rfkill)
++void backport_rfkill_pause_polling(struct rfkill *rfkill)
+ {
+ 	BUG_ON(!rfkill);
+ 
+@@ -699,9 +699,9 @@ void rfkill_pause_polling(struct rfkill *rfkill)
+ 
+ 	cancel_delayed_work_sync(&rfkill->poll_work);
+ }
+-EXPORT_SYMBOL(rfkill_pause_polling);
++EXPORT_SYMBOL(backport_rfkill_pause_polling);
+ 
+-void rfkill_resume_polling(struct rfkill *rfkill)
++void backport_rfkill_resume_polling(struct rfkill *rfkill)
+ {
+ 	BUG_ON(!rfkill);
+ 
+@@ -710,13 +710,13 @@ void rfkill_resume_polling(struct rfkill *rfkill)
+ 
+ 	schedule_work(&rfkill->poll_work.work);
+ }
+-EXPORT_SYMBOL(rfkill_resume_polling);
++EXPORT_SYMBOL(backport_rfkill_resume_polling);
+ 
+ static int rfkill_suspend(struct device *dev, pm_message_t state)
+ {
+ 	struct rfkill *rfkill = to_rfkill(dev);
+ 
+-	rfkill_pause_polling(rfkill);
++	backport_rfkill_pause_polling(rfkill);
+ 
+ 	rfkill->suspended = true;
+ 
+@@ -733,13 +733,13 @@ static int rfkill_resume(struct device *dev)
+ 
+ 	rfkill->suspended = false;
+ 
+-	rfkill_resume_polling(rfkill);
++	backport_rfkill_resume_polling(rfkill);
+ 
+ 	return 0;
+ }
+ 
+ static struct class rfkill_class = {
+-	.name		= "rfkill",
++	.name		= "rfkill_backport",
+ 	.dev_release	= rfkill_release,
+ 	.dev_attrs	= rfkill_dev_attrs,
+ 	.dev_uevent	= rfkill_dev_uevent,
+@@ -747,7 +747,7 @@ static struct class rfkill_class = {
+ 	.resume		= rfkill_resume,
+ };
+ 
+-bool rfkill_blocked(struct rfkill *rfkill)
++bool backport_rfkill_blocked(struct rfkill *rfkill)
+ {
+ 	unsigned long flags;
+ 	u32 state;
+@@ -758,10 +758,10 @@ bool rfkill_blocked(struct rfkill *rfkill)
+ 
+ 	return !!(state & RFKILL_BLOCK_ANY);
+ }
+-EXPORT_SYMBOL(rfkill_blocked);
++EXPORT_SYMBOL(backport_rfkill_blocked);
+ 
+ 
+-struct rfkill * __must_check rfkill_alloc(const char *name,
++struct rfkill * __must_check backport_rfkill_alloc(const char *name,
+ 					  struct device *parent,
+ 					  const enum rfkill_type type,
+ 					  const struct rfkill_ops *ops,
+@@ -800,7 +800,7 @@ struct rfkill * __must_check rfkill_alloc(const char *name,
+ 
+ 	return rfkill;
+ }
+-EXPORT_SYMBOL(rfkill_alloc);
++EXPORT_SYMBOL(backport_rfkill_alloc);
+ 
+ static void rfkill_poll(struct work_struct *work)
+ {
+@@ -843,7 +843,7 @@ static void rfkill_sync_work(struct work_struct *work)
+ 	mutex_unlock(&rfkill_global_mutex);
+ }
+ 
+-int __must_check rfkill_register(struct rfkill *rfkill)
++int __must_check backport_rfkill_register(struct rfkill *rfkill)
+ {
+ 	static unsigned long rfkill_no;
+ 	struct device *dev = &rfkill->dev;
+@@ -885,7 +885,7 @@ int __must_check rfkill_register(struct rfkill *rfkill)
+ 	if (!rfkill->persistent || rfkill_epo_lock_active) {
+ 		schedule_work(&rfkill->sync_work);
+ 	} else {
+-#ifdef CONFIG_RFKILL_INPUT
++#ifdef CONFIG_RFKILL_BACKPORT_INPUT
+ 		bool soft_blocked = !!(rfkill->state & RFKILL_BLOCK_SW);
+ 
+ 		if (!atomic_read(&rfkill_input_disabled))
+@@ -906,9 +906,9 @@ int __must_check rfkill_register(struct rfkill *rfkill)
+ 	mutex_unlock(&rfkill_global_mutex);
+ 	return error;
+ }
+-EXPORT_SYMBOL(rfkill_register);
++EXPORT_SYMBOL(backport_rfkill_register);
+ 
+-void rfkill_unregister(struct rfkill *rfkill)
++void backport_rfkill_unregister(struct rfkill *rfkill)
+ {
+ 	BUG_ON(!rfkill);
+ 
+@@ -929,14 +929,14 @@ void rfkill_unregister(struct rfkill *rfkill)
+ 
+ 	rfkill_led_trigger_unregister(rfkill);
+ }
+-EXPORT_SYMBOL(rfkill_unregister);
++EXPORT_SYMBOL(backport_rfkill_unregister);
+ 
+-void rfkill_destroy(struct rfkill *rfkill)
++void backport_rfkill_destroy(struct rfkill *rfkill)
+ {
+ 	if (rfkill)
+ 		put_device(&rfkill->dev);
+ }
+-EXPORT_SYMBOL(rfkill_destroy);
++EXPORT_SYMBOL(backport_rfkill_destroy);
+ 
+ static int rfkill_fop_open(struct inode *inode, struct file *file)
+ {
+@@ -1107,7 +1107,7 @@ static int rfkill_fop_release(struct inode *inode, struct file *file)
+ 	list_for_each_entry_safe(ev, tmp, &data->events, list)
+ 		kfree(ev);
+ 
+-#ifdef CONFIG_RFKILL_INPUT
++#ifdef CONFIG_RFKILL_BACKPORT_INPUT
+ 	if (data->input_handler)
+ 		if (atomic_dec_return(&rfkill_input_disabled) == 0)
+ 			printk(KERN_DEBUG "rfkill: input handler enabled\n");
+@@ -1118,7 +1118,7 @@ static int rfkill_fop_release(struct inode *inode, struct file *file)
+ 	return 0;
+ }
+ 
+-#ifdef CONFIG_RFKILL_INPUT
++#ifdef CONFIG_RFKILL_BACKPORT_INPUT
+ static long rfkill_fop_ioctl(struct file *file, unsigned int cmd,
+ 			     unsigned long arg)
+ {
+@@ -1150,14 +1150,14 @@ static const struct file_operations rfkill_fops = {
+ 	.write		= rfkill_fop_write,
+ 	.poll		= rfkill_fop_poll,
+ 	.release	= rfkill_fop_release,
+-#ifdef CONFIG_RFKILL_INPUT
++#ifdef CONFIG_RFKILL_BACKPORT_INPUT
+ 	.unlocked_ioctl	= rfkill_fop_ioctl,
+ 	.compat_ioctl	= rfkill_fop_ioctl,
+ #endif
+ };
+ 
+ static struct miscdevice rfkill_miscdev = {
+-	.name	= "rfkill",
++	.name	= "rfkill_backport",
+ 	.fops	= &rfkill_fops,
+ 	.minor	= MISC_DYNAMIC_MINOR,
+ };
+@@ -1180,7 +1180,7 @@ static int __init rfkill_init(void)
+ 		goto out;
+ 	}
+ 
+-#ifdef CONFIG_RFKILL_INPUT
++#ifdef CONFIG_RFKILL_BACKPORT_INPUT
+ 	error = rfkill_handler_init();
+ 	if (error) {
+ 		misc_deregister(&rfkill_miscdev);
+@@ -1196,7 +1196,7 @@ subsys_initcall(rfkill_init);
+ 
+ static void __exit rfkill_exit(void)
+ {
+-#ifdef CONFIG_RFKILL_INPUT
++#ifdef CONFIG_RFKILL_BACKPORT_INPUT
+ 	rfkill_handler_exit();
+ #endif
+ 	misc_deregister(&rfkill_miscdev);
+--- a/net/rfkill/input.c
++++ b/net/rfkill/input.c
+@@ -17,7 +17,7 @@
+ #include <linux/slab.h>
+ #include <linux/workqueue.h>
+ #include <linux/init.h>
+-#include <linux/rfkill.h>
++#include <linux/rfkill_backport.h>
+ #include <linux/sched.h>
+ 
+ #include "rfkill.h"
+@@ -229,7 +229,7 @@ static int rfkill_connect(struct input_handler *handler, struct input_dev *dev,
+ 
+ 	handle->dev = dev;
+ 	handle->handler = handler;
+-	handle->name = "rfkill";
++	handle->name = "rfkill_backport";
+ 
+ 	/* causes rfkill_start() to be called */
+ 	error = input_register_handle(handle);
 --- a/net/wireless/Makefile
 +++ b/net/wireless/Makefile
 @@ -1,11 +1,10 @@
@@ -672,9 +1343,135 @@
  cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
  cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
  
---- a/net/wireless/core.h	2009-05-18 14:36:20.000000000 -0700
-+++ b/net/wireless/core.h	2009-05-18 14:36:20.000000000 -0700
-@@ -104,7 +104,11 @@
+--- a/net/wireless/core.c
++++ b/net/wireless/core.c
+@@ -260,7 +260,11 @@ static void cfg80211_rfkill_sync_work(struct work_struct *work)
+ 	struct cfg80211_registered_device *drv;
+ 
+ 	drv = container_of(work, struct cfg80211_registered_device, rfkill_sync);
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 	cfg80211_rfkill_set_block(drv, rfkill_blocked(drv->rfkill));
++#else
++	cfg80211_rfkill_set_block(drv, backport_rfkill_blocked(drv->rfkill));
++#endif
+ }
+ 
+ /* exported functions */
+@@ -311,9 +315,15 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
+ 	drv->wiphy.dev.platform_data = drv;
+ 
+ 	drv->rfkill_ops.set_block = cfg80211_rfkill_set_block;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 	drv->rfkill = rfkill_alloc(dev_name(&drv->wiphy.dev),
+ 				   &drv->wiphy.dev, RFKILL_TYPE_WLAN,
+ 				   &drv->rfkill_ops, drv);
++#else
++	drv->rfkill = backport_rfkill_alloc(dev_name(&drv->wiphy.dev),
++				   &drv->wiphy.dev, RFKILL_TYPE_WLAN,
++				   &drv->rfkill_ops, drv);
++#endif
+ 
+ 	if (!drv->rfkill) {
+ 		kfree(drv);
+@@ -399,7 +409,11 @@ int wiphy_register(struct wiphy *wiphy)
+ 	if (res)
+ 		return res;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 	res = rfkill_register(drv->rfkill);
++#else
++	res = backport_rfkill_register(drv->rfkill);
++#endif
+ 	if (res)
+ 		goto out_rm_dev;
+ 
+@@ -447,7 +461,11 @@ void wiphy_rfkill_start_polling(struct wiphy *wiphy)
+ 	if (!drv->ops->rfkill_poll)
+ 		return;
+ 	drv->rfkill_ops.poll = cfg80211_rfkill_poll;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 	rfkill_resume_polling(drv->rfkill);
++#else
++	backport_rfkill_resume_polling(drv->rfkill);
++#endif
+ }
+ EXPORT_SYMBOL(wiphy_rfkill_start_polling);
+ 
+@@ -455,7 +473,11 @@ void wiphy_rfkill_stop_polling(struct wiphy *wiphy)
+ {
+ 	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 	rfkill_pause_polling(drv->rfkill);
++#else
++	backport_rfkill_pause_polling(drv->rfkill);
++#endif
+ }
+ EXPORT_SYMBOL(wiphy_rfkill_stop_polling);
+ 
+@@ -463,7 +485,11 @@ void wiphy_unregister(struct wiphy *wiphy)
+ {
+ 	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 	rfkill_unregister(drv->rfkill);
++#else
++	backport_rfkill_unregister(drv->rfkill);
++#endif
+ 
+ 	/* protect the device list */
+ 	mutex_lock(&cfg80211_mutex);
+@@ -501,7 +527,11 @@ EXPORT_SYMBOL(wiphy_unregister);
+ void cfg80211_dev_free(struct cfg80211_registered_device *drv)
+ {
+ 	struct cfg80211_internal_bss *scan, *tmp;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 	rfkill_destroy(drv->rfkill);
++#else
++	backport_rfkill_destroy(drv->rfkill);
++#endif
+ 	mutex_destroy(&drv->mtx);
+ 	mutex_destroy(&drv->devlist_mtx);
+ 	list_for_each_entry_safe(scan, tmp, &drv->bss_list, list)
+@@ -519,7 +549,11 @@ void wiphy_rfkill_set_hw_state(struct wiphy *wiphy, bool blocked)
+ {
+ 	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 	if (rfkill_set_hw_state(drv->rfkill, blocked))
++#else
++	if (backport_rfkill_set_hw_state(drv->rfkill, blocked))
++#endif
+ 		schedule_work(&drv->rfkill_sync);
+ }
+ EXPORT_SYMBOL(wiphy_rfkill_set_hw_state);
+@@ -579,7 +613,11 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
+ 		mutex_unlock(&rdev->devlist_mtx);
+ 		break;
+ 	case NETDEV_PRE_UP:
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 		if (rfkill_blocked(rdev->rfkill))
++#else
++		if (backport_rfkill_blocked(rdev->rfkill))
++#endif
+ 			return notifier_from_errno(-ERFKILL);
+ 		break;
+ 	}
+--- a/net/wireless/core.h
++++ b/net/wireless/core.h
+@@ -11,7 +11,11 @@
+ #include <linux/kref.h>
+ #include <linux/rbtree.h>
+ #include <linux/debugfs.h>
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ #include <linux/rfkill.h>
++#else
++#include <linux/rfkill_backport.h>
++#endif
+ #include <linux/workqueue.h>
+ #include <net/genetlink.h>
+ #include <net/cfg80211.h>
+@@ -104,7 +108,11 @@ struct cfg80211_internal_bss {
  	struct rb_node rbn;
  	unsigned long ts;
  	struct kref ref;
@@ -736,3 +1533,41 @@
  		kref_put(&res->ref, bss_release);
  	} else {
  		/* this "consumes" the reference */
+--- a/net/wireless/wext-compat.c
++++ b/net/wireless/wext-compat.c
+@@ -764,7 +764,11 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
+ 
+ 	/* only change when not disabling */
+ 	if (!data->txpower.disabled) {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 		rfkill_set_sw_state(rdev->rfkill, false);
++#else
++		backport_rfkill_set_sw_state(rdev->rfkill, false);
++#endif
+ 
+ 		if (data->txpower.fixed) {
+ 			/*
+@@ -789,7 +793,11 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
+ 			}
+ 		}
+ 	} else {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 		rfkill_set_sw_state(rdev->rfkill, true);
++#else
++		backport_rfkill_set_sw_state(rdev->rfkill, true);
++#endif
+ 		schedule_work(&rdev->rfkill_sync);
+ 		return 0;
+ 	}
+@@ -820,7 +828,11 @@ int cfg80211_wext_giwtxpower(struct net_device *dev,
+ 
+ 	/* well... oh well */
+ 	data->txpower.fixed = 1;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 	data->txpower.disabled = rfkill_blocked(rdev->rfkill);
++#else
++	data->txpower.disabled = backport_rfkill_blocked(rdev->rfkill);
++#endif
+ 	data->txpower.value = val;
+ 	data->txpower.flags = IW_TXPOW_DBM;
+ 
diff --git a/compat/compat.h b/compat/compat.h
index f951a37..964a512 100644
--- a/compat/compat.h
+++ b/compat/compat.h
@@ -93,6 +93,28 @@ static inline void skb_queue_splice_tail_init(struct sk_buff_head *list,
 #define SDIO_DEVICE_ID_MARVELL_8688WLAN		0x9104
 #endif
 
+#ifndef ERFKILL
+#if !defined(CONFIG_ALPHA) && !defined(CONFIG_MIPS) && !defined(CONFIG_PARISC) && !defined(CONFIG_SPARC)
+#define ERFKILL		132	/* Operation not possible due to RF-kill */
+#endif
+#ifdef CONFIG_ALPHA
+#define ERFKILL		138	/* Operation not possible due to RF-kill */
+#endif
+#ifdef CONFIG_MIPS
+#define ERFKILL		167	/* Operation not possible due to RF-kill */
+#endif
+#ifdef CONFIG_PARISC
+#define ERFKILL		256	/* Operation not possible due to RF-kill */
+#endif
+#ifdef CONFIG_SPARC
+#define ERFKILL		134	/* Operation not possible due to RF-kill */
+#endif
+#endif
+
+#ifndef NETDEV_PRE_UP
+#define NETDEV_PRE_UP		0x000D
+#endif
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) */
 
 #endif /* LINUX_26_COMPAT_H */
diff --git a/config.mk b/config.mk
index 8992f9b..c06c9c2 100644
--- a/config.mk
+++ b/config.mk
@@ -123,13 +123,14 @@ ifneq ($(CONFIG_PCI),)
 
 CONFIG_ATH5K=m
 # CONFIG_ATH5K_DEBUG=y
+CONFIG_ATH5K_RFKILL=y
 CONFIG_ATH9K=m
 # CONFIG_ATH9K_DEBUG=y
 
 
 CONFIG_IWLWIFI=m
 CONFIG_IWLWIFI_LEDS=y
-# CONFIG_IWLWIFI_RFKILL=y
+CONFIG_IWLWIFI_RFKILL=y
 CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=y
 # CONFIG_IWLWIFI_DEBUG=y
 # CONFIG_IWLWIFI_DEBUGFS=y
@@ -147,7 +148,7 @@ CONFIG_B43_PCICORE_AUTOSELECT=y
 CONFIG_B43_PCMCIA=y
 CONFIG_B43_PIO=y
 CONFIG_B43_LEDS=y
-# CONFIG_B43_RFKILL=y
+CONFIG_B43_RFKILL=y
 # CONFIG_B43_DEBUG=y
 # CONFIG_B43_FORCE_PIO=y
 
@@ -156,7 +157,7 @@ CONFIG_B43LEGACY_HWRNG=y
 CONFIG_B43LEGACY_PCI_AUTOSELECT=y
 CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
 CONFIG_B43LEGACY_LEDS=y
-# CONFIG_B43LEGACY_RFKILL=y
+CONFIG_B43LEGACY_RFKILL=y
 # CONFIG_B43LEGACY_DEBUG=y
 CONFIG_B43LEGACY_DMA=y
 CONFIG_B43LEGACY_PIO=y
@@ -322,7 +323,7 @@ CONFIG_RT2X00_LIB=m
 CONFIG_RT2X00_LIB_HT=y
 CONFIG_RT2X00_LIB_FIRMWARE=y
 CONFIG_RT2X00_LIB_CRYPTO=y
-# CONFIG_RT2X00_LIB_RFKILL=y
+CONFIG_RT2X00_LIB_RFKILL=y
 CONFIG_RT2X00_LIB_LEDS=y
 # CONFIG_RT2X00_LIB_DEBUGFS=y
 # CONFIG_RT2X00_DEBUG=y
@@ -352,3 +353,7 @@ CONFIG_LIBERTAS=m
 # CONFIG_LIBERTAS_DEBUG=y
 endif
 
+CONFIG_RFKILL_BACKPORT=m
+CONFIG_RFKILL_BACKPORT_LEDS=y
+CONFIG_RFKILL_BACKPORT_INPUT=y
+
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 07f7d85..aab866e 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -30,7 +30,7 @@ INCLUDE_LINUX_SPI="wl12xx.h libertas_spi.h"
 INCLUDE_NET="cfg80211.h ieee80211_radiotap.h iw_handler.h"
 INCLUDE_NET="$INCLUDE_NET mac80211.h wext.h lib80211.h regulatory.h"
 
-NET_DIRS="wireless mac80211"
+NET_DIRS="wireless mac80211 rfkill"
 # User exported this variable
 if [ -z $GIT_TREE ]; then
 	GIT_TREE="/home/$USER/devel/wireless-testing/"
@@ -77,6 +77,7 @@ mkdir -p include/linux/ include/net/ include/linux/usb \
 	include/linux/unaligned \
 	include/linux/spi \
 	net/mac80211/ net/wireless/ \
+	net/rfkill/ \
 	drivers/ssb/ \
 	drivers/net/usb/ \
 	drivers/net/wireless/
@@ -89,6 +90,7 @@ for i in $INCLUDE_LINUX; do
 done
 
 cp -a $GIT_TREE/include/linux/ssb include/linux/
+cp -a $GIT_TREE/include/linux/rfkill.h include/linux/rfkill_backport.h
 
 # include/net
 DIR="include/net"
-- 
1.6.2.1

