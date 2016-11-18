Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60168 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752320AbcKRLZW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 06:25:22 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: don't do unbalanced free()'ing in cleanup_if()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1477524560-49226-1-git-send-email-briannorris@chromium.org>
References: <1477524560-49226-1-git-send-email-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Cathy Luo <cluo@marvell.com>, Rajat Jain <rajatja@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20161118112521.4F5316265F@smtp.codeaurora.org> (sfid-20161118_122541_548110_892DA256)
Date: Fri, 18 Nov 2016 11:25:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> The cleanup_if() callback is the inverse of init_if(). We allocate our
> 'card' interface structure in the probe() function, but we free it in
> cleanup_if(). That gives a few problems:
> (a) we leak this memory if probe() fails before we reach init_if()
> (b) we can't safely utilize 'card' after cleanup_if() -- namely, in
>     remove() or suspend(), both of which might race with the cleanup
>     paths in our asynchronous FW initialization path
> 
> Solution: just use devm_kzalloc(), which will free this structure
> properly when the device is removed -- and drop the set_drvdata(...,
> NULL), since the driver core does this for us. This also removes the
> temptation to use drvdata == NULL as a hack for checking if the device
> has been "cleaned up."
> 
> I *do* leave the set_drvdata(..., NULL) for the hacky SDIO
> mwifiex_recreate_adapter(), since the device core won't be able to clear
> that one for us.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

66b9c182538e mwifiex: don't do unbalanced free()'ing in cleanup_if()

-- 
https://patchwork.kernel.org/patch/9398689/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
