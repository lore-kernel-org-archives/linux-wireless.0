Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab2CHQNm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 11:13:42 -0500
Subject: Re: [PATCH 4/6] mac80211: remove spurious BSSID change flag
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Sujith <m.sujith@gmail.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
In-Reply-To: <20120308140227.133587480@sipsolutions.net> (sfid-20120308_150328_058540_9FB5A49A)
References: <20120308140202.751490800@sipsolutions.net>
	 <20120308140227.133587480@sipsolutions.net>
	 (sfid-20120308_150328_058540_9FB5A49A)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Mar 2012 17:13:37 +0100
Message-ID: <1331223217.1598.1.camel@jlt3.sipsolutions.net> (sfid-20120308_171346_064648_0FAF4E13)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The BSSID has been set a lot earlier already and
> didn't change again in ieee80211_set_associated().
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/mlme.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> --- a/net/mac80211/mlme.c	2012-03-08 13:55:16.000000000 +0100
> +++ b/net/mac80211/mlme.c	2012-03-08 13:55:22.000000000 +0100
> @@ -1351,9 +1351,6 @@ static void ieee80211_set_associated(str
>  	 */
>  	bss_info_changed |= BSS_CHANGED_BASIC_RATES;
>  
> -	/* And the BSSID changed - we're associated now */
> -	bss_info_changed |= BSS_CHANGED_BSSID;

Sujith tells me that this will break ath9k -- Rajkumar, can you take a
look at this? Before your commit 99e4d43ad5ff5778f92ee3bc40a29a ath9k
did listen to BSS_CHANGED_ASSOC -- it seems like it should again?

johannes

