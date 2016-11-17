Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54628 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932110AbcKQL20 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 06:28:26 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: fix corner case power save issue
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1477062948-8558-1-git-send-email-akarwar@marvell.com>
References: <1477062948-8558-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161117112825.D8F186164F@smtp.codeaurora.org> (sfid-20161117_122830_486643_A3F34F31)
Date: Thu, 17 Nov 2016 11:28:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> We may get SLEEP event from firmware even if TXDone for last Tx packet
> is still pending. In this case, we may end up accessing PCIe memory for
> handling TXDone after power save handshake is completed. This causes
> kernel crash with external abort.
> 
> We will delay sending SLEEP confirm to firmware in
> this case to resolve the problem.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Tested-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Dropped per request from Amitkumar.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9389485/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
