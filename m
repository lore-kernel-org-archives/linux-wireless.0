Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42450 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbdHPPCh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 11:02:37 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH] qtnfmac: pcie datapath optimizations and cleanups
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
Date: Wed, 16 Aug 2017 18:02:33 +0300
In-Reply-To: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Tue, 15 Aug 2017 16:06:30 +0300")
Message-ID: <8760dntv1y.fsf@purkki.adurom.net> (sfid-20170816_170241_347461_A4958A14)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Hello Kalle and all,
>
> This patchset implements several optimizations and cleanups for
> pcie datapath in qtnfmac driver. Major changes include:
> - switch to kernel circ_buf implementation
> - modify tx reclaim locking
> - introduce counter for rx underflow events
>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
>
>  bus.h                   |    1 
>  pearl/pcie.c            |  285 +++++++++++++++++++++++++++++-------------------
>  pearl/pcie_bus_priv.h   |   15 +-
>  pearl/pcie_ipc.h        |    1 
>  pearl/pcie_regs_pearl.h |    1 
>  5 files changed, 183 insertions(+), 120 deletions(-)

I don't see patch 9 in the mailing list. Did it get lost somewhere?

-- 
Kalle Valo
