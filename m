Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965138AbdEVQub (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 12:50:31 -0400
MIME-Version: 1.0
In-Reply-To: <20170522162114.w4pw25pcecsm6lhi@earth>
References: <20170505141553.2605-1-sebastian.reichel@collabora.co.uk>
 <8737bx5jgr.fsf@purkki.adurom.net> <20170522.103010.1779800840743690143.davem@davemloft.net>
 <87wp99t0hj.fsf@kamboji.qca.qualcomm.com> <20170522152112.634mnsv65lryrmkp@earth>
 <CAL_JsqL91sruKNaWmVEqT+L_OCh5xFkkGY07mBBUmqkKHc5fQw@mail.gmail.com> <20170522162114.w4pw25pcecsm6lhi@earth>
From: Rob Herring <robh+dt@kernel.org>
Date: Mon, 22 May 2017 11:50:04 -0500
Message-ID: <CAL_JsqLJ1F-2So4fSeVwR7RsUZZwMLv7HcnzHdKrOUGCU2F8+w@mail.gmail.com> (sfid-20170522_185258_905724_4991E1FF)
Subject: Re: [PATCHv4] wlcore: add wl1285 compatible
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 22, 2017 at 11:21 AM, Sebastian Reichel
<sebastian.reichel@collabora.co.uk> wrote:
> Hi,
>
> On Mon, May 22, 2017 at 11:11:49AM -0500, Rob Herring wrote:
>> On Mon, May 22, 2017 at 10:21 AM, Sebastian Reichel
>> <sebastian.reichel@collabora.co.uk> wrote:
>> > Hi,
>> >
>> > On Mon, May 22, 2017 at 05:44:24PM +0300, Kalle Valo wrote:
>> >> David Miller <davem@davemloft.net> writes:
>> >> > From: Kalle Valo <kvalo@codeaurora.org>
>> >> > Date: Mon, 22 May 2017 12:28:20 +0300
>> >> >
>> >> >> Sebastian Reichel <sebastian.reichel@collabora.co.uk> writes:
>> >> >>
>> >> >>> Motorola Droid 4 uses a WL1285C. With differences between the
>> >> >>> chips not being public let's add explicit binding for wl1285
>> >> >>> instead of relying on wl1283 being very similar.
>> >> >>>
>> >> >>> Reviewed-by: Rob Herring <robh@kernel.org>
>> >> >>> Acked-by: Kalle Valo <kvalo@codeaurora.org>
>> >> >>> Acked-by: Tony Lindgren <tony@atomide.com>
>> >> >>> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
>> >> >>> ---
>> >> >>> Hi Dave,
>> >> >>>
>> >> >>> I previously send this in two patches, but its hard to apply without
>> >> >>> requiring multiple kernel releases (the driver must be updated before
>> >> >>> the DTS change). Since the actual change is not very complex Marcel
>> >> >>> Holtmann & Tony Lindgren suggested, that I send this directly to you
>> >> >>> in a single patch for inclusion into 4.12. This also means, that the
>> >> >>> remaining series can be queued normally for 4.13.
>> >> >>
>> >> >> I noticed that Dave set this patch to Awaiting Upstream state on his
>> >> >> patchwork:
>> >> >>
>> >> >> https://patchwork.ozlabs.org/patch/759042/
>> >> >>
>> >> >> Which makes me suspect that he is waiting me to apply this (as I
>> >> >> normally apply wlcore patches). Dave, should I actually take this patch?
>> >> >> What do you prefer?
>> >> >
>> >> > Anything that touches wireless drivers I defer to you, yes.
>> >>
>> >> Thanks, I'll take it then. Not sure why Sebastian was suggested to
>> >> submit this patch via your tree in the first place.
>> >>
>> >> https://patchwork.kernel.org/patch/9713645/
>> >
>> > Thanks. The idea was to get into early 4.12-rc to avoid merge
>> > conflicts in the droid 4 *.dts during 4.13 cycle. This strategy
>> > obviously failed :)
>>
>> First, I'm not sure why you combined everything. A maintainer can just
>> as easily take a series as a single patch and we prefer binding doc,
>> dts and driver changes all separate.
>>
>> Second, the dts changes could go thru arm-soc and the driver change
>> thru netdev. The binding doc can be thru either. There's no bisecting
>> dependency and things shouldn't break. It just won't all work until
>> you have both branches.
>
> This is only true for new devices. WLAN for droid4 works at the
> moment using incorrect compatible string. If *.dts is updated and
> driver is not yet updated WLAN does not work. IMHO that is a
> bisecting dependency.

True. That's also breaking compatibility if a new kernel doesn't work
with an old DT. Is it just a compatible string change? If so, then
just keep the old string as a fallback.

Rob
