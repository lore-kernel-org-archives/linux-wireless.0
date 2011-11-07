Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39046 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1KGIuC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 03:50:02 -0500
Subject: Re: [PATCH 05/12] nl80211: advertise device AP SME
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <anamtsov@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CA+XVXfemN4dZC2GkKqpvGsFxs81dST4Mth0rEDd-MQrXc8rnXw@mail.gmail.com> (sfid-20111107_093026_977912_651FE7AA)
References: <20111104101809.711636760@sipsolutions.net>
	 <20111104101943.704950080@sipsolutions.net>
	 <CA+XVXfemN4dZC2GkKqpvGsFxs81dST4Mth0rEDd-MQrXc8rnXw@mail.gmail.com>
	 (sfid-20111107_093026_977912_651FE7AA)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 09:49:57 +0100
Message-ID: <1320655797.3993.12.camel@jlt3.sipsolutions.net> (sfid-20111107_095006_842508_74ACBABE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-07 at 10:29 +0200, Arik Nemtsov wrote:

> > +/**
> > + * enum nl80211_ap_sme_features - device-integrated AP features
> > + * @NL80211_AP_SME_WSC: The driver is capable of indicating received probe
> > + *     request frames to userspace via management frame subscription events
> > + *     if the payload includes the WSC IE. The driver is capable of adding
> > + *     the WSC IE as configured from userspace into beacons, probe responses
> > + *     and (re)association reponse frame and allows userspace to update them
> > + *     during the lifetime of the BSS.
> > + */
> > +enum nl80211_ap_sme_features {
> > +       NL80211_AP_SME_WSC      = 1 << 0,
> > +};
> 
> Perhaps we should break up this feature into two? With the upcoming
> probe-resp patches a wl12xx card will be able to indicate
> probe-requests with WSC IE up, but won't be able to add a userspace
> provided WSC IE into beacons.

Break up how? wl12xx obviously wouldn't say it has AP SME included.
Also, I think here it is actually still doing this by reporting probe
requests up, but it's somewhat different.

> Also I'm wondering what this is used for. For instance this contains
> no indication about WPS1 and p2p. Pretty sure ath6kl handles these in
> a similar fashion (at least for the put-IE-from-userspace-in-beacon
> part).

Yeah. This was more or less a placeholder, I guess we need more info
from the ath6kl people.

> And as a final nit-pick, I think WPS2 is more appropriate, as this is
> also the name of the option in the hostapd code and config file.

Good point. Let's discuss the bits & the behaviour a bit more, although
I hate having to postpone the patchset for it :-)


I think the thing here is that we approach a middle ground from two
different sides. With mac80211, we typically handle everything on the
host, so things like replying to probe requests is an offload. With
AP_SME, we initially expect everything to be handled on the device and
approach middle ground by not replying to WPS probe requests. I thought
it makes sense to put these into different attributes rather than use
the same probe response offload attribute you have for wl12xx, but I'll
admit that the semantics are pretty similar.
However, I could see much more features come into play here, for example
FT would probably not be a feature an AP_SME device has, but for
mac80211 based drivers it's obviously just implemented in hostapd. So
such a feature might also need a bit in this new bitfield.

johannes

