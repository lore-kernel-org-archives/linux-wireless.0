Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33068 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1174452AbdDXUZu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 16:25:50 -0400
Received: by mail-oi0-f54.google.com with SMTP id y11so117012548oie.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 13:25:45 -0700 (PDT)
Received: from mail-oi0-f43.google.com (mail-oi0-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id h10sm8509203otb.39.2017.04.24.13.25.42
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Apr 2017 13:25:42 -0700 (PDT)
Received: by mail-oi0-f43.google.com with SMTP id j201so149219286oih.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 13:25:42 -0700 (PDT)
MIME-Version: 1.0
From: Adam Casson <adam.casson@inscopemedical.com>
Date: Mon, 24 Apr 2017 16:25:11 -0400
Message-ID: <CAPdsbMvE=_-oQ9wWLPQkUuF_Q3JeHCKo-0NrPt0hRRPo8khH9Q@mail.gmail.com> (sfid-20170424_222619_941094_0D79E42A)
Subject: WPA authorization with RTL8723DS
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to build a product around the Next Thing Co CHIP Pro
(nextthing.co/pages/chippro) and have found that the RTL8723DS wifi/BT
chip is fairly unstable, particularly when trying to implement WPA
authorization. A previous version of this SoM uses the RTL8723BS which
is similar in structure and driver, but this new 8723DS is different
enough to warrant a separate code branch from both Realtek and the
manufacturer of the SoM. However, Realtek has not publically released
a driver for the new 8723DS chip. We have received no support from the
SoM manufacturer, so we're looking for some external help so that we
can maybe salvage the considerable work we've put into developing
around this SoM.

Some additional details about how the device was being used are below.

Use hopstapd (configuration for open and WPA included) to configure
the Chip Pro as an access point. Launch hostapd (command line also
provided in logs).

Gadget buildroot git commit e550a93f2b08c771f0dd75919bb042ad86faa763

WPA version 2 (as specified in the provided hostapd config).

Client types tested:

- rtl8188eu usb dongle on Ubuntu 16.04 workstation
- 2013 Mac Book Pro running 10.12 Sierra

Same results with both (WPA auth failed). Both clients have been
tested successfully with a wide range of WPA2 access points.

Thanks for any help you can provide!
Adam
