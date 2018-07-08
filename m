Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:42857 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753825AbeGHQaJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Jul 2018 12:30:09 -0400
Subject: Re: [PATCH] staging: r8822be: Fix RTL8822be can't find any wireless
 AP
To: pkshih@realtek.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        jian-hong@endlessm.com
References: <20180706054435.3732-1-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <63971c24-d99d-459e-fb9a-df583c5a89d6@lwfinger.net> (sfid-20180708_183041_564256_81BC0B3B)
Date: Sun, 8 Jul 2018 11:30:08 -0500
MIME-Version: 1.0
In-Reply-To: <20180706054435.3732-1-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/06/2018 12:44 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> RTL8822be can't bring up properly on ASUS X530UN, and dmesg says:
> [ 8.591333] r8822be: module is from the staging directory, the quality
> is unknown, you have been warned.
> [ 8.593122] r8822be 0000:02:00.0: enabling device (0000 -> 0003)
> [ 8.669163] r8822be: Using firmware rtlwifi/rtl8822befw.bin
> [ 9.289939] r8822be: rtlwifi: wireless switch is on
> [ 10.056426] r8822be 0000:02:00.0 wlp2s0: renamed from wlan0
> ...
> [ 11.952534] r8822be: halmac_init_hal failed
> [ 11.955933] r8822be: halmac_init_hal failed
> [ 11.956227] r8822be: halmac_init_hal failed
> [ 22.007942] r8822be: halmac_init_hal failed
> 
> Jian-Hong reported it works if turn off ASPM with module parameter aspm=0.
> In order to fix this problem kindly, this commit don't turn off aspm but
> enlarge ASPM L1 latency to 7.
> 
> Reported-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Tested-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

This patch definitely needs a Cc for stable. Otherwise I ACK it.

Larry
