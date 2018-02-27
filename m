Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44894 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752107AbeB0Nwp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 08:52:45 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] bcma: Replace mdelay with usleep_range in
 bcma_pmu_resources_init
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1516984715-9237-1-git-send-email-baijiaju1990@gmail.com>
References: <1516984715-9237-1-git-send-email-baijiaju1990@gmail.com>
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: Larry.Finger@lwfinger.net, zajec5@gmail.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Message-Id: <20180227135244.E5FF1607EF@smtp.codeaurora.org> (sfid-20180227_145318_815741_3C6A1134)
Date: Tue, 27 Feb 2018 13:52:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> After checking all possible call chains to bcma_pmu_resources_init() here,
> my tool finds that this function is never called in atomic context,
> namely never in an interrupt handler or holding a spinlock.
> Thus mdelay can be replaced with usleep_range to avoid busy wait.
> 
> This is found by a static analysis tool named DCNS written by myself.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

8100091d0248 bcma: Replace mdelay with usleep_range in bcma_pmu_resources_init

-- 
https://patchwork.kernel.org/patch/10186561/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
