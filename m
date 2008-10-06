Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:43137 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbYJFOEX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 10:04:23 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register  access?
References: <87k5cm3ee2.fsf@denkblock.local>
	<alpine.LFD.2.00.0810052354000.3398@apollo>
Date: Mon, 06 Oct 2008 16:04:12 +0200
In-Reply-To: <alpine.LFD.2.00.0810052354000.3398@apollo> (Thomas Gleixner's
	message of "Sun, 5 Oct 2008 23:59:05 +0200 (CEST)")
Message-ID: <87d4id3jmr.fsf@denkblock.local> (sfid-20081006_160427_925406_3E8E463C)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=

Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sun, 5 Oct 2008, Elias Oltmanns wrote:
>> Hi there,
>
>> 
>> on my system, I observe some odd symptoms which I have troubled Thomas
>> with before. After some more investigation, I have come to the
>> conclusion that ath5k is at the bottom of this, but since I don't really
>> understand the connection, I thought that Thomas may perhaps throw some
>> light on the matter, after all, even though I still think that ath5k
>> will have to be fixed. The Behaviour I'm seeing is this: sometimes,
>> timers fire prematurely, i.e. a timer x started with
>> 
>> 	mod_timer(&x, HZ/50);
>> 
>> fires after less than 10 or even 1 msec rather than 20 msec. Trying to
>> get to the bottom of this, it struck me that these glitches only occur
>> when ath5k is loaded and an interface is brought up (ifconfig wlan0 up
>> is quite sufficient). Some more digging revealed that the occurrences of
>> such ``fast forward events'' coincided with the expiry of the
>> recalibration timer started for the interface. The same behaviour can be
>> observed on kernels 2.6.25.16, 2.6.26.5, 2.6.27-rc8-git8 and
>> next-20080919.
>
> We had an intermittent problem with jffies based timers between
> 2.6.27-rc6 and -rc8-latest. This is fixed in current mainline. It only
> happened when CONFIG_NOHZ=n and CONFIG_HIGH_RES_TIMERS=n or both
> options were disabled at the kernel commandline.

No, it isn't that one. My problem can be reproduced most reliably when
NO_HZ is enabled (HIGH_RES_TIMERS doesn't seem to matter).

>
> I have no idea why this should happen on any other kernel versions.
>
> Can you please point me to the code in question (file, line number) ?

Well, I'm suspicious about ath5k_calibrate() (defined in
drivers/net/wireless/ath5k/base.c) and everything that gets called from
there, to begin with. This is the timer callback function and is executed
every ten seconds by default. Perhaps you'd like to start by looking at
ath5k_hw_noise_floor_calibration() in drivers/net/wireless/ath5k/phy.c.
This function is called as part of the calibration sequence performed by
ath5k_calibrate() in softirq context. Additionally, it is part of the
reset sequence which can be initiated from various place in both,
process and softirq context (look for calls to ath5k_reset() in
drivers/net/wireless/ath5k/base.c).

Also, here is some information about my test case: Please find below a
patch to Linus' tree which adds a simple test module. Secondly, I've
attached the source of the simple program chktimer. After rebooting into
the new kernel, I do the following to verify that the problem is still
present:

# modprobe evdev
# modprobe timer-test
# modprobe ath5k
# ifconfig wlan0 up
# chktimer /dev/input/event1

Make sure that event1 is the right device. chktimer usually reports
several premature timer expiries in less than a minute.

Regards,

Elias



--=-=-=
Content-Type: text/x-diff; name=timer-test.patch
Content-Disposition: inline

 drivers/misc/Kconfig      |   11 ++++++
 drivers/misc/Makefile     |    1 +
 drivers/misc/timer-test.c |   80 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 92 insertions(+), 0 deletions(-)
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
index 0000000..a58adcf
--- /dev/null
+++ b/drivers/misc/timer-test.c
@@ -0,0 +1,80 @@
+#include <linux/input.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
+#include <linux/delay.h>
+
+#define TSTM_FREQ 50
+
+static struct timer_list tstm_timer;
+static struct input_dev *tstm_idev;
+static int key_state = 0;
+
+static void tstm_input_update(unsigned long data)
+{
+	key_state ^= 1;
+	input_report_key(tstm_idev, BTN_0, key_state);
+	input_sync(tstm_idev);
+	mod_timer(&tstm_timer, jiffies + HZ/TSTM_FREQ);
+}
+
+static int tstm_dev_open(struct input_dev *dev)
+{
+	mod_timer(&tstm_timer, jiffies + HZ/TSTM_FREQ);
+	return 0;
+}
+
+static void tstm_dev_close(struct input_dev *dev)
+{
+	del_timer_sync(&tstm_timer);
+}
+
+static int __init tstm_init(void)
+{
+	int ret;
+
+	tstm_idev = input_allocate_device();
+	if (!tstm_idev) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* initialise the input device */
+	tstm_idev->name = "Timer stress test data";
+	tstm_idev->phys = "tstm/input0";
+	tstm_idev->id.bustype = BUS_HOST;
+	tstm_idev->evbit[0] = BIT(EV_KEY);
+	tstm_idev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+	tstm_idev->open = tstm_dev_open;
+	tstm_idev->close = tstm_dev_close;
+
+	ret = input_register_device(tstm_idev);
+	if (ret)
+		goto out_idev;
+
+	init_timer(&tstm_timer);
+	tstm_timer.function = tstm_input_update;
+
+	printk(KERN_INFO "timer-test: module successfully loaded.\n");
+	return 0;
+
+out_idev:
+	input_free_device(tstm_idev);
+out:
+	printk(KERN_WARNING "timer-test: module init failed (ret=%d)!\n", ret);
+	return ret;
+}
+
+static void __exit tstm_exit(void)
+{
+	input_unregister_device(tstm_idev);
+	printk(KERN_INFO "tstm: module unloaded.\n");
+}
+
+module_init(tstm_init);
+module_exit(tstm_exit);
+
+MODULE_AUTHOR("Elias Oltmanns");
+MODULE_DESCRIPTION("Timer stress test module");
+MODULE_LICENSE("GPL v2");

--=-=-=
Content-Type: text/x-csrc; name=chktimer.c
Content-Disposition: inline

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/time.h>
#include <errno.h>
#include <linux/input.h>

int main(int argc, char *argv[])
{
	struct input_event ev;
	double unow = 0, old_unow = 0;
	int fd;

	if (argc != 2) {
		printf("Usage: %s <inputdev>\n", argv[0]);
		return 1;
	}
	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		printf("Cannot open %s.\n", argv[1]);
		return 2;
	}

	while (read(fd, &ev, sizeof(struct input_event)) ==
	       sizeof(struct input_event)) {
		if (ev.type != EV_SYN)
			continue;

		unow = ev.time.tv_sec + ev.time.tv_usec/1000000.0;
		if (unow - old_unow < 0.001) {
			struct timeval tm;

			gettimeofday(&tm, NULL);
			printf("[%5lu.%06lu] Premature timer expiry.\n",
			       tm.tv_sec, tm.tv_usec);
		}
		old_unow = unow;
	}

	return 0;
}

--=-=-=--
