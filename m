Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36063 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761472Ab2FVHRb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 03:17:31 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>, dan.carpenter@oracle.com
Subject: Re: [PATCH 3/3] ath9k: fix 'side effect in macro' smatch warning
References: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1340303492-30947-4-git-send-email-rmanohar@qca.qualcomm.com>
Date: Fri, 22 Jun 2012 10:17:23 +0300
In-Reply-To: <1340303492-30947-4-git-send-email-rmanohar@qca.qualcomm.com>
	(Rajkumar Manoharan's message of "Fri, 22 Jun 2012 00:01:32 +0530")
Message-ID: <87ipej4xz0.fsf@purkki.adurom.net> (sfid-20120622_091739_535072_332E718F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qca.qualcomm.com> writes:

> ath9k_get_et_stats() warn: side effect in macro
> 'AWDATA' doing 'i++'
>
> Cc: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

[...]

>  	do {								\
> -		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem; \
> -		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem; \
> -		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem; \
> -		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem; \
> +		data[i+0] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem; \
> +		data[i+1] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem; \
> +		data[i+2] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem; \
> +		data[i+3] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem; \
> +		i += 4; \
>  	} while (0)

I agree with Ben, this is a useless change as the end result is still
the same (the side effect is that i is increased with four). You are
just hiding that from smatch and once smatch is fixed it will warn again
about the same thing.

I recommend fixing this properly so that the macro doesn't have any side
effects.

-- 
Kalle Valo
