Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0075.outbound.protection.outlook.com ([104.47.40.75]:19424
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754551AbdJIQAr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 12:00:47 -0400
Date: Mon, 9 Oct 2017 19:00:35 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH V2 0/8] qtnfmac: get rid of redundant state caching in
 driver
Message-ID: <20171009160033.o734uvdguk62yapx@bars> (sfid-20171009_180051_822904_766C6997)
References: <20171005013813.13332-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171005013813.13332-1-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> In many cases qtnfmac driver stores state info (like current channel,
> interface state) in driver's internal state that is either unused or
> duplicates information that is available elsewhere. Cleanup driver
> to get rid of not needed cached data.
> 
> It was part of bigger changeset when it was V1.
> 
> Changelist V1->V2:
> PATCH 3:
>   - add missing cpu_to_le16() to CMD len field initialization.
> 
> Igor Mitsyanko (8):
>   qtnfmac: do not cache AP settings in driver structures
>   qtnfmac: pass all AP settings to wireless card for processing
>   qtnfmac: pass channel definition to WiFi card on START_AP command
>   qtnfmac: get rid of QTNF_STATE_AP_CONFIG
>   qtnfmac: get rid of QTNF_STATE_AP_START flag
>   qtnfmac: do not cache BSS state in per-VIF structure
>   qtnfmac: make encryption info a part of CONNECT command.
>   qtnfmac: do not cache current channel info in driver's state
> 
>  drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  | 110 ++------------
>  drivers/net/wireless/quantenna/qtnfmac/commands.c  | 163 +++++++++++----------
>  drivers/net/wireless/quantenna/qtnfmac/commands.h  |   3 +-
>  drivers/net/wireless/quantenna/qtnfmac/core.h      |  24 +--
>  drivers/net/wireless/quantenna/qtnfmac/event.c     |  14 --
>  drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  92 +++++++++---
>  .../net/wireless/quantenna/qtnfmac/qlink_util.c    |  45 ++++++
>  .../net/wireless/quantenna/qtnfmac/qlink_util.h    |   3 +
>  8 files changed, 224 insertions(+), 230 deletions(-)

For the whole patchset:
Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
