Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34468 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935646AbdGTR2k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Jul 2017 13:28:40 -0400
Received: by mail-pf0-f176.google.com with SMTP id q85so14649556pfq.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jul 2017 10:28:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170720171636.GA55380@google.com>
References: <1500446187-8034-1-git-send-email-huxinming820@gmail.com>
 <20170719200933.GA126381@google.com> <2729342a9145434682181afd4bae1710@SC-EXCH02.marvell.com>
 <20170720171636.GA55380@google.com>
From: Dmitry Torokhov <dtor@google.com>
Date: Thu, 20 Jul 2017 10:28:38 -0700
Message-ID: <CAE_wzQ_Q47--atuME69f4eMDa5eMD3B_X5p3HiatY9K4iwoBXw@mail.gmail.com> (sfid-20170720_192843_961106_4B0E8F3E)
Subject: Re: Re: [PATCH] mwifiex: add tdls uapsd support module parameter
To: Brian Norris <briannorris@chromium.org>
Cc: Xinming Hu <huxm@marvell.com>, Xinming Hu <huxinming820@gmail.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 20, 2017 at 10:16 AM, Brian Norris <briannorris@chromium.org> w=
rote:
> Hi,
>
> On Thu, Jul 20, 2017 at 10:54:16AM +0000, Xinming Hu wrote:
>> Hi Brian,
>>
>> > -----Original Message-----
>> > From: Brian Norris [mailto:briannorris@chromium.org]
>> > Sent: 2017=E5=B9=B47=E6=9C=8820=E6=97=A5 4:10
>> > To: Xinming Hu
>> > Cc: Linux Wireless; Kalle Valo; Dmitry Torokhov; rajatja@google.com; Z=
hiyuan
>> > Yang; Tim Song; Cathy Luo; Xinming Hu
>> > Subject: [EXT] Re: [PATCH] mwifiex: add tdls uapsd support module para=
meter
>> >
>> > External Email
>> >
>> > ----------------------------------------------------------------------
>> > On Wed, Jul 19, 2017 at 06:36:27AM +0000, Xinming Hu wrote:
>> > > From: Xinming Hu <huxm@marvell.com>
>> > >
>> > > Add module parameter to control tdls uapsd support, which is default
>> > > disabled.
>> >
>> > Why default disabled, when it looks like it used to be on by default?
>>
>> Oho, I should comment more in description, it is now confusing.
>> We just fixed an tdls uapsd issue in latest firmware, so try to disable
>> this feature as a workaround to the old firmware. At the same time,
>> it is optional to enable this feature in specific case.
>
> That helps a bit, thanks.
>
>> I will add more comments in V2.
>> Please let us know if you have more comments.
>
> I won't insist on changes, but for something like this, it seems
> reasonable (if you have really fixed the issue in the latest firmware)
> to just provide the knob to disable as a backup, not as a default. If
> someone is going to update their kernel (to include this patch), but not
> update their firmware, then they probably should know enough to be able
> to provide the module parameter to disable.
>
> Or alternatively: how is anyone supposed to know whether their current
> firmware is broken or not? And how is this feature ever going to be
> default-enabled again? New chipsets with new firmware should hopefully
> not have the same bugs, no?

Better yet, the driver could check the firmware version, and if it is
known bad disable the feature automatically. Then there is no need to
provide this knob.

Thanks.

--=20
Dmitry
