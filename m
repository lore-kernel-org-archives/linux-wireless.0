Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727768AbeHINfP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 09:35:15 -0400
Date: Thu, 9 Aug 2018 13:10:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Randy Oostdyk <linux-kernel@oostdyk.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless dongle causing entire machine to hang
Message-ID: <20180809111049.GC1955@redhat.com> (sfid-20180809_131108_886760_C1CA47C4)
References: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 08, 2018 at 11:58:36AM -0600, Randy Oostdyk wrote:
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

We have this change that make device not presend when we get -EPROTO
error from USB driver.

commit 2ad69ac5976191e9bb7dc4044204a504653ad1bb
Author: Richard Genoud <richard.genoud@gmail.com>
Date:   Thu Apr 3 16:48:56 2014 +0200

    rt2x00: Endless loop on hub port power down 

However I reverted it in

commit dc50a52a36f459e0e3bed492d72a78bf64772c25
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Wed Nov 26 15:29:16 2014 +0100

    Revert "rt2x00: Endless loop on hub port power down"

Because it caused that if we get this error only one time,
it prevent devices to work, which worked otherwise.

rt2800usb driver expect thet we get -ENODEV or -ENOENT from
usb host driver when we can not talk to device anymore. On other usb
errors rt2800usb just try to work. I think this should be fixed in
usb host driver to return proper error code.

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

I'm reluctant to replace _warn by _dbg messages as if somethings
will go wrong we will not notice that. We can use printk_ratelimited()
variant instead to do not spam log in speed that it will hung
the machine. But the correct fix should be in USB host drivers,
which seems to be not in perfect shape on those embedded platforms.

Regards
Stanislaw
