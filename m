Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:45339 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbdJSAQo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 20:16:44 -0400
Received: by mail-oi0-f68.google.com with SMTP id f66so11955517oib.2
        for <linux-wireless@vger.kernel.org>; Wed, 18 Oct 2017 17:16:44 -0700 (PDT)
Subject: Re: rtlwifi oops
To: nirinA <nirina.raseliarison@gmail.com>,
        James Cameron <quozl@laptop.org>,
        linux-wireless@vger.kernel.org
References: <cf61cfda-1e32-3ec3-d558-b508c3b923b6@gmail.com>
 <20171018223320.GB641@us.netrek.org>
 <c13aa975-6339-2f5a-20bb-0a82656a2271@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <fcf4b761-d7bd-7956-fa98-07fd8b2f8c3b@lwfinger.net> (sfid-20171019_021748_710645_D8551AF5)
Date: Wed, 18 Oct 2017 19:16:42 -0500
MIME-Version: 1.0
In-Reply-To: <c13aa975-6339-2f5a-20bb-0a82656a2271@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/2017 06:18 PM, nirinA wrote:
> not really a rtlwifi oops then. maybe issue with udev as that also disabled the 
> usb mouse.
> but i have no problem since. i will report if i will catch it again.
> 
> thanks,
> 
> -- 
> nirinA
> 
> James Cameron wrote:
>> On Thu, Oct 19, 2017 at 01:31:43AM +0300, nirinA wrote:
>>> hello there,
>>> i got the oops below with a rtl8192cu:0bda:8178 and kernel 4.13.6, but
>>> cannot reproduce it.
>>> i use this device since 4.3 or so without noticing any issue.
>>>
>>> nirinA
>>>
>>> [  239.338040] usb 2-1.3: new high-speed USB device number 4 using ehci-pci
>>> [  239.417728] usb 2-1.3: New USB device found, idVendor=0bda,
>>> idProduct=8178
>>> [  239.417730] usb 2-1.3: New USB device strings: Mfr=1, Product=2,
>>> SerialNumber=3
>>> [  239.417731] usb 2-1.3: Product: 802.11n WLAN Adapter
>>> [  239.417732] usb 2-1.3: Manufacturer: Realtek
>>> [  239.417733] usb 2-1.3: SerialNumber: 00e04c000001
>>> [  239.578100] rtl8192cu: Chip version 0x11
>>> [  239.678225] usb 2-1-port3: disabled by hub (EMI?), re-enabling...
>> Just prior to the oops, your USB hub disabled the port being used by
>> the wireless device.
>>
>> While the response of the driver seems wrong, it is a difficult
>> condition to reproduce; one must either force or forge the disabling
>> by the hub.
>>
>>> [  239.678230] usb 2-1.3: USB disconnect, device number 4
>>> [  239.679128] rtl_usb: reg 0x30, usbctrl_vendorreq TimeOut!
>>> status:0xffffffed value=0x0

This sequence of events is unusual. A driver should be able to trust that the 
platform is behaving correctly and normally.

In reviewing the USB probe routine, the only thing I could see is that one 
returned value is not being checked. If the problem happens again, please try 
the following patch:

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c 
b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 5590d07d0918..092cd2da15f6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1082,6 +1082,8 @@ int rtl_usb_probe(struct usb_interface *intf,
         init_completion(&rtlpriv->firmware_loading_complete);
         SET_IEEE80211_DEV(hw, &intf->dev);
         udev = interface_to_usbdev(intf);
+       if (!udev)
+               return -ENODEV;
         usb_get_dev(udev);
         usb_priv = rtl_usbpriv(hw);
         memset(usb_priv, 0, sizeof(*usb_priv));

I will test and push this patch because that value should be checked, but I'm 
not sure it would correct your problem.

Larry
