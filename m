Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:24876 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab0CGIQb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 03:16:31 -0500
Subject: Re: Realtek rtl8188 support?
From: Pavel Roskin <proski@gnu.org>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Paul Thomas <pthomas8589@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>
	 <69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Mar 2010 03:16:22 -0500
Message-Id: <1267949782.15192.13.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-03-06 at 19:07 +0100, Gábor Stefanik wrote: 
> Doesn't the RTL8192SU driver handle this chipset already?

Yes, I was able to test it.  I followed instructions from this site:
http://blog.xff.lt/2009/12/28/canyon-cnp-wf518n2-usb-wireless-linux/

I added the ID

diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index 6f424fe..bec729f 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -130,6 +130,7 @@ static struct usb_device_id rtl8192_usb_id_tbl[] = {
 	{USB_DEVICE(0x06f8, 0xe031)},
 	//92SU
 	{USB_DEVICE(0x0bda, 0x8172)},
+	{USB_DEVICE(0x0bda, 0x8171)},
 	{}
 };
 

Then I downloaded the driver from
http://xff.lt/stuff/canyon-wifi/rtl8192se_linux_2.6.0013.1204.2009.tar.gz

I took rtl8192sfw.bin from it and put it to /lib/firmware/RTL8192SU (not
RTL8192SE as in the archive).

I was able to load the driver, bring the interface up and scan.  I could
not connect to an AP with CCMP for some reason:

# wpa_supplicant -c /etc/wpa_supplicant/mike1.conf -i wlan29 -D wext
ioctl[SIOCSIWPMKSA]: Invalid argument
ioctl[SIOCSIWPMKSA]: Invalid argument
CTRL-EVENT-SCAN-RESULTS 
CTRL-EVENT-SCAN-RESULTS 
Trying to associate with 00:25:9c:28:15:62 (SSID='mike1' freq=2437 MHz)
ioctl[SIOCSIWFREQ]: Operation not supported
Association request to the driver failed

But I was able to connect to an unsecured AP:

wlan29    802.11b/g/n  li  ESSID:"mike2"  
          Mode:Managed  Frequency=2.437 GHz  Access Point: 00:26:5A:C2:4C:3D   
          Bit Rate=130 Mb/s   
          Retry min limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=89/100  Signal level=-56 dBm  Noise level=-114 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

I could also use the firmware called rtl8192sfw492.bin by renaming it to
rtl8192sfw.bin.

-- 
Regards,
Pavel Roskin
