Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:62760 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaASMUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jan 2014 07:20:03 -0500
Received: by mail-la0-f46.google.com with SMTP id b8so4788915lan.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jan 2014 04:19:59 -0800 (PST)
Message-ID: <1390133995.6945.11.camel@X1Carbon.localdomain> (sfid-20140119_132010_312844_D05E9967)
Subject: Re: USB rt2x00 driver regression
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: Sergei Antonov <saproj@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Date: Sun, 19 Jan 2014 16:19:55 +0400
In-Reply-To: <A411C6B4-8474-47AC-97E1-0D92B24EB675@gmail.com>
References: <CABikg9yZrXX=qfqeR+V77u+Ndegx50D1_POAYMeq63qJuEzv=w@mail.gmail.com>
	 <20140117100613.GD1425@redhat.com>
	 <A411C6B4-8474-47AC-97E1-0D92B24EB675@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-01-19 at 11:57 +0100, Sergei Antonov wrote:
> > Am 17.01.2014 um 11:06 schrieb Stanislaw Gruszka <sgruszka@redhat.com>:
> > 
> >> On Tue, Jan 14, 2014 at 07:28:39PM +0100, Sergei Antonov wrote:
> >> Hello!
> >> I use a USB Wi-Fi adapter identified as follows.
> >> 
> >> usb 2-4: new high-speed USB device number 5 using ehci-pci
> >> usb 2-4: New USB device found, idVendor=148f, idProduct=5370
> >> usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> >> usb 2-4: Product: 802.11 n WLAN
> >> usb 2-4: Manufacturer: Ralink
> >> usb 2-4: SerialNumber: 1.0
> >> usb 2-4: reset high-speed USB device number 5 using ehci-pci
> >> ieee80211 phy3: rt2x00_set_rt: Info - RT chipset 5390, rev 0502 detected
> >> ieee80211 phy3: rt2x00_set_rf: Info - RF chipset 5370 detected
> >> 
> >> It worked well with older kernels and does not with newer kernels.
> >> Specifically it fails to find any AP when scanning.
> >> The first bad commit is:
> >> 
> >> commit 76773f301f2210dcc20c466aebda7118062673eb
> >> Author: Gabor Juhos <juhosg@openwrt.org>
> >> Date:   Sat Aug 17 14:09:30 2013 +0200
> >> 
> >>    rt2x00: rt2800lib: use a MCU command for frequency adjustment on USB devices
> >> 
> >>    According to the Ralink driver, there is an MCU
> >>    command which can be used to send the frequency
> >>    offset value directly to the USB device without
> >>    going through the RFCSR writing sequence.
> >> 
> >>    Based on the DPO_RT5572_LinuxSTA_2.6.0.1_20120629
> >>    driver.
> >> 
> >>    Reference:
> >>      RTMPAdjustFrequencyOffset function in common/rt_rf.c
> >> 
> >>    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> >>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
> >> 
> >> After I removed this special USB handling (see the patch) the adapter
> >> works again.
> > 
> > Thanks for bisecting! Could you check if following patch fixes the
> > issue?
> 
> It does not fix the issue. The same broken behavior remains.
I couldn't understand one string in original RTMPAdjustFrequencyOffset. Could you try follow patch ?

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 776aff3..dbb33a5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1893,7 +1893,7 @@ static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
        u8 rfcsr, prev_rfcsr;
 
        freq_offset = rt2x00_get_field8(rt2x00dev->freq_offset, RFCSR17_CODE);
-       freq_offset = min_t(u8, freq_offset, FREQ_OFFSET_BOUND);
+       freq_offset = min_t(u8, (freq_offset & 0x7f), FREQ_OFFSET_BOUND);
 
        rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
        prev_rfcsr = rfcsr;

-- 
-Igor Gnatenko


