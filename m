Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63169 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2FNOR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 10:17:59 -0400
Received: by gglu4 with SMTP id u4so1391694ggl.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 07:17:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMJBoFMHD8ukfOTonYOt+1wxC+hQbK=XAQMj+wiPev4ZKGV2ew@mail.gmail.com>
References: <CAMJBoFN48EZ0Bh6wSwtHz950PMS-bUR30aHq0v2hXg3spKbHFA@mail.gmail.com>
	<CAB3XZEfBzLBP48f930tcGbSZ=jqEkuNd9RDUJYEWQUDodczqeg@mail.gmail.com>
	<CAMJBoFMHD8ukfOTonYOt+1wxC+hQbK=XAQMj+wiPev4ZKGV2ew@mail.gmail.com>
Date: Thu, 14 Jun 2012 17:17:58 +0300
Message-ID: <CAB3XZEd1OYkpA4giY-gd6sCxCuP=jzLP7dcrwFC6qxhu-cNYbA@mail.gmail.com> (sfid-20120614_161802_882401_A47E9A9C)
Subject: Re: bug in __ieee80211_suspend?
From: Eliad Peller <eliad@wizery.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 14, 2012 at 3:09 PM, Vitaly Wool <vitalywool@gmail.com> wrote:
>>> I have some doubts about the following patch: "mac80211: quiesce vif
>>> before suspending". In fact, I think it introduces a hard-to-track
>>> bug: when a driver signals disconnection from the AP and the device
>>> goes to sleep shortly thereafter, beacon_connection_loss_work will get
>>> cancelled and the actual disconnection will never happen. Shouldn't we
>>> fix that or is there something I'm missing?
>>>
>>
>> i think that flush_workqueue(local->workqueue) should handle the
>> normal disconnect-before-suspend case.
>> however, there's probably still some race condition when the work is
>> scheduled between the flush_workqueue() and the drv_suspend() call.
>> i'm not sure what is the right solution regarding it. maybe add
>> another flush_workqueue() after drv_suspend?
>
> Maybe, but aren't we increasing the probability of hitting the 3s
> suspend timeout and thus crashing the system here?
>
flush_workqueue() will do it anyway (if the work was queued before),
so i don't think it's much different.

>> additionally, i don't think that the patch itself is the issue here,
>> as without it beacon_connection_loss_work might run after mac80211 was
>> already suspended, which might result in unexpected outcome as well...
>
> Well, the patch is the issue because previously the driver could just
> stall the work and now it has no control over it.
>
> I think there are two opportunities to look into:
>
> 1. Freeze workqueues on suspend without flushing
hmm... this might be a bit unexpected - userspace might want to use
wowlan only while connected. so postponing the disconnection after the
resume (while the ap is already gone) might be wrong.

> 2. Reject suspend if an important work is pending (and yes, connection
> loss work *is* important!)
>
i think this solution is easier and more correct.

Eliad.
