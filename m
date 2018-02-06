Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55750 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751624AbeBFOE6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Feb 2018 09:04:58 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8821ae: Fix connection lost problem correctly
References: <20180205183811.19526-1-Larry.Finger@lwfinger.net>
Date: Tue, 06 Feb 2018 16:04:52 +0200
In-Reply-To: <20180205183811.19526-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Mon, 5 Feb 2018 12:38:11 -0600")
Message-ID: <87zi4mgqnv.fsf@kamboji.qca.qualcomm.com> (sfid-20180206_150501_993467_BE7E5DAF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> There has been a coding error in rtl8821ae since it was first introduced,
> namely that an 8-bit register was read using a 16-bit read in
> _rtl8821ae_dbi_read(). This error was fixed with commit 40b368af4b75
> ("rtlwifi: Fix alignment issues"); however, this change led to
> instability in the connection. To restore stability, this change
> was reverted in commit b8b8b16352cd ("rtlwifi: rtl8821ae: Fix connection
> lost problem").
>
> Unfortunately, the unaligned access causes machine checks in ARM
> architecture, and we were finally forced to find the actual cause of the
> problem on x86 platforms. Following a suggestion from Pkshih
> <pkshih@realtek.com>, it was found that increasing the ASPM L1
> latency from 0 to 7 fixed the instability. This parameter was varied to
> see if a smaller value would work; however, it appears that 7 is the
> safest value. A new symbol is defined for this quantity, thus it can be
> easily changed if necessary.
>
> Fixes: b8b8b16352cd ("rtlwifi: rtl8821ae: Fix connection lost problem")
> Cc: Stable <stable@vger.kernel.org> # 4.14+
> Fix-suggested-by: Pkshih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> Kalle,
>
> This patch should be submitted to 4.16.

Ok, I'll queue this to 4.16.

-- 
Kalle Valo
