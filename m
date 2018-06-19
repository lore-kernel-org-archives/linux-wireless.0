Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33368 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937554AbeFSKkz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 06:40:55 -0400
MIME-Version: 1.0
In-Reply-To: <20180618151142.1214422-3-arnd@arndb.de>
References: <20180618151142.1214422-1-arnd@arndb.de> <20180618151142.1214422-3-arnd@arndb.de>
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Date: Tue, 19 Jun 2018 14:40:53 +0400
Message-ID: <CA++WF2NRGtCKr=Q=+zmA7otu64J6JBfrnK9vB-Nyqk6oYivWDA@mail.gmail.com> (sfid-20180619_124118_666093_0FD9A9DD)
Subject: Re: [PATCH 3/4] ipw2x00: track time using boottime
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, y2038@lists.linaro.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/06/2018, Arnd Bergmann <arnd@arndb.de> wrote:
> The ipw2x00 driver family uses get_seconds() to read the current time
> for various purposes. This function is deprecated because of the 32-bit
> time_t overflow, and it can cause unexpected behavior when the time
> changes due to settimeofday() calls or leap second updates.
>
> In many cases, we want to use monotonic time instead, however ipw2x00
> explicitly tracks the time spent in suspend, so this changes the
> driver over to use ktime_get_boottime_seconds(), which is slightly
> slower, but not used in a fastpath here.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2100.c | 18 +++++++++---------
>  drivers/net/wireless/intel/ipw2x00/ipw2100.h | 12 ++++++------
>  drivers/net/wireless/intel/ipw2x00/ipw2200.c |  4 ++--
>  drivers/net/wireless/intel/ipw2x00/ipw2200.h |  6 +++---
>  4 files changed, 20 insertions(+), 20 deletions(-)
>

Acked-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>

Looks fine, thanks!

Stanislav.
