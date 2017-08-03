Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:22664 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751940AbdHCLfe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 07:35:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: sdio: fix compile warning
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1499540921-18521-1-git-send-email-erik.stromdahl@gmail.com>
References: <1499540921-18521-1-git-send-email-erik.stromdahl@gmail.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <4a06a6fc064e43009a37fc7a4a1c52af@euamsexm01a.eu.qualcomm.com> (sfid-20170803_133549_316401_B01A07EB)
Date: Thu, 3 Aug 2017 13:35:27 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> wrote:

> As suggested by Arnd Bergmann, replace
> "while (time_before_...) {}"
> with
> "do {} while (time_before_...)"
> 
> This fixes the following warnings detected by gcc 4.1.2:
> 
> drivers/net/wireless/ath/ath10k/sdio.c: In function
> ‘ath10k_sdio_mbox_rxmsg_pending_handler’:
> drivers/net/wireless/ath/ath10k/sdio.c:676: warning: ‘ret’ may be used uninitialized in this function
> 
> ...
> 
> drivers/net/wireless/ath/ath10k/sdio.c: In function
> ‘ath10k_sdio_irq_handler’:
> drivers/net/wireless/ath/ath10k/sdio.c:1331: warning: ‘ret’ may be used uninitialized in this function
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

433ef1b22678 ath10k: sdio: fix compile warning

-- 
https://patchwork.kernel.org/patch/9831499/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
