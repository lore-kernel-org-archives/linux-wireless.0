Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52858 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754809AbeFNLII (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 07:08:08 -0400
Message-ID: <1528974485.26847.3.camel@sipsolutions.net> (sfid-20180614_130811_796047_F74CC080)
Subject: Re: [PATCH v2 2/5] mac80211: use BIT_ULL for NL80211_STA_INFO_*
 attribute types
From: Johannes Berg <johannes@sipsolutions.net>
To: Omer Efrat <omer.efrat@tandemg.com>, linux-wireless@vger.kernel.org
Date: Thu, 14 Jun 2018 13:08:05 +0200
In-Reply-To: <1528971073-349-1-git-send-email-omer.efrat@tandemg.com> (sfid-20180614_121125_842548_E3DF065D)
References: <1528971073-349-1-git-send-email-omer.efrat@tandemg.com>
         (sfid-20180614_121125_842548_E3DF065D)
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

It seems like the only change needed is with
BIT(NL80211_STA_INFO_TID_STATS), so I'd argue you should restrict the
patch to that.


Perhaps, though I'm not sure I see it, there's some value in switching
them all so that if you copy something and change it to a new value you
don't run into this problem again, but if anything that should be (a)
separate patch(es) since this one is a bugfix and the others aren't.

johannes
