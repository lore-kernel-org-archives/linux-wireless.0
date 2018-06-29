Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56574 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932526AbeF2HJL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 03:09:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] rtlwifi: rtl8821ae: fix firmware is not ready to run
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180628020227.8776-1-pkshih@realtek.com>
References: <20180628020227.8776-1-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <linux-wireless@vger.kernel.org>, <Larry.Finger@lwfinger.net>,
        <stable@vger.kernel.org>
Message-Id: <20180629070910.A0CE760791@smtp.codeaurora.org> (sfid-20180629_090914_796479_2E5F7F27)
Date: Fri, 29 Jun 2018 07:09:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Without this patch, firmware will not run properly on rtl8821ae, and it
> causes bad user experience. For example, bad connection performance with
> low rate, higher power consumption, and so on.
> 
> rtl8821ae uses two kinds of firmwares for normal and WoWlan cases, and
> each firmware has firmware data buffer and size individually. Original
> code always overwrite size of normal firmware rtlpriv->rtlhal.fwsize, and
> this mismatch causes firmware checksum error, then firmware can't start.
> 
> In this situation, driver gives message "Firmware is not ready to run!".
> 
> Fixes: fe89707f0afa ("rtlwifi: rtl8821ae: Simplify loading of WOWLAN firmware")
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Stable <stable@vger.kernel.org> # 4.0+
> Reviewed-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers.git, thanks.

9a98302de199 rtlwifi: rtl8821ae: fix firmware is not ready to run

-- 
https://patchwork.kernel.org/patch/10492933/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
