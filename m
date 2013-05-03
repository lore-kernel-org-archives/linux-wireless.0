Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761723Ab3ECM4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 08:56:42 -0400
Message-ID: <1367585797.13104.23.camel@jlt4.sipsolutions.net> (sfid-20130503_145646_255139_1416A3B8)
Subject: Re: Does mac80211 support use of WIPHY_FLAG_SUPPORTS_FW_ROAM?
From: Johannes Berg <johannes@sipsolutions.net>
To: m.fitzjohn@samsung.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 03 May 2013 14:56:37 +0200
In-Reply-To: <006d01ce47fc$76a61690$63f243b0$%fitzjohn@samsung.com> (sfid-20130503_144817_713432_206EE938)
References: <006d01ce47fc$76a61690$63f243b0$%fitzjohn@samsung.com>
	 (sfid-20130503_144817_713432_206EE938)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The short answer to your question is: no.

> I know that we need to set the WIPHY_FLAG_SUPPORTS_FW_ROAMING but I'm not
> sure if anything else needs to be signalled (called) in to mac80211?
> 
> I've seen calls to cfg80211_roamed_bss which gets the roamed indication out
> to the user space but do we need to use this as well?
> 
> Can anyone explain?

The longer answer is that mac80211 doesn't use the connect API, it
implements the MLME itself. Roaming in firmware isn't just that, it's
much much more complex. Think of the AP station entry getting updated
(mac80211 would have to do this!), the new QoS/WMM parameters,
BSSID, ...

If you have roaming in your firmware, then you must have the MLME in the
firmware as well. Then, why are you using mac80211? Clearly not for the
MLME, but then what for instead? Maybe what you really want instead is
to do some (really really big!) refactoring on the datapath?

johannes

