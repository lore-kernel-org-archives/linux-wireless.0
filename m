Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60623 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab2FNMJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 08:09:02 -0400
Received: by obbtb18 with SMTP id tb18so2333883obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 05:09:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEfBzLBP48f930tcGbSZ=jqEkuNd9RDUJYEWQUDodczqeg@mail.gmail.com>
References: <CAMJBoFN48EZ0Bh6wSwtHz950PMS-bUR30aHq0v2hXg3spKbHFA@mail.gmail.com>
	<CAB3XZEfBzLBP48f930tcGbSZ=jqEkuNd9RDUJYEWQUDodczqeg@mail.gmail.com>
Date: Thu, 14 Jun 2012 14:09:01 +0200
Message-ID: <CAMJBoFMHD8ukfOTonYOt+1wxC+hQbK=XAQMj+wiPev4ZKGV2ew@mail.gmail.com> (sfid-20120614_140913_663290_A0F76E87)
Subject: Re: bug in __ieee80211_suspend?
From: Vitaly Wool <vitalywool@gmail.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

On Thu, Jun 14, 2012 at 1:42 PM, Eliad Peller <eliad@wizery.com> wrote:
> hi Vitaly,
>
> On Thu, Jun 14, 2012 at 1:48 PM, Vitaly Wool <vitalywool@gmail.com> wrote:
>> I have some doubts about the following patch: "mac80211: quiesce vif
>> before suspending". In fact, I think it introduces a hard-to-track
>> bug: when a driver signals disconnection from the AP and the device
>> goes to sleep shortly thereafter, beacon_connection_loss_work will get
>> cancelled and the actual disconnection will never happen. Shouldn't we
>> fix that or is there something I'm missing?
>>
>
> i think that flush_workqueue(local->workqueue) should handle the
> normal disconnect-before-suspend case.
> however, there's probably still some race condition when the work is
> scheduled between the flush_workqueue() and the drv_suspend() call.
> i'm not sure what is the right solution regarding it. maybe add
> another flush_workqueue() after drv_suspend?

Maybe, but aren't we increasing the probability of hitting the 3s
suspend timeout and thus crashing the system here?

> additionally, i don't think that the patch itself is the issue here,
> as without it beacon_connection_loss_work might run after mac80211 was
> already suspended, which might result in unexpected outcome as well...

Well, the patch is the issue because previously the driver could just
stall the work and now it has no control over it.

I think there are two opportunities to look into:

1. Freeze workqueues on suspend without flushing
2. Reject suspend if an important work is pending (and yes, connection
loss work *is* important!)

Thanks,
   Vitaly
