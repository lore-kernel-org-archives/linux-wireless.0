Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4166 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbbF3Men (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 08:34:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@venema.h4ckr.net>,
	<ath10k@lists.infradead.org>, <poh@qca.qualcomm.com>
Subject: Re: [PATCH] ath: DFS - limit number of potential PRI sequences
References: <1434443643-28477-1-git-send-email-zefir.kurtisi@neratec.com>
Date: Tue, 30 Jun 2015 15:34:34 +0300
In-Reply-To: <1434443643-28477-1-git-send-email-zefir.kurtisi@neratec.com>
	(Zefir Kurtisi's message of "Tue, 16 Jun 2015 10:34:03 +0200")
Message-ID: <87si991ijp.fsf@kamboji.qca.qualcomm.com> (sfid-20150630_143451_051779_F366D4F2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zefir Kurtisi <zefir.kurtisi@neratec.com> writes:

> In the PRI detector, after the current radar pulse
> has been checked agains existing PRI sequences, it
> is considered as part of a new potential sequence.
>
> Previously, the condition to accept a new sequence
> was to have at least the same number of pulses as
> the longest matching sequence. This was wrong,
> since it led to duplicates of PRI sequences.
>
> This patch changes the acceptance criteria for new
> potential sequences from 'at least' to 'more than'
> the longest existing.
>
> Detection performance remains unaffected, while
> the number of PRI sequences accounted at runtime
> (and with it CPU load) is reduced by up to 50%.
>
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
