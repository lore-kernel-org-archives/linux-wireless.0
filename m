Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54016 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933715AbeEIK01 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 06:26:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: increase TX threashold to avoid TX timeout during ED MAC
 test
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1525718458-5299-1-git-send-email-gbhat@marvell.com>
References: <1525718458-5299-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20180509102626.BA49160F94@smtp.codeaurora.org> (sfid-20180509_122630_827700_26D0EF28)
Date: Wed,  9 May 2018 10:26:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> While carrying energy detection(ED) tests, the chip will stop
> transmission upon detecting an energy in the connected channel.
> As a feedback, driver will stop dequeuing TX packets and due to
> which wmm_tx_pending keep incremeting. Once wmm_tx_pending
> reaches 100, driver calls netif_tx_stop_queue(). If TX ques is
> not restarted within 5(watchdog_timeo) seconds, it will result in
> TX timeout.
> 
> The ED test is carried out for one minute and the current
> threshold of 100 is easily overcome by the traffic, cuasing TX
> timeouts. To fix this increase the threshold to 400.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

4f9fb990013c mwifiex: increase TX threashold to avoid TX timeout during ED MAC test

-- 
https://patchwork.kernel.org/patch/10384615/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
