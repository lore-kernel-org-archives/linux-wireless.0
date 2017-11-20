Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:43746 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751454AbdKTQjs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 11:39:48 -0500
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAKGcT5W003801
        for <linux-wireless@vger.kernel.org>; Mon, 20 Nov 2017 16:39:47 GMT
Received: from mail-wr0-f199.google.com (mail-wr0-f199.google.com [209.85.128.199])
        by mx08-00252a01.pphosted.com with ESMTP id 2eaa7k16h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Mon, 20 Nov 2017 16:39:47 +0000
Received: by mail-wr0-f199.google.com with SMTP id y42so6167098wrd.23
        for <linux-wireless@vger.kernel.org>; Mon, 20 Nov 2017 08:39:47 -0800 (PST)
MIME-Version: 1.0
From: James Hughes <james.hughes@raspberrypi.org>
Date: Mon, 20 Nov 2017 16:39:45 +0000
Message-ID: <CAE_XsML9q6=viKqG2TQCEb921reZBFuRC7=_vy87VDNqD5ONww@mail.gmail.com> (sfid-20171120_173952_028130_0BA38678)
Subject: Question on a RTL8812AU driver
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I know there been a lot of work done on Realtek drivers in the last
few months, and was wondering whether this will be of use for my
particular issue.

We have a Raspberry Pi that needs to use a USB wireless adaptor
(2001:3314) which uses the rtl8812AU chipset. We have to use this
device as it's the only one that has been qualified for this
particular use case.

We have been using an out of tree driver, I think originally from
Realtek, that works, but after a few days locks up, and often requires
a reboot on the Pi. We do have some mitigation strategies, but it'
would be better to have a working driver. The Pi is, on the whole,
inaccessible.

The OoT driver is from here
https://github.com/diederikdehaas/rtl8812AU and appear quite ancient.

So, I've been looking at the 4.14 staging drivers that do seem to have
support for some realtek devices. However, none of the drivers I have
built recognise the module. The source of rtlwifi does refer to the
8812AU, but only to ignore it. There are other references throughout
the source.,

My question, eventually, is down to figuring out whether any of the
new staging code is destined to work on this device, or am I going to
have to stick with the driver we are currently using which clearly has
a lockup issue that I, in all likelihood, not going to be able to
track down since its takes days for it to occur.

Or if anyone has any suggestions for getting this working, I'm all ears.

TIA

James Hughes, Raspberry Pi.
