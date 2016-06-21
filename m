Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:33556 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbcFUTCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 15:02:38 -0400
Received: by mail-lf0-f46.google.com with SMTP id f6so38086047lfg.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2016 12:02:37 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Add USB ID for Cisco Linksys AE1200
To: Ismael Luceno <ismael@iodev.co.uk>, linux-wireless@vger.kernel.org
References: <20160621001841.5383-1-ismael@iodev.co.uk>
Cc: brcm80211-dev-list@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <57698F43.3050303@broadcom.com> (sfid-20160621_210241_983260_59665901)
Date: Tue, 21 Jun 2016 21:02:27 +0200
MIME-Version: 1.0
In-Reply-To: <20160621001841.5383-1-ismael@iodev.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21-06-16 02:18, Ismael Luceno wrote:
> Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>

A bit more description would be nice. I am actually wondering why you
would be adding this. If I am not mistaken the AE1200 can not be handled
by brcmfmac. Otherwise I am interested in a kernel log showing the
device probe sequence with brcmfmac loaded with parameter debug=0x1416.

Regards,
Arend

> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c        | 4 ++++
>  drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 3 +++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> index 98b15a9..455fc69 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> @@ -1462,11 +1462,15 @@ static int brcmf_usb_reset_resume(struct usb_interface *intf)
>  #define BRCMF_USB_DEVICE(dev_id)	\
>  	{ USB_DEVICE(BRCM_USB_VENDOR_ID_BROADCOM, dev_id) }
>  
> +#define LINKSYS_USB_DEVICE(dev_id)	\
> +	{ USB_DEVICE(BRCM_USB_VENDOR_ID_LINKSYS, dev_id) }
> +
>  static struct usb_device_id brcmf_usb_devid_table[] = {
>  	BRCMF_USB_DEVICE(BRCM_USB_43143_DEVICE_ID),
>  	BRCMF_USB_DEVICE(BRCM_USB_43236_DEVICE_ID),
>  	BRCMF_USB_DEVICE(BRCM_USB_43242_DEVICE_ID),
>  	BRCMF_USB_DEVICE(BRCM_USB_43569_DEVICE_ID),
> +	LINKSYS_USB_DEVICE(BRCM_USB_43235_LINKSYS_DEVICE_ID),
>  	{ USB_DEVICE(BRCM_USB_VENDOR_ID_LG, BRCM_USB_43242_LG_DEVICE_ID) },
>  	/* special entry for device with firmware loaded and running */
>  	BRCMF_USB_DEVICE(BRCM_USB_BCMFW_DEVICE_ID),
> diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
> index 699f2c2..6666513 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
> @@ -22,6 +22,7 @@
>  
>  #define BRCM_USB_VENDOR_ID_BROADCOM	0x0a5c
>  #define BRCM_USB_VENDOR_ID_LG		0x043e
> +#define BRCM_USB_VENDOR_ID_LINKSYS	0x13b1
>  #define BRCM_PCIE_VENDOR_ID_BROADCOM	PCI_VENDOR_ID_BROADCOM
>  
>  /* Chipcommon Core Chip IDs */
> @@ -56,6 +57,8 @@
>  
>  /* USB Device IDs */
>  #define BRCM_USB_43143_DEVICE_ID	0xbd1e
> +#define BRCM_USB_43235_LINKSYS_DEVICE_ID \
> +					0x0039
>  #define BRCM_USB_43236_DEVICE_ID	0xbd17
>  #define BRCM_USB_43242_DEVICE_ID	0xbd1f
>  #define BRCM_USB_43242_LG_DEVICE_ID	0x3101
> 
