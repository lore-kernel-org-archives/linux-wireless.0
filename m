Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:20263 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbbCSNyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 09:54:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: protect driver from unsolicited htc ep0 events
References: <1426081031-15296-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 19 Mar 2015 15:53:50 +0200
In-Reply-To: <1426081031-15296-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 11 Mar 2015 14:37:11 +0100")
Message-ID: <87wq2dhz4h.fsf@kamboji.qca.qualcomm.com> (sfid-20150319_145403_335895_FD5CA485)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some firmware revisions (tested with qca6174
> rm2.0-00088) deliver unsolicited unknown (kind of
> garbled) HTC ep0 event to host in some cases.
>
> This issue was mainly observed with both qca988x
> and qca6174 being installed on a single host
> system. During driver probing if qca6174 booting
> sequences were somehow deferred (e.g. by qca988x
> implicitly making some resources busy presumably)
> the unsolicited event would came around 1s after
> ATH10K_HTC_MSG_READY_ID was delivered to host for
> qca6174.
>
> The unsolicited event would confuse driver and
> cause HTT initialization (and subsequently
> driver probing) to fail.
>
> Make the ep0 event processing more robust. The
> event will still be caught but instead will
> only generate a warning now.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
