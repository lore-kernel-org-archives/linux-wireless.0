Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39529 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbcCHKcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 05:32:32 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: Fix size of wireless mode variable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1456419781-14722-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20160308103226.BDDB760897@smtp.codeaurora.org> (sfid-20160308_113640_793306_C2D57417)
Date: Tue,  8 Mar 2016 10:32:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Smatch reports the following warning:
> 
>   CHECK   drivers/net/wireless/realtek/rtlwifi/rc.c
> drivers/net/wireless/realtek/rtlwifi/rc.c:144 _rtl_rc_rate_set_series() warn: impossible condition '(wireless_mode == 256) => (0-255 == 256)'
> 
> This warning arises because commit acc6907b87a9 ("rtlwifi: Fix warning
> from ieee80211_get_tx_rates() when using 5G") now checks the wireless
> mode for WIRELESS_MODE_AC_ONLY (BIT(8)) in _rtl_rc_rate_set_series().
> As a result, all quantities used to store the wireless mode must be u16.
> 
> This patch also reorders struct rtl_sta_info to save a little space.
> 
> Fixes: d76d65fd2695 ("rtlwifi: fix broken VHT support")
> Reported-by: Dan Williams <dcbw@redhat.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
