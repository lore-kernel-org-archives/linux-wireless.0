Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194Ab1KHURp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 15:17:45 -0500
Subject: Re: [PATCH v8 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320783128.24797.48.camel@jlt3.sipsolutions.net> (sfid-20111108_211213_875547_E1753A2D)
References: <1320780995-30483-1-git-send-email-greearb@candelatech.com>
	 <1320780995-30483-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111108_203659_989707_E33ECA13)  <1320783128.24797.48.camel@jlt3.sipsolutions.net>
	 (sfid-20111108_211213_875547_E1753A2D)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 21:17:38 +0100
Message-ID: <1320783458.24797.49.camel@jlt3.sipsolutions.net> (sfid-20111108_211749_009438_CC61DE09)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 21:12 +0100, Johannes Berg wrote:

> For example here:
> 
> >  		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
> > +		    !ieee80111_cfg_override_disables_ht40(sdata) &&
> >  		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
> >  		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
> >  			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
> 
> This just adds complexity. If you calculate sdata->used_ht_caps first
> then you can replace the sband->ht_cap.cap check with an
> sdata->used_ht_caps.cap check and be done with it, instead of having to
> check both.

Similarly in ieee80211_add_ht_ie(), you wouldn't have to re-calculate
the override, etc. I think it would be a lot simpler that way.

johannes

