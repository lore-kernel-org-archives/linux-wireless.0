Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab0CZGVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 02:21:54 -0400
Subject: Re: [PATCH] iw: Add support for connection quality monitor
 configuation
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1269584079.10120.889.camel@wimaxnb.nmp.nokia.com>
References: <1269582379-10253-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1269583649.4581.4.camel@jlt3.sipsolutions.net>
	 <1269584079.10120.889.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 23:21:41 -0700
Message-ID: <1269584501.4581.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > +	NLA_PUT_U32(cqm, NL80211_ATTR_CQM_RSSI_THOLD, thold);
> > > +	NLA_PUT_U32(cqm, NL80211_ATTR_CQM_RSSI_HYST, hyst);
> > 
> > Hmm. guess I missed that in the kernel side review, but should we change
> > the API so that leaving them out means disabling?
> 
> Heh, yep, the kernel part does not disable this if these are left out. 
> 
> Actually, I can think of one downside to the approach you propose: when
> this gets extended, there will be multiple different cqm parameters, and
> they would have to be always configured simultaneously, otherwise some
> of the configurations would end up disabled. At least with iw, that
> would be somewhat awkward?

Hmm, yes, maybe. In that case you'd want leaving them out meaning no
change I guess. I'll give it another thought, but now I need to get
sleep and you won't hear from me again until I'm home on like Sunday :)

johannes

