Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48923 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab2FNILn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 04:11:43 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: set only VO as a U-APSD enabled AC
References: <1339660146-21030-1-git-send-email-arik@wizery.com>
Date: Thu, 14 Jun 2012 11:11:42 +0300
In-Reply-To: <1339660146-21030-1-git-send-email-arik@wizery.com> (Arik
	Nemtsov's message of "Thu, 14 Jun 2012 10:49:06 +0300")
Message-ID: <87ehpi5n41.fsf@purkki.adurom.net> (sfid-20120614_101215_305743_0F1DF465)
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
> ---
> Let's have another go at this :)

Looks good to me :)

>  #define IEEE80211_DEFAULT_UAPSD_QUEUES \
> -	(IEEE80211_WMM_IE_STA_QOSINFO_AC_BK |	\
> -	 IEEE80211_WMM_IE_STA_QOSINFO_AC_BE |	\
> -	 IEEE80211_WMM_IE_STA_QOSINFO_AC_VI |	\
> -	 IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
> +	IEEE80211_WMM_IE_STA_QOSINFO_AC_VO

A comment why we only enable VO would be nice.

-- 
Kalle Valo
