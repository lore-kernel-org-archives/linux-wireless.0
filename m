Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36820 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbeCJHWI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 02:22:08 -0500
Received: by mail-io0-f179.google.com with SMTP id e30so6003148ioc.3
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2018 23:22:08 -0800 (PST)
MIME-Version: 1.0
From: Arjav Parikh <parikharjav24@gmail.com>
Date: Sat, 10 Mar 2018 12:52:07 +0530
Message-ID: <CADoF8+AU991ut3889d0QsxVfKsQ_YXAYQBhQPzLWmxNE1Kn_WA@mail.gmail.com> (sfid-20180310_082810_580968_2B9D1592)
Subject: Dependency required for wil6210 kernel module
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Currently I am working to minimize the filesystem for one of my
project. In my project I only want to add support for USB & Wireless
(wil6210). To minimize the filesystem I disabled the unwanted things
like Iptables, VLAN, VPN, Ethernet support etc from .config and
brought my image size from 22 MB to 8.9 MB.

Now when I did the ifconfig wlan0 up I get below error:
wil6210 0000:01:00.0 wlan0: wil_open: Failed to register with NSS

In Ideal case when I enter the above command I should get below logs:
wil6210 0000:01:00.0 wlan0: wil_open: Registered with NSS

I checked the dependency for wil6210.ko module and they are cfg80211 &
compat and they both are enabled.

Can any one tell me which libraries/modules I have mistakenly disabled
which is causing this error.


-- 
Thanks & Regards,
Arjav Parikh
