Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34952 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbcAGNGA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 08:06:00 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Fengwei Yin <fengwei.yin@linaro.org>
Cc: julian.calaby@gmail.com, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com,
	lking@qti.qualcomm.com
Subject: Re: [PATCH v3 0/2] wcn36xx: fix crash because rx skb allocation failure
References: <1450617641-29531-1-git-send-email-fengwei.yin@linaro.org>
Date: Thu, 07 Jan 2016 15:05:53 +0200
In-Reply-To: <1450617641-29531-1-git-send-email-fengwei.yin@linaro.org>
	(Fengwei Yin's message of "Sun, 20 Dec 2015 21:20:39 +0800")
Message-ID: <87si29k09a.fsf@kamboji.qca.qualcomm.com> (sfid-20160107_140604_596949_9D44AD6E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fengwei Yin <fengwei.yin@linaro.org> writes:

> The current wcn36xx driver didn't handle rx skb allocation failure case.
> It only could be triggered when system is in extremly memory shortage
> case. King Lawrence <lking@qti.qualcomm.com> hit it by git clone linux
> kernel tree on DragonBoard <1>.
>
> The fixing is not to submit the old rx skb to network upper layer and 
> reuse it as rx DMA buffer again.
>
> Changes from v2:
>  * Remove the ugly macro introduced in v2 per comment from Julian Calaby.
>  * Seperate the DMA int mask register writing as one patch per comment
>    from Bjorn Andersson.
>
> Changes from v1:
>  * Move switch block out of while loop.
>  * Remove the warning of unknown channel because we didn't deal with it.
>
> Fengwei Yin (2):
>   wcn36xx: handle rx skb allocation failure to avoid system crash
>   wcn36xx: split DMA mask register writing.

Applied to ath.git, thanks.

-- 
Kalle Valo
