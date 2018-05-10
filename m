Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0049.outbound.protection.outlook.com ([104.47.34.49]:10592
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753944AbeEJJwL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 05:52:11 -0400
Date: Thu, 10 May 2018 12:51:57 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] wireless-drivers: Dynamically allocate struct
 station_info
Message-ID: <20180510095156.7ha4oueua5yxn5b6@bars> (sfid-20180510_115217_129271_30634CD0)
References: <152594435934.24751.8979312538330792032.stgit@alrua-kau>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <152594435934.24751.8979312538330792032.stgit@alrua-kau>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Since the addition of the TXQ stats to cfg80211, the station_info struct
> has grown to be quite large, which results in warnings when allocated on
> the stack. Fix the affected places to do dynamic allocations instead.
> 
> Fixes: 52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to userspace")
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> ---
> v4:
>   - Add missing kfree before return in qtnfmac, as pointed out by Sergey
>     Matyukevich.
> 
>  drivers/net/wireless/ath/ath6kl/main.c             |   14 ++++---
>  drivers/net/wireless/ath/wil6210/debugfs.c         |   22 +++++++----
>  drivers/net/wireless/ath/wil6210/wmi.c             |   19 ++++++---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   18 ++++++---
>  drivers/net/wireless/marvell/mwifiex/uap_event.c   |   25 ++++++++----
>  drivers/net/wireless/quantenna/qtnfmac/event.c     |   41 +++++++++++++-------
>  6 files changed, 90 insertions(+), 49 deletions(-)

Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Thanks!
Sergey
