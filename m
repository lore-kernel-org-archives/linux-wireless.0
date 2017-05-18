Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55280 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752968AbdERNkK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 09:40:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,1/2] mwifiex: initiate card-specific work atomically
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170501193700.89264-1-briannorris@chromium.org>
References: <20170501193700.89264-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20170518134009.8E38F60F5F@smtp.codeaurora.org> (sfid-20170518_154042_675953_22893D8B)
Date: Thu, 18 May 2017 13:40:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> The non-atomic test + set is a little awkward here, and it technically
> means we might double-schedule work unnecessarily. AFAICT, this is not
> really a problem, since the extra "work" will be a no-op (the flag(s)
> will be cleared by then), but it's still an anti-pattern.
> 
> Rewrite this to use the atomic test_and_set_bit() helper instead.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

2 patches applied to wireless-drivers-next.git, thanks.

21f569af9ab3 mwifiex: initiate card-specific work atomically
6d7d579a8243 mwifiex: pcie: add card_reset() support

-- 
https://patchwork.kernel.org/patch/9706851/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
