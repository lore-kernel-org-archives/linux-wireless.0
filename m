Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:59148 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758836AbaKURB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 12:01:57 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] ath10k: rework rx path
References: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 21 Nov 2014 19:01:51 +0200
In-Reply-To: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 4 Nov 2014 15:22:04 +0100")
Message-ID: <87oas0bi80.fsf@kamboji.qca.qualcomm.com> (sfid-20141121_180208_832253_D4205242)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This patchset unifies rx path. Instead of
> branching for A-MSDU and MSDU cases a single
> codepath is introduced.
>
> This yields:
>
>    text    data     bss     dec     hex filename
>   14068       0       0   14068    36f4 before/htt_rx.o
>   13308       3       0   13311    33ff after/htt_rx.o
>
> I haven't measured any Rx performance loss in my
> setup but I may be biased. In theory this could
> reduce i-cache pressure and improve Rx throughput
> on CPU contrained systems by a few mbps.
>
> This patchset serves two purposes though:
>  - clean up and unify the Rx path a bit
>  - make it possible to reuse code more easily in
>    the future
>
>
> Michal Kazior (7):
>   ath10k: start using sk_buff_head
>   ath10k: simplify Rx loop
>   ath10k: refactor htt->rx_confused
>   ath10k: unify rx undecapping
>   ath10k: remove unused function argument
>   ath10k: use rx descriptor for ppdu status extraction
>   ath10k: report rx rate and signal for fragmented Rx

Thanks, all seven applied.

-- 
Kalle Valo
