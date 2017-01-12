Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42382 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdALOye (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 09:54:34 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,1/5] mwifiex: don't wait for main_process in shutdown_drv
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
References: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20170112144527.4C56A605A8@smtp.codeaurora.org> (sfid-20170112_155530_716749_83CD9D3B)
Date: Thu, 12 Jan 2017 14:45:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> main_process is not expected to be running when shutdown_drv function
> is called. currently we wait for main_process completion in the
> function.
> 
> Actually the caller has already made sure main_process is completed by
> performing below actions.
> (1) disable interrupts in if_ops->disable_int.
> (2) set adapter->surprise_removed = true, main_process wont be queued.
> (3) mwifiex_terminate_workqueue(adapter), wait for workqueue to be
> completed.
> 
> This patch removes redundant wait code and takes care of related
> cleanup.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

5 patches applied to wireless-drivers-next.git, thanks.

5bf15e3fb85d mwifiex: don't wait for main_process in shutdown_drv
fb45bd0c6d6b mwifiex: do not free firmware dump memory in shutdown_drv
d27121fca129 mwifiex: get rid of drv_info* adapter variables
41efaf5824e7 mwifiex: wait firmware dump complete during card remove process
3860e5e39532 mwifiex: move pcie_work and related variables inside card

-- 
https://patchwork.kernel.org/patch/9431485/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
