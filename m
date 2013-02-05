Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:41363 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab3BEXpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 18:45:39 -0500
Received: by mail-oa0-f50.google.com with SMTP id l20so881099oag.37
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 15:45:39 -0800 (PST)
Message-ID: <511199A1.8000207@lwfinger.net> (sfid-20130206_004544_993606_D7AFEA19)
Date: Tue, 05 Feb 2013 17:45:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: Thomas Rosenkranz <tom.rosary@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
References: <51102B22.20702@gmail.com> <CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com> <511163BA.7060902@gmail.com> <51116A33.9070207@lwfinger.net> <51117994.1060506@gmail.com> <51117F98.3040900@lwfinger.net> <511189A9.8060609@gmail.com>
In-Reply-To: <511189A9.8060609@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060205010201010301030900"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060205010201010301030900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 02/05/2013 04:37 PM, Xose Vazquez Perez wrote:
> On 02/05/2013 10:54 PM, Larry Finger wrote:
>
>> Yes, but not a bug for the devices that it is supposed to support! No one ever says that their driver will support *future* devices! As I said earlier, there are newer versions of the RTL8188C chip
>> that requires different programming, which may be the cause of the problem. On the other hand, the chip change did not cause a crash in rtl8192ce. I just didn't work very well. As I have no such
>> device, I cannot test any changes; therefore, I will not make them. If you want to write patches that let that device work with the kernel driver, I will be happy to review them.
>
> Then, remove the "new_id" facility of the driver.
>
> *Or* fix the driver. rt2x00 handles correctly any
> kind of unknown device.

The attached patch will fix the oops when a foreign new_id is inserted. I will 
be submitting it soon.

Larry


--------------060205010201010301030900
Content-Type: text/plain; charset=UTF-8;
 name="rtlwifi_fix_oops_with_new_id"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtlwifi_fix_oops_with_new_id"

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
@@ -977,6 +977,9 @@ int rtl_usb_probe(struct usb_interface *
 	rtl_dbgp_flag_init(hw);
 	/* Init IO handler */
 	_rtl_usb_io_handler_init(&udev->dev, hw);
+	if (!rtlpriv->cfg || !rtlpriv->cfg->ops ||
+	    !rtlpriv->cfg->ops->read_chip_version)
+		return -ENODEV;
 	rtlpriv->cfg->ops->read_chip_version(hw);
 	/*like read eeprom and so on */
 	rtlpriv->cfg->ops->read_eeprom_info(hw);

--------------060205010201010301030900--
