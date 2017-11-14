Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:44512 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753220AbdKNJ1E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 04:27:04 -0500
Received: by mail-pg0-f68.google.com with SMTP id 4so6012717pge.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Nov 2017 01:27:04 -0800 (PST)
Received: from [10.20.1.175] (ivokamhome.ddns.nbis.net. [87.120.136.31])
        by smtp.gmail.com with ESMTPSA id x188sm24320123pgx.33.2017.11.14.01.27.01
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Nov 2017 01:27:01 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: Slow connection with rtl8xxxu and 8192eu chipset
Message-ID: <1195e649-c57f-1247-a0dc-2f0cc0732a00@gmail.com> (sfid-20171114_102736_580396_EC3801FA)
Date: Tue, 14 Nov 2017 11:26:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Please CC as I'm not subscribed)

Hello,

I have the tp-link tl-wn822N usb wifi dongle. lsbusb reports it as

Bus 001 Device 003: ID 2357:0108

Unfortunately with the in-kernel rtl8xxxu driver I don't get very good
results:

wifi1     IEEE 802.11  ESSID:"HOME"
          Mode:Managed  Frequency:2.462 GHz  Access Point:
30:B5:C2:75:A4:CD
          Bit Rate=1 Mb/s   Tx-Power=20 dBm
          Retry short limit:7   RTS thr=2347 B   Fragment thr:off
          Power Management:off
          Link Quality=26/70  Signal level=-84 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:165   Missed beacon:0


At the same time if I use an out of tree driver acquired from github:
https://github.com/Mange/rtl8192eu-linux-driver I get the following:

wifi1     IEEE 802.11bgn  ESSID:"HOME"  Nickname:"<WIFI@REALTEK>"
          Mode:Managed  Frequency:2.462 GHz  Access Point:
30:B5:C2:75:A4:CD
          Bit Rate:144.4 Mb/s   Sensitivity:0/0
          Retry:off   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=81/100  Signal level=100/100  Noise level=0/100
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Clearly this is a software problem of the in-kernel driver. I'm using
v4.10.17 with commit c14239f23adb ("rtl8xxxu: Add another 8192eu device
to the USB list") so that my device is recognised. Latest commit for
that driver in my kernel is: c59f13bbead4 ("rtl8xxxu: Work around issue
with 8192eu and 8723bu devices not reconnecting").

Any ideas what I can do to further debug this, I'd really like to use
the in-kernel driver ?
