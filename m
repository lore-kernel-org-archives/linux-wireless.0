Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout023.mac.com ([17.148.16.98]:48101 "EHLO
	asmtpout023.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629Ab0KPPCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 10:02:18 -0500
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Received: from [192.168.1.100] ([87.201.169.183])
 by asmtp023.mac.com (Sun Java(tm) System Messaging Server 6.3-8.01 (built Dec
 16 2008; 32bit)) with ESMTPSA id <0LBZ008IYGF6TF10@asmtp023.mac.com> for
 linux-wireless@vger.kernel.org; Tue, 16 Nov 2010 07:01:58 -0800 (PST)
Subject: Re: Android 2.2/2.2.1 wifi not working after restart with driver-awext
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <201011161304.26637.holgerschurig@gmail.com>
Date: Tue, 16 Nov 2010 19:01:33 +0400
Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Message-id: <873543BB-F827-4B21-BEA0-F538015CDA9A@mac.com>
References: <0604E650-C4CD-40FF-ACC6-262E555C8194@mac.com>
 <201011161304.26637.holgerschurig@gmail.com>
To: Holger Schurig <holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Holger,

On Nov 16, 2010, at 4:04 PM, Holger Schurig wrote:

> Android doesn't work well with upstream groups. They made their own ecosystem,
> both in kernel-space and much more in user-space. They also usualy use
> outdated software, e.g. ancient kernel version.

Tell me about it! :-) The current version that I'm working on is 2.6.32.

> You're therefore encouraged to use android-specific mailing-lists or forums to
> solve your problems.

I had a feeling I might get this response, since this was not kernel wireless driver
specific issue. There are no android wireless equivalent mailing-list or forums, like
there is for linux. The android-porting groups list, I didn't get any response for
a whole month. Its pretty fragmented. 

> That said, the interface isn't up, contrary to your belief:

This is not true. You probably read the last few sections of the log file. On
first start and connect, wifi works and I'm able to use the wlan0 interface 
and browse the internet. 

After turning off wifi and turning it back on from the control panel, it doesnt
connect, and you see the following message. 

> 
> V/WifiStateTracker(  969): Changing supplicant state: DISCONNECTED ==> 
> SCANNING
> I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWSTATS]: Operation not 
> supported on transport endpoint
> I//system/bin/wpa_supplicant( 1396): ioctl[SIOCGIWRATE]: Network is down
> 
> So something in restarting the wifi link forgot Android's equivalent
> of "ifconfig $interface up". If the interface isn't up, it won't scan. Without
> current scan results and an "up"-interface, it cannot associate.

In my init.rc file, I have the following entry, which is intended to bring wlan0 up

service ifcfg_ralink /system/bin/ifconfig wlan0 up
    group system wifi
    disabled
    oneshot

which probably gets called in the following code fragment from libhardware_legacy/wifi/wifi.c for wifi_load_driver()

diff --git a/wifi/wifi.c b/wifi/wifi.c
index 3f8708d..7533a64 100644
--- a/wifi/wifi.c
+++ b/wifi/wifi.c
@@ -188,8 +188,10 @@ int wifi_load_driver()
     sched_yield();
     while (count-- > 0) {
         if (property_get(DRIVER_PROP_NAME, driver_status, NULL)) {
-            if (strcmp(driver_status, "ok") == 0)
+            if (strcmp(driver_status, "ok") == 0) {
+		property_set("ctl.start", "ifcfg_ralink");
                 return 0;
+	    }
             else if (strcmp(DRIVER_PROP_NAME, "failed") == 0) {
                 wifi_unload_driver();
                 return -1;

Best regards,

Elvis Dowson

Elvis Dowson
