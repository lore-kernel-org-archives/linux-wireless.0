Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52990 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754320AbeDTKBS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 06:01:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: remove variables which set but not used
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180318075014.GA26784@blackstone>
References: <20180318075014.GA26784@blackstone>
To: Kenneth Lu <kuohsianglu@gmail.com>
Cc: kvalo@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Message-Id: <20180420100118.368D360FEF@smtp.codeaurora.org> (sfid-20180420_120122_615750_2815A5F0)
Date: Fri, 20 Apr 2018 10:01:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kenneth Lu <kuohsianglu@gmail.com> wrote:

> Variable buf_len and num_vdev_stats are bging assigned but never read.
> These are redundant and can be remove.
> 
> Signed-off-by: Kenneth Lu <kuohsianglu@gmail.com>

Fails to compile:

drivers/net/wireless/ath/ath10k/wmi.c: In function 'ath10k_wmi_10_4_op_pull_fw_stats':
drivers/net/wireless/ath/ath10k/wmi.c:3067:18: error: 'num_vdev_stats' undeclared (first use in this function); did you mean 'num_pdev_stats'?
  for (i = 0; i < num_vdev_stats; i++) {
                  ^~~~~~~~~~~~~~
                  num_pdev_stats
drivers/net/wireless/ath/ath10k/wmi.c:3067:18: note: each undeclared identifier is reported only once for each function it appears in
make[5]: *** [drivers/net/wireless/ath/ath10k/wmi.o] Error 1
make[4]: *** [drivers/net/wireless/ath/ath10k] Error 2
make[3]: *** [drivers/net/wireless/ath] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10291063/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
