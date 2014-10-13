Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37169 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaJMIBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 04:01:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/5] ath10k: replace power up/down with reset callback
References: <1412842950-14098-1-git-send-email-michal.kazior@tieto.com>
	<1412842950-14098-6-git-send-email-michal.kazior@tieto.com>
Date: Mon, 13 Oct 2014 11:01:07 +0300
In-Reply-To: <1412842950-14098-6-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 9 Oct 2014 10:22:30 +0200")
Message-ID: <87fves9z5o.fsf@kamboji.qca.qualcomm.com> (sfid-20141013_100137_929376_DBEE06DB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The power up/down didn't make much sense any more
> since hif_stop already stops the device
> compeletely. The target lifecycle was never symmetric
> so don't bother trying to make it look like it is
> and expose a reset hif callback instead of power
> up/down callbacks.
>
> This removes redundant reset calls and thus makes
> device boot/stop/recovery a bit faster.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

About this I'm not that sure. The reason why I wanted to have power_up()
and power_down() is the case when we need to control the target power
via a gpio line, which I anticipate we will need soon. If you remove
these how could we control the gpio line?

Wouldn't it be the same that you just make hif_power_up() do the same as
hif_reset() and hif_power_down() doesn't do anything (for now)? Or am I
missing something?

-- 
Kalle Valo
