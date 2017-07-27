Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41184 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbdG0JgY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 05:36:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: correct channel stat buffer overflows
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170630012354.98931-1-briannorris@chromium.org>
References: <20170630012354.98931-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Avinash Patil <patila@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Message-Id: <20170727093624.061F96095E@smtp.codeaurora.org> (sfid-20170727_113644_732496_56CF68D8)
Date: Thu, 27 Jul 2017 09:36:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:

> mwifiex records information about various channels as it receives scan
> information. It does this by appending to a buffer that was sized
> to the max number of supported channels on any band, but there are
> numerous problems:
> 
> (a) scans can return info from more than one band (e.g., both 2.4 and 5
>     GHz), so the determined "max" is not large enough
> (b) some firmware appears to return multiple results for a given
>     channel, so the max *really* isn't large enough
> (c) there is no bounds checking when stashing these stats, so problems
>     (a) and (b) can easily lead to buffer overflows
> 
> Let's patch this by setting a slightly-more-correct max (that accounts
> for a combination of both 2.4G and 5G bands) and adding a bounds check
> when writing to our statistics buffer.
> 
> Due to problem (b), we still might not properly report all known survey
> information (e.g., with "iw <dev> survey dump"), since duplicate results
> (or otherwise "larger than expected" results) will cause some
> truncation. But that's a problem for a future bugfix.
> 
> (And because of this known deficiency, only log the excess at the WARN
> level, since that isn't visible by default in this driver and would
> otherwise be a bit too noisy.)
> 
> Fixes: bf35443314ac ("mwifiex: channel statistics support for mwifiex")
> Cc: <stable@vger.kernel.org>
> Cc: Avinash Patil <patila@marvell.com>
> Cc: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Reviewed-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

4b5dde2d6234 mwifiex: correct channel stat buffer overflows

-- 
https://patchwork.kernel.org/patch/9818269/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
