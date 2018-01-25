Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:45245 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbeAYUUW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 15:20:22 -0500
Received: by mail-wm0-f43.google.com with SMTP id i186so16925560wmi.4
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jan 2018 12:20:22 -0800 (PST)
Subject: Re: [PATCH v2] mac80211_hwsim: don't use WQ_MEM_RECLAIM
To: Johannes Berg <johannes@sipsolutions.net>
References: <20180124074051.19939-1-johannes@sipsolutions.net>
 <7eb10bf1-7825-3dae-b813-d912e6670440@uni-rostock.de>
 <1516790786.2508.43.camel@sipsolutions.net>
 <CAF7Mx6oASGjDrzVq4_t8Wt-DU7Zap1tcpz5vU7bk-Q5qzg4V=g@mail.gmail.com>
 <CAF7Mx6o_Y0AeGQfhGKMkSxUHtRNyGaHh3g-TyvusJmsYyckFZg@mail.gmail.com>
 <CAF7Mx6rg2XOOG0mZxnKiM_1ToB36Yc2A=sKQfN7drLsr3+4crw@mail.gmail.com>
Cc: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A6A3BFC.5090305@broadcom.com> (sfid-20180125_212026_793379_39F4F963)
Date: Thu, 25 Jan 2018 21:20:12 +0100
MIME-Version: 1.0
In-Reply-To: <CAF7Mx6rg2XOOG0mZxnKiM_1ToB36Yc2A=sKQfN7drLsr3+4crw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

resending as it included html and got blocked from the list.

On 1/25/2018 7:21 PM, Arend Van Spriel wrote:
> Op 24 jan. 2018 11:46 schreef "Johannes Berg" <johannes@sipsolutions.net
> <mailto:johannes@sipsolutions.net>>:
>  >
>  > On Wed, 2018-01-24 at 10:39 +0100, Benjamin Beichler wrote:
>  >
>  > > sorry for introducing that error, but I'm a bit confused by the
>  > > workqueue documentation.
>  > > My assumption was, that deleting hwsim radios is reclaiming memory, and
>  > > since this queue does nothing else it would save/necessary to set
> this flag.
>  > >
>  > > Maybe a hint in the documentation, that a work item on a WQ_MEM_RECLAIM
>  > > queue must not call flush of an !WQ_MEM_RECLAIM queue would be nice.
>  > > Maybe it's kind of obvious, but there is also a reminder not to forget
>  > > that flag, if a queue may have work items that reclaim memory
>  >
>  > Yeah, honestly, I'm not really sure either. Clearly we can't set it,
>  > but other drivers also set it...
>
> That triggered something in my memory. So indeed we use it in brcmfmac
> as well. We used create_singlethread_workqueue(), but I wanted to avoid
> snprintf and specify the name format so switched to using
> alloc_ordered_workqueue() keeping WQ_MEM_RECLAIM as per the macro
> definition.

#define create_singlethread_workqueue(name)				\
	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)

> Don't recall why I dropped the __WQ_LEGACY flag though.
>
> Regards,
> Arend
>
>  > I don't think it was *intended* for when you're freeing memory, since I
>  > think reclaiming is what happens when you write out dirty buffers to
>  > disk etc.
>  >
>  > johannes
>
