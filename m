Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39120 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752746AbcJMKXR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 06:23:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2] rtlwifi: Fix regression caused by commit d86e64768859
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161012185404.26441-1-Larry.Finger@lwfinger.net>
References: <20161012185404.26441-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Message-Id: <20161013102246.3B7BC6183F@smtp.codeaurora.org> (sfid-20161013_122322_074043_9EE4F6AC)
Date: Thu, 13 Oct 2016 10:22:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
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
> Cc: Stable <stable@vger.kernel.org> # 4.8
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>

Patch applied to wireless-drivers.git, thanks.

cf4747d7535a rtlwifi: Fix regression caused by commit d86e64768859

-- 
https://patchwork.kernel.org/patch/9373717/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
