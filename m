Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7571 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaEWKbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 06:31:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] ath10k: drain tx before restarting hw
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-4-git-send-email-michal.kazior@tieto.com>
	<87oayovr1m.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmJTsh3Kcwmqx19WAzoBhYrhkQaPT_S=JFVPptkVaaKyw@mail.gmail.com>
	<87bnuovq6x.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQn_V5zGA18qGMNrWYy_-fBQzBi1=EmzMs=0SLvk1LBVJQ@mail.gmail.com>
Date: Fri, 23 May 2014 13:31:01 +0300
In-Reply-To: <CA+BoTQn_V5zGA18qGMNrWYy_-fBQzBi1=EmzMs=0SLvk1LBVJQ@mail.gmail.com>
	(Michal Kazior's message of "Fri, 23 May 2014 11:06:25 +0200")
Message-ID: <877g5cvlay.fsf@kamboji.qca.qualcomm.com> (sfid-20140523_123112_393126_EFFFD5CF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>> Sure, but I still think it's a bit ugly. The right way to fix this would
>> be to add it to include/lockdep.h, instead of adding custom checks to a
>> driver.
>
> Good point. I wonder if it's generic enough to justify.

No idea. But no matter what it will take some time to get it accepted,
so we need to solve this in a faster way so that I can apply this patch.

>> But does this check even make sense? There's nothing preventing
>> to another thread to take lock just after the WARN_ON(), right?
>
> There's nothing wrong with other thread holding it. Actually that's
> the reason for this very check.
>
> The point is to prevent ath10k_drain_tx() being called while caller
> (current thread) holds conf_mutex. If it were to hold conf_mutex then
> cancel_work_sync() can deadlock as both workers it tries to stop try
> to get a hold of the lock too.

Ah, now I understand.

What if we just drop the WARN_ON() from this patch just so that I can
apply the patch and we add a proper code for checking the mutex in a
followup patch? Are you ok with that?


-- 
Kalle Valo
