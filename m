Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36538 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933754AbcECTA0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 15:00:26 -0400
Message-ID: <1462302024.10444.5.camel@sipsolutions.net> (sfid-20160503_210029_993325_11BE5333)
Subject: Re: [PATCH] cfg80211: Advertise extended capabilities per interface
 type to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>,
	"Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>
Date: Tue, 03 May 2016 21:00:24 +0200
In-Reply-To: <19a916fb8aeb4226927a7a0c6541a361@APHYDEXM01E.ap.qualcomm.com>
References: <1460719669-3421-1-git-send-email-vkanchan@qti.qualcomm.com>
	 <1460844715.2075.21.camel@sipsolutions.net>
	 <19a916fb8aeb4226927a7a0c6541a361@APHYDEXM01E.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-04-22 at 14:52 +0000, Kanchanapally, Vidyullatha wrote:
> 
> > So I'm thinking something like
> > 
> > supported_on_all = iftype_ext_capab[0]
> > for i in 1..num_iftype_ext_capab-1:
> >    supported_on_all &= iftype_ext_capab[i]

> >  WARN_ON(wiphy->ext_capa_mask & ~supported_on_all)

> We were thinking whether this is an appropriate validation or not
> since we cannot be sure how the Extended Capabilities are defined.
> They need not necessarily be all positive capabilities, they could
> couple both the positive and negative capabilities as well.
> Please let us know if this change is really needed.

I'm ambivalent about this. I don't think it makes sense to see drivers
that register both, i.e. would result in the warning I suggested. I
don't think *negative* capabilities can really be added, since the spec
always assumes that capabilities that you don't list are zero.

In considering multi-bit values, you might have a point, if - for
example - you had a MAX-MSDU-IN-AMSDU value of 0b11 for some
interfaces, and 0b01 for all the others.

Realistically though, does that make sense?

I would expect this to be the only multi-bit field that might ever be
supported this way, since in the future drivers would likely only
specify the current subset of capabilities in the wiphy ext_capab, and
put all newer extensions into the per-iftype ext_capa, assuming that
they're running on a newer supplicant.

So on the whole, I don't really see a good reason to not do pretty much
exactly the (pseudo)code I wrote above; perhaps you can come up with a
better example than I tried?

johannes
