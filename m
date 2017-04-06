Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:33969 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755730AbdDFEcc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 00:32:32 -0400
MIME-Version: 1.0
In-Reply-To: <20170331202136.100342-1-briannorris@chromium.org>
References: <20170331202136.100342-1-briannorris@chromium.org>
From: amit karwar <amitkarwar@gmail.com>
Date: Thu, 6 Apr 2017 10:02:31 +0530
Message-ID: <CAEhWJF==rVqrO3sWz2Sq-7kd=6=66rfJs7+9qu4dgeB3ONyYLg@mail.gmail.com> (sfid-20170406_063241_703359_CFCFEB8E)
Subject: Re: [RFC PATCH] Revert "mwifiex: fix system hang problem after resume"
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jeffy Chen <jeffy.chen@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 1, 2017 at 1:51 AM, Brian Norris <briannorris@chromium.org> wrote:
> This reverts commit 437322ea2a36d112e20aa7282c869bf924b3a836.
>
> This above-mentioned "fix" does not actually do anything to prevent a
> race condition. It simply papers over it so that the issue doesn't
> appear.
>
> If this is a real problem, it should be explained better than the above
> commit does, and an alternative, non-racy solution should be found.
>
> For further reason to revert this: there's ot reason we can't try
> resetting the card when it's *actually* stuck in host-sleep mode. So
> instead, this is unnecessarily creating scenarios where we can't recover
> Wifi.
>
> Cc: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> Amit, please take a look. AIUI, your "fix" is wrong, and quite racy. If you
> still think it's needed, can you please propose an alternative? Or at least
> explain more why this is needed? Thanks.
>

I agree. Fix just covers the issue. We need to investigate why system
hangs when card reset is attempted in host sleep activated scenario.

Acked-by: Amitkumar Karwar <amitkarwar@gmail.com>

Regards,
Amitkumar Karwar
