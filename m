Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52906 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754782AbeFNLJh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 07:09:37 -0400
Message-ID: <1528974574.26847.4.camel@sipsolutions.net> (sfid-20180614_130940_742597_C014D2C2)
Subject: Re: [PATCH v2 5/5] staging: use BIT_ULL for NL80211_STA_INFO_*
 attribute types
From: Johannes Berg <johannes@sipsolutions.net>
To: Omer Efrat <omer.efrat@tandemg.com>, linux-wireless@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Date: Thu, 14 Jun 2018 13:09:34 +0200
In-Reply-To: <1528971217-566-1-git-send-email-omer.efrat@tandemg.com> (sfid-20180614_121347_502894_F98D1325)
References: <1528971217-566-1-git-send-email-omer.efrat@tandemg.com>
         (sfid-20180614_121347_502894_F98D1325)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-06-14 at 13:13 +0300, Omer Efrat wrote:
> Since 'filled' member in station_info changed to u64, BIT_ULL macro
> should be used with NL80211_STA_INFO_* attribute types instead of BIT.
> 
> The BIT macro uses unsigned long type which some architectures handle as 32bit
> and this results in compilation warnings such as:
> 
> net/mac80211/sta_info.c:2223:2: warning: left shift count >= width of type
>   sinfo->filled |= BIT(NL80211_STA_INFO_TID_STATS);
>   ^

Same here, I don't think this patch is really needed, but I'll leave it
up to Greg.

Greg, FWIW, only a few values are >=31 to need this, including the one
pointed out in the commit message, but none in this code are affected.

johannes
