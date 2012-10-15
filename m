Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51284 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2JOKnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 06:43:14 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2357640bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2012 03:43:12 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] rtlwifi: fix in_ep = in_ep_num mishap in _rtl_usb_init_rx
Date: Mon, 15 Oct 2012 12:42:58 +0200
Cc: linux-wireless@vger.kernel.org, Joshua.Roys@gtri.gatech.edu
References: <201210142213.56197.chunkeey@googlemail.com> <507B4CE5.2020104@lwfinger.net>
In-Reply-To: <507B4CE5.2020104@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210151242.58431.chunkeey@googlemail.com> (sfid-20121015_124317_737491_7F8277AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, October 15, 2012 01:38:13 AM Larry Finger wrote:
> On 10/14/2012 03:13 PM, Christian Lamparter wrote:
> > in_ep and in_ep_num should not be the same as
> > a device can have a different in_ep than "1".
> >
> > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > Larry, do you know of any hardware which has two in endpoints?
> 
> The RTL8188CU has the following:
> 
> Bus 004 Device 002: ID 0bda:8723 Realtek Semiconductor Corp.
>          bEndpointAddress     0x81  EP 1 IN
>          bEndpointAddress     0x02  EP 2 OUT
>          bEndpointAddress     0x82  EP 2 IN
>          bEndpointAddress     0x03  EP 3 OUT
>          bEndpointAddress     0x83  EP 3 IN
>          bEndpointAddress     0x03  EP 3 OUT
>          bEndpointAddress     0x83  EP 3 IN
>          bEndpointAddress     0x03  EP 3 OUT
>          bEndpointAddress     0x83  EP 3 IN
> 
> My SU device has the same layout. It seems that only EP 
> 1 is used exclusively for input operations.

It's a bit weird that you have three IN and OUT 0x3 eps. Is this
really true or is this a c&p error and your devices have more
than one interface configuration?

The endpoint configuration for my SU devices (both are the same)
look like this:
   Interface Descriptor:
        bEndpointAddress     0x83  EP 3  IN  Bulk Data 512 bytes
        bEndpointAddress     0x04  EP 4  OUT Bulk Data 512 bytes
        bEndpointAddress     0x06  EP 6  OUT Bulk Data 512 bytes
        bEndpointAddress     0x0d  EP 13 OUT Bulk Data 512 bytes

It looks like that we should parse the endpoint descriptor and
get the first endpoint from there.

Regards,
	Chr
