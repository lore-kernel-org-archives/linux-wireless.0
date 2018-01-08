Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50594 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753381AbeAHRid (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:38:33 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: cancel pcie/sdio work in remove/shutdown handler
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1513164473-13827-1-git-send-email-huxm@marvell.com>
References: <1513164473-13827-1-git-send-email-huxm@marvell.com>
To: Xinming Hu <huxm@marvell.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Message-Id: <20180108173833.5B3046077A@smtp.codeaurora.org> (sfid-20180108_183839_415257_AC96A796)
Date: Mon,  8 Jan 2018 17:38:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> wrote:

> The last command used to shutdown firmware might be timeout,
> and trigger firmware dump in asynchronous pcie/sdio work.
> 
> The remove/shutdown handler will continue free core data
> structure private/adapter, which might be dereferenced in
> pcie/sdio work, finally crash the kernel.
> 
> Sync and Cancel pcie/sdio work, could be a fix for above
> cornel case. In this way, the last command timeout could
> be handled properly.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

b713bbf1471b mwifiex: cancel pcie/sdio work in remove/shutdown handler

-- 
https://patchwork.kernel.org/patch/10109773/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
