Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37883 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754120AbcJLIBk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 04:01:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        "Stable \[ 4 . 8+ \]" <stable@vger.kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [PATCH] rtlwifi: Fix regression caused by commit d86e64768859
References: <20161010233211.13519-1-Larry.Finger@lwfinger.net>
Date: Wed, 12 Oct 2016 10:53:01 +0300
In-Reply-To: <20161010233211.13519-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Mon, 10 Oct 2016 18:32:11 -0500")
Message-ID: <87r37mf1gi.fsf@kamboji.qca.qualcomm.com> (sfid-20161012_100142_392375_28D88F6C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> In commit d86e64768859 ("rtlwifi: rtl818x: constify local structures"),
> the configuration struct for most of the drivers was changed to be
> constant. The problem is that five of the modified drivers need to be
> able to update the firmware name based on the exact model of the card.
> As the file names were stored in one of the members of that struct,
> these drivers would fail with a kernel BUG splat when they tried to
> update the firmware name.
>
> Rather than reverting the previous commit, I used a suggestion by
> Johannes Berg and made the firmware file name pointers be local to
> the routines that update the software variables.
>
> The configuration struct of rtl8192cu, which was not touched in the
> previous patch, is now constantfied.
>
> Fixes: d86e64768859 ("rtlwifi: rtl818x: constify local structures")
> Suggested-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable [4.8+] <stable@vger.kernel.org>

This should be:

Cc: Stable <stable@vger.kernel.org> # 4.8

And the plus sign isn't needed as I'll push this to 4.9.

> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> ---
> Kalle,
>
> My apologies for letting these bugs to get by my review and testing.

No worries, this is business as usual :) Excellent that you noticed this
so early.

And this again shows that simple cleanup patches are not without cost,
there is a clear risk. Has anyone done any statistics how much cleanup
patches cause regressions? My guess is that in a 5% ballpark of the
cleanup patches have some sort of issues. Of course in this case the
cleanup patch revealed a design flaw in the driver, so in this case it
was very useful.

> As they affect kernel 4.8, please push this patch as soon as possible.
> To reiterate, this patch replaces the one entitled 'Revert "rtlwifi:
> rtl818x: constify local structures"'

Ok, understood. Many thanks for making this super clear for me, makes my
life a lot easier. I'm hoping that this will make it to 4.9-rc2.

CCing Thorsten to get this regression to his radar.

-- 
Kalle Valo
