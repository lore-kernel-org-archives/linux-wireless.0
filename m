Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52057 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbcCWPxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 11:53:18 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: fix gcc-6 indentation warning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1458209066-3979295-1-git-send-email-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20160323155317.53EB26022C@smtp.codeaurora.org> (sfid-20160323_165338_379128_A3AA0EA1)
Date: Wed, 23 Mar 2016 15:53:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The rtl8821ae_dm_txpower_tracking_callback_thermalmeter function
> contains a call to RT_TRACE() that is indented in a misleading
> way, as pointed out by a gcc-6 warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c: In function 'rtl8821ae_dm_txpower_tracking_callback_thermalmeter':
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c:2491:4: error: statement is indented as if it were guarded by...
>     RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
>     ^~~~~~~~
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c:2488:3: note: ...this 'for' clause, but it is not
>    for (p = RF90_PATH_A; p < MAX_PATH_NUM_8821A; p++)
>    ^~~
> 
> It is clear from the context that the call was not meant to be
> part of the loop and only the indentation is wrong, so this
> removes the extra tabs.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers.git.

Kalle Valo
