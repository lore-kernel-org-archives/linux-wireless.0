Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:38733 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaASS3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jan 2014 13:29:41 -0500
Message-ID: <52DC1761.9080608@openwrt.org> (sfid-20140119_192945_677804_50A5FC13)
Date: Sun, 19 Jan 2014 19:20:17 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Sergei Antonov <saproj@gmail.com>,
	Igor Gnatenko <i.gnatenko.brain@gmail.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: USB rt2x00 driver regression
References: <CABikg9yZrXX=qfqeR+V77u+Ndegx50D1_POAYMeq63qJuEzv=w@mail.gmail.com> <20140117100613.GD1425@redhat.com> <A411C6B4-8474-47AC-97E1-0D92B24EB675@gmail.com> <1390133995.6945.11.camel@X1Carbon.localdomain> <03574886-F38F-461C-97FC-B10DCCCF30E8@gmail.com>
In-Reply-To: <03574886-F38F-461C-97FC-B10DCCCF30E8@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090701040003000803050806"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090701040003000803050806
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Sergei,

<...>

>>>>> It worked well with older kernels and does not with newer kernels.
>>>>> Specifically it fails to find any AP when scanning.
>>>>> The first bad commit is:
>>>>>
>>>>> commit 76773f301f2210dcc20c466aebda7118062673eb
>>>>> Author: Gabor Juhos <juhosg@openwrt.org>
>>>>> Date:   Sat Aug 17 14:09:30 2013 +0200
>>>>>
>>>>>   rt2x00: rt2800lib: use a MCU command for frequency adjustment on USB devices
>>>>>
>>>>>   According to the Ralink driver, there is an MCU
>>>>>   command which can be used to send the frequency
>>>>>   offset value directly to the USB device without
>>>>>   going through the RFCSR writing sequence.
>>>>>
>>>>>   Based on the DPO_RT5572_LinuxSTA_2.6.0.1_20120629
>>>>>   driver.
>>>>>
>>>>>   Reference:
>>>>>     RTMPAdjustFrequencyOffset function in common/rt_rf.c
>>>>>
>>>>>   Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
>>>>>   Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>>>>
>>>>> After I removed this special USB handling (see the patch) the adapter
>>>>> works again.
>>>>
>>>> Thanks for bisecting! Could you check if following patch fixes the
>>>> issue?
>>>
>>> It does not fix the issue. The same broken behavior remains.
>> I couldn't understand one string in original RTMPAdjustFrequencyOffset. Could you try follow patch ?
> Tried your patch with and without Stanislaw's patch. No success.

I guess that this is a timing issue. Maybe the RT5390 device does not finish the
MCU command before the scan runs.

The Ralink reference driver calls the frequency adjustment code from the
NICInitRT5390RFRegisters function but the equivalent call is missing from the
rt2x00 driver. Additionaly, the Ralink driver uses 1 ms delay after calling the
frequency adjustment code which is also missing from rt2x00.

The attached patch set adds the missing code to rt2x00. Please test whether it
fixes the problem or not.

Thanks,
Gabor



--------------090701040003000803050806
Content-Type: text/x-patch;
 name="0001-rt2x00-rt2800lib-add-a-delay-after-frequency-adjustm.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-rt2x00-rt2800lib-add-a-delay-after-frequency-adjustm.pa";
 filename*1="tch"

>From ff8f124dcc6b256c63a006c9fde9e02785fa20b6 Mon Sep 17 00:00:00 2001
From: Gabor Juhos <juhosg@openwrt.org>
Date: Sun, 19 Jan 2014 12:54:49 +0100
Subject: [PATCH 1/2] rt2x00: rt2800lib: add a delay after frequency
 adjustment MCU command

The delay helps to ensure that the MCU command is processed
by the USB device before we are returning from the frequency
adjustment code.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d152b16..c6bc231 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1980,6 +1980,7 @@ static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00_is_usb(rt2x00dev)) {
 		rt2800_mcu_request(rt2x00dev, MCU_FREQ_OFFSET, 0xff,
 				   freq_offset, prev_rfcsr);
+		usleep_range(1000, 1500);
 		return;
 	}
 
-- 
1.7.10


--------------090701040003000803050806
Content-Type: text/x-patch;
 name="0002-rt2x00-rt2800lib-adjust-frequency-offset-during-rfcs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-rt2x00-rt2800lib-adjust-frequency-offset-during-rfcs.pa";
 filename*1="tch"

>From 3f4a100688acbe0c331fc490827bb21c2dc614ca Mon Sep 17 00:00:00 2001
From: Gabor Juhos <juhosg@openwrt.org>
Date: Fri, 17 Jan 2014 22:08:51 +0100
Subject: [PATCH 2/2] rt2x00: rt2800lib: adjust frequency offset during rfcsr
 init on RT5390/5392

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c6bc231..ca92403 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -6550,6 +6550,8 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_rf_init_calibration(rt2x00dev, 2);
 
+	rt2800_adjust_freq_offset(rt2x00dev);
+
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
 	rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
 	rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
@@ -6648,6 +6650,8 @@ static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_rf_init_calibration(rt2x00dev, 2);
 
+	rt2800_adjust_freq_offset(rt2x00dev);
+
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
 	rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
 	rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
-- 
1.7.10


--------------090701040003000803050806--
