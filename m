Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:49658 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab3JGQgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 12:36:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: fix scheduling while atomic bug
References: <to=1380292567-2363-1-git-send-email-michal.kazior@tieto.com>
	<1380874630-14280-1-git-send-email-michal.kazior@tieto.com>
	<1380874630-14280-3-git-send-email-michal.kazior@tieto.com>
Date: Mon, 7 Oct 2013 19:35:57 +0300
In-Reply-To: <1380874630-14280-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 4 Oct 2013 10:17:10 +0200")
Message-ID: <87li25t4wi.fsf@kamboji.qca.qualcomm.com> (sfid-20131007_183634_385111_B721DC43)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Recent WMI/HTC changes made it possible for WMI
> commands to sleep (if there's not enough HTC TX
> credits to submit a command). TX path is in an
> atomic context so calling WMI commands in it is
> wrong.
>
> This simply moves WEP key index update to a worker
> and fixes the 'scheduling while atomic' bug.
>
> This still leaves multiple WEP key handling laggy,
> i.e. some frames may be TXed with an old/different
> key (although recipient should still be able to RX
> them).
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I see conflicts with this patch. Can you rebase, please?

-- 
Kalle Valo
