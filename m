Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:21756 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaJUISX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 04:18:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ath10k: speed up hw recovery
References: <1413807758-30249-1-git-send-email-michal.kazior@tieto.com>
	<1413807758-30249-4-git-send-email-michal.kazior@tieto.com>
Date: Tue, 21 Oct 2014 11:17:58 +0300
In-Reply-To: <1413807758-30249-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 20 Oct 2014 14:22:38 +0200")
Message-ID: <87lho9ygy1.fsf@kamboji.qca.qualcomm.com> (sfid-20141021_101831_577315_2422128E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> In some cases hw recovery was taking an absurdly
> long time due to ath10k waiting for things that
> would never really complete.
>
> Instead of waiting for inevitable timeouts poke
> all completions and wakequeues and check if it's
> still worth waiting.
>
> Reading/writing ar->state requires conf_mutex.
> Since waiters might be holding it introduce a new
> flag CRASH_FLUSH so it's possible to tell waiters
> to abort whatever they were waiting for.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

While applying to ath-next-test there was a conflict in core.h. Please
check my resolution:

https://github.com/kvalo/ath/commit/6cccda0185c7df96f439dc3f87961e81843de3ee

-- 
Kalle Valo
