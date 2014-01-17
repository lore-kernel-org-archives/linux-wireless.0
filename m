Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbaAQKHG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 05:07:06 -0500
Date: Fri, 17 Jan 2014 11:06:14 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sergei Antonov <saproj@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: Re: USB rt2x00 driver regression
Message-ID: <20140117100613.GD1425@redhat.com> (sfid-20140117_110710_854095_408AE3BE)
References: <CABikg9yZrXX=qfqeR+V77u+Ndegx50D1_POAYMeq63qJuEzv=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABikg9yZrXX=qfqeR+V77u+Ndegx50D1_POAYMeq63qJuEzv=w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 14, 2014 at 07:28:39PM +0100, Sergei Antonov wrote:
> Hello!
> I use a USB Wi-Fi adapter identified as follows.
> 
> usb 2-4: new high-speed USB device number 5 using ehci-pci
> usb 2-4: New USB device found, idVendor=148f, idProduct=5370
> usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 2-4: Product: 802.11 n WLAN
> usb 2-4: Manufacturer: Ralink
> usb 2-4: SerialNumber: 1.0
> usb 2-4: reset high-speed USB device number 5 using ehci-pci
> ieee80211 phy3: rt2x00_set_rt: Info - RT chipset 5390, rev 0502 detected
> ieee80211 phy3: rt2x00_set_rf: Info - RF chipset 5370 detected
> 
> It worked well with older kernels and does not with newer kernels.
> Specifically it fails to find any AP when scanning.
> The first bad commit is:
> 
> commit 76773f301f2210dcc20c466aebda7118062673eb
> Author: Gabor Juhos <juhosg@openwrt.org>
> Date:   Sat Aug 17 14:09:30 2013 +0200
> 
>     rt2x00: rt2800lib: use a MCU command for frequency adjustment on USB devices
> 
>     According to the Ralink driver, there is an MCU
>     command which can be used to send the frequency
>     offset value directly to the USB device without
>     going through the RFCSR writing sequence.
> 
>     Based on the DPO_RT5572_LinuxSTA_2.6.0.1_20120629
>     driver.
> 
>     Reference:
>       RTMPAdjustFrequencyOffset function in common/rt_rf.c
> 
>     Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> After I removed this special USB handling (see the patch) the adapter
> works again.

Thanks for bisecting! Could you check if following patch fixes the
issue?

Thanks
Stanislaw

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 776aff3..5c06836 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1902,13 +1902,13 @@ static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
 	if (rfcsr == prev_rfcsr)
 		return;
 
+	prev_freq_offset = rt2x00_get_field8(prev_rfcsr, RFCSR17_CODE);
 	if (rt2x00_is_usb(rt2x00dev)) {
 		rt2800_mcu_request(rt2x00dev, MCU_FREQ_OFFSET, 0xff,
-				   freq_offset, prev_rfcsr);
+				   freq_offset, prev_freq_offset);
 		return;
 	}
 
-	prev_freq_offset = rt2x00_get_field8(prev_rfcsr, RFCSR17_CODE);
 	while (prev_freq_offset != freq_offset) {
 		if (prev_freq_offset < freq_offset)
 			prev_freq_offset++;
