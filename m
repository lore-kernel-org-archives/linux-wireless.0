Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:34163 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933198AbcJUM57 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 08:57:59 -0400
Received: by mail-yw0-f182.google.com with SMTP id w3so92566836ywg.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2016 05:57:59 -0700 (PDT)
MIME-Version: 1.0
From: Nicklas Persson <nicklas.m.persson@gmail.com>
Date: Fri, 21 Oct 2016 14:57:57 +0200
Message-ID: <CAJHOaSPSPXh3XD7Rv_7G0g8yUWgu2ior9Qbk_00vNDQNU3UB-g@mail.gmail.com> (sfid-20161021_145813_193936_2DAE752E)
Subject: wl12xx stuck in fw
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I have been debugging my WLAN driver interface for a while. I have
a Beaglebone equivalent board with the TI wl1271 wireless module. I am
very new to linux drivers and wireless configuration so these couple
of days I have spent have been really interesting and I have much more
knowledge now.

My problem is that when I run "ifconfig wlan0 up" I get the following
message over and over again:

"wlcore: ERROR Tx stuck (in FW) for 5000 ms. Starting recover"

I successfully done a calibration, that does not help. I also tried
with the default .nvs file that is provided.

I have tried with different firmware binaries with no luck. Actually,
I have browsed the source code for wl12xx and wlcore and it seems like
I need to use the 5-series of firmware binaries so I have been using
those for the most time.

I have rebuilt the kernel with a lot of added printk()'s all over the
place but I do not understand at all what is happening. My guess is
that there is something with the watchdog and that the driver thinks
that the firmware/wlan module is not responding.

I am really desperate for some guidance or some pointers. What can I try next?

Thanks,
Regards Nicklas.
