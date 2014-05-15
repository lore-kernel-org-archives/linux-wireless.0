Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:57463 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaEONSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 09:18:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] ath10k: drain tx before restarting hw
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-4-git-send-email-michal.kazior@tieto.com>
Date: Thu, 15 May 2014 16:18:37 +0300
In-Reply-To: <1400143324-14911-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 15 May 2014 10:42:02 +0200")
Message-ID: <87k39n89jm.fsf@kamboji.qca.qualcomm.com> (sfid-20140515_151850_229547_DD626BF8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This makes sure no further tx requests are
> submitted to HTT before driver teardown.
>
> This should prevent invalid pointer/NULL
> dereference on htt tx pool in ath10k_htt_tx() in
> some cases of heavy traffic.
>
> Reported-By: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

For some reason I'm not receiving buildbot emails anymore, but I noticed
via the kbuild-all archives that this patch has a warning:

   drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_drain_tx':
>> drivers/net/wireless/ath/ath10k/mac.c:2442:2: error: implicit
declaration of function 'lockdep_is_held'
[-Werror=implicit-function-declaration]

https://lists.01.org/pipermail/kbuild-all/2014-May/004387.html

-- 
Kalle Valo
