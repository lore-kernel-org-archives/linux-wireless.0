Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49809 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbKBIiA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:38:00 -0500
Message-ID: <1446453472.3205.3.camel@sipsolutions.net> (sfid-20151102_093804_035083_74B7EDDB)
Subject: Re: [WEXT/nl80211] few API questions
From: Johannes Berg <johannes@sipsolutions.net>
To: Gerrit Renker <gerrit@sdf.org>, linux-wireless@vger.kernel.org
Date: Mon, 02 Nov 2015 09:37:52 +0100
In-Reply-To: <20151031141057.324b3274@vaygach> (sfid-20151031_211741_208909_2F737FC0)
References: <20151031141057.324b3274@vaygach>
	 (sfid-20151031_211741_208909_2F737FC0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The iw code has been helpful, and I have used bits of it so far. When it comes
> to kernel components, though, I don't understand that code well enough; so I'd
> appreciate help with the following:
> 
>  1. Signal Level Units
>     This refers to station signal level in status ASSOCIATED, AUTHENTICATED,
>     or IBSS_JOINED.
>     
>        Q: Are the values reported via NL80211_STA_INFO_SIGNAL{,_AVG} 
>           in xxx always in dBm, or if not, what information should be used
>           (NL80211_BSS_SIGNAL_MBM, NL80211_BSS_SIGNAL_UNSPEC).
> 
>           The wext API sets the unit via iw_quality.updated flags (IW_QUAL_DBM),
>           is the same needed in nl80211?

In nl80211 you just check which kind of attributes you get.
STA_INFO_SIGNAL(_AVG) is documented to be in dBm, so it'll be missing
if the hardware doesn't report dBm. BSS_SIGNAL_* will be present
depending on what the hardware reported.

>   2. Noise Level
>      It seems that the WEXT API does no longer support reporting noise floor
>      levels (IW_QUAL_NOISE_INVALID is always set).

Very few drivers ever were really able to report it.

>        Q: Is it correct to use NL80211_SURVEY_INFO_NOISE for the active channel
>           (NL80211_SURVEY_INFO_IN_USE) as replacement (header says it is dBm)?

Perhaps, I'm not really sure.

>  3. Link Quality
>     WEXT has the concept of a link quality metric (iw_quality.qual).
> 
>        Q: Given access to signal levels in dBm or mBm, looking at
>           cfg80211_wireless_stats(); would be correct to replace the call to
>           SIOCGIWSTATS by using the nl80211 values in (1) and simply
>           interpret -110dBm and -40dBm as ends of a quality scale from 0..70?

Well, that's one interpretation we made, a few drivers were doing it
that way, so we put that into the wext backward compatibility code.
There are possibly other things you could take into account (bitrate,
noise floor, ...) but we didn't want a complex algorithm for wext.

johannes
