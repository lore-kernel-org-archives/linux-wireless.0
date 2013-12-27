Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:10665 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3L0LrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Dec 2013 06:47:11 -0500
Message-ID: <52BD68BA.3080304@broadcom.com> (sfid-20131227_124724_546950_FC307CAD)
Date: Fri, 27 Dec 2013 12:47:06 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
CC: Hans de Goede <hdegoede@redhat.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Olliver Schinagl <oliver+list@schinagl.nl>,
	<benn@cubietech.com>
Subject: Re: [linux-sunxi] Firmware for Bluetooth (and wifi)
References: <52A040CE.5040706@schinagl.nl> <CAFXj5xjJ0DTa0Qo1avLboQF-e3TFv3aEr_jjkuZjinwuTzXykQ@mail.gmail.com> <52A09B5B.70800@schinagl.nl> <CAGRGNgWBgWqoPUdHSm2OXGb8r-ca5NX2z4_v0eG6oOMgJRd3HQ@mail.gmail.com> <52B17973.1000608@broadcom.com> <52B19F38.7060503@redhat.com> <52B1CA51.4010202@broadcom.com> <CAGb2v67cnP0yth0xxBKcaW_T2fF+4nP4r6h9NLqy5FV2x=hO=Q@mail.gmail.com> <CAGb2v67mmYnyPeOd4Wwp1zHs7EC_Gr+gEdaaMWeKP5z_Z_SVGA@mail.gmail.com> <CAGb2v66646-1Sye=Eb04_SoeCGBU064OePcxDi7th1fqU8XfBg@mail.gmail.com>
In-Reply-To: <CAGb2v66646-1Sye=Eb04_SoeCGBU064OePcxDi7th1fqU8XfBg@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="------------090804010600040808080108"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------090804010600040808080108
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 12/26/2013 05:13 PM, Chen-Yu Tsai wrote:
> Hi,
> 
> On Thu, Dec 19, 2013 at 6:12 PM, Chen-Yu Tsai <wens@csie.org> wrote:
>> Hi,
>>
>> On Thu, Dec 19, 2013 at 12:39 AM, Chen-Yu Tsai <wens@csie.org> wrote:
>>> Hi,
>>>
>>> On Thu, Dec 19, 2013 at 12:16 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>>> On 12/18/2013 02:12 PM, Hans de Goede wrote:
>>>>> Hi,
>>>>>
>>>>> On 12/18/2013 11:31 AM, Arend van Spriel wrote:
>>>>>> On 12/05/2013 10:46 PM, Julian Calaby wrote:
>>>>>>> Firstly, are there any plans to support the BCM43362 chipset with the
>>>>>>> brcmfmac driver in the near future?
>>>>>>
>>>>>> Hi Julian,
>>>>>>
>>>>>> I am working on a patch to support this chip. It is looking promising.
>>>>>> Just have to go after a firmware image to be sure.
>>>>>
>>>>> Cool. Do you have a cubietruck? With my latest wip tree:
>>>>> https://github.com/jwrdegoede/linux-sunxi/commits/sunxi-next
>>>>
>>>> No cubietruck here. I googled the term last week because it came up and
>>>> found embeddedcomputer.nl selling it.
>>>>
>>>>> We've mmc/sdio controller support on top of 3.13-rc4, it would be
>>>>> nice if we could also get the wifi and bluetooth to work here.
>>
>> I got the chip to respond to probing. It is BCM43362 for sure.
>>
>>   root@cubietruck:/sys/bus/mmc/devices/mmc1:0001/mmc1:0001:1# cat device
>>   0xa962
>>   root@cubietruck:/sys/bus/mmc/devices/mmc1:0001/mmc1:0001:1# cat vendor
>>   0x02d0
>>
>> Vendor ID is Broadcom. Device ID is 43362.
>> But I get two devices, mmc1:0001:1 and mmc1:0001:2. I don't know
>> if this is normal or not.

There might be three devices/functions. The last digit of the device
indicates the SDIO function number. Function 1 allows access to F1
registers in the SDIO core of the device and F2 is for WLAN
functionality. F3 could be providing BT functionality, but I am not
familiar with that part.

> Merry Christmas everyone. I got AP6210 (BCM43362) to work with mainline
> brcmfmac driver. I only tested managed mode. Monitor mode does not work.
> You can use firmware from CubieTech images.

brcmfmac does not support monitor mode. It does support AP mode and P2P
modes.

> Things missing:
> 
>   1. output clock is using default 32KHz from 24M / 750.
>      need to find some place to put clk_set_rate call.

What clock is this? You mean there is a clock output driven by the
AP6210 module or Cubieboard provides it to the module.

>   2. BCM43362 out-of-band interrupts not supported.
>      OOB interrupt in brcmfmac is set using platform data.
>      Need to put this is board code, or add device tree support.

It would be good to add device tree support so the driver can first look
for device tree data and have platform data and in-band as backup mechanism.

> Core ID and addresses were found using bcmdhd driver debug output.
> Arend might want to take a look at the patch:
> 
>   https://github.com/wens/linux/commit/d945809d27de930eba5db0ca4bb7936e3ca88865

I have different addresses from the chip documentation, but my test spin
went poorly. So much for hardware documentation. I will give these
values a try. In my patch there is also bcm43362 specific SDIO drive
strength programming (see attachment). The patch won't apply as my tree
is a bit different due to some rework in the SDIO part of brcmfmac. So
you probably need to pick the missing part from it.

> Working tree:
> 
>   https://github.com/wens/linux/tree/wip/sunxi-next-wifi
> 
> Comments welcome :)

No comment, but: Nice work!

Gr. AvS

>>
>> Bluetooth still isn't responding.
> 
> Bluetooth still not working. :(
> Has anyone had any luck with this?
> 
>>
>>>>> I'm certainly willing to give some patches for this a try. Do you
>>>>> have an example of what the dts file for a board with broadcom sdio
>>>>> wifi looks like ?
>>>>
>>>> I am still struggling with dts changes for a Pandaboard. As I understood
>>>> the cubietruck uses AP6210 module and the dts really depends on how
>>>> things are wired up with it. Apart from the SDIO lines it may have an
>>>> additional GPIO output to power the module and GPIO inputs to wakeup the
>>>> host and interrupt line.
>>>
>>> Yes it does. 2 GPIO lines for power, 1 for WiFi, 1 for BT.
>>> Also takes 2 GPIO inputs for interrupts. Not sure how to feed this
>>> to the driver. Last, it takes a clock output out of the A20 for the
>>> low power 32k clock. Not sure if this is mandatory?
>>>
>>> I've read the schematics more than a few times. I can get a dts out
>>> tomorrow. I was planning on doing the clock output and rfkill part
>>> first.
>>
>> Here's my tree, in case anyone wants to play around. It will be rebased
>> a lot.
>>
>>   https://github.com/wens/linux/tree/wip/sunxi-next-wifi
>>
>> The DT is not finished yet. External interrupts and low power clock are
>> still missing. Can anyone provide an example for useing the PIO EINT
>> interrupt pins?
>>
>>
>> Cheers,
>>
>> ChenYu


--------------090804010600040808080108
Content-Type: text/x-patch;
	name="0001-brcmfmac-add-support-for-bcm43362-device.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-brcmfmac-add-support-for-bcm43362-device.patch"

>From 0bad779042b7807f0476e9b5098f943d4ace33ee Mon Sep 17 00:00:00 2001
From: Arend van Spriel <arend@broadcom.com>
Date: Tue, 17 Dec 2013 20:33:43 +0100
Subject: [PATCH] brcmfmac: add support for bcm43362 device

This patch adds support for the bcm43362 1x1 11n chipset.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    5 +++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   33 ++++++++++++++++++++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    1 +
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
 5 files changed, 41 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index ae0e0c9..d8dc356 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -948,6 +948,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4329)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4330)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_4334)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM, SDIO_DEVICE_ID_BROADCOM_43362)},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_BROADCOM,
 		     SDIO_DEVICE_ID_BROADCOM_4335_4339)},
 	{ /* end: all zeroes */ },
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 270cf9b..d7655eb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -511,6 +511,8 @@ enum brcmf_sdio_frmtype {
 #define BCM4335_NVRAM_NAME		"brcm/brcmfmac4335-sdio.txt"
 #define BCM4339_FIRMWARE_NAME		"brcm/brcmfmac4339-sdio.bin"
 #define BCM4339_NVRAM_NAME		"brcm/brcmfmac4339-sdio.txt"
+#define BCM43362_FIRMWARE_NAME		"brcm/brcmfmac43362-sdio.bin"
+#define BCM43362_NVRAM_NAME		"brcm/brcmfmac43362-sdio.txt"
 
 MODULE_FIRMWARE(BCM43143_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM43143_NVRAM_NAME);
@@ -528,6 +530,8 @@ MODULE_FIRMWARE(BCM4335_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4335_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4339_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4339_NVRAM_NAME);
+MODULE_FIRMWARE(BCM43362_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM43362_NVRAM_NAME);
 
 struct brcmf_firmware_names {
 	u32 chipid;
@@ -552,6 +556,7 @@ static const struct brcmf_firmware_names brcmf_fwname_data[] = {
 	{ BCM4330_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4330) },
 	{ BCM4334_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4334) },
 	{ BCM4335_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4335) },
+	{ BCM43362_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM43362) },
 	{ BCM4339_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4339) }
 };
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 5f39f28..2243b02 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -83,6 +83,17 @@ static const struct sdiod_drive_str sdiod_drvstr_tab1_1v8[] = {
 	{0, 0x1}
 };
 
+/* SDIO Drive Strength to sel value table for PMU Rev 13 (1.8v) */
+static const struct sdiod_drive_str sdiod_drive_strength_tab5_1v8[] = {
+        {6, 0x7},
+        {5, 0x6},
+        {4, 0x5},
+        {3, 0x4},
+        {2, 0x2},
+        {1, 0x1},
+        {0, 0x0}
+};
+
 /* SDIO Drive Strength to sel value table for 43143 PMU Rev 17 (3.3V) */
 static const struct sdiod_drive_str sdiod_drvstr_tab2_3v3[] = {
 	{16, 0x7},
@@ -569,6 +580,23 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->ramsize = 0xc0000;
 		ci->rambase = 0x180000;
 		break;
+	case BCM43362_CHIP_ID:
+		ci->c_inf[0].wrapbase = 0x18100000;
+		ci->c_inf[0].cib = 0x1c004211;
+		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
+		ci->c_inf[1].base = 0x18002000;
+		ci->c_inf[1].wrapbase = 0x18102000;
+		ci->c_inf[1].cib = 0x01004211;
+		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
+		ci->c_inf[2].base = 0x18004000;
+		ci->c_inf[2].wrapbase = 0x18104000;
+		ci->c_inf[2].cib = 0x06080401;
+		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
+		ci->c_inf[3].base = 0x18003000;
+		ci->c_inf[3].wrapbase = 0x18103000;
+		ci->c_inf[3].cib = 0x01004211;
+		ci->ramsize = 0x3C000;
+		break;
 	default:
 		brcmf_err("chipid 0x%x is not supported\n", ci->chip);
 		return -ENODEV;
@@ -769,6 +797,11 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 				  brcmf_sdio_chip_name(ci->chip, chn, 8),
 				  drivestrength);
 		break;
+	case SDIOD_DRVSTR_KEY(BCM43362_CHIP_ID, 13):
+		str_tab = sdiod_drive_strength_tab5_1v8;
+		str_mask = 0x00003800;
+		str_shift = 11;
+		break;
 	default:
 		brcmf_err("No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
 			  brcmf_sdio_chip_name(ci->chip, chn, 8),
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index d0f4b45..d0253af 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -61,6 +61,7 @@
 #define SDIO_DEVICE_ID_BROADCOM_4330		0x4330
 #define SDIO_DEVICE_ID_BROADCOM_4334		0x4334
 #define SDIO_DEVICE_ID_BROADCOM_4335_4339	0x4335
+#define SDIO_DEVICE_ID_BROADCOM_43362		43362
 
 struct chip_core_info {
 	u16 id;
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index 84113ea..1039f7e 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -42,5 +42,6 @@
 #define BCM4334_CHIP_ID		0x4334
 #define BCM4335_CHIP_ID		0x4335
 #define BCM4339_CHIP_ID		0x4339
+#define BCM43362_CHIP_ID	43362
 
 #endif				/* _BRCM_HW_IDS_H_ */
-- 
1.7.10.4


--------------090804010600040808080108--
