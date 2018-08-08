Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:44191 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729721AbeHHVZM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 17:25:12 -0400
Received: by mail-oi0-f46.google.com with SMTP id s198-v6so5567925oih.11
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2018 12:04:10 -0700 (PDT)
Subject: Re: wireless dongle causing entire machine to hang
To: Randy Oostdyk <linux-kernel@oostdyk.com>,
        linux-wireless@vger.kernel.org
References: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d218d719-3f29-f16d-7656-272533df7ebf@lwfinger.net> (sfid-20180808_210413_057913_A08E3D55)
Date: Wed, 8 Aug 2018 14:04:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/2018 12:58 PM, Randy Oostdyk wrote:
> Good day all,
> 
> I'm writing to report an issue with the linux kernel, and I'm hoping
> this is the right place to report it. (short aside: I tried to ask in
> the #linux-wireless IRC channel, but wasn't permitted to speak!)
> 
> I'm aware that this is a USB protocol issue, and so this may be the
> wrong place to report the bug, but the warning seems to be generated
> by the wireless driver, and that appears to be the key issue here.
> 
> My USB wifi dongle is on the end of a very long USB cable, and was
> connected to a USB hub. On two different occasions (after hours or
> days of use), the machine it was attached to (Raspberry Pi 3) stopped
> responding. I was unable to SSH in, even over ethernet. After a hard
> reboot, I found that the following error was repeated **many thousands
> of times per second** in three different log files:
> 
> Rpi kernel: [857011.857581] ieee80211 phy1:
> rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed
> -71
> 
> As the machine continued in that state for hours, those log files had
> grown to several gigabytes in size each! (/var/log/syslog,
> /var/log/kern.log, and /var/log/messages)
> 
> It appears to be a very similar (if not same) bug referenced here:
> https://www.spinics.net/lists/linux-wireless/msg150555.html
> 
> He resolved the "soft lockup" issue with some changes to the driver
> (diff included in that thread), so I'm hoping this is the right place
> to bring this issue up.
> 
> Output of uname -a:
> Linux RCBLpi 4.14.52-v7+ #1123 SMP Wed Jun 27 17:35:49 BST 2018 armv7l GNU/Linux

My browsing shows that error 71 (EPROTO) is some kind of protocol error. Was the 
one you noted the first, or had others been logged? If that was the first, that 
infrequent an error will be hard to find.

I suspect some subtle USB timing issue. Is that very long cable within specs of 
5 meters for USB2 or 3 for USB3? Was the hub powered? If your setup permits, you 
might try with a shorter cable.

Larry
