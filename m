Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48788 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753630AbeBGNjl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 08:39:41 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8821ae: Fix connection lost problem correctly
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180205183811.19526-1-Larry.Finger@lwfinger.net>
References: <20180205183811.19526-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Message-Id: <20180207133941.0D9FE60767@smtp.codeaurora.org> (sfid-20180207_143945_595884_29891E11)
Date: Wed,  7 Feb 2018 13:39:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

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
> Tested-by: James Cameron <quozl@laptop.org>  # x86_64 OLPC NL3

Patch applied to wireless-drivers-next.git, thanks.

c713fb071edc rtlwifi: rtl8821ae: Fix connection lost problem correctly

-- 
https://patchwork.kernel.org/patch/10201247/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
