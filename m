Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:40442 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbYJGP11 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 11:27:27 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register  access?
References: <87k5cm3ee2.fsf@denkblock.local>
	<alpine.LFD.2.00.0810052354000.3398@apollo>
	<87d4id3jmr.fsf@denkblock.local>
	<alpine.LFD.2.00.0810061614490.3166@apollo>
Date: Tue, 07 Oct 2008 17:27:09 +0200
Message-ID: <87skr8h1de.fsf@denkblock.local> (sfid-20081007_172732_454178_F5F4F5B5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 6 Oct 2008, Elias Oltmanns wrote:
>> Make sure that event1 is the right device. chktimer usually reports
>> several premature timer expiries in less than a minute.
[...]
> Your measuring method is wrong. You really want to measure the delta
> of the timer events in the kernel via ktime_get(), not the delta of
> something else in userspace.

Alright, here is a stripped down version of the test case. This time,
you only need to load the timer-test module and start up the ath5k
interface. The glitch is triggered slightly less reliably, but I can
still easily verify that the problem is present when running 2.6.27-rc9
on my system.

Regards,

Elias

---
 drivers/misc/Kconfig      |   11 ++++++++++
 drivers/misc/Makefile     |    1 +
 drivers/misc/timer-test.c |   50 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/timer-test.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index a726f3b..7ebdcfc 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -475,4 +475,15 @@ config SGI_GRU_DEBUG
 	This option enables addition debugging code for the SGI GRU driver. If
 	you are unsure, say N.
 
+config TIMER_TEST
+	tristate "timer stress test"
+	default n
+	select INPUT
+	---help---
+	This is some code for stress testing the timer code. It is purely for
+	debugging purposes and should generally be disabled. If built as a
+	module, the module will be called timer-test.
+
+	If you are unsure, say N.
+
 endif # MISC_DEVICES
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c6c13f6..ffffd78 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
 obj-$(CONFIG_SGI_XP)		+= sgi-xp/
 obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
+obj-$(CONFIG_TIMER_TEST)	+= timer-test.o
diff --git a/drivers/misc/timer-test.c b/drivers/misc/timer-test.c
new file mode 100644
index 0000000..780f3dd
--- /dev/null
+++ b/drivers/misc/timer-test.c
@@ -0,0 +1,50 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
+
+#define TSTM_FREQ 50
+#define __TSTM_THRESH (NSEC_PER_SEC / TSTM_FREQ / 20)
+#if __TSTM_THRESH > 0
+# define TSTM_THRESH __TSTM_THRESH
+#else
+# define TSTM_THRESH 1
+#endif
+
+static struct timer_list tstm_timer;
+
+static void tstm_callback(unsigned long data)
+{
+	static struct timespec before;
+	struct timespec now, diff;
+
+	ktime_get_ts(&now);
+	diff = timespec_sub(now, before);
+	if (timespec_to_ns(&diff) < TSTM_THRESH)
+		printk(KERN_INFO "Timer expired prematurely.\n");
+	before = now;
+	mod_timer(&tstm_timer, jiffies + HZ/TSTM_FREQ);
+}
+
+static int __init tstm_init(void)
+{
+	init_timer(&tstm_timer);
+	tstm_timer.function = tstm_callback;
+	mod_timer(&tstm_timer, jiffies + HZ/TSTM_FREQ);
+
+	printk(KERN_INFO "timer-test: module successfully loaded.\n");
+	return 0;
+}
+
+static void __exit tstm_exit(void)
+{
+	del_timer_sync(&tstm_timer);
+	printk(KERN_INFO "tstm: module unloaded.\n");
+}
+
+module_init(tstm_init);
+module_exit(tstm_exit);
+
+MODULE_AUTHOR("Elias Oltmanns");
+MODULE_DESCRIPTION("Timer stress test module");
+MODULE_LICENSE("GPL v2");
