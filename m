Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:49329 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3FKSbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 14:31:37 -0400
Received: by mail-ee0-f49.google.com with SMTP id b57so3884535eek.22
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 11:31:36 -0700 (PDT)
References: <1370504180-10950-1-git-send-email-juhosg@openwrt.org> <1370504180-10950-2-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1370504180-10950-2-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <0ED4F231-072D-4227-9204-4930A0B24555@gmail.com> (sfid-20130611_203140_289704_BEB86597)
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Gabor Juhos <juhosg@openwrt.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v2 2/2] rt2x00: rt2800usb: nuke rt2800usb_ops_5592
Date: Tue, 11 Jun 2013 20:31:35 +0200
To: Gabor Juhos <juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 6 jun. 2013, at 09:36, Gabor Juhos <juhosg@openwrt.org> wrote:

> It is exactly the same like the generic rt2800usb_ops.
> Remove the duplicate and use the generic ops for all
> devices.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> drivers/net/wireless/rt2x00/rt2800usb.c |   29 +++++------------------------
> 1 file changed, 5 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 68ea00e..7edd903 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -914,22 +914,6 @@ static const struct rt2x00_ops rt2800usb_ops = {
> #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
> };
> 
> -static const struct rt2x00_ops rt2800usb_ops_5592 = {
> -    .name            = KBUILD_MODNAME,
> -    .drv_data_size        = sizeof(struct rt2800_drv_data),
> -    .max_ap_intf        = 8,
> -    .eeprom_size        = EEPROM_SIZE,
> -    .rf_size        = RF_SIZE,
> -    .tx_queues        = NUM_TX_QUEUES,
> -    .queue_init        = rt2800usb_queue_init,
> -    .lib            = &rt2800usb_rt2x00_ops,
> -    .drv            = &rt2800usb_rt2800_ops,
> -    .hw            = &rt2800usb_mac80211_ops,
> -#ifdef CONFIG_RT2X00_LIB_DEBUGFS
> -    .debugfs        = &rt2800_rt2x00debug,
> -#endif /* CONFIG_RT2X00_LIB_DEBUGFS */
> -};
> -
> /*
>  * rt2800usb module information.
>  */
> @@ -1242,15 +1226,15 @@ static struct usb_device_id rt2800usb_device_table[] = {
> #endif
> #ifdef CONFIG_RT2800USB_RT55XX
>    /* Arcadyan */
> -    { USB_DEVICE(0x043e, 0x7a32), .driver_info = 5592 },
> +    { USB_DEVICE(0x043e, 0x7a32) },
>    /* AVM GmbH */
> -    { USB_DEVICE(0x057c, 0x8501), .driver_info = 5592 },
> +    { USB_DEVICE(0x057c, 0x8501) },
>    /* D-Link DWA-160-B2 */
> -    { USB_DEVICE(0x2001, 0x3c1a), .driver_info = 5592 },
> +    { USB_DEVICE(0x2001, 0x3c1a) },
>    /* Proware */
> -    { USB_DEVICE(0x043e, 0x7a13), .driver_info = 5592 },
> +    { USB_DEVICE(0x043e, 0x7a13) },
>    /* Ralink */
> -    { USB_DEVICE(0x148f, 0x5572), .driver_info = 5592 },
> +    { USB_DEVICE(0x148f, 0x5572) },
> #endif
> #ifdef CONFIG_RT2800USB_UNKNOWN
>    /*
> @@ -1355,9 +1339,6 @@ MODULE_LICENSE("GPL");
> static int rt2800usb_probe(struct usb_interface *usb_intf,
>               const struct usb_device_id *id)
> {
> -    if (id->driver_info == 5592)
> -        return rt2x00usb_probe(usb_intf, &rt2800usb_ops_5592);
> -
>    return rt2x00usb_probe(usb_intf, &rt2800usb_ops);
> }
> 
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
