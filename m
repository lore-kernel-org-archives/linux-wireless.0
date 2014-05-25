Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:45706 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaEYHyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2014 03:54:04 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<apenwarr@gmail.com>
Subject: Re: [PATCH 2/3] ath10k: revert incomplete scatter-gather pci tx
References: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
	<1400158139-13836-3-git-send-email-michal.kazior@tieto.com>
Date: Sun, 25 May 2014 10:53:57 +0300
In-Reply-To: <1400158139-13836-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 15 May 2014 14:48:58 +0200")
Message-ID: <87fvjytht6.fsf@kamboji.qca.qualcomm.com> (sfid-20140525_095408_297502_BB843475)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This prevents leaving incomplete scatter-gather
> transfer on CE rings which can lead firmware to
> crash.
>
> Reported-By: Avery Pennarun <apenwarr@gmail.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

The title is a bit misleading as usually the commit log with the word
revert means that the commit is reverting another git commit. Maybe
something like this is better:

ath10k: drop incomplete scatter-gather pci tx transfers

> +	if (WARN_ON(src_ring->write_index == src_ring->sw_index))
> +		return;
> +
> +	if (WARN_ON(src_ring->write_index ==
> +		    ath10k_ce_src_ring_write_index_get(ar, ctrl_addr)))
> +		return;

WARN_ON() on data path is dangerous. WARN_ON_ONCE() or ath10k_warn() is
better.

> +err:
> +	for (; i > 0; i--)

Isn't this just a fancy way to say 'while (i-- > 0)'?

-- 
Kalle Valo
