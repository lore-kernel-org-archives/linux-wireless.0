Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:52477 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3KRJKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 04:10:07 -0500
Message-ID: <1384765780.22010.42.camel@porter.coelho.fi> (sfid-20131118_101013_090166_E14FC8C0)
Subject: Re: WL12xx support for WL1270 and ti-connectivity firmware
From: Luca Coelho <luca@coelho.fi>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: linux-wireless@vger.kernel.org, coelho@ti.com
Date: Mon, 18 Nov 2013 11:09:40 +0200
In-Reply-To: <CADqH6VygZFB4HEgcSesZB0cAhB4OvGnST+9mvTjw_QEAD_6QnQ@mail.gmail.com>
References: <CADqH6VygZFB4HEgcSesZB0cAhB4OvGnST+9mvTjw_QEAD_6QnQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-11-17 at 11:56 +0800, Jaya Kumar wrote:
> Hi friends,
> 
> I searched through the mailing list archives to see if there's any
> conclusive answer about this but didn't find any. I'm planning on
> using the wl12xx driver in 3.0.35 for i.mx6 board with a murata
> LBWA19XSLZ chip (TI WL1270 transceiver) and am checking if this might
> work.
> 
> a) does wl12xx support wl1270?
> I'm not certain whether or not the wl12xx driver supports wl1270. The
> code does not mention wl1270. The defines/ops are prefixed with
> wl1271. Eg:
> linux-3.0.35$ egrep ieee80211_ops drivers/net/wireless/wl12xx/*.c
> drivers/net/wireless/wl12xx/main.c:static const struct ieee80211_ops
> wl1271_ops = {
> 
> Can I conclude that I should not expect this to work for wl1270? Or is
> it just that wl1271 and wl1270 share compatible ops?

I have never heard of wl1270 while working at TI.  My only guess is that
this is a chip based on wl1271 (since the Murata specs only say b/g/n
and no "a" which is the 5GHz support in wl1273).  Maybe it's a cheaper
chip without Bluetooth? To be sure, you should ask TI.


> b) is there specific firmware I will need for the wl1270?
> I see that wl1271 gets its firmware from ti-connectivity which has:
> https://github.com/shaharlevi/linux-firmware-ti-connectivity/tree/ti-connectivity/ti-connectivity
> wl1271-fw.binlinux-firmware: wl12xx-update STA FW supports 11n BA sessions
> wl127x-fw-3.binlinux-firmware: wl12xx: Updated STA & AP FW for wl12xx-fw-3
> 
> I'm wondering if that wl127x includes wl1270 support.

Same as above... If this wl1270 is indeed based on the wl1271, it should
probably work.  With the driver you may need to add some new SDIO IDs
for it to be recognized though.

--
Luca.


