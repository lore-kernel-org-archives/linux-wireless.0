Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:52265 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842AbXKGQpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 11:45:38 -0500
Message-ID: <4731EBAC.8040502@lwfinger.net> (sfid-20071107_164557_624336_168385A9)
Date: Wed, 07 Nov 2007 10:45:32 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix MAC80211_RCSIMPLE Kconfig
References: <4731D9CC.3090809@lwfinger.net> <1194450073.4470.46.camel@johannes.berg>
In-Reply-To: <1194450073.4470.46.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> I meant for this to be selectable only with EMBEDDED, not enabled only
> with EMBEDDED. This does it that way. Sorry.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- everything.orig/net/mac80211/Kconfig	2007-11-07 16:38:57.779051161 +0100
> +++ everything/net/mac80211/Kconfig	2007-11-07 16:39:06.949024631 +0100
> @@ -14,9 +14,9 @@ config MAC80211
>  	networking stack.
>  
>  config MAC80211_RCSIMPLE
> -	bool "'simple' rate control algorithm"
> +	bool "'simple' rate control algorithm" if EMBEDDED
>  	default y
> -	depends on MAC80211 && EMBEDDED
> +	depends on MAC80211
>  	help
>  	  This option allows you to turn off the 'simple' rate
>  	  control algorithm in mac80211. If you do turn it off,

This one works here. ACK for non-embedded system.

Larry
