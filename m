Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50897 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbcCGMis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 07:38:48 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix size of wireless mode variable
References: <1456419781-14722-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Mon, 07 Mar 2016 14:38:41 +0200
In-Reply-To: <1456419781-14722-1-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Thu, 25 Feb 2016 11:03:01 -0600")
Message-ID: <87pov6tqcu.fsf@kamboji.qca.qualcomm.com> (sfid-20160307_133851_179594_4FCFD2A6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

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
> Fixes: commit acc6907b87a9 ("rtlwifi: Fix warning from ieee80211_get_tx_rates() when using 5G")
> Reported-by: Dan Williams <dcbw@redhat.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

I can't find commit acc6907b87a9 from any of my trees. And oddly enough
I can't either any commits with title "rtlwifi: Fix warning from
ieee80211_get_tx_rates() when using 5G". I can fix it before commiting
but what should I use?

Also the fixes line should not have the word "commit".

-- 
Kalle Valo
