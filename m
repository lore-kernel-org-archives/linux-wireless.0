Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932079AbeADOmo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 09:42:44 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi,
        sara.sharon@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: pcie: fix DMA memory mapping / unmapping
References: <20180104071913.15470-1-emmanuel.grumbach@intel.com>
Date: Thu, 04 Jan 2018 16:42:40 +0200
In-Reply-To: <20180104071913.15470-1-emmanuel.grumbach@intel.com> (Emmanuel
        Grumbach's message of "Thu, 4 Jan 2018 09:19:13 +0200")
Message-ID: <87r2r57kin.fsf@kamboji.qca.qualcomm.com> (sfid-20180104_154257_537225_DFB30C65)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

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
> ---
> Hi Kalle,
>
> Luca is on vacation is 4.15 will be closed soon.
> I am fixing here a bug that caused much troube on our side.
> There are two bugzillas on it. Users on both bugs validated
> this fix.
> Please apply this on wireless-drivers.git directly and I'll sync
> with Luca when he'll be back.

Ok, I'll queue this for 4.15.

-- 
Kalle Valo
