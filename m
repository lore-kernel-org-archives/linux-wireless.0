Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:24213 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbbHZJed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 05:34:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix compilation warnings in wmi phyerr pull function
References: <1440162756-4025-1-git-send-email-rmani@qti.qualcomm.com>
Date: Wed, 26 Aug 2015 12:34:26 +0300
In-Reply-To: <1440162756-4025-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Fri, 21 Aug 2015 18:42:36 +0530")
Message-ID: <87fv361jh9.fsf@kamboji.qca.qualcomm.com> (sfid-20150826_113438_485178_47CE9449)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> Below compilation warnings are observed in gcc version 4.8.2.
> Even though it's not seen in bit older gcc versions (for ex, 4.7.3),
> It's good to fix it by changing format specifier from %d to
> %zd in wmi pull phyerr functions.
>
> wmi.c: In function 'ath10k_wmi_op_pull_phyerr_ev':
> wmi.c:3567:8: warning: format '%d' expects argument of type 'int',
>               but argument 4 has type 'long unsigned int' [-Wformat=]
>               left_len, sizeof(*phyerr));
>                         ^
> wmi.c: In function 'ath10k_wmi_10_4_op_pull_phyerr_ev':
> wmi.c:3612:8: warning: format '%d' expects argument of type 'int',
> 	      but argument 4 has type 'long unsigned int' [-Wformat=]
>               left_len, sizeof(*phyerr));
>                         ^
> Fixes: 991adf71a6cd ("ath10k: refactor phyerr event handlers")
> Fixes: 2b0a2e0d7c2f ("ath10k: handle 10.4 firmware phyerr event")
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
