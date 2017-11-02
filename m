Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33736 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933508AbdKBO5t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 10:57:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Karun Eagalapati <karun256@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rsi: sdio: fix building without CONFIG_PM
References: <20171102142827.773188-1-arnd@arndb.de>
Date: Thu, 02 Nov 2017 16:57:42 +0200
In-Reply-To: <20171102142827.773188-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Thu, 2 Nov 2017 15:28:07 +0100")
Message-ID: <87r2tglod5.fsf@codeaurora.org> (sfid-20171102_155826_895172_38187ADB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> The addition of the WoWLAN support has caused a number of new
> build errors when CONFIG_PM is disabled, including:
>
> drivers/net/wireless/rsi/rsi_91x_mac80211.c: In function 'rsi_wow_map_triggers':
> drivers/net/wireless/rsi/rsi_91x_mac80211.c:1773:19: error: 'RSI_WOW_ANY' undeclared (first use in this function); did you mean 'RSI_WEP_KEY'?
> drivers/net/wireless/rsi/rsi_91x_mac80211.c: In function 'rsi_mac80211_attach':
> drivers/net/wireless/rsi/rsi_91x_mac80211.c:1980:7: error: 'struct wiphy' has no member named 'wowlan'
>
> This adds more #ifdef CONFIG_PM guards around the code that otherwise
> fails to build and that we know is not used without CONFIG_PM.
>
> Fixes: f3ac4e7394a1 ("rsi: sdio: add WOWLAN support for S3 suspend state")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Amit already submitted two patches to fix this problem:

https://patchwork.kernel.org/patch/10036297/

https://patchwork.kernel.org/patch/10036299/

I applied them to my pending branch yesterday, and at least buildbot
seems to be happy, so I'm planning take apply those instead. Please let
me know if that's a problem.

-- 
Kalle Valo
