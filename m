Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48160 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752827AbcIIMF4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 08:05:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] ath10k: implement NAPI support
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160826102250.24174-1-rmanohar@qti.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>,
        <rmanohar@codeaurora.org>
Message-ID: <5b16e9c1bb354beb9650733e0f7a84b0@euamsexm01a.eu.qualcomm.com> (sfid-20160909_140559_719711_2819CC2D)
Date: Fri, 9 Sep 2016 14:05:48 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> Add NAPI support for rx and tx completion. NAPI poll is scheduled
> from interrupt handler. The design is as below
> 
>  - on interrupt
>      - schedule napi and mask interrupts
>  - on poll
>    - process all pipes (no actual Tx/Rx)
>    - process Rx within budget
>    - if quota exceeds budget reschedule napi poll by returning budget
>    - process Tx completions and update budget if necessary
>    - process Tx fetch indications (pull-push)
>    - push any other pending Tx (if possible)
>    - before resched or napi completion replenish htt rx ring buffer
>    - if work done < budget, complete napi poll and unmask interrupts
> 
> This change also get rid of two tasklets (intr_tq and txrx_compl_task).
> 
> Measured peak throughput with NAPI on IPQ4019 platform in controlled
> environment. No noticeable reduction in throughput is seen and also
> observed improvements in CPU usage. Approx. 15% CPU usage got reduced
> in UDP uplink case.
> 
> DL: AP DUT Tx
> UL: AP DUT Rx
> 
> IPQ4019 (avg. cpu usage %)
> 
> ========
>                 TOT              +NAPI
>               ===========      =============
> TCP DL       644 Mbps (42%)    645 Mbps (36%)
> TCP UL       673 Mbps (30%)    675 Mbps (26%)
> UDP DL       682 Mbps (49%)    680 Mbps (49%)
> UDP UL       720 Mbps (28%)    717 Mbps (11%)
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

3c97f5de1f28 ath10k: implement NAPI support

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9301091/
