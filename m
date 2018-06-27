Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54408 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934246AbeF0QIX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 12:08:23 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,
 4/5] wireless-drivers: use BIT_ULL for NL80211_STA_INFO_ attribute
 types
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1529230033-17948-1-git-send-email-omer.efrat@tandemg.com>
References: <1529230033-17948-1-git-send-email-omer.efrat@tandemg.com>
To: Omer Efrat <omer.efrat@tandemg.com>
Cc: linux-wireless@vger.kernel.org, Omer Efrat <omer.efrat@tandemg.com>
Message-Id: <20180627160822.8FF6160B18@smtp.codeaurora.org> (sfid-20180627_180826_773820_17EA37F1)
Date: Wed, 27 Jun 2018 16:08:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Omer Efrat <omer.efrat@tandemg.com> wrote:

> The BIT macro uses unsigned long which some architectures handle as 32 bit
> and therefore might cause macro's shift to overflow when used on a value
> equals or larger than 32 (NL80211_STA_INFO_RX_DURATION and afterwards).
> 
> Since 'filled' member in station_info changed to u64, BIT_ULL macro
> should be used with all NL80211_STA_INFO_* attribute types instead of BIT
> to prevent future possible bugs when one will use BIT macro for higher
> attributes by mistake.
> 
> This commit cleans up all usages of BIT macro with the above field
> in wireless-drivers by changing it to BIT_ULL instead. In addition, there are
> some places which don't use BIT nor BIT_ULL macros so align those as well.
> 
> Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>

Patch applied to wireless-drivers-next.git, thanks.

22d0d2fafca9 wireless-drivers: use BIT_ULL for NL80211_STA_INFO_ attribute types

-- 
https://patchwork.kernel.org/patch/10468745/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
