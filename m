Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1AaLDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:03:15 -0500
Subject: Re: Why is wmm_param required for HT40- in mlme.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4D45A128.6060905@candelatech.com>
References: <4D44F94F.8040707@candelatech.com>
	 <1296380208.3616.0.camel@jlt3.sipsolutions.net>
	 <4D45A128.6060905@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 12:03:11 +0100
Message-ID: <1296471791.3812.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-30 at 09:34 -0800, Ben Greear wrote:
> On 01/30/2011 01:36 AM, Johannes Berg wrote:
> > On Sat, 2011-01-29 at 21:38 -0800, Ben Greear wrote:
> >> I tried to set up hostapd to do HT40-, but for whatever reason,
> >> it's not sending any wmm_param options, so the stations will not
> >> associate with HT40- enabled due to the check below.
> >>
> >> Is it really *reqired* that wmm_param exist to enable HT mode?
> >>
> >>   From mlme.c:
> >> 	if (elems.ht_info_elem&&  elems.wmm_param&&
> >> 	(sdata->local->hw.queues>= 4)&&
> >> 	!(ifmgd->flags&  IEEE80211_STA_DISABLE_11N))
> >> 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
> >> 					       cbss->bssid, ap_ht_cap_flags);
> >
> > 802.11n-2009 says it is required.
> 
> Do you know the pertinent section, or some keywords to search for?  I'm
> unable to find anything useful.

No, I got confused. 802.11n says an HT STA is a QoS STA (5.2.9), but in
practice WMM is tested/certified instead of QoS.

johannes

