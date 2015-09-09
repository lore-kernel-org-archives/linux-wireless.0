Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43850 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbIIJzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 05:55:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath: use PRI value given by spec for fixed PRI
References: <f9db7f54d12e2589bcbb39215049d51a762d5d75.1441731619.git.poh@qca.qualcomm.com>
Date: Wed, 9 Sep 2015 12:55:39 +0300
In-Reply-To: <f9db7f54d12e2589bcbb39215049d51a762d5d75.1441731619.git.poh@qca.qualcomm.com>
	(Peter Oh's message of "Tue, 8 Sep 2015 10:04:41 -0700")
Message-ID: <87h9n39ask.fsf@kamboji.qca.qualcomm.com> (sfid-20150909_115554_804196_D114BEF9)
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

A changelog would be good to have. What changed in v2?

-- 
Kalle Valo
