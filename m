Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0086.outbound.protection.outlook.com ([104.47.40.86]:35425
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750943AbdHQGxg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 02:53:36 -0400
Subject: Re: [PATCH] qtnfmac: pcie datapath optimizations and cleanups
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Cc: Avinash Patil <avinashp@quantenna.com>
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <5013e189-64f4-fb63-f8b0-03dfe43a0613@quantenna.com> (sfid-20170817_085341_055561_9732FFA9)
Date: Wed, 16 Aug 2017 23:53:23 -0700
MIME-Version: 1.0
In-Reply-To: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/15/2017 06:06 AM, Sergey Matyukevich wrote:
> Hello Kalle and all,
> 
> This patchset implements several optimizations and cleanups for
> pcie datapath in qtnfmac driver. Major changes include:
> - switch to kernel circ_buf implementation
> - modify tx reclaim locking
> - introduce counter for rx underflow events
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Entire series:
Tested-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

> 
>   bus.h                   |    1
>   pearl/pcie.c            |  285 +++++++++++++++++++++++++++++-------------------
>   pearl/pcie_bus_priv.h   |   15 +-
>   pearl/pcie_ipc.h        |    1
>   pearl/pcie_regs_pearl.h |    1
>   5 files changed, 183 insertions(+), 120 deletions(-)
> 
