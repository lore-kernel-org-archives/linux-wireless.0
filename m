Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43714 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752620AbdKGIx3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Nov 2017 03:53:29 -0500
Date: Tue, 7 Nov 2017 09:53:28 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Soft lockup in rt2x00usb_work_rxdone()
Message-ID: <20171107085327.GA11380@redhat.com> (sfid-20171107_095346_610378_6464B82D)
References: <1509983829.10974.2.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1509983829.10974.2.camel@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Nov 06, 2017 at 04:57:09PM +0100, Richard Genoud wrote:
> I get a soft lock-up while unbinding the USB driver on a TP-Link TL-WN727Nv3 (chipset 5370):
> 
> # echo 1-2.2 > /sys/bus/usb/drivers/usb/unbind
> watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u2:3:308]
...
> I can trigger this each time.

I can not reproduce this on my system (I'm using 4.14.0-rc6, but I don't
think it's an issue). I think the problem may be caused by usb
host controler driver, which can be different on your system.

Does ftrace work on your platform ? If so could you use ftrace
to provide rt2x00 functions trace when the  probllem happen ? 

3 short articles how to configure and use ftrace are here:
https://lwn.net/Articles/365835/
https://lwn.net/Articles/366796/
https://lwn.net/Articles/370423/

Thanks
Stanislaw
