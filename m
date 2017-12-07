Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:3220 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753003AbdLGOYJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 09:24:09 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: use 64-bit crash dump timestamps
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171127115113.2831506-1-arnd@arndb.de>
References: <20171127115113.2831506-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
CC: <y2038@lists.linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "Waldemar Rymarkiewicz" <ext.waldemar.rymarkiewicz@tieto.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
        Sarada Prasanna Garnayak <c_sgarna@qti.qualcomm.com>,
        Venkateswara Naralasetty <vnaralas@qti.qualcomm.com>,
        Marcin Rokicki <marcin.rokicki@tieto.com>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <688aa963236549dfb9561afcf7c7488a@euamsexm01a.eu.qualcomm.com> (sfid-20171207_152431_635868_76AE920F)
Date: Thu, 7 Dec 2017 15:23:51 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> The dump format uses 64-bit timestamps already, but calling
> getnstimeofday() only returns a 32-bit number on 32-bit architectures,
> so that will overflow in y2038.
> 
> This changes it to use ktime_get_real_ts64() instead.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

dafa42036012 ath10k: use 64-bit crash dump timestamps

-- 
https://patchwork.kernel.org/patch/10076697/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
