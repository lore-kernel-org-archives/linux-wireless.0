Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:33936 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964786AbdGTRQm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Jul 2017 13:16:42 -0400
Received: by mail-pg0-f44.google.com with SMTP id 123so17498730pgj.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jul 2017 10:16:42 -0700 (PDT)
Date: Thu, 20 Jul 2017 10:16:38 -0700
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxm@marvell.com>
Cc: Xinming Hu <huxinming820@gmail.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>
Subject: Re: Re: [PATCH] mwifiex: add tdls uapsd support module parameter
Message-ID: <20170720171636.GA55380@google.com> (sfid-20170720_191646_381696_59AFA850)
References: <1500446187-8034-1-git-send-email-huxinming820@gmail.com>
 <20170719200933.GA126381@google.com>
 <2729342a9145434682181afd4bae1710@SC-EXCH02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <2729342a9145434682181afd4bae1710@SC-EXCH02.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Jul 20, 2017 at 10:54:16AM +0000, Xinming Hu wrote:
> Hi Brian,
> 
> > -----Original Message-----
> > From: Brian Norris [mailto:briannorris@chromium.org]
> > Sent: 2017年7月20日 4:10
> > To: Xinming Hu
> > Cc: Linux Wireless; Kalle Valo; Dmitry Torokhov; rajatja@google.com; Zhiyuan
> > Yang; Tim Song; Cathy Luo; Xinming Hu
> > Subject: [EXT] Re: [PATCH] mwifiex: add tdls uapsd support module parameter
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > On Wed, Jul 19, 2017 at 06:36:27AM +0000, Xinming Hu wrote:
> > > From: Xinming Hu <huxm@marvell.com>
> > >
> > > Add module parameter to control tdls uapsd support, which is default
> > > disabled.
> > 
> > Why default disabled, when it looks like it used to be on by default?
> 
> Oho, I should comment more in description, it is now confusing.
> We just fixed an tdls uapsd issue in latest firmware, so try to disable
> this feature as a workaround to the old firmware. At the same time, 
> it is optional to enable this feature in specific case.

That helps a bit, thanks.

> I will add more comments in V2.
> Please let us know if you have more comments.

I won't insist on changes, but for something like this, it seems
reasonable (if you have really fixed the issue in the latest firmware)
to just provide the knob to disable as a backup, not as a default. If
someone is going to update their kernel (to include this patch), but not
update their firmware, then they probably should know enough to be able
to provide the module parameter to disable.

Or alternatively: how is anyone supposed to know whether their current
firmware is broken or not? And how is this feature ever going to be
default-enabled again? New chipsets with new firmware should hopefully
not have the same bugs, no?

Brian
