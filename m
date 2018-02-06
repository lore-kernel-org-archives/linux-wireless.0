Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.media.mit.edu ([18.85.44.157]:44329 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752132AbeBFEeh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Feb 2018 23:34:37 -0500
Date: Tue, 6 Feb 2018 15:34:30 +1100
From: James Cameron <quozl@laptop.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8821ae: Fix connection lost problem correctly
Message-ID: <20180206043430.GF31854@us.netrek.org> (sfid-20180206_053441_215412_B0EACE51)
References: <20180205183811.19526-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180205183811.19526-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 05, 2018 at 12:38:11PM -0600, Larry Finger wrote:
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

Tested-by: James Cameron <quozl@laptop.org>  # x86_64 OLPC NL3

Thanks Larry & Pkshih, this does work as well as it did before.

-- 
James Cameron
http://quozl.netrek.org/
