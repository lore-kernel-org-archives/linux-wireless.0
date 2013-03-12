Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41937 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3CLQfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 12:35:01 -0400
Received: by mail-ob0-f181.google.com with SMTP id ni5so27692obc.40
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 09:35:01 -0700 (PDT)
Message-ID: <513F5931.6040509@lwfinger.net> (sfid-20130312_173507_597815_D9777ED3)
Date: Tue, 12 Mar 2013 11:34:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Patrik, Kluba" <pkluba@dension.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: bug: deadlock in rtl8192cu
References: <20130312163020.67f9532b.pkluba@dension.com>
In-Reply-To: <20130312163020.67f9532b.pkluba@dension.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/2013 10:30 AM, Patrik, Kluba wrote:
>
> Hi!
>
> After killing a wpa_supplicant which was set up to connect to an
> invalid (non-existent) SSID, it goes to 'D' state, and brings down
> every process trying to do low-level network operations (anything
> involving an rtnl_lock) to their knees. The same happens when instead
> of killing wpa_supplicant, I do 'ifconfig wlan0 down'.
>
> See the task state dump at the end. Unfortunately it's not very helpful
> as there are a plenty of static functions called, and due to this a
> couple of addresses are resolved to incorrect symbol names, which
> makes the dump confusing. BTW this is on an ARM system.
>
> The blocking usb_control_msg was actually called from
> _usbctrl_vendorreq_sync_read(). See the following fragment:
>
>
>          do {
>                  status = usb_control_msg(udev, pipe, request, reqtype, value,
>                                           index, pdata, len, 0); /*max. timeout*/
>                  if (status < 0) {
>
>
> Seems like the blocking is intentional (max timeout specified in the
> comment), but I don't know why the transfer cannot finish.
>
> The caller of _usbctrl_vendorreq_sync_read() is _DisableGPIO().
>
>
>          /* 1. Disable GPIO[7:0] */
>          rtl_write_word(rtlpriv, REG_GPIO_PIN_CTRL+2, 0x0000);
>          value32 = rtl_read_dword(rtlpriv, REG_GPIO_PIN_CTRL) & 0xFFFF00FF;
>
>
> rtl_write_word() completes, and rtl_read_dword() is being blocked.
>
> The caller of _DisableGPIO() is _CardDisableHWSM(), which was called
> from rtl92cu_card_disable(), which was called from rtl_usb_stop().
> rtl_usb_stop was called with rtnl_lock held.
>
> This was first observed on a 3.2.34 kernel. Today I have tried
> compat-wireless-02-22 on the same kernel, with the patches from OpenWrt,
> but nothing changed. I have checked the wireless-next git tree, and
> _usbctrl_vendorreq_sync_read() is the same.
>
> I have no idea what can be the actual problem, but can do a bit of debugging and
> information gathering if you need more, just tell me what should I do.
> usb_control_msg() has not completed for at least 30 minutes now. As a quick
> workaround, is it enough to set a timeout of say, 5 seconds in
> usbctrl_vendorreq_sync_read() ? Could this cause problems at different places?

I do not think that a timeout of 5 seconds would cause any problems. Any USB I/O 
that has not completed in that time should return an error status.

Please try it with

    status = usb_control_msg(udev, pipe, request, reqtype, value,
                             index, pdata, len, USB_CTRL_SET_TIMEOUT);

That symbol is set to 5000 (milliseconds).

Let me know if that helps. I have not seen this problem on x86 or ppc 
architecture. Perhaps these are fundamentally different than ARM.

Larry


