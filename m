Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38009 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054AbaCSOWS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:22:18 -0400
Message-ID: <1395238934.4142.22.camel@jlt4.sipsolutions.net> (sfid-20140319_152221_926466_2421DAED)
Subject: Re: [PATCH] mac80211: don't downgrade VHT20 to HT20
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 19 Mar 2014 15:22:14 +0100
In-Reply-To: <CA+BoTQnvSxOCxV4UwUmi2_if8NQWWJCht=urAewBZAiEJdHpZA@mail.gmail.com> (sfid-20140225_141121_872159_6A96AC3B)
References: <1393327628-1078-1-git-send-email-michal.kazior@tieto.com>
	 <1393330040.4170.0.camel@jlt4.sipsolutions.net>
	 <1393330210.4170.1.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnvSxOCxV4UwUmi2_if8NQWWJCht=urAewBZAiEJdHpZA@mail.gmail.com>
	 (sfid-20140225_141121_872159_6A96AC3B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the delay. Somehow I thought this was addressed, but I'm
confused.

I think we all agree that the spec says:

> > A VHT STA shall set the Supported Channel Width Set subfield in its HT
> > Capabilities element HT Capabilities Info field to 1, indicating that
> > both 20 MHz operation and 40 MHz operation are supported.

and that the station should therefore set the 20_40 capability bit in
the association response?

> The spec also defines VHT BSS operating channel width is derived from
> HT Operation Element: STA Channel Width field (Table 10-19) and 20 MHz
> is not forbidden for AP/mesh. hostapd seems to go in line with this
> and allows VHT20 and VHT40.

Yes but how is that related to the *capability* bit? You're talking
about the HT/VHT operation information.

> Without my patch (i.e. with the 20/40 check left intact):
> 
> * If a station connects to VHT20 BSS, hostapd tries to add a VHT20
> station, but mac80211 downgrades it to HT20,
> * If mac80211 station connects to a VHT20 BSS it gets downgraded to HT20 too.
> 
> This means mac80211 is unable to setup VHT20 pairing properly even
> though VHT20 BSS is defined in the spec.
> 
> My take is 10.39.1 means VHT STA AssocReq must contain
> IEEE80211_HT_CAP_SUP_WIDTH_20_40.
> I suppose AP (hostapd) should deny STA association in that case.

So are you saying the station isn't setting 20_40 capability? Or is
something else unsetting the bit in case it's a 20MHz network?

johannes

