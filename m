Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61174 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbbAOKfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 05:35:37 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: prevent fw reg dump spam
References: <1421072977-22688-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 15 Jan 2015 12:35:26 +0200
In-Reply-To: <1421072977-22688-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 12 Jan 2015 15:29:37 +0100")
Message-ID: <87wq4oxrf5.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_113549_863454_52E402E9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Originally the explicit fw register dump was added
> to wait_for_target_init because interrupts are
> masked early during power_up.
>
> Due to some changes in power_up/reset sequences
> sometimes when fw crashed ath10k would print the
> dump more than once via hif_stop -> warm_reset ->
> wait_for_target_init, possibly with different
> values each.
>
> Prevent this by doing the explicit fw register
> dump only during power_up instead of
> wait_for_target_init.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
