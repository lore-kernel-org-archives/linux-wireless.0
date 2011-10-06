Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36150 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab1JFWGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 18:06:22 -0400
Received: by yxl31 with SMTP id 31so3067223yxl.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 15:06:22 -0700 (PDT)
Message-ID: <4E8E2659.3060808@lwfinger.net> (sfid-20111007_000630_182399_12817B8D)
Date: Thu, 06 Oct 2011 17:06:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Toddy <toddy@fishpost.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org> <loom.20111006T181210-236@post.gmane.org>
In-Reply-To: <loom.20111006T181210-236@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/06/2011 11:25 AM, Toddy wrote:
> Hello,
>
> I also have the AWUS036NHR device and I got it working on Ubuntu 11.04
> 2.6.38-11-generic x64. The only thing I did is to compile&install
> compat-wireless-2.6.39-1 (same as beini!) which can be found here:
> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.39/
>
> There was only one strange thing: In drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> there is no entry for the AWUS036NHR so that no driver is loaded when I plugged
> the USB in, but in older versions of compat-wireless (e.g. 2.6.38) there IS one
> entry for this device. The entry looks like this:
>
> /* 8188RU in Alfa AWUS036NHR */
> {RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817f, rtl92cu_hal_cfg)}
>
> So I patched the file, compiled&installed it and everything worked! Could
> someone patch the sources and add this device? Thanks!

The device is already in the kernel source.

Your choice of a compat-wireless version is what caused the problem. That device 
was added to wireless-testing code on Aug. 5, 2011. By choosing an older version 
of compat-wireless, you did not get that patch. For best results, you should 
always choose the bleeding-edge version of compat-wireless.

Larry
