Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:41319 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaCFU7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 15:59:54 -0500
Received: by mail-qa0-f43.google.com with SMTP id j15so3155035qaq.30
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 12:59:53 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 7 Mar 2014 00:59:53 +0400
Message-ID: <CAEfLLqQ4C0ks+G-hKwOc9ioy2XUuExjScfMcBPCHniSTXXJ+Gg@mail.gmail.com> (sfid-20140306_215958_199343_77A83169)
Subject: Intel Wireless-N 7260 5GHz band degradation on 3.13
From: Ivan Afonichev <ivan.afonichev@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I have Lenovo Ideapad Yoga 2 pro with Intel Wireless-N 7260.
On kernel versions <=3.12.10 it works well on both 2.4GHz and 5GHz.

[root@localhost ~]# uname -a
Linux localhost 3.12.10-300.fc20.x86_64 #1 SMP Thu Feb 6 22:11:48 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux
[root@localhost ~]# iwconfig
wlp1s0 IEEE 802.11abgn ESSID:"GD-wifi-5"
Mode:Managed Frequency:5.18 GHz Access Point: 38:EA:A7:80:E8:24
Bit Rate=78 Mb/s Tx-Power=16 dBm
Retry long limit:7 RTS thr:off Fragment thr:off
Encryption key:off
Power Management:on
Link Quality=44/70 Signal level=-66 dBm
Rx invalid nwid:0 Rx invalid crypt:0 Rx invalid frag:0
Tx excessive retries:8 Invalid misc:17 Missed beacon:0

But on 3.13.5 such behavior was considered as bug and 5GHz band was disabled.
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/net/wireless/iwlwifi?id=c512865446e6dd5b6e91e81187e75b734ad7cfc7

For me it seems to be some sort of "marketing bullshit". If device is
able to work on 5GHz band why it should be disabled on vanilla kernel
without option to enable it?
