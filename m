Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37038 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbbI0Mxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 08:53:31 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath: use PRI value given by spec for fixed PRI
References: <f2542c539e8c0eab1b0cbd184dceeb412a3e4516.1441821191.git.poh@qca.qualcomm.com>
Date: Sun, 27 Sep 2015 15:53:15 +0300
In-Reply-To: <f2542c539e8c0eab1b0cbd184dceeb412a3e4516.1441821191.git.poh@qca.qualcomm.com>
	(Peter Oh's message of "Wed, 9 Sep 2015 10:53:23 -0700")
Message-ID: <87fv20c9c4.fsf@kamboji.qca.qualcomm.com> (sfid-20150927_145343_123538_E7337B2B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> PRI value is used as divider when DFS detector analyzes candidate
> radar pulses.
> If PRI deviation is big from its origin PRI, DFS detector could miss
> valid radar reports since HW often misses detecting radar pulses and
> causes long interval value of pulses.
>
> For instance from practical results, if runtime PRI is calculated as
> 1431 for fixed PRI value of 1428 and delta timestamp logs 15719,
> the modular remainder will be 1409 and the delta between the remainder
> and runtime PRI is 22 that is bigger than PRI tolerance which is 16.
> As a result this radar report will be ignored even though it's valid.
>
> By using spec defined PRI for fixed PRI, we can correct this error.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
