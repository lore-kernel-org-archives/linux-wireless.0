Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35902 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaFBSHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 14:07:31 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: remove unnecessary htt rx corruption check
References: <1401357008-16259-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 2 Jun 2014 21:07:13 +0300
In-Reply-To: <1401357008-16259-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 29 May 2014 11:50:08 +0200")
Message-ID: <87sinnxk1a.fsf@kamboji.qca.qualcomm.com> (sfid-20140602_200834_298321_D1E7E8B2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> While fixing a bug reported by Avery I went ahead
> and added a warning suspecting there might be
> something more to the bug. This ended up with
> people reporting they see warnings during heavy
> traffic. This bought me some time and helped me
> understand the problem better - apparently fw/hw
> can report a chained msdus as follows: 1 msdu, 1
> chained, 1 msdu (0 length).
>
> The patch removes the extra check but leaves the
> other change that fixed the original skb_push
> panic bug (msdu_chaining was overwritten in an
> unfortunate way which made the above example to
> be treated as non-chained case).
>
> Reported-by: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
> Reported-by: Tim Harvey <tharvey@gateworks.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied to ath-current branch.

-- 
Kalle Valo
