Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab2LLWIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 17:08:11 -0500
Message-ID: <1355350115.9708.21.camel@jlt4.sipsolutions.net> (sfid-20121212_230815_476624_826BD591)
Subject: Re: [RFC 2/6] wifi: Don't spam logs with 'Found new beacon'
 messages.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Dec 2012 23:08:35 +0100
In-Reply-To: <1355349295-30960-2-git-send-email-greearb@candelatech.com> (sfid-20121212_225535_981449_212B81FE)
References: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
	 <1355349295-30960-2-git-send-email-greearb@candelatech.com>
	 (sfid-20121212_225535_981449_212B81FE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 13:54 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> We saw logs fill with this (at very high speeds):
> 
> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on wiphy0
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  net/wireless/reg.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 6e53089..8aa7867 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -2067,11 +2067,12 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
>  	if (!reg_beacon)
>  		return -ENOMEM;
>  
> -	REG_DBG_PRINT("Found new beacon on "

Why not just disable the config option for it if you don't care?

johannes

