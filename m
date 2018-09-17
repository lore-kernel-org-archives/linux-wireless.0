Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48456 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbeIQTjE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 15:39:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 4.19] mt76x0: fix remove_interface
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1535970381-5526-1-git-send-email-sgruszka@redhat.com>
References: <1535970381-5526-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Message-Id: <20180917141133.C415060C4B@smtp.codeaurora.org> (sfid-20180917_161137_018176_C6C7BE71)
Date: Mon, 17 Sep 2018 14:11:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> We wrongly use wcid_mask instead of vif_mask. This creates problems
> when the interface is removed more than 8 times, for example with iw:
> 
> iw dev <devname> interface add <name> type <type>
> iw dev <name> del
> 
> This caused 'ifconfig up' to fail with error:
> 
> SIOCSIFFLAGS: No space left on device
> 
> Fixes: 95e444098a7b ("mt76x0: main file")
> Reported-and-tested-by: Sid Hayn <sidhayn@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers.git, thanks.

3341ba9f0f26 mt76x0: fix remove_interface

-- 
https://patchwork.kernel.org/patch/10585737/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
