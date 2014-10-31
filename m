Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14250 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161019AbaJaARx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 20:17:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: avoid possible deadlock with scan timeout
References: <1414488189-28625-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 31 Oct 2014 02:17:33 +0200
In-Reply-To: <1414488189-28625-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 28 Oct 2014 10:23:09 +0100")
Message-ID: <87ppd9drdu.fsf@kamboji.qca.qualcomm.com> (sfid-20141031_011757_312297_EB8CFDFE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This should prevent deadlock predicted by the
> following splat:
>
>  ======================================================
>  [ INFO: possible circular locking dependency detected ]
>  3.17.0-wl-ath+ #67 Not tainted
>  -------------------------------------------------------
>  kworker/u32:1/7230 is trying to acquire lock:
>   (&ar->conf_mutex){+.+.+.}, at: [<ffffffffa040a57d>] ath10k_scan_timeout_work+0x2d/0x50 [ath10k_core]
>
>  but task is already holding lock:
>   ((&(&ar->scan.timeout)->work)){+.+...}, at: [<ffffffff8106dae1>] process_one_work+0x151/0x470
>
>  which lock already depends on the new lock.
>

[...]

>   *** DEADLOCK ***
>
> Reported-by: Marek Puzyniak <marek.puzyniak@tieto.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
