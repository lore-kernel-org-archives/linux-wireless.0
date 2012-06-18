Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:55797 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab2FRHXK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 03:23:10 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: set only VO as a U-APSD enabled AC
References: <1340003971-7037-1-git-send-email-arik@wizery.com>
Date: Mon, 18 Jun 2012 10:23:09 +0300
In-Reply-To: <1340003971-7037-1-git-send-email-arik@wizery.com> (Arik
	Nemtsov's message of "Mon, 18 Jun 2012 10:19:31 +0300")
Message-ID: <87aa015bj6.fsf@purkki.adurom.net> (sfid-20120618_092313_464036_92F13FEA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arik Nemtsov <arik@wizery.com> writes:

> Some APs experience problems when working with U-APSD. Decrease the
> probability of that happening by using legacy mode for all ACs but VO.
>
> The AP that caused us troubles was a Cisco 4410N. It ignores our
> setting, and always treats non-VO ACs as legacy.
>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>

[...]

> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -56,10 +56,7 @@ struct ieee80211_local;
>  #define TU_TO_EXP_TIME(x)	(jiffies + TU_TO_JIFFIES(x))
>  
>  #define IEEE80211_DEFAULT_UAPSD_QUEUES \
> -	(IEEE80211_WMM_IE_STA_QOSINFO_AC_BK |	\
> -	 IEEE80211_WMM_IE_STA_QOSINFO_AC_BE |	\
> -	 IEEE80211_WMM_IE_STA_QOSINFO_AC_VI |	\
> -	 IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
> +	IEEE80211_WMM_IE_STA_QOSINFO_AC_VO

Am I in your kill file now? :)

http://www.spinics.net/lists/linux-wireless/msg92159.html

-- 
Kalle Valo
