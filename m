Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:50399 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab0HARFk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 13:05:40 -0400
Subject: wl1251 issues
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@adurom.com>
Content-Type: multipart/mixed; boundary="=-lgan/aSOA8NUapgUjGIi"
Date: Sun, 01 Aug 2010 19:05:26 +0200
Message-ID: <1280682326.3868.37.camel@gnutoo-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lgan/aSOA8NUapgUjGIi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi, I've an htc dream(also known as G1,first google phone,same device
than the ADP1 )
I prefer GNU/Linux than android,mainly because of the small number of
free software applications for android,and also because I'm used to
GNU/Linux(I feel at home).
So I helped standardizing and debugging the htcdream kernel in order to
be able to run GNU/Linux (android has its own userland interfaces for
some periphericals/devices(I mean something like the sound driver,the
wifi driver etc...))

The wifi driver that ships with android is free software,the sources are
available here:
http://android.git.kernel.org/?p=platform/hardware/ti/wlan.git;a=summary

But unfortunately it uses non-standard userspace<->kernel interfaces.
The non-standard interfaces are used by a patched wpa_supplicant.
The non-standard wpa_supplicant depend on android.

But...there is a wl1251_sdio standard driver in the android kernel we
used,which is available here:
http://gitorious.org/htc-msm-2-6-32/leviathan-incoming/commits/android-msm-2.6.32-rebase
It is derived from the android-msm-2.6.32 branch of the android kernel
available here:
http://android.git.kernel.org/?p=kernel/msm.git;a=summary
At first I used this driver.
But unfortunately it didn't support Power saving modes,and so it
consumed the battery in about one hour.

Fortunately compat-wireless has support for Power saving.
So I used that locally and made tests.

So my goal is to have a working wireless driver with PSM and have
standard kernel interfaces(in order to be compatible with userland
applications),using the android ti wlan driver would be the last resort.

The wl1251_sdio depends on the msm sdcard controller which lives at:
drivers/mmc/host/msm_sdcc.c
it contains the flollowing patch:
sdio: add new function for RAW (Read after Write) operation
viewable here:
http://gitorious.org/htc-msm-2-6-32/leviathan-incoming/commit/03e2cd19cb8b0a486ef8b8f2bec60d3c1b88d8b4


In order to keep the conversation and the flow of mail manageable I will
start with the first issue which doesn't involve PSM.

Here's the setup:
*kernel:
http://gitorious.org/htc-msm-2-6-32/leviathan-incoming/commits/android-msm-2.6.32-rebase at the following commit:
sdio: add new function for RAW (Read after Write) operation

*compat-wireless 2010-07-31 with the following attached patches patches:
0011-wl1251-add-reset-handling.patch
0013-wl1251-prevent-scan-when-connected.patch
va_vormat-2.6.36.patch
debug.patch

all is built with openembedded(the compat-wireless recipe is not
commited in org.openembedded.dev because it's changing so often)

Here's the issue(this first issue doesn't involve PSM yet):
I connect trough wpa to the local access point at the wifi cafee(wrt54
somrthing,running an old openwrt with a 2.4 kernel and the proprietary
broadcom module)

I use dhcp to get an ip
The connection last for a while and then I've that:
wlan0     IEEE 802.11bg  ESSID:"essid_has_been_hidden_in_that_mail"  
          Mode:Managed  Frequency:2.432 GHz  Access Point:
00:23:69:XX:XX:XX  
          Bit Rate=1 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=43/70  Signal level=-67 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
That seem connected.

root@htcdream ~ # ping 192.168.2.1
PING 192.168.2.1 (192.168.2.1): 56 data bytes
^C
--- 192.168.2.1 ping statistics ---
22 packets transmitted, 0 packets received, 100% packet loss

here's the wpa connection script output:
ot@htcdream ~ # sh wpa.sh
CTRL-EVENT-SCAN-RESULTS 
Trying to associate with 00:23:69:xx:xx:xx
(SSID='essid_has_been_hidden_in_that_mail' freq=2432 MHz)
Associated with 00:23:69:xx:xx:xx
WPA: Key negotiation completed with 00:23:69:xx:xx:xx [PTK=CCMP
GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:23:69:xx:xx:xx completed (auth)
[id=0 id_str=]

the essid and mac address have been changed.

a while true;do dmesg -c;done gave a still flowing flow of messages:
here's a part of it:
[ 3233.009460] wl1251: IRQ
[ 3233.011016] wl1251: IRQ work
[ 3233.011199] wl1251: intr: 0x1
[ 3233.011260] wl1251: RX: FW +1
[ 3233.011260] wl1251: RX counter: 13
[ 3233.011291] wl1251: WL1251_ACX_INTR_RX0_DATA
[ 3233.011413] wl1251: rx skb 0xc4664c00: 144 B beacon
[ 3233.039428] wl1251: IRQ
[ 3233.039611] wl1251: IRQ work
[ 3233.039764] wl1251: intr: 0x8
[ 3233.039825] wl1251: RX: FW +1
[ 3233.039825] wl1251: RX counter: 14
[ 3233.039855] wl1251: WL1251_ACX_INTR_RX0_DATA
[ 3233.039947] wl1251: rx skb 0xc4664300: 18 B beacon
[ 3233.089447] wl1251: IRQ
[ 3233.089538] wl1251: IRQ work
[ 3233.089660] wl1251: intr: 0x1
[ 3233.089721] wl1251: RX: FW +1
[ 3233.089721] wl1251: RX counter: 15
[ 3233.089752] wl1251: WL1251_ACX_INTR_RX0_DATA
[ 3233.089874] wl1251: rx skb 0xc4664780: 18 B beacon
[ 3233.109436] wl1251: IRQ
[ 3233.109527] wl1251: IRQ work
[ 3233.109680] wl1251: intr: 0x8
[ 3233.109741] wl1251: RX: FW +1
[ 3233.109741] wl1251: RX counter: 0
[ 3233.109741] wl1251: WL1251_ACX_INTR_RX0_DATA
[ 3233.109863] wl1251: rx skb 0xc46649c0: 144 B beacon
[ 3233.159484] wl1251: IRQ
[ 3233.159637] wl1251: IRQ work
[ 3233.159790] wl1251: intr: 0x9
[ 3233.159851] wl1251: RX: FW +2
[ 3233.159851] wl1251: RX counter: 2
[ 3233.159881] wl1251: WL1251_ACX_INTR_RX0_DATA
[ 3233.159973] wl1251: rx skb 0xc4664780: 18 B beacon
[ 3233.160064] wl1251: WL1251_ACX_INTR_RX1_DATA
[ 3233.160186] wl1251: rx skb 0xc4664780: 18 B beacon
[ 3233.209472] wl1251: IRQ
[ 3233.209564] wl1251: IRQ work
[ 3233.209686] wl1251: intr: 0x1
[ 3233.209747] wl1251: RX: FW +1
[ 3233.209777] wl1251: RX counter: 3
[ 3233.209777] wl1251: WL1251_ACX_INTR_RX0_DATA
[ 3233.209899] wl1251: rx skb 0xc4664840: 144 B beacon


I've also a rt2070 card, should I make tests with that card instead?

Denis


--=-lgan/aSOA8NUapgUjGIi
Content-Disposition: attachment; filename="0011-wl1251-add-reset-handling.patch"
Content-Type: text/x-patch; name="0011-wl1251-add-reset-handling.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Index: compat-wireless-2010-06-19/drivers/net/wireless/wl12xx/wl1251_sdio.c
===================================================================
--- compat-wireless-2010-06-19.orig/drivers/net/wireless/wl12xx/wl1251_sdio.c	2010-06-20 22:04:12.776553632 +0200
+++ compat-wireless-2010-06-19/drivers/net/wireless/wl12xx/wl1251_sdio.c	2010-06-20 22:06:30.375232047 +0200
@@ -131,6 +131,20 @@
 
 static void wl1251_sdio_reset(struct wl1251 *wl)
 {
+	extern int sdio_reset_comm(struct mmc_card *card);
+	struct sdio_func *func = wl_to_func(wl);
+	int ret;
+
+	sdio_claim_host(func);
+	sdio_reset_comm(func->card);
+	ret = sdio_enable_func(func);
+	if (ret)
+		goto release;
+
+	sdio_set_block_size(func, 512);
+
+release:
+	sdio_release_host(func);
 }
 
 static void wl1251_sdio_enable_irq(struct wl1251 *wl)
@@ -271,6 +285,9 @@
 	ret = wl1251_init_ieee80211(wl);
 	if (ret)
 		goto out_free_irq;
+	
+	/* we can power it down now until it's started */
+	wl->set_power(0);
 
 	sdio_set_drvdata(func, wl);
 	return ret;

--=-lgan/aSOA8NUapgUjGIi
Content-Disposition: attachment; filename="0013-wl1251-prevent-scan-when-connected.patch"
Content-Type: text/x-patch; name="0013-wl1251-prevent-scan-when-connected.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Index: compat-wireless-2010-07-31/drivers/net/wireless/wl12xx/wl1251.h
===================================================================
--- compat-wireless-2010-07-31.orig/drivers/net/wireless/wl12xx/wl1251.h	2010-08-01 15:04:21.219724545 +0200
+++ compat-wireless-2010-07-31/drivers/net/wireless/wl12xx/wl1251.h	2010-08-01 15:05:22.307219824 +0200
@@ -381,7 +381,9 @@
 
 	u32 chip_id;
 	char fw_ver[21];
-
+	
+	bool associated;
+	
 	/* Most recently reported noise in dBm */
 	s8 noise;
 };
Index: compat-wireless-2010-07-31/drivers/net/wireless/wl12xx/wl1251_main.c
===================================================================
--- compat-wireless-2010-07-31.orig/drivers/net/wireless/wl12xx/wl1251_main.c	2010-08-01 15:04:32.919105073 +0200
+++ compat-wireless-2010-07-31/drivers/net/wireless/wl12xx/wl1251_main.c	2010-08-01 15:05:59.668541777 +0200
@@ -874,6 +874,13 @@
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 hw scan");
 
+	/*
+	 * FIXME: scanning while associated causes lockups,
+	 * so we don't allow that
+	 */
+	if (wl->associated)
+		return -EBUSY;
+
 	if (req->n_ssids) {
 		ssid = req->ssids[0].ssid;
 		ssid_len = req->ssids[0].ssid_len;

--=-lgan/aSOA8NUapgUjGIi
Content-Disposition: attachment; filename="va_vormat-2.6.36.patch"
Content-Type: text/x-patch; name="va_vormat-2.6.36.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Index: compat-wireless-2010-07-31/include/linux/compat-2.6.36.h
===================================================================
--- compat-wireless-2010-07-31.orig/include/linux/compat-2.6.36.h	2010-08-01 15:28:00.299100291 +0200
+++ compat-wireless-2010-07-31/include/linux/compat-2.6.36.h	2010-08-01 15:28:26.847223098 +0200
@@ -8,6 +8,11 @@
 #define kparam_block_sysfs_write(a)
 #define kparam_unblock_sysfs_write(a)
 
+struct va_format {
+	const char *fmt;
+	va_list *va;
+};
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */

--=-lgan/aSOA8NUapgUjGIi
Content-Disposition: attachment; filename="debug.patch"
Content-Type: text/x-patch; name="debug.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Index: compat-wireless-2010-07-17/drivers/net/wireless/wl12xx/wl1251.h
===================================================================
--- compat-wireless-2010-07-17.orig/drivers/net/wireless/wl12xx/wl1251.h	2010-07-18 18:55:22.054116356 +0200
+++ compat-wireless-2010-07-17/drivers/net/wireless/wl12xx/wl1251.h	2010-07-18 18:55:37.583421412 +0200
@@ -52,7 +52,7 @@
 	DEBUG_ALL	= ~0,
 };
 
-#define DEBUG_LEVEL (DEBUG_NONE)
+#define DEBUG_LEVEL (DEBUG_ALL)
 
 #define DEBUG_DUMP_LIMIT 1024
 

--=-lgan/aSOA8NUapgUjGIi--

