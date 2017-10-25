Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:52572 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932206AbdJYSn5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 14:43:57 -0400
Received: by mail-ua0-f170.google.com with SMTP id i35so721364uah.9
        for <linux-wireless@vger.kernel.org>; Wed, 25 Oct 2017 11:43:56 -0700 (PDT)
MIME-Version: 1.0
From: David Ashley <dashxdr@gmail.com>
Date: Wed, 25 Oct 2017 13:43:55 -0500
Message-ID: <CABkE59DHPoLD5PGRHpKMAwy0w3vR9M_qoHEQ1AkK-ELDcUXD9Q@mail.gmail.com> (sfid-20171025_204401_104346_1D83767E)
Subject: RTL usb adapter question
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to understand how the linux kernel loads RTL8188CUS firmware
rtlwifi: Loading alternative firmware rtlwifi/rtl8192cufw.bin
when that file isn't available anywhere in my embedded system's filesystem.

Basically I'm trying to understand the theory. We have a product that
is making use of the device

Bus 001 Device 007: ID 7392:7811 Edimax Technology Co., Ltd
EW-7811Un802.11n Wireless Adapter [Realtek RTL8188CUS]

It has not been especially reliable. I've never provided firmware
files for the device in the root filesystem. I've started to pay
attention to the kernel error messages. Now the kernel drivers seem to
be loading the rtlwifi/rtl8192cufw_TMSC.bin file and I'm trying to
understand if this is actually working, if it makes any difference in
reliability...

It's like I can't figure out how the usb dongle even worked without
its firmware file...

My working theory is that the usb dongle comes from the factory with a
hardcoded firmware file (rtlwifi/rtl8192cufw.bin) but it is buggy or
inferior. And the performance and reliability can be improved if the
driver successfully manages to load the rtl8192cufw_TMSC.bin file. I
don't know if the firmware load persists across a power cycle (my
assumption is it doesn't).

Thanks for any insight anyone can provide.

-Dave
