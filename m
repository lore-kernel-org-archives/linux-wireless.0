Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:38541 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdLBBpK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 20:45:10 -0500
Received: by mail-io0-f193.google.com with SMTP id d14so13198043ioc.5
        for <linux-wireless@vger.kernel.org>; Fri, 01 Dec 2017 17:45:10 -0800 (PST)
Date: Fri, 1 Dec 2017 17:45:06 -0800
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxm@marvell.com>
Cc: Xinming Hu <huxinming820@gmail.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        James Cao <jcao@marvell.com>
Subject: Re: Re: Re: [PATCH 3/3] mwifiex: debugfs: trigger device dump for
 usb interface
Message-ID: <20171202014505.GA85160@google.com> (sfid-20171202_024514_799498_7E9529CF)
References: <ff513aca34c94c6cab0b4ff0408c7922@SC-EXCH02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ff513aca34c94c6cab0b4ff0408c7922@SC-EXCH02.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 01, 2017 at 08:36:01AM +0000, Xinming Hu wrote:
> Thanks for the suggestion, it sounds better than exporting
> mwifiex_send_cmd() directly.
> In addition to used as debugfs tirgger, the "defined point"
> if_ops.device_dump is only used in command timeout context.
> For sdio/pcie interface, register operation will be made to trigger
> firmware dump and get dump context under specific algorithm.
> For usb interface, however,  this is not needed, since firmware will
> automatically send dump event to host without any trigger, and what's
> more , host is also not able to issue command in the situation.
> 
> So per my understand,  here we only need provide a simple way to
> trigger , instead of a totally functional complete dump entry point.
> Suppose if we make the command trigger a part of if_ops->device_dump,
> then we also need add check for "MWIFIEX_USB" in mwifiex_cmd_tmo_func. 

Ah, I see. Your explanation makes some more sense then. It would be nice
if you could include some of this in
(a) the commit message
(b) the entry point in debugfs.c, where you trigger this

Something along the lines of "For command timeouts, USB firmware will
automatically emit firmware dump events, so we don't implement
device_dump(). For user-initiated dumps, we trigger it ourselves."

> it also looks inelegant, and what we did looks weird, they are
> (1) export a new  kernel symbol,  the wrapper of mwifiex_send_command
> (2) add usb if_ops->device_dump, it  send the command in mwifiex_usb, instead of in mwifiex itself.
> (3) bypass above "if_ops->device_dump" in mwifiex_cmd_tmo_func, which is the mainly user case.

No, I'm not sure that solution would be much better. Your existing
solution with additional comments is probably fine.

> I am not sure whether there is a better way on this, perhaps we need a
> trade-off on different solutions, please let us know if you have more
> suggestions.
> 
> Thanks & Regards,
> SImon

Brian
