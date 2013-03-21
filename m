Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:35840 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342Ab3CULlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 07:41:12 -0400
Received: by mail-oa0-f53.google.com with SMTP id m17so1532901oag.40
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 04:41:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <18571064.59631363798987681.JavaMail.www@wwinf3703>
References: <24720158.53141363795611541.JavaMail.www@wwinf3703>
	<18571064.59631363798987681.JavaMail.www@wwinf3703>
Date: Thu, 21 Mar 2013 17:11:11 +0530
Message-ID: <CAD2nsn1ep2HOZx55rGmbpgof-HWkMMeiEHSGBEqpe0gZzubbWg@mail.gmail.com> (sfid-20130321_124255_618409_BC81D2B6)
Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: nick@nhthomas.freeserve.co.uk
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 20, 2013 at 10:33 PM,  <nick@nhthomas.freeserve.co.uk> wrote:
>
> Here is another example, taken from Wireshark.
> It's an ARP response, effectively saying IP address 192.168.0.107 is at 00:03:7f:20:50:59
>
> This is a message coming out of the wifi adaptor, and the above numbers are the IP address, and MAC address of the wifi device.
>
> 7f 20 50 59 00 24 00 03 7f 20 50 59 08 06 00 01
> 08 00 06 04 00 02 00 03 7f 20 50 59 c0 a8 00 07
> 20 cf 30 94 83 7b c0 a8 00 65
>
> What we see here is the Destination MAC address is 7f:20:50:59:00:24 (first 6 bytes).
> But that's wrong. It should be 20:cf:30:94:83:7b .
>
> The other parts look right though:
> 00:03:7f:20:50:59 is the MAC of the wifi device.
> c0 a8 00 65 is 192.168.0.101 which is the IP address of the destination.
> c0 a8 00 07 is the IP address of the wifi adaptor itself.

let us check in ath6kl_wmi_dix_2_dot3, that should give us some clue.

>
> So, where in the code is the first 6 bytes generated ?
>
>
> Regards
>
> Nick



-- 
thanks,
shafi
