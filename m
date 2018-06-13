Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48086 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935251AbeFMLfI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 07:35:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/3] wireless-drivers: use BIT_ULL for NL80211_STA_INFO_*
 attribute types
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1528273621-28116-2-git-send-email-omer.efrat@tandemg.com>
References: <1528273621-28116-2-git-send-email-omer.efrat@tandemg.com>
To: Omer Efrat <omer.efrat@tandemg.com>
Cc: linux-wireless@vger.kernel.org, Omer Efrat <omer.efrat@tandemg.com>
Message-Id: <20180613113507.C548B602FC@smtp.codeaurora.org> (sfid-20180613_133600_429252_BEA7E022)
Date: Wed, 13 Jun 2018 11:35:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Omer Efrat <omer.efrat@tandemg.com> wrote:

> Since 'filled' member in station_info changed to u64, BIT_ULL macro
> should be used with NL80211_STA_INFO_* attribute types instead of BIT.
> 
> The BIT macro uses unsigned long type which some architectures handle as 32bit
> and this results in compilation warnings such as:
> 
> net/mac80211/sta_info.c:2223:2: warning: left shift count >= width of type
>   sinfo->filled |= BIT(NL80211_STA_INFO_TID_STATS);
>   ^
> 
> Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>

Can I take this patch 2 or is it going via some other tree?

-- 
https://patchwork.kernel.org/patch/10449829/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
