Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40066 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752100AbdAROiE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 09:38:04 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/5] ath10k: Remove unused 'buf_len' variable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <196e46eee00fd3ebb56da1373c36f3dff66f2ae1.1479974100.git.kirtika@chromium.org>
References: <196e46eee00fd3ebb56da1373c36f3dff66f2ae1.1479974100.git.kirtika@chromium.org>
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Raja Mani <rmani@qti.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>
Message-Id: <20170118143724.7A5FA6080C@smtp.codeaurora.org> (sfid-20170118_153848_669462_EA9CA9D7)
Date: Wed, 18 Jan 2017 14:37:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kirtika Ruchandani <kirtika.ruchandani@gmail.com> wrote:
> Commit 32653cf19554 removed the call to 'skb_trim(skb, buf_len)'
> in ath10k_wmi_event_mgmt_rx(), leaving the buf_len variable set but
> unused. Compiling with W=1 gives the following warning, fix it.
> drivers/net/wireless/ath/ath10k/wmi.c: In function ‘ath10k_wmi_event_mgmt_rx’:
> drivers/net/wireless/ath/ath10k/wmi.c:2280:6: warning: variable ‘buf_len’ set but not used [-Wunused-but-set-variable]
> 
> This is a harmless warning, and is only being fixed to reduce the
> noise with W=1 in the kernel.
> 
> Fixes: 32653cf19554 ("ath10k: implement intermediate event args")
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Kirtika Ruchandani <kirtika@chromium.org>

These patches seem to be corrupted:

Applying: ath10k: Remove unused 'buf_len' variable
fatal: corrupt patch at line 13
error: could not build fake ancestor
Patch failed at 0001 ath10k: Remove unused 'buf_len' variable

When resending please also cc ath10k list:

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/sources#submitting_patches

4 patches set to Changes Requested.

9444973 [1/5] ath10k: Remove unused 'buf_len' variable
9444935 [2/5] ath10k: Remove unused 'num_vdev_stats' variable
9444971 [4/5] ath10k: Removed unused 'dev' in ath10k_ahb_clock_enable()
9444975 [5/5] ath10k: Removed unused 'dev' in ath10k_ahb_resource_init

-- 
https://patchwork.kernel.org/patch/9444973/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
