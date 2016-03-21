Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57471 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbcCUOYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2016 10:24:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] ath9k: fix buffer overrun for ar9287
References: <1457965120-3155420-1-git-send-email-arnd@arndb.de>
	<1457965120-3155420-4-git-send-email-arnd@arndb.de>
Date: Mon, 21 Mar 2016 16:23:59 +0200
In-Reply-To: <1457965120-3155420-4-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Mon, 14 Mar 2016 15:18:36 +0100")
Message-ID: <87lh5bhpts.fsf@purkki.adurom.net> (sfid-20160321_152411_905435_BC2107FB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> Code that was added back in 2.6.38 has an obvious overflow
> when accessing a static array, and at the time it was added
> only a code comment was put in front of it as a reminder
> to have it reviewed properly.
>
> This has not happened, but gcc-6 now points to the specific
> overflow:
>
> drivers/net/wireless/ath/ath9k/eeprom.c: In function 'ath9k_hw_get_gain_boundaries_pdadcs':
> drivers/net/wireless/ath/ath9k/eeprom.c:483:44: error: array subscript is above array bounds [-Werror=array-bounds]
>      maxPwrT4[i] = data_9287[idxL].pwrPdg[i][4];
>                    ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
>
> It turns out that the correct array length exists in the local
> 'intercepts' variable of this function, so we can just use that
> instead of hardcoding '4', so this patch changes all three
> instances to use that variable. The other two instances were
> already correct, but it's more consistent this way.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 940cd2c12ebf ("ath9k_hw: merge the ar9287 version of ath9k_hw_get_gain_boundaries_pdadcs")

Dave already applies this so I can skip this.

-- 
Kalle Valo
