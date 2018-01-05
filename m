Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34238 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbeAELzd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Jan 2018 06:55:33 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: iwlwifi: pcie: fix DMA memory mapping / unmapping
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180104071913.15470-1-emmanuel.grumbach@intel.com>
References: <20180104071913.15470-1-emmanuel.grumbach@intel.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi,
        sara.sharon@intel.com, stable@vger.kernel.org
Message-Id: <20180105115533.70D616079C@smtp.codeaurora.org> (sfid-20180105_125538_976972_E8035F19)
Date: Fri,  5 Jan 2018 11:55:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> wrote:

> 22000 devices (previously referenced as A000) can support
> short transmit queues. This means that we have less DMA
> descriptors (TFD) for those shorter queues.
> Previous devices must still have 256 TFDs for each queue
> even if those 256 TFDs point to fewer buffers.
> 
> When I introduced support for the short queues for 22000
> I broke older devices by assuming that they can also have
> less TFDs in their queues. This led to several problems:
> 
> 1) the payload of the commands weren't unmapped properly
>    which caused the SWIOTLB to complain at some point.
> 2) the hardware could get confused and we get hardware
>    crashes.
> 
> The corresponding bugzilla entries are:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=198201
> https://bugzilla.kernel.org/show_bug.cgi?id=198265
> 
> Cc: stable@vger.kernel.org # 4.14+
> Fixes: 4ecab5616023 ("iwlwifi: pcie: support short Tx queues for A000 device family")
> Reviewed-by: Sharon, Sara <sara.sharon@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Patch applied to wireless-drivers.git, thanks.

943309d4aad6 iwlwifi: pcie: fix DMA memory mapping / unmapping

-- 
https://patchwork.kernel.org/patch/10143989/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
