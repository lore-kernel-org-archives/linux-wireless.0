Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02002ECDE3A
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 18:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 851A1214C5
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 18:20:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 851A1214C5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=theobroma-systems.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbeJJBjM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 21:39:12 -0400
Received: from vegas.theobroma-systems.com ([144.76.126.164]:56711 "EHLO
        mail.theobroma-systems.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726427AbeJJBjM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 21:39:12 -0400
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2018 21:39:10 EDT
Received: from [86.59.122.178] (port=53417 helo=[10.2.146.249])
        by mail.theobroma-systems.com with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <christoph.muellner@theobroma-systems.com>)
        id 1g9wT1-0008Qf-W7; Tue, 09 Oct 2018 20:10:48 +0200
From:   =?utf-8?Q?Christoph_M=C3=BCllner?= 
        <christoph.muellner@theobroma-systems.com>
Content-Type: multipart/mixed;
        boundary="Apple-Mail=_75AE657D-4E76-42CD-9F38-AEFB52EB426B"
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Subject: brcmfmac with BCM4359 on arm64 (RK3399) and SDIO
Message-Id: <5C44048D-0676-48E6-9AA3-F327839F13E5@theobroma-systems.com>
Date:   Tue, 9 Oct 2018 20:10:46 +0200
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
X-Mailer: Apple Mail (2.3445.6.18)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--Apple-Mail=_75AE657D-4E76-42CD-9F38-AEFB52EB426B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi Arend,

recently I got an SDIO module, which includes a BCM4359.
I tried to get it up and running via the SD card interface
on a RK3399 SoC and succeeded in doing so with
bcmdhd.1.579.77.41.x and a vendor kernel (based on Linux 4.4).
All that was necessary was configure BCMDHD to run with
in-band IRQs and use a GPIO as gpio_wl_reg_on.

Since I can run a mainline kernel as well, I gave it a try and
tried brcmfmac on Linux 4.19-rc7. As the BCM4359 is not in
the list of supported SDIO devices, but is supported USB device,
I've created a patch (attached), which adds the support for that device.
Additionally I've patched my DTS to include the WL_REG_ON
pin as part of mmc-pwrseq-simple's reset-gpios and added
a bcm4329-fmac node in the mmc node.

During bootup I see messages from brcmfmac, which indicate
that the BCM4359 has been found, but loading the nvram file
continuously fails:

> [    5.993741] brcmfmac: brcmf_fw_alloc_request: using =
brcm/brcmfmac4359-sdio for chip BCM4359/9
> [...]
> [    7.987167] brcmfmac: brcmf_sdiod_ramrw: membytes transfer failed
> [    8.008715] brcmfmac: brcmf_sdio_verifymemory: error -84 on reading =
2048 membytes at 0x0025f1f0
> [    8.021182] brcmfmac: brcmf_sdio_download_firmware: dongle nvram =
file download failed

That -84 means EILSEQ, which is the error value, which represents
a CRC error during SDIO data exchange (returned by the function =
dw_mci_data_complete()
in the MMC driver).

To address this, I've reduced the clock speed (in several steps) to 400 =
kHz
(and verified the clock signal on an oscilloscope), but the issue =
persists.
I've also tried to use Linux 4.14.74, where I see the same issue.

I can confirm that the MMC interface works in general (I can use an SD =
card
to host my rootfs).

FWIW I'm using the same exact same firmware and nvram file for the DHD =
driver
and the brcmfmac.

Do you have any ideas how to debug this issue?

Thanks,
Christoph


--Apple-Mail=_75AE657D-4E76-42CD-9F38-AEFB52EB426B
Content-Disposition: attachment;
	filename=0001-brcmfmac-Add-SDIO-support-for-BCM4359.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="0001-brcmfmac-Add-SDIO-support-for-BCM4359.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20b918861440ca99ae5f9438e25794025a98c1b579=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Christoph=20Muellner=20=
<christoph.muellner@theobroma-systems.com>=0ADate:=20Tue,=203=20Jul=20=
2018=2014:13:28=20+0200=0ASubject:=20[PATCH]=20brcmfmac:=20Add=20SDIO=20=
support=20for=20BCM4359=0A=0AThe=20brcmfmac=20driver=20already=20=
supports=20the=20BCM4359=20as=20USB=20device.=0AThis=20patch=20adds=20=
support=20for=20an=20SDIO=20connection.=0A=0ASigned-off-by:=20Christoph=20=
Muellner=20<christoph.muellner@theobroma-systems.com>=0A---=0A=20=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c=20|=201=20+=0A=20=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c=20=20=20|=202=20=
++=0A=20include/linux/mmc/sdio_ids.h=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20|=201=20+=0A=203=20=
files=20changed,=204=20insertions(+)=0A=0Adiff=20--git=20=
a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c=20=
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c=0Aindex=20=
d2f788d88668..aa434b787953=20100644=0A---=20=
a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c=0A+++=20=
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c=0A@@=20=
-971,6=20+971,7=20@@=20static=20const=20struct=20sdio_device_id=20=
brcmf_sdmmc_ids[]=20=3D=20{=0A=20=09=
BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43455),=0A=20=09=
BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),=0A=20=09=
BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4356),=0A+=09=
BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4359),=0A=20=09=
BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_4373),=0A=20=09{=20/*=20end:=20=
all=20zeroes=20*/=20}=0A=20};=0Adiff=20--git=20=
a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c=20=
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c=0Aindex=20=
a907d7b065fa..cf90a87bda60=20100644=0A---=20=
a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c=0A+++=20=
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c=0A@@=20-617,6=20=
+617,7=20@@=20BRCMF_FW_DEF(43430A1,=20"brcmfmac43430-sdio");=0A=20=
BRCMF_FW_DEF(43455,=20"brcmfmac43455-sdio");=0A=20BRCMF_FW_DEF(4354,=20=
"brcmfmac4354-sdio");=0A=20BRCMF_FW_DEF(4356,=20"brcmfmac4356-sdio");=0A=
+BRCMF_FW_DEF(4359,=20"brcmfmac4359-sdio");=0A=20BRCMF_FW_DEF(4373,=20=
"brcmfmac4373-sdio");=0A=20=0A=20static=20const=20struct=20=
brcmf_firmware_mapping=20brcmf_sdio_fwnames[]=20=3D=20{=0A@@=20-637,6=20=
+638,7=20@@=20static=20const=20struct=20brcmf_firmware_mapping=20=
brcmf_sdio_fwnames[]=20=3D=20{=0A=20=09=
BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID,=200xFFFFFFC0,=2043455),=0A=20=09=
BRCMF_FW_ENTRY(BRCM_CC_4354_CHIP_ID,=200xFFFFFFFF,=204354),=0A=20=09=
BRCMF_FW_ENTRY(BRCM_CC_4356_CHIP_ID,=200xFFFFFFFF,=204356),=0A+=09=
BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID,=200xFFFFFFFF,=204359),=0A=20=09=
BRCMF_FW_ENTRY(CY_CC_4373_CHIP_ID,=200xFFFFFFFF,=204373)=0A=20};=0A=20=0A=
diff=20--git=20a/include/linux/mmc/sdio_ids.h=20=
b/include/linux/mmc/sdio_ids.h=0Aindex=204224902a8e22..00e3f624baf2=20=
100644=0A---=20a/include/linux/mmc/sdio_ids.h=0A+++=20=
b/include/linux/mmc/sdio_ids.h=0A@@=20-41,6=20+41,7=20@@=0A=20#define=20=
SDIO_DEVICE_ID_BROADCOM_43455=09=090xa9bf=0A=20#define=20=
SDIO_DEVICE_ID_BROADCOM_4354=09=090x4354=0A=20#define=20=
SDIO_DEVICE_ID_BROADCOM_4356=09=090x4356=0A+#define=20=
SDIO_DEVICE_ID_BROADCOM_4359=09=090x4359=0A=20#define=20=
SDIO_DEVICE_ID_CYPRESS_4373=09=090x4373=0A=20=0A=20#define=20=
SDIO_VENDOR_ID_INTEL=09=09=090x0089=0A--=20=0A2.11.0=0A=0A=

--Apple-Mail=_75AE657D-4E76-42CD-9F38-AEFB52EB426B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



--=20
Christoph M=C3=BCllner
Theobroma Systems Design und Consulting GmbH
Seestadtstra=C3=9Fe 27 (Aspern IQ), 1220 Wien, Austria
Phone: +43 1 236 98 93-409, Fax: +43 1 236 98 93-9
http://www.theobroma-systems.com





--Apple-Mail=_75AE657D-4E76-42CD-9F38-AEFB52EB426B--
