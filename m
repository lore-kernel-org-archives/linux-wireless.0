Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:33450 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750704AbdFFF0h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Jun 2017 01:26:37 -0400
Received: by mail-vk0-f47.google.com with SMTP id p62so41763888vkp.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jun 2017 22:26:37 -0700 (PDT)
MIME-Version: 1.0
From: Benjamin Wie <beewee91@gmail.com>
Date: Tue, 6 Jun 2017 07:26:36 +0200
Message-ID: <CAAPSgj3XDzQ_7TK4SuX_L_1QgQ=CDtn6EqWPo4RFWM+20JG4Hw@mail.gmail.com> (sfid-20170606_072643_256442_FE50768D)
Subject: ath9k: wifi not working with btcoex_enable on AR9462
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm trying to use a bluetooth speaker while connected to a wifi. At
first, once I started sending something to the speaker via bluetooth,
the wifi connection was slowed down a lot or even disconnected because
btcoex_enable was not set.
Now I enabled it using:

  modprobe -r ath9k
  modprobe ath9k btcoex_enable=1

with the result, that I can't connect to the wifi at all, even if
bluetooth is completely disabled.
Do you know how to fix this?

[ben@localhost]~% uname -r
4.11.3-200.fc25.x86_64

[ben@localhost]~% lspci -k
(...)
04:00.0 Network controller: Qualcomm Atheros AR9462 Wireless Network
Adapter (rev 01)
    Subsystem: Foxconn International, Inc. Device e052
    Kernel driver in use: ath9k
    Kernel modules: ath9k

[ben@localhost]~% dmesg | grep ath
[    4.482734] usbcore: registered new interface driver ath3k
[    4.769527] ath: phy0: ASPM enabled: 0x42
[    4.769530] ath: EEPROM regdomain: 0x6c
[    4.769531] ath: EEPROM indicates we should expect a direct regpair map
[    4.769533] ath: Country alpha2 being used: 00
[    4.769533] ath: Regpair used: 0x6c
[    4.819454] ath9k 0000:04:00.0 wlp4s0: renamed from wlan0


Thank you!
Benjamin
