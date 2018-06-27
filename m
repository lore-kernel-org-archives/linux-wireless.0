Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:36994 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752898AbeF0NgY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 09:36:24 -0400
Received: by mail-ot0-f195.google.com with SMTP id q11-v6so2404otk.4
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2018 06:36:23 -0700 (PDT)
Subject: Re: [PATCH v2] rtlwifi: rtl8821ae: fix firmware is not ready to run
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180627080130.12195-1-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <834573bf-fb52-2476-fb35-96127532924d@lwfinger.net> (sfid-20180627_153628_245781_7B71B8A4)
Date: Wed, 27 Jun 2018 08:36:22 -0500
MIME-Version: 1.0
In-Reply-To: <20180627080130.12195-1-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/27/2018 03:01 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
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
> ---
> v2: fix commit log typo.
> ---
>   drivers/net/wireless/realtek/rtlwifi/core.c | 1 -
>   1 file changed, 1 deletion(-)

This change is a good one, and I approve of it. The only change is that it 
should have a Cc to stable as this code was added in kernel 4.0!

Larry
