Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52328 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754721AbdLGN0D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:26:03 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rsi: fix memory leak on buf and usb_reg_buf
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171116173918.3030-1-colin.king@canonical.com>
References: <20171116173918.3030-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20171207132603.1A9C260240@smtp.codeaurora.org> (sfid-20171207_142633_846304_448033E2)
Date: Thu,  7 Dec 2017 13:26:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> In the cases where len is too long, the error return path fails to
> kfree allocated buffers buf and usb_reg_buf.  The simplest fix is to
> perform the sanity check on len before the allocations to avoid having
> to do the kfree'ing in the first place.
> 
> Detected by CoverityScan, CID#1452258,1452259 ("Resource Leak")
> 
> Fixes: 59f73e2ae185 ("rsi: check length before USB read/write register")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

c4ee30a280b1 wlcore, wl1251: fix spelling: "Couldnt" -> "Couldn't" and remove error on -ENOMEM

-- 
https://patchwork.kernel.org/patch/10061619/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
