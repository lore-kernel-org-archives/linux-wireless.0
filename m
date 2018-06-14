Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52842 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755073AbeFNLGR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 07:06:17 -0400
Message-ID: <1528974375.26847.1.camel@sipsolutions.net> (sfid-20180614_130625_355349_0E5970E1)
Subject: Re: [PATCH v2 1/5] cfg80211: use BIT_ULL for NL80211_STA_INFO_*
 attribute types
From: Johannes Berg <johannes@sipsolutions.net>
To: Omer Efrat <omer.efrat@tandemg.com>, linux-wireless@vger.kernel.org
Date: Thu, 14 Jun 2018 13:06:15 +0200
In-Reply-To: <1528971063-32764-1-git-send-email-omer.efrat@tandemg.com> (sfid-20180614_121121_151470_A6E7ECB5)
References: <1528971063-32764-1-git-send-email-omer.efrat@tandemg.com>
         (sfid-20180614_121121_151470_A6E7ECB5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-06-14 at 13:11 +0300, Omer Efrat wrote:
> Since 'filled' member in station_info changed to u64, BIT_ULL macro
> should be used with NL80211_STA_INFO_* attribute types instead of BIT.
> 
> The BIT macro uses unsigned long type which some architectures handle as 32bit
> and this results in compilation warnings such as:
> 
> net/mac80211/sta_info.c:2223:2: warning: left shift count >= width of type
>   sinfo->filled |= BIT(NL80211_STA_INFO_TID_STATS);
>   ^

Actually ... This patch isn't needed. The one thing that needed fixing
is BIT(NL80211_STA_INFO_TID_STATS) you point out there, but the others
are fine as BIT().

johannes
