Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753634AbdLGNUs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:20:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wlcore: use boottime for fw time sync
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171127114903.2779545-1-arnd@arndb.de>
References: <20171127114903.2779545-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Iain Hunter <drhunter95@gmail.com>,
        "Reizer, Eyal" <eyalr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20171207132047.9770D6086A@smtp.codeaurora.org> (sfid-20171207_142135_416492_BD3DC95F)
Date: Thu,  7 Dec 2017 13:20:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> Using getnstimeofday()/timespec_to_ns() causes an overflow on 32-bit
> architectures in 2038, and may suffer from time jumps due to
> settimeofday() or leap seconds.
> 
> I don't see a reason why this needs to be UTC, so either monotonic
> or boot time would be better here. Assuming that the fw time keeps
> running during suspend, boottime is better than monotonic, and
> ktime_get_boot_ns() will also save the additional conversion to
> nanoseconds.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers-next.git, thanks.

99f6996d4cba wlcore: use boottime for fw time sync

-- 
https://patchwork.kernel.org/patch/10076691/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
