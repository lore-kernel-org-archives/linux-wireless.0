Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:47975 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbaCCH7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 02:59:00 -0500
Received: by mail-ob0-f177.google.com with SMTP id wo20so4052247obc.8
        for <linux-wireless@vger.kernel.org>; Sun, 02 Mar 2014 23:59:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKH5=LtkNnX9g9U5Fv8EH9uDj2=KC6gieRT-Td8NNbFhkv_hvg@mail.gmail.com>
References: <CAKH5=LtkNnX9g9U5Fv8EH9uDj2=KC6gieRT-Td8NNbFhkv_hvg@mail.gmail.com>
Date: Mon, 3 Mar 2014 15:59:00 +0800
Message-ID: <CAKH5=LuaHTG40hMy3f-A9UcmCxkRxnfBvoYBzRbL5zfBAKmRJw@mail.gmail.com> (sfid-20140303_085904_997279_8D0C4247)
Subject: Re: insmod: cannot insert `wl_high.ko': Success (17): Success ??
From: Naughtboy <skylvlinux@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

yes  today i kwon it the reason  by accident

# insmod wl_high.ko nvram_path=../nvram/fake43236usb_p420.nvm
insmod: cannot insert `wl_high.ko': Success (17): Success


some reason caused by  wl.ko  (which  has arealdy insmod in the kernel )
so  after  i just  rmmod wl.ko  ,insomd wl_high.ko it just ok !!!!
so  i  change the bcm43236 code  to generate the diffrent moduels name
  ,just slove it , thank you  erenoyone  !!


# insmod bcm_usbshim.ko
# insmod wl_high.ko
bcm_rpc_up: waiting to be connected
bcm_rpc_buf_recv_mgn_high: Reason: 0 Dongle Version: 0x571623e
bcm_rpc_buf_recv_mgn_high: Connected!
eth5: Broadcom BCMa8e4 802.11 Wireless Controller 5.113.98.62
usbcore: registered new interface driver dbus_usbdev

# lsmod
Module                  Size  Used by
wl_high 1350048 0 - Live 0xc045c000 (P)
bcm_usbshim 2048 1 wl_high, Live 0xc0070000
wl 1807408 0 - Live 0xc02a1000 (P)
pktflow 41056 0 - Live 0xc0064000 (PF)






--Naughtboy



2014-02-20 19:19 GMT+08:00 Naughtboy <skylvlinux@gmail.com>:
> i try tralsplant 43236  --5.8G usb dongle drivers into linux-2.6.21.5
> ,but here is some erros .....
>
> filename:       wl_high.ko
> license:        Proprietary
> alias:          usb:v0A5Cp0BDCd*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0471p20E7d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v04DAp23F2d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v043Ep3001d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v1EDAp0BDCd*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v050DpD321d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v050Dp615Bd*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0846p9011d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0A5CpBD17d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0A5CpBD16d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0A5CpBD13d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0A5CpBD12d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0A5Cp0000d*dc*dsc*dp*ic*isc*ip*
> depends:        bcm_usbshim
> vermagic:       2.6.21.5 mod_unload MIPS32_R2 32BIT
> parm:           oneonly:int
> parm:           piomode:int
> parm:           instance_base:int
> parm:           nompc:int
> parm:           name:string
> parm:           nvram_path:string
>
> # insmod bcm_usbshim.ko    ----ok
> but  insmod wl_high.ko occur error  .....    as the follow ..
>
> # insmod wl_high.ko nvram_path=../nvram/fake43236usb_p420.nvm
> insmod: cannot insert `wl_high.ko': Success (17): Success
> # insmod wl_high.ko nvram_path=../nvram/fake43236usb_p420.nvm
> insmod: cannot insert `wl_high.ko': Success (17): Success
>
>
>
>
> any bigman  can do me a gudiance
>
> thank you
> --Naughtboy
