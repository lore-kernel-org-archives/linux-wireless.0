Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60864 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751449AbcITNs3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 09:48:29 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: RE: [PATCH 2/2] mwifiex: firmware name correction for usb8997 chipset
Date: Tue, 20 Sep 2016 13:48:17 +0000
Message-ID: <3ca1064a85854ba9b7f5e6b5ef127726@SC-EXCH04.marvell.com> (sfid-20160920_154832_115243_C04131CB)
References: <1473686728-8101-1-git-send-email-akarwar@marvell.com>
        <1473686728-8101-3-git-send-email-akarwar@marvell.com>
 <87poo6ct94.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87poo6ct94.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Wednesday, September 14, 2016 10:29 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> Ganapathi Bhat
> Subject: Re: [PATCH 2/2] mwifiex: firmware name correction for usb8997
> chipset
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > From: Ganapathi Bhat <gbhat@marvell.com>
> >
> > Similar to pcie8997 chipset, first firmware submitted for usb8997
> > chipset will be usbusb8997_combo_v4.bin. This patch corrects the name
> > used in driver.
> >
> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> >  drivers/net/wireless/marvell/mwifiex/usb.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/usb.h
> > b/drivers/net/wireless/marvell/mwifiex/usb.h
> > index 1b49c52..30e8eb8 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/usb.h
> > +++ b/drivers/net/wireless/marvell/mwifiex/usb.h
> > @@ -46,7 +46,7 @@
> >  #define USB8766_DEFAULT_FW_NAME	"mrvl/usb8766_uapsta.bin"
> >  #define USB8797_DEFAULT_FW_NAME	"mrvl/usb8797_uapsta.bin"
> >  #define USB8801_DEFAULT_FW_NAME	"mrvl/usb8801_uapsta.bin"
> > -#define USB8997_DEFAULT_FW_NAME	"mrvl/usb8997_uapsta.bin"
> > +#define USB8997_DEFAULT_FW_NAME	"mrvl/usbusb8997_combo_v4.bin"
> 
> Like discussed earlier, the firmware names are supposed to be stable. I
> consider them to be an interface between kernel and user space. Instead
> of changing the driver you should actually rename the firmware file. I'm
> planning to take this anyway but in the future please pay extra
> attention to do this properly.

Thanks for accepting the patch. We will stick to the same name for 8997 and ensure v3/v4 etc won't be used for future chipsets/firmwares.
 
> My recommendation is to keep the firmware name simple as possible and
> get rid of any extra cruft, for example in this case a good name would
> be "mrvl/usb8997.bin". That extra "usb" and "combo_v4" don't bring any
> benefit.
> 

'combo' here indicates it's a combine firmware image for bluetooth and wifi. Firmware images with bluetooth only OR WiFi only functionality are also possible.
Example use case: We support PCIe function level reset feature as a recovery mechanism. With this mechanism, WiFi recovery can happen by re-downloading WiFi only firmware without affecting bluetooth functionality for PCIe-USB8997 chipset.

'usbusb' here indicates this firmware is for a USB-USB8997 chipset where WiFi and bluetooth are over USB bus. There would be a different firmware if chipset is USB-UART8997 where bluetooth is via UART.

I agree that we should have avoided v4.

Regards,
Amitkumar Karwar
