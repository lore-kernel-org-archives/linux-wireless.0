Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32795 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753524AbcICQI4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 12:08:56 -0400
Date: Sat, 3 Sep 2016 19:08:51 +0300
From: Giedrius =?utf-8?Q?Statkevi=C4=8Dius?=
        <giedrius.statkevicius@gmail.com>
To: kvalo@codeaurora.org
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath9k-devel@lists.ath9k.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] ath9k: bring back direction setting in ath9k_{start_stop}
Message-ID: <20160903160851.GA27396@tyrael> (sfid-20160903_180915_596509_BCA55532)
References: <20160901174702.8645-1-giedrius.statkevicius@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160901174702.8645-1-giedrius.statkevicius@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some more users complaining about this:
https://bbs.archlinux.org/viewtopic.php?id=215978

On Thu, Sep 01, 2016 at 08:47:02PM +0300, Giedrius Statkevičius wrote:
> A regression was introduced in commit id 79d4db1214a ("ath9k: cleanup
> led_pin initial") that broken the WLAN status led on my laptop with
> AR9287 after suspending and resuming.
> 
> Steps to reproduce:
> * Suspend (laptop)
> * Resume (laptop)
> * Observe that the WLAN led no longer turns ON/OFF depending on the
>   status and is always red
> 
> Even though for my case it only needs to be set to OUT in ath9k_start
> but for consistency bring back the IN direction setting as well.
> 
> Cc: Miaoqing Pan <miaoqing@codeaurora.org>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>
> ---
[...]
