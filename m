Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48834 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3IIIA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 04:00:29 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: prevent CE from looping indefinitely
References: <1378213798-24769-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 9 Sep 2013 11:00:11 +0300
In-Reply-To: <1378213798-24769-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 3 Sep 2013 15:09:58 +0200")
Message-ID: <87txhuctmc.fsf@kamboji.qca.qualcomm.com> (sfid-20130909_100032_635668_F33F133B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The double while() could end up running forever.
> Inner while() would complete very fast. However
> the completion processing could take enough time
> for more completions to flow in. In that case the
> outer while() would not terminate and run again,
> and again. This could happen especially on a slow
> host system.
>
> This could lead to a system freeze during heavy
> traffic. Note: this doesn't solve all known
> starvation issues yet.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Applied, thanks.

-- 
Kalle Valo
