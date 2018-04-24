Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42888 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754498AbeDXKQT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 06:16:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rtlwifi: cleanup 8723be ant_sel definition
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180420023009.3182-1-pkshih@realtek.com>
References: <20180420023009.3182-1-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <stable@vger.kernel.org>
Message-Id: <20180424101618.E9D0260863@smtp.codeaurora.org> (sfid-20180424_121623_773807_2B8D55A5)
Date: Tue, 24 Apr 2018 10:16:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Some HP laptops have only a single wifi antenna. This would not be a
> problem except that they were shipped with an incorrectly encoded
> EFUSE. It should have been possible to open the computer and transfer
> the antenna connection to the other terminal except that such action
> might void the warranty, and moving the antenna broke the Windows
> driver. The fix was to add a module option that would override the
> EFUSE encoding. That was done with commit c18d8f509571 ("rtlwifi:
> rtl8723be: Add antenna select module parameter"). There was still a
> problem with Bluetooth coexistence, which was addressed with commit
> baa170229095 ("rtlwifi: btcoexist: Implement antenna selection").
> There were still problems, thus there were commit 0ff78adeef11
> ("rtlwifi: rtl8723be: fix ant_sel code") and commit 6d6226928369
> ("rtlwifi: btcoexist: Fix antenna selection code"). Despite all these
> attempts at fixing the problem, the code is not yet right. A proper
> fix is important as there are now instances of laptops having
> RTL8723DE chips with the same problem.
> 
> The module parameter ant_sel is used to control antenna number and path.
> At present enum ANT_{X2,X1} is used to define the antenna number, but
> this choice is not intuitive, thus change to a new enum ANT_{MAIN,AUX}
> to make it more readable. This change showed examples where incorrect
> values were used. It was also possible to remove a workaround in
> halbtcoutsrc.c.
> 
> The experimental results with single antenna connected to specific path
> are now as follows:
>   ant_sel  ANT_MAIN(#1)  ANT_AUX(#2)
>      0        -8            -62
>      1        -62           -10
>      2        -6            -60
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Fixes: c18d8f509571 ("rtlwifi: rtl8723be: Add antenna select module parameter")
> Fixes: baa170229095 ("rtlwifi: btcoexist: Implement antenna selection")
> Fixes: 0ff78adeef11 ("rtlwifi: rtl8723be: fix ant_sel code")
> Fixes: 6d6226928369 ("rtlwifi: btcoexist: Fix antenna selection code")
> Cc: Stable <stable@vger.kernel.org> # 4.7+
> Reviewed-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers.git, thanks.

af8a41cccf8f rtlwifi: cleanup 8723be ant_sel definition

-- 
https://patchwork.kernel.org/patch/10351789/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
