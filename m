Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58371 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3JAQfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 12:35:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: fix scheduling while atomic bug
References: <1380292567-2363-1-git-send-email-michal.kazior@tieto.com>
	<1380292567-2363-3-git-send-email-michal.kazior@tieto.com>
Date: Tue, 1 Oct 2013 19:35:45 +0300
In-Reply-To: <1380292567-2363-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 27 Sep 2013 16:36:07 +0200")
Message-ID: <8761th6ja6.fsf@kamboji.qca.qualcomm.com> (sfid-20131001_183554_735596_3E93A3B6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Recent WMI/HTC changes broke WEP with multiple
> keys. If WMI had no HTC TX credits to submit
> command for default wep index update it would
> trigger a bug.
>
> This simply moves the wep key index update to a
> worker.
>
> The key update may happen some time after first
> frame with a different wep key has been sent (i.e.
> some frames will be sent with old key). This was
> the case before too as WMI commands were
> asynchronous.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

This looks problematic. Basically you just delay sending the WMI
command, but there's no guarantee that we actually have free credits at
the time of transmission. So to me it looks like this fixes the issue
just by luck.

-- 
Kalle Valo
