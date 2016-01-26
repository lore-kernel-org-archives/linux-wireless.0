Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:32444 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184AbcAZPC1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 10:02:27 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: prevent txrx running for too long
References: <1452693172-28340-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 26 Jan 2016 17:01:57 +0200
In-Reply-To: <1452693172-28340-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 13 Jan 2016 14:52:52 +0100")
Message-ID: <87twm0peoq.fsf@kamboji.qca.qualcomm.com> (sfid-20160126_160229_974339_FC6C761D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On multicore systems it was possible for the txrx
> tasklet to keep on running for long periods of
> time on a single CPU due to tx completion
> processing. Another CPU could feed the running
> tasklet for an indefinite amount of time.
>
> The tasklet is now guaranteed to run a finite
> amount of time and is limited by HTT CE Rx ring
> depth.
>
> This improves behavior when RPS is used on target
> system and might improve TCP handling as well.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Applied, thanks.

-- 
Kalle Valo
