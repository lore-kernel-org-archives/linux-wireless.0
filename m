Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46000 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbaEPNtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 09:49:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: warm reset fixes 2014-05-14
References: <1400050658-2763-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 16 May 2014 16:49:08 +0300
In-Reply-To: <1400050658-2763-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 14 May 2014 08:57:36 +0200")
Message-ID: <87vbt54ywb.fsf@kamboji.qca.qualcomm.com> (sfid-20140516_154925_116508_42BBC93A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> Warm reset was not able to recover from a device
> crash so ath10k was falling back to cold reset
> which would occasionally hang the system or
> generate a data bus error with some device chips.
>
> Warm reset now works a lot more reliably (at least
> on my T430). It's able to recover from a "hard"
> simulate fw crash and some firmware asserts I've
> forced meaning it should recover in most cases
> without falling back to the cold reset.
>
> There's still one case of a crash warm reset is
> incapable to recover from: IOMMU faults (when
> supported and enabled and device tries to access
> non-DMA mapped host memory) trigger device crash
> and leave CE totally unresponsive before and after
> the warm reset.
>
>
> Michal Kazior (2):
>   ath10k: improve warm reset reliability
>   ath10k: retry warm reset a few times

Thanks, both patches applied.

-- 
Kalle Valo
