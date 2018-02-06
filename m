Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:39303 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbeBFUFK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Feb 2018 15:05:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAGbDTvrA85Qao_y0FxCFR_cE26WejoLLrA=PA1qhTButiDp3xg@mail.gmail.com>
References: <CAGbDTvrA85Qao_y0FxCFR_cE26WejoLLrA=PA1qhTButiDp3xg@mail.gmail.com>
From: Iago Abal <iago.abal@gmail.com>
Date: Tue, 6 Feb 2018 21:04:29 +0100
Message-ID: <CAGbDTvrfrm5kuWL3SqeDGxyBXYbCyAV0ukah-CNsGqW0ueia3w@mail.gmail.com> (sfid-20180206_210521_053013_2E25FA40)
Subject: Re: Potential deadlock BUG in drivers/net/wireless/st/cw1200/sta.c
 (Linux 4.9)
To: Johannes Berg <johannes.berg@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This still looks like a deadlock bug to me, could someone take a look
as well and confirm? I will help preparing a patch if needed.

Thanks,

-- iago


On Fri, Nov 18, 2016 at 10:58 PM, Iago Abal <iago.abal@gmail.com> wrote:
> Hi,
>
> With the help of a static bug finder (EBA -
> https://github.com/models-team/eba) I have found a potential deadlock
> in drivers/net/wireless/st/cw1200/
> sta.c. This happens due to a recursive mutex_lock on `priv->conf_mutex'.
>
> If this is indeed a bug, I will be happy to help with a patch.
>
> A quick (not elegant) fix could be to unlock before the call to
> `cw1200_do_unjoin' in line 1174, and lock again afterwards. It seems
> that `cw1200_join_complete' is always called with `priv->conf_mutex'
> held. Another option could be to add a Boolean parameter to
> `cw1200_do_unjoin' to choose whether this function should take the
> lock itself. Yet another option would be to have a
> `__cw1200_do_unjoin' that does not lock, and make `cw1200_do_unjoin' a
> wrapper over this that adds the locking; `cw1200_join_complete' would
> call `__cw1200_do_unjoin' instead.
>
> Someone who is actually familiar with this code may have a better
> proposal though.
>
> The trace is as follows:
>
> 1. Function `cw1200_join_complete_work' takes the first lock in line 1189:
>
>     // see https://github.com/torvalds/linux/blob/v4.9-rc5/drivers/net/wireless/st/cw1200/sta.c#L1189
>     mutex_lock(& priv->conf_mutex);
>
> 2. and subsequently calls `cw1200_join_complete';
> 3. which calls `cw1200_do_unjoin' in line 1174;
> 4. and this latter function takes the lock for the second time in line 1387:
>
>     // see https://github.com/torvalds/linux/blob/v4.9-rc5/drivers/net/wireless/st/cw1200/sta.c#L1387
>     mutex_lock(& priv->conf_mutex);
>
> Hope it helps!
>
> --
> iago
