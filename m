Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63439 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbcGHOaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 10:30:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: implement NAPI support
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160627055128.7005-1-rmanohar@qti.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>,
	<rmanohar@codeaurora.org>
Message-ID: <6169ec35e7d9438180c60909a96390ae@euamsexm01a.eu.qualcomm.com> (sfid-20160708_163005_710985_C51D0DB6)
Date: Fri, 8 Jul 2016 16:29:53 +0200
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

This is quite big change and I'm planning to queue this for 4.9. So I'm not
applying this quite yet.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9199911/

