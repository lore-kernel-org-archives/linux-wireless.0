Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:31738 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab0DPUvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 16:51:36 -0400
Received: by fg-out-1718.google.com with SMTP id 19so501902fgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 13:51:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <k2r8108ad761004161334x894f9298xf3728846ff69b36b@mail.gmail.com>
References: <k2r8108ad761004161334x894f9298xf3728846ff69b36b@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 16 Apr 2010 22:51:15 +0200
Message-ID: <w2s69e28c911004161351xa56d4d50l519a3c99258c5ea0@mail.gmail.com>
Subject: Re: timeout in zd1211rw with zotac mini-itx (geforce 9300)
To: Tsuwei Chen <tsuwei@gmail.com>
Cc: zd1211-devs@lists.sourceforge.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 16, 2010 at 10:34 PM, Tsuwei Chen <tsuwei@gmail.com> wrote:
> Has anyone use the zd1211 usb adapter with mini-itx board based on
> geforce 9300? I have been experience some annoying issues ever since I
> got this motherboard. The problem is that sometime the card just
> cannot be switched on. It complains about ioread32() error -110. And I
> have spent a few days and try a few different combination, and here is
> what I have found so far:
>
> 1, with 1 wifi adapter directly plugged into the board, the wifi
> adapter works fine most of the time (have seen a couple failure, but
> is hard to reproduce)
> 2. with 1 wifi adapter, plugged in through a USB hub, the driver
> complains ioread32 error. I've try 2 USB hubs: a cheap 4-port USB
> dongle and also the USB hubs built into my DELL monitor. Both showed
> the same problem.
> 3. If I plugged in 2 wifi adapters directly to the board, more than
> 50% of chance one of the wifi adapter would fail during the 'ifconifg
> up'.
>
> I tried to dig our more on this. I am using kernel 2.6.24-26 (ubuntu).

Please try a more recent kernel - 2.6.24 contains
zd1211rw-ieee80211softmac, which is no longer developed.

> I had turned on the debug message output and I have traced out that
> the failure was first detected in the zd_mac_open(). Probably around
> the call to zd_chip_switch_radio_on(). The error message is printed in
> the zd_usb_ioread16v(), and probably indicate the driver is
> experiencing a timeout while it is trying to read the register from
> the adapter.
>
> What exactly does this mean? Why adding a usb hub cause such a huge
> differnce? Has anyone experienced similar problem before? Any pointer
> that can help me solve this problem is appreciated.
>
> BTW, I never had this problem before when I was still using a regular
> HP desktop PC, even with the same version of kernel and same USB hub.
> I switched to mini-itx because I am building a small system. So if
> anyone is currently using this adapter with a mini-ITX board, please
> also let me know which model you use.
>
> TIA,
> Tsuwei
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
