Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:30991 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaIJQOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 12:14:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: fix debugfs_create_dir() checking
References: <1409827005-3777-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 10 Sep 2014 19:14:37 +0300
In-Reply-To: <1409827005-3777-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 4 Sep 2014 12:36:45 +0200")
Message-ID: <87sijz5u6q.fsf@kamboji.qca.qualcomm.com> (sfid-20140910_181453_512549_BE85554F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The function may return an -ENODEV if debugfs is
> disabled in kernel. This should originally be
> guarded by ath10k's Kconfig but it still makes
> sense to check for the non-NULL errno return
> value.
>

[...]

> Reported-by: Matteo Croce <matteo@openwrt.org>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>
> Notes:
>     v2:
>      * fix commit subject (sorry for the noise!)
>     
>     v3:
>      * remove Kconfig patch (I accidentally amended something I shouldn't have,
>        sorry for the noise again! I guess I need a break..)
>
> @Kalle:
>
>  - this patch prevents kernel oops but ath10k will
>    fail to load
>
>  - Matteo's patch prevents kernel oops and ath10k
>    will load fine
>
> Since mine is just an extra precaution feel free
> to drop all but the first paragraph of my commit
> message if you want to.

Thanks, I just left the first paragraph like you recommended. Also I had
a conflict with this patch, please double check my resolution in
ath-next-test:

https://github.com/kvalo/ath/commit/bee6d655eefe488b76998c9c0018a4e6b0828de6

-- 
Kalle Valo
