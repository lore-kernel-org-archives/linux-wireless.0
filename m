Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37104 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754467AbeFMMm6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 08:42:58 -0400
Message-ID: <1528893775.1637.0.camel@sipsolutions.net> (sfid-20180613_144301_974100_67F98050)
Subject: Re: [PATCH 1/3] net: use BIT_ULL for NL80211_STA_INFO_* attribute
 types
From: Johannes Berg <johannes@sipsolutions.net>
To: Omer Efrat <omer.efrat@tandemg.com>, linux-wireless@vger.kernel.org
Date: Wed, 13 Jun 2018 14:42:55 +0200
In-Reply-To: <1528273621-28116-1-git-send-email-omer.efrat@tandemg.com> (sfid-20180606_102723_958302_FE904769)
References: <1528273621-28116-1-git-send-email-omer.efrat@tandemg.com>
         (sfid-20180606_102723_958302_FE904769)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-06-06 at 11:26 +0300, Omer Efrat wrote:
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
> 
Looks good, but can you please split it? I don't want to take batman
changes, and they probably don't want to take my mac80211 - unless davem
decides to take it all?

johannes
