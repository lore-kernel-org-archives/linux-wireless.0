Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47215 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbbBOPvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 10:51:20 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix AP/IBSS CSA with template based fw
References: <1423749198-11346-1-git-send-email-michal.kazior@tieto.com>
Date: Sun, 15 Feb 2015 17:51:14 +0200
In-Reply-To: <1423749198-11346-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 12 Feb 2015 14:53:18 +0100")
Message-ID: <87mw4fgolp.fsf@kamboji.qca.qualcomm.com> (sfid-20150215_165128_181988_5CE25D55)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> qca6174 with wmi-tlv firmware uses offloaded
> beaconing scheme (i.e. templates). This requires a
> little different approach when implementing CSA.
>
> Add missing code to update CS count and report CSA
> completion to mac80211. Without it channel switch
> was never finished.
>
> To avoid races during interface teardown data_lock
> has been used to protect is_up and is_started so
> they can be compared against before scheduling
> count down work.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>
> @Kalle: I'm deferring the chanctx patchset v4
> until this gets applied. I'd like to avoid posting
> patches without a valid parent id and leaving you
> with some weird conflicts and implicit depndencies
> in the code to deal with.

Ok.

I actually had strange conflicts already with this patch (in mac.c). As
I'm travelling, please check my resolution from the pending branch very
carefully. I might have done something stupid.

-- 
Kalle Valo
