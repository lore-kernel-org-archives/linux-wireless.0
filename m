Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53618 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932132AbeB0QSS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:18:18 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8192cu: remove pointless memcpy
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180209132531.2755482-1-arnd@arndb.de>
References: <20180209132531.2755482-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ping-Ke Shih <pkshih@realtek.com>, Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20180227161817.C4BD36070A@smtp.codeaurora.org> (sfid-20180227_171836_767125_EB6A32AF)
Date: Tue, 27 Feb 2018 16:18:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> gcc-8 points out that source and destination of the memcpy() are
> always the same pointer, so the effect of memcpy() is undefined
> here (its arguments must not overlap):
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c: In function '_rtl_rx_process':
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c:430:2: error: 'memcpy' source argument is the same as destination [-Werror=restrict]
> 
> Most likely this is harmless, but it's easy to just remove the
> line and get rid of the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

dcdd54c2bcae rtlwifi: rtl8192cu: remove pointless memcpy

-- 
https://patchwork.kernel.org/patch/10208979/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
