Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22012 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaIWJ36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 05:29:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: workaround fw beaconing bug
References: <1411023358-5703-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 23 Sep 2014 12:29:46 +0300
In-Reply-To: <1411023358-5703-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 18 Sep 2014 08:55:58 +0200")
Message-ID: <87y4taelbp.fsf@kamboji.qca.qualcomm.com> (sfid-20140923_113001_376270_1C0570E1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some firmware revisions don't wait for beacon tx
> completion before sending another SWBA event. This
> could lead to hardware using old (freed) beacon
> data in some cases, e.g. tx credit starvation
> combined with missed TBTT. This is very very rare.
>
> On non-IOMMU-enabled hosts this could be a
> possible security issue because hw could beacon
> some random data on the air.  On IOMMU-enabled
> hosts DMAR faults would occur in most cases and
> target device would crash.
>
> Since there are no beacon tx completions (implicit
> nor explicit) propagated to host the only
> workaround for this is to allocate a DMA-coherent
> buffer for a lifetime of a vif and use it for all
> beacon tx commands. Worst case for this approach
> is some beacons may become corrupted, e.g. garbled
> IEs or out-of-date TIM bitmap.
>
> Keep the original beacon-related code as-is in
> case future firmware revisions solve this problem
> so that the old path can be easily re-enabled with
> a fw_feature flag.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
