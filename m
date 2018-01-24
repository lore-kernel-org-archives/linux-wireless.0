Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52106 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934033AbeAXPMX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:12:23 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: fix WMM parameter configuration
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <7554b3527fd55afa7561ffc89fb7f3bea1a902ed.1516186517.git.lorenzo.bianconi@redhat.com>
References: <7554b3527fd55afa7561ffc89fb7f3bea1a902ed.1516186517.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org,
        gaetano.catalli@gmail.com
Message-Id: <20180124151222.E1C7A600C1@smtp.codeaurora.org> (sfid-20180124_161230_643820_756C8B13)
Date: Wed, 24 Jan 2018 15:12:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Fix hw queue configuration since mt76x2 devices use a reverse queue
> enumeration respect to mac80211 one:
>  - 0: AC_BE
>  - 1: AC_BK
>  - 2: AC_VI
>  - 3: AC_VO
> 
> The issue can be reproduced sending two concurrent flow using
> two separate queues:
>  - VO: 20Mbps UDP traffic
>  - BE: TCP traffic
> 
> In this scenario the UDP traffic will be blocked by the TCP one.
> Fix it configuring properly WMM hw queue parameters
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Tested-by: Gaetano Catalli <gaetano.catalli@gmail.com>
> Signed-off-by: Gaetano Catalli <gaetano.catalli@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

1cbbf69cc83e mt76x2: fix WMM parameter configuration

-- 
https://patchwork.kernel.org/patch/10169067/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
