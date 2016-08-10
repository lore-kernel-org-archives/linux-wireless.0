Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47671 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822AbcHJTAT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 15:00:19 -0400
Message-ID: <1470842288.10717.12.camel@sipsolutions.net> (sfid-20160810_210106_891859_74471A3E)
Subject: Re: [PATCH v4] cfg80211: Provision to allow the support for
 different beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
	"Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Kondabattini, Ganesh" <ganeshk@qti.qualcomm.com>,
	"Kalikot Veetil, Mahesh Kumar" <mkalikot@qca.qualcomm.com>,
	"Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>,
	"Kumar, Deepak (QCA)" <djindal@qti.qualcomm.com>
Date: Wed, 10 Aug 2016 17:18:08 +0200
In-Reply-To: <33789175707446c89435264aa54f7474@APSANEXR01F.ap.qualcomm.com>
References: <1470374768-22297-1-git-send-email-pkushwah@qti.qualcomm.com>
	 <1470386912.2977.28.camel@sipsolutions.net>
	 <9513d3caf9354aeda408f65128b4a079@aphydexm01f.ap.qualcomm.com>
 <1470729393.28531.11.camel@sipsolutions.net>
	 <33789175707446c89435264aa54f7474@APSANEXR01F.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-08-10 at 14:53 +0000, Undekari, Sunil Dutt wrote:
> > 
> > I don't know what your firmware/hardware capabilities are :)
> I was not referring to any specific architecture here.  With the 2
> choices you had mentioned (mesh must match either one of them / make
> this apply on mesh and IBSS as well ) we see that this new flag being
> defined in the interface combinations could better be applicable for
> all the beaconing interfaces. 

Yes, I agree. If that's what you can implement, that's clearly the
better choice, and once you have multiple BIs for APs it seems
relatively straight-forward to also add for other interface types.

> If we had restricted this to AP / P2P GO and have Mesh match either
> of them , a new request ( in future ? ) to have a different interval
> for Mesh, IMO  would ask a need for new flag , isn't ?  Our intention
> here was to avoid this by ensuring that this flag is applicable for
> all the beaconing interface combinations. 

Makes sense.

Just need to update the documentation then, I guess?

> > I'd argue that instead of having the interface combinations flag,
> > that nl80211 attribute could carry the GCD?
> If your say here is to just use the wiphy parameter rather than
> having the flag in the interface combinations, signifying the support
> for different beacon intervals , Yes we too agree to your point. 

Well, I think it would still make sense to have this on the interface
combinations, if only for flexibility. It's practically equally
complicated (or cheap) to do that way, but gives a bit more
flexibility.

I was just thinking that instead of adding the *flag* on interface
combinations, which you did in this patch:
> +	bool supp_diff_beacon_int;
...
> + * @NL80211_IFACE_COMB_DIFF_BEACON_INTERVAL: flag attribute specifying that

it would make sense to make that a

u8 diff_beacon_int_gcd;
...
NL80211_IFACE_COMB_DIFF_BEACON_GCD: u32 attribute specifying the GCD
	of different beacon interfaces (not present if all beacon
	intervals must match)


> This is considering the fact that the current implementation
> restricts the validation of the beacon interval
> (cfg80211_validate_beacon_int ) to only AP / P2P GO. 
> Neither the Mesh / IBSS ( join ) have this restriction . Not sure why
> this is not imposed for Mesh / IBSS though. 

Interesting, that seems like a bug that we should fix. I suspect the
reason is that IBSS used to not be supported in combinations, and so
nobody thought of adding it there, and mesh was more or less copied
from IBSS. Do you want to submit a (separate) patch to fix this?
Otherwise I can do that.

> After introducing this flag in the interface combinations, we do feel
> that currently it is not going to apply for Mesh / IBSS , unless
> there is a future need to do so , which we are not aware of . 

Well, you're right given the circumstances, but I'd rather fix that
first, forcing MBSS/IBSS to match, and then let it be relaxed with the
new capability. I'm pretty sure current drivers wouldn't do something
useful when mesh/AP combinations have different BIs.

johannes
