Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46406 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1JQO7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 10:59:19 -0400
Received: by gyb13 with SMTP id 13so3042297gyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 07:59:18 -0700 (PDT)
Message-ID: <4E9C42CF.5010702@lwfinger.net> (sfid-20111017_165930_134232_00DAE180)
Date: Mon, 17 Oct 2011 09:59:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: v4mp <gaigo88@hotmail.it>
CC: linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org> <loom.20111006T181210-236@post.gmane.org> <4E8E2659.3060808@lwfinger.net> <loom.20111008T181929-517@post.gmane.org> <4E907FB8.1040101@lwfinger.net> <CA+XFjio+on2rUymoSZNxOWKMX9  xOn5hutA6q01r0yBeOXz0ivw@mail.gmail.com> <loom.20111009T161348-133@post.gmane.org> <4E91B400.1020305@lwfinger.net> <loom.20111015T161652-440@post.gmane.org> <4E9A4647.60901@lwfinger.net> <loom.20111017T115802-634@post.gmane.org>
In-Reply-To: <loom.20111017T115802-634@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/17/2011 05:07 AM, v4mp wrote:
>
> ok, i've attached the alfa and run rfkill list but it shows that there are no
> blocked devices, then i run modprobe rtl8192cu and strangely the alfa has
> lighted, but it doesn't work..
> i've done dmesg and seen this:
>
> [ 1218.079638] rtlwifi: reg 0xc80, usbctrl_vendorreq TimeOut! status:0xfffffff4
> value=0xed545b78
> [ 1218.079645] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [ 1218.079650] rtlwifi: reg 0xc80, usbctrl_vendorreq TimeOut! status:0xfffffff4
> value=0xed545b78
> [ 1218.079657] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [ 1218.079664] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [ 1218.079669] rtlwifi: reg 0xc4c, usbctrl_vendorreq TimeOut! status:0xfffffff4
> value=0xed545b78
> [ 1218.079676] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [ 1218.079682] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [ 1218.079687] rtlwifi: reg 0xc94, usbctrl_vendorreq TimeOut! status:0xfffffff4
> value=0xed545b78
> [ 1218.241190] ADDRCONF(NETDEV_UP): wlan1: link is not ready

Those errors look as if the device was removed before unloading the driver. That 
is a known problem with the driver.

> for the firmware i don't know how to update it, i'm using ubuntu 11.04 natty
> with 3.1.0-0301rc9-generic
> where can i download updated firmware to test it for this card?
> thx

The firmware is available in the linux-firmware git repo, and should be in your 
distro's firmware package.

Only one version of the firmware has been published. The md5sum output is

943e9b714a926e630b8152d7aad91d2e  /lib/firmware/rtlwifi/rtl8192cufw.bin.

Please reboot your system, try to connect, and then post your entire dmesg 
output at pastebin.com. Report the link here.

Larry
