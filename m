Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:32920 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbeAQK02 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 05:26:28 -0500
Received: by mail-qk0-f195.google.com with SMTP id i141so24610352qke.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jan 2018 02:26:28 -0800 (PST)
Subject: Re: [PATCH v3 04/10] rtlwifi: enable mac80211 fast-tx support
To: pkshih@realtek.com, kvalo@codeaurora.org
References: <20180117061530.30049-1-pkshih@realtek.com>
 <20180117061530.30049-5-pkshih@realtek.com>
Cc: Larry.Finger@lwfinger.net, yhchuang@realtek.com,
        linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A5F24D1.2080709@broadcom.com> (sfid-20180117_112632_968898_97647EFB)
Date: Wed, 17 Jan 2018 11:26:25 +0100
MIME-Version: 1.0
In-Reply-To: <20180117061530.30049-5-pkshih@realtek.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/17/2018 7:15 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
>
> To enable the mac80211 fast-tx feature, the hw/driver needs to support
> dynamic power saving and fragmentation. Since our driver does not
> need to fragment packet into smaller pieces, we just hook an empty
> callback of set_frag_threshold to avoid fragmentation in mac80211.
>
> After this, the mac80211 will not fragment the packets and can transmit
> them faster by cache the header information.

NACK. Please refer to earlier discussion [1].

Regards,
Arend

[1] https://patchwork.kernel.org/patch/10157389/

> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/base.c | 2 ++
>   drivers/net/wireless/realtek/rtlwifi/core.c | 6 ++++++
>   2 files changed, 8 insertions(+)
