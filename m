Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35054 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1DOX4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 19:56:48 -0400
Message-ID: <4DA8DB3C.3060800@lwfinger.net>
Date: Fri, 15 Apr 2011 18:56:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Strange build error with new driver on 2.6.39-rc3
References: <4DA8C0DD.8090003@lwfinger.net>
In-Reply-To: <4DA8C0DD.8090003@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/15/2011 05:04 PM, Larry Finger wrote:
> When building a new driver on kernel 2.6.39-rc3 when using a 32-bit system, I
> get the following error:
>
> MODPOST 511 modules
> FATAL: drivers/net/wireless/rtlwifi/rtl8192se/rtl8192se: sizeof(struct
> usb_device_id)=20 is not a modulo of the size of section
> __mod_usb_device_table=168.
> Fix definition of struct usb_device_id in mod_devicetable.h
>
> This error is strange in that this device is PCI based and contains no mention
> of usb_device_id. There is a USB-based driver in the rtlwifi tree, but there is
> also another PCI driver and it does not get this error.

I found the problem. It was a faulty MODULE_DEVICE_TABLE macro statement.

Larry
