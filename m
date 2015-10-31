Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from odin.sdf-eu.org ([178.63.35.194]:55278 "EHLO sdfeu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbbJaURh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2015 16:17:37 -0400
Received: from vaygach (199-119-235-162.eng.wind.ca [199.119.235.162] (may be forged))
	(authenticated (0 bits))
	by sdfeu.org (8.14.8/8.14.3) with ESMTP id t9VK6snM016548
	(using TLSv1/SSLv3 with cipher AES128-GCM-SHA256 (128 bits) verified NO)
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2015 20:06:58 GMT
Date: Sat, 31 Oct 2015 14:10:57 -0600
From: Gerrit Renker <gerrit@sdf.org>
To: linux-wireless@vger.kernel.org
Subject: [WEXT/nl80211] few API questions
Message-ID: <20151031141057.324b3274@vaygach> (sfid-20151031_211741_208909_2F737FC0)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a few short nl80211 API questions to help convert a userland
program from WEXT to nl80211 [1].

The iw code has been helpful, and I have used bits of it so far. When it comes
to kernel components, though, I don't understand that code well enough; so I'd
appreciate help with the following:

 1. Signal Level Units
    This refers to station signal level in status ASSOCIATED, AUTHENTICATED,
    or IBSS_JOINED.
    
       Q: Are the values reported via NL80211_STA_INFO_SIGNAL{,_AVG} 
          in xxx always in dBm, or if not, what information should be used
          (NL80211_BSS_SIGNAL_MBM, NL80211_BSS_SIGNAL_UNSPEC).

          The wext API sets the unit via iw_quality.updated flags (IW_QUAL_DBM),
          is the same needed in nl80211?

  2. Noise Level
     It seems that the WEXT API does no longer support reporting noise floor
     levels (IW_QUAL_NOISE_INVALID is always set).

       Q: Is it correct to use NL80211_SURVEY_INFO_NOISE for the active channel
          (NL80211_SURVEY_INFO_IN_USE) as replacement (header says it is dBm)?
          
 3. Link Quality
    WEXT has the concept of a link quality metric (iw_quality.qual).

       Q: Given access to signal levels in dBm or mBm, looking at
          cfg80211_wireless_stats(); would be correct to replace the call to
          SIOCGIWSTATS by using the nl80211 values in (1) and simply
          interpret -110dBm and -40dBm as ends of a quality scale from 0..70?


Thanks in advance,
Gerrit

 [1] https://github.com/uoaerg/wavemon/tree/development
