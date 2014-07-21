Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:31667 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaGUSCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 14:02:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, Ben Greear <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: prevent some tx flushing failures
References: <1405518073-14513-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 21 Jul 2014 21:02:16 +0300
In-Reply-To: <1405518073-14513-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 16 Jul 2014 15:41:13 +0200")
Message-ID: <874myay4if.fsf@kamboji.qca.qualcomm.com> (sfid-20140721_200225_948784_3557838D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Firmware could request inspection of some
> submitted tx requests. Since the callback wasn't
> implemented it was possible to bleed tx msdu_ids
> which could translate to tx flushing timeouts.
>
> There's nothing ath10k can do to help firmware
> with tx processing now so just report all tx
> frames as already inspected to prevent firmware
> from sending up inspection events and force it to
> report regular tx completion indications with
> discard status.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
