Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56394 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab2FNLmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 07:42:55 -0400
Received: by obbtb18 with SMTP id tb18so2304972obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 04:42:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMJBoFN48EZ0Bh6wSwtHz950PMS-bUR30aHq0v2hXg3spKbHFA@mail.gmail.com>
References: <CAMJBoFN48EZ0Bh6wSwtHz950PMS-bUR30aHq0v2hXg3spKbHFA@mail.gmail.com>
Date: Thu, 14 Jun 2012 14:42:55 +0300
Message-ID: <CAB3XZEfBzLBP48f930tcGbSZ=jqEkuNd9RDUJYEWQUDodczqeg@mail.gmail.com> (sfid-20120614_134259_005197_55D83BE5)
Subject: Re: bug in __ieee80211_suspend?
From: Eliad Peller <eliad@wizery.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Vitaly,

On Thu, Jun 14, 2012 at 1:48 PM, Vitaly Wool <vitalywool@gmail.com> wrote:
> I have some doubts about the following patch: "mac80211: quiesce vif
> before suspending". In fact, I think it introduces a hard-to-track
> bug: when a driver signals disconnection from the AP and the device
> goes to sleep shortly thereafter, beacon_connection_loss_work will get
> cancelled and the actual disconnection will never happen. Shouldn't we
> fix that or is there something I'm missing?
>

i think that flush_workqueue(local->workqueue) should handle the
normal disconnect-before-suspend case.
however, there's probably still some race condition when the work is
scheduled between the flush_workqueue() and the drv_suspend() call.
i'm not sure what is the right solution regarding it. maybe add
another flush_workqueue() after drv_suspend?

additionally, i don't think that the patch itself is the issue here,
as without it beacon_connection_loss_work might run after mac80211 was
already suspended, which might result in unexpected outcome as well...

Eliad.
