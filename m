Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59114 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbeDSJwe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 05:52:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: cleanup 8723be ant_sel definition
References: <20180419083100.5254-1-pkshih@realtek.com>
Date: Thu, 19 Apr 2018 12:52:28 +0300
In-Reply-To: <20180419083100.5254-1-pkshih@realtek.com> (pkshih@realtek.com's
        message of "Thu, 19 Apr 2018 16:31:00 +0800")
Message-ID: <87k1t3mskj.fsf@kamboji.qca.qualcomm.com> (sfid-20180419_115237_684616_378E0816)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<pkshih@realtek.com> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> The module parameter ant_sel is used to control antenna number and path.
> There is an existing enum ANT_{X2,X1} defined the antenna number, so
> add a new enum ANT_{MAIN,AUX} to make it readable. After this work,
> incorrect given values depend on ant_sel were exposed, so refill values
> according following definition:
>   ant_sel   ant_num   ant_path  print_label
>      1      ANT_X1    ANT_AUX        #2
>      2      ANT_X2    ANT_MAIN       #1
> Then, the workaround in halbtcoutsrc.c was removed.
>
> The experimental results with single antenna connected to specific path
> are in following:
>   ant_sel  ANT_MAIN(#1)  ANT_AUX(#2)
>      0        -8            -62
>      1        -62           -10
>      2        -6            -60
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Stable <stable@vger.kernel.org> # 4.7+
> Reviewed-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> Hi Kalle,
>
> This patch would send to 4.17.

For -rc releases I require a quite clear bug report but I do not
understand what you are fixing here, even after reading the commit log
twice. Could you try to improve it? Especially focus on describing the
bug in simple terms and how this patch changes the functionality from
user's point of view.

-- 
Kalle Valo
