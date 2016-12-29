Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:36202 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752873AbcL2QWQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Dec 2016 11:22:16 -0500
Received: by mail-qt0-f195.google.com with SMTP id d22so19830963qtd.3
        for <linux-wireless@vger.kernel.org>; Thu, 29 Dec 2016 08:22:16 -0800 (PST)
MIME-Version: 1.0
From: Agustin Martin <agustin6martin@gmail.com>
Date: Thu, 29 Dec 2016 17:22:15 +0100
Message-ID: <CAHMXK7gqy9_PsZLKxTW7821XmGO1VOaD0Ex+gEsdzsXgwGenWg@mail.gmail.com> (sfid-20161229_172221_032134_2B8E16F5)
Subject: rtl8xxxu: Testing with 0BDA:8178 (TP-link TL-WN821N with 8192cu)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Jes

Sorry if you already received this feedback, I could not find references.

I am trying a TP-LINK TL-WN821N wifi usb dongle with Realtek 8192cu
(lsusb returns: 0bda:8178 Realtek Semiconductor Corp. RTL8192CU
802.11n WLAN Adapter) and found the same problems described in

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1365844

When using kernel rtl8192cu driver, I can connect to wifi, but soon
the connection is dropped.

Since some time ago (2014) you asked for feedback in that bug and I
did not find further references I decided to try your rtl8xxxu driver.

All tests were carried out in a Debian GNU/Linux jessie box (current
stable release) with kernel 4.7.8 from Debian jessie backports (source
package linux_4.7.8-1~bpo8+1.dsc).

Changed kernel config to

## file: drivers/net/wireless/realtek/rtl8xxxu/Kconfig
##
CONFIG_RTL8XXXU=m
CONFIG_RTL8XXXU_UNTESTED=y

built a kernel (slooow here), installed it and added this line to a
file under /etc/modprobe.d

alias usb:v0BDAp8178d*dc*dsc*dp*icFFiscFFipFFin* rtl8xxxu

If the dongle is initially connected, system loads the rtl8xxxu module
instead of rtl8192cu when booting but seems not to initialize the
dongle, so I have no connection. However, if I disconnect the dongle
and reconnect it again with the system on, everything seems to work
well with no connection dropping. Only minimally tested, but apart
from the boot problem apparently much better than with the built-in
rtl8192cu kernel module.

Thanks for all the work you are putting into this driver

-- 
Agustin
