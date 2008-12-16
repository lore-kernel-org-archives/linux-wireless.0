Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:34149 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYLPNt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 08:49:27 -0500
Received: by ewy10 with SMTP id 10so3669061ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 05:49:26 -0800 (PST)
Message-ID: <4947B1E3.4080008@gmail.com> (sfid-20081216_144940_468231_21EA8FF2)
Date: Tue, 16 Dec 2008 14:49:23 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200812160024.27451.chunkeey@web.de> <49477A2A.7030406@gmail.com> <200812161415.09365.chunkeey@web.de>
In-Reply-To: <200812161415.09365.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Tuesday 16 December 2008 10:51:38 Artur Skawina wrote:
>> Christian Lamparter wrote:
>>> On Tuesday 16 December 2008 00:03:42 Artur Skawina wrote:
>>>> Artur Skawina wrote:
>>>>> Christian Lamparter wrote:
>>>>>> On Monday 15 December 2008 19:41:13 Larry Finger wrote:
>>>>>>> Artur Skawina wrote:
>>>>>>>> I have a sinus 154 data usb adapter, which used to work w/ p54 in 2.6.27:
>>>>>>> Can you bisect this problem?
>>>>>> Naa I guess its "p54: fix memory management".
>>>> Done:
>>>> 78e74789bf2dab82f9539cd46e7f7583ff9516c1 is first bad commit
>>>> commit 78e74789bf2dab82f9539cd46e7f7583ff9516c1
>>>> Author: Christian Lamparter <chunkeey@web.de>
>>>> Date:   Wed Oct 15 04:07:16 2008 +0200
>>>>
>>>>     p54: fix memory management
>>> ahh, well there went the 100% chance...
>>>
>>> Anyway can you fire up usbmon
>>> (see Linux-Source/Documentation/usb/usbmon.txt ,
>>> or right there: http://www.mjmwired.net/kernel/Documentation/usb/usbmon.txt)
>>> and capture the frames which are sent to the device?
>>> for the p54usb in 2.6.27 and the not working one in the git tree?
>>>
>>> Regards,
>>> 	Chr 
>>>
>> Both files attached. The diff seems to be:
>> +0 0 S Bo:1:666:1 -115 1056 = 00000000 2c040000 00000000 00000000 00800404 64020200 0c000000 0000f803
>> -0 0 S Bo:1:666:1 -115 32 = 00020200 10004000 00000000 00000000 00800420 00020200 0c000000 00000020
> that's very odd....
> it looks like the patch doesn't have any effect at all....

I've looked at that commit more closely in the mean time;
this patch makes the card reappear:

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 9c2c651..474f739 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -314,6 +314,7 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb,
 	struct net2280_tx_hdr *hdr;
 	struct net2280_reg_write *reg;
 	int err = 0;
+	struct p54_hdr *pkg_hdr = (struct p54_hdr *)skb->data;
 
 	reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
 	if (!reg)
@@ -338,8 +339,8 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb,
 
 	hdr = (void *)skb_push(skb, sizeof(*hdr));
 	memset(hdr, 0, sizeof(*hdr));
-	hdr->device_addr = ((struct p54_hdr *)skb->data)->req_id;
-	hdr->len = cpu_to_le16(skb->len + sizeof(struct p54_hdr));
+	hdr->device_addr = pkg_hdr->req_id;
+	hdr->len = cpu_to_le16(skb->len - sizeof(*hdr));
 
 	usb_fill_bulk_urb(int_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),


> Dec 16 14:32:44 kernel: usb 1-7: new high speed USB device using ehci_hcd and address 14
> Dec 16 14:32:44 kernel: usb 1-7: configuration #1 chosen from 1 choice
> Dec 16 14:32:44 kernel: usb 1-7: firmware: requesting isl3886usb
> Dec 16 14:32:44 kernel: usb 1-7: New USB device found, idVendor=0846, idProduct=4200
> Dec 16 14:32:44 kernel: usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> Dec 16 14:32:44 kernel: phy1: p54 detected a LM86 firmware
> Dec 16 14:32:44 kernel: phy1: FW rev 2.5.6.0 - Softmac protocol 3.0
> Dec 16 14:32:44 kernel: phy1: you are using an obsolete firmware. visit http://wireless.kernel.org/en/users/Drivers/p54 and grab one for "kernel >= 2.6.28"!
> Dec 16 14:32:44 kernel: phy1: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:no
> Dec 16 14:32:47 kernel: phy1: hwaddr 00:30:f1:12:34:56, MAC:isl3886 RF:Frisbee
> Dec 16 14:32:47 kernel: phy1: Selected rate control algorithm 'minstrel'
> Dec 16 14:32:47 kernel: usbcore: registered new interface driver p54usb
> Dec 16 14:32:47 kernel: udev: renamed network interface wlan0 to wlan1

Did not do any further testing yet.

> Can you please revert it and add this one?
> it adds a few printks that should help.

I assume this is no longer needed, but i'll be happy test any p54usb/2280 related patches.

Thanks,

artur

