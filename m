Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29472 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3IXGWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 02:22:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath10k: replenish HTT RX buffers in a tasklet
References: <1379509691-19904-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 24 Sep 2013 09:22:29 +0300
In-Reply-To: <1379509691-19904-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 18 Sep 2013 15:08:10 +0200")
Message-ID: <87r4cebuxm.fsf@kamboji.qca.qualcomm.com> (sfid-20130924_082243_067421_C57BFA71)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This fixes system starvation when under heavy RX
> traffic. This problem could be observed on AP135
> and led to watchdog resetting the platform.
>
> Patch starves FW RX ring buffer by progressively
> replenishing buffers to auto-balance the RX
> handled to the host system.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Looks good to me. I suspect there is a better way to do this in long
term, but this looks like a viable short term solution.

Does it decrease throughput in a noticeable way?

-- 
Kalle Valo
