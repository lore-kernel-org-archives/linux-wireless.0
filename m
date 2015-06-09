Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:13991 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbbFIKu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 06:50:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: fix ar->rx_channel updating logic
References: <1433326616-23279-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 9 Jun 2015 13:50:21 +0300
In-Reply-To: <1433326616-23279-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 3 Jun 2015 12:16:54 +0200")
Message-ID: <87wpzdf95e.fsf@kamboji.qca.qualcomm.com> (sfid-20150609_125032_247689_774CDF13)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Channel contexts aren't iterable until after
> they've been added to the driver. The code assumed
> otherwise.
>
> This problem could result in:
>
>  * rx_channel being NULL and forcing Rx path to go
>    the slow way to get channel on QCA988X,
>
>  * report incorrect channel when running
>    multi-channel on QCA61X4 hw2.1,
>
>  * report incorrect channel after AP channel
>    switch.
>
> Fixes: 500ff9f9389d ("ath10k: implement chanctx API")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, all three patches applied.

-- 
Kalle Valo
