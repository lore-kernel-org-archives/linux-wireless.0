Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:47588 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3KQD4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Nov 2013 22:56:38 -0500
Received: by mail-oa0-f41.google.com with SMTP id g12so5790535oah.0
        for <linux-wireless@vger.kernel.org>; Sat, 16 Nov 2013 19:56:37 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 17 Nov 2013 11:56:37 +0800
Message-ID: <CADqH6VygZFB4HEgcSesZB0cAhB4OvGnST+9mvTjw_QEAD_6QnQ@mail.gmail.com> (sfid-20131117_045642_461091_42E62D85)
Subject: WL12xx support for WL1270 and ti-connectivity firmware
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: linux-wireless@vger.kernel.org, coelho@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi friends,

I searched through the mailing list archives to see if there's any
conclusive answer about this but didn't find any. I'm planning on
using the wl12xx driver in 3.0.35 for i.mx6 board with a murata
LBWA19XSLZ chip (TI WL1270 transceiver) and am checking if this might
work.

a) does wl12xx support wl1270?
I'm not certain whether or not the wl12xx driver supports wl1270. The
code does not mention wl1270. The defines/ops are prefixed with
wl1271. Eg:
linux-3.0.35$ egrep ieee80211_ops drivers/net/wireless/wl12xx/*.c
drivers/net/wireless/wl12xx/main.c:static const struct ieee80211_ops
wl1271_ops = {

Can I conclude that I should not expect this to work for wl1270? Or is
it just that wl1271 and wl1270 share compatible ops?

b) is there specific firmware I will need for the wl1270?
I see that wl1271 gets its firmware from ti-connectivity which has:
https://github.com/shaharlevi/linux-firmware-ti-connectivity/tree/ti-connectivity/ti-connectivity
wl1271-fw.binlinux-firmware: wl12xx-update STA FW supports 11n BA sessions
wl127x-fw-3.binlinux-firmware: wl12xx: Updated STA & AP FW for wl12xx-fw-3

I'm wondering if that wl127x includes wl1270 support.

Thanks for any advice/suggestions.

Thanks,
jayakumar
