Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:40788 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3BFADV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 19:03:21 -0500
Received: by mail-we0-f172.google.com with SMTP id x10so672090wey.17
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 16:03:20 -0800 (PST)
Message-ID: <51119DC5.8020200@gmail.com> (sfid-20130206_010324_669213_9A3D2CF0)
Date: Wed, 06 Feb 2013 01:03:17 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Thomas Rosenkranz <tom.rosary@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
References: <51102B22.20702@gmail.com> <CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com> <511163BA.7060902@gmail.com> <51116A33.9070207@lwfinger.net> <51117994.1060506@gmail.com> <51117F98.3040900@lwfinger.net> <511189A9.8060609@gmail.com> <511199A1.8000207@lwfinger.net>
In-Reply-To: <511199A1.8000207@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2013 12:45 AM, Larry Finger wrote:

>> Then, remove the "new_id" facility of the driver.
>>
>> *Or* fix the driver. rt2x00 handles correctly any
>> kind of unknown device.
> 
> The attached patch will fix the oops when a foreign new_id is inserted. I will be submitting it soon.

> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
> @@ -977,6 +977,9 @@ int rtl_usb_probe(struct usb_interface *
>  	rtl_dbgp_flag_init(hw);
>  	/* Init IO handler */
>  	_rtl_usb_io_handler_init(&udev->dev, hw);
> +	if (!rtlpriv->cfg || !rtlpriv->cfg->ops ||
> +	    !rtlpriv->cfg->ops->read_chip_version)
> +		return -ENODEV;
>  	rtlpriv->cfg->ops->read_chip_version(hw);
>  	/*like read eeprom and so on */
>  	rtlpriv->cfg->ops->read_eeprom_info(hw);
> 

How about pci devices(rtlwifi/pci.c) ?

thank you.
