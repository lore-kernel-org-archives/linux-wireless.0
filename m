Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60274 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2JOPNn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 11:13:43 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so7955021iea.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2012 08:13:42 -0700 (PDT)
Message-ID: <507C2823.7030500@lwfinger.net> (sfid-20121015_171347_128268_3CA7A4D3)
Date: Mon, 15 Oct 2012 10:13:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, Joshua.Roys@gtri.gatech.edu
Subject: Re: [RFC] rtlwifi: fix in_ep = in_ep_num mishap in _rtl_usb_init_rx
References: <201210142213.56197.chunkeey@googlemail.com> <507B4CE5.2020104@lwfinger.net> <201210151242.58431.chunkeey@googlemail.com>
In-Reply-To: <201210151242.58431.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/2012 05:42 AM, Christian Lamparter wrote:
> It's a bit weird that you have three IN and OUT 0x3 eps. Is this
> really true or is this a c&p error and your devices have more
> than one interface configuration?
>
> The endpoint configuration for my SU devices (both are the same)
> look like this:
>     Interface Descriptor:
>          bEndpointAddress     0x83  EP 3  IN  Bulk Data 512 bytes
>          bEndpointAddress     0x04  EP 4  OUT Bulk Data 512 bytes
>          bEndpointAddress     0x06  EP 6  OUT Bulk Data 512 bytes
>          bEndpointAddress     0x0d  EP 13 OUT Bulk Data 512 bytes
>
> It looks like that we should parse the endpoint descriptor and
> get the first endpoint from there.

The confusion arose from me reporting the EP configuration for the USB Bluetooth 
component of an RTL8723AE that I currently have installed. It has the 
bidirectional EPs:

         bEndpointAddress     0x81  EP 1 IN
         bEndpointAddress     0x02  EP 2 OUT
         bEndpointAddress     0x82  EP 2 IN
         bEndpointAddress     0x03  EP 3 OUT
         bEndpointAddress     0x83  EP 3 IN
         bEndpointAddress     0x03  EP 3 OUT
         bEndpointAddress     0x83  EP 3 IN
         bEndpointAddress     0x03  EP 3 OUT
         bEndpointAddress     0x83  EP 3 IN
         bEndpointAddress     0x03  EP 3 OUT
         bEndpointAddress     0x83  EP 3 IN
         bEndpointAddress     0x03  EP 3 OUT
         bEndpointAddress     0x83  EP 3 IN
         bEndpointAddress     0x03  EP 3 OUT
         bEndpointAddress     0x83  EP 3 IN

My RTL8191SU and the RTL8192SU both have the following:

         bEndpointAddress     0x83  EP 3 IN
         bEndpointAddress     0x04  EP 4 OUT
         bEndpointAddress     0x06  EP 6 OUT
         bEndpointAddress     0x0d  EP 13 OUT

My two copies if RTL8188CUS chips that use rtl8192cu both have

         bEndpointAddress     0x81  EP 1 IN
         bEndpointAddress     0x02  EP 2 OUT
         bEndpointAddress     0x03  EP 3 OUT
         bEndpointAddress     0x84  EP 4 IN

Although these chips have two IN EPs, the first is the one in use, thus 
searching for the first IN EP should be OK, and we can ignore the fact that the 
chip has two IN EPs. I am currently trying to acquire a sample of the RTL8192DU 
device with dual band operation on separate MACs. I think it registers as two 
separate devices (at least the PCI version does), and it should not change the 
situation. Even if it does, its initial driver will be in staging, and will not 
use rtlwifi.

Larry

