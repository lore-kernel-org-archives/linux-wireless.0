Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38966 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaHMLIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 07:08:49 -0400
Message-ID: <1407928122.21220.31.camel@jlt4.sipsolutions.net> (sfid-20140813_130902_464091_E4323CA2)
Subject: Re: [PATCH 1/2] cfg80211: clarify BSS probe response vs. beacon data
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@adurom.com>
Date: Wed, 13 Aug 2014 13:08:42 +0200
In-Reply-To: <CAB3XZEckyoDVShskF8rRe7DFuVMO-LBdhFDejiJ63SjhsEvmAA@mail.gmail.com> (sfid-20140813_125704_716079_1D61019F)
References: <1407870219-1720-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEckyoDVShskF8rRe7DFuVMO-LBdhFDejiJ63SjhsEvmAA@mail.gmail.com>
	 (sfid-20140813_125704_716079_1D61019F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-08-13 at 13:57 +0300, Eliad Peller wrote:


> > @@ -1011,6 +1018,9 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
> >         if (res->pub.capability & WLAN_CAPABILITY_ESS)
> >                 regulatory_hint_found_beacon(wiphy, channel, gfp);
> >
> > +       /* assume drivers don't mix and match too badly */
> > +       res->known_frame_type = true;
> > +
> 
> i think you should set the flag only in case of a beacon.
> otherwise, you might "validate" res->ies although it contains probe
> response data.

Hm, what do you mean? If we have known frametype and we have beacon_ies,
then IEs in nl80211 are certain to be proberesp_ies ...

johannes

