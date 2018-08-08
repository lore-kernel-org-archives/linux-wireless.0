Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f46.google.com ([209.85.161.46]:45707 "EHLO
        mail-yw1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727748AbeHHUTZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 16:19:25 -0400
Received: by mail-yw1-f46.google.com with SMTP id 139-v6so2185491ywg.12
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2018 10:58:38 -0700 (PDT)
MIME-Version: 1.0
From: Randy Oostdyk <linux-kernel@oostdyk.com>
Date: Wed, 8 Aug 2018 11:58:36 -0600
Message-ID: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com> (sfid-20180808_195840_821604_0CECD7B6)
Subject: wireless dongle causing entire machine to hang
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good day all,

I'm writing to report an issue with the linux kernel, and I'm hoping
this is the right place to report it. (short aside: I tried to ask in
the #linux-wireless IRC channel, but wasn't permitted to speak!)

I'm aware that this is a USB protocol issue, and so this may be the
wrong place to report the bug, but the warning seems to be generated
by the wireless driver, and that appears to be the key issue here.

My USB wifi dongle is on the end of a very long USB cable, and was
connected to a USB hub. On two different occasions (after hours or
days of use), the machine it was attached to (Raspberry Pi 3) stopped
responding. I was unable to SSH in, even over ethernet. After a hard
reboot, I found that the following error was repeated **many thousands
of times per second** in three different log files:

Rpi kernel: [857011.857581] ieee80211 phy1:
rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
-71

As the machine continued in that state for hours, those log files had
grown to several gigabytes in size each! (/var/log/syslog,
/var/log/kern.log, and /var/log/messages)

It appears to be a very similar (if not same) bug referenced here:
https://www.spinics.net/lists/linux-wireless/msg150555.html

He resolved the "soft lockup" issue with some changes to the driver
(diff included in that thread), so I'm hoping this is the right place
to bring this issue up.

Output of uname -a:
Linux RCBLpi 4.14.52-v7+ #1123 SMP Wed Jun 27 17:35:49 BST 2018 armv7l GNU/Linux

If any further details are needed, feel free to email me directly, as
I haven't subscribed to this list.
