Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57254 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaEGPtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 11:49:20 -0400
MIME-Version: 1.0
In-Reply-To: <1399097729.5873.2.camel@dubbel>
References: <1399041597-27409-1-git-send-email-standby24x7@gmail.com>
	<1399041597-27409-2-git-send-email-standby24x7@gmail.com>
	<1399097729.5873.2.camel@dubbel>
Date: Thu, 8 May 2014 00:49:17 +0900
Message-ID: <CALLJCT2Y=0v7m0hSSBTaAQMqeNCfyXQS=S8pEERYev9YuyUqhw@mail.gmail.com> (sfid-20140507_174928_243716_33281D14)
Subject: Re: [PATCH] cfg80211/mac80211: Fix warning on make xmldocs caused by cfg80211.h
From: Masanari Iida <standby24x7@gmail.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: johannes.berg@intel.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
Your patch fixed the symptom.
I have tested it on linux-next as of 7th/May.
Thank you.

Tested-by: Masanari Iida <standby24x7@gmail.com>

Regards,
Masanari

On Sat, May 3, 2014 at 3:15 PM, Luciano Coelho <luciano.coelho@intel.com> wrote:
> Hi,
>
> A better way to fix this would be to add "iftype" to the function
> prototype, since we don't usually use nameless arguments:
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 43c674e..f9e7373 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -458,7 +458,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
>   */
>  int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
>                                   const struct cfg80211_chan_def *chandef,
> -                                 enum nl80211_iftype);
> +                                 enum nl80211_iftype iftype);
>
>  /**
>   * ieee80211_chandef_rate_flags - returns rate flags for a channel
>
> --
> Cheers,
> Luca.
>
