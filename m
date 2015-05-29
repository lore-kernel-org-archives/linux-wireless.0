Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37927 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbbE2LjS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 07:39:18 -0400
Message-ID: <1432899554.2104.17.camel@sipsolutions.net> (sfid-20150529_133922_141233_62F6F486)
Subject: Re: [PATCH v2 2/2] mac80211: guard against invalid ptr deref
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 29 May 2015 13:39:14 +0200
In-Reply-To: <CA+BoTQmkg8KBhFGqSsdt6Sks6JGUDGnM2oSzMSEWtCEz-abwzA@mail.gmail.com> (sfid-20150529_133408_532814_43B8B10C)
References: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com>
	 <1432285043-8878-1-git-send-email-michal.kazior@tieto.com>
	 <1432285043-8878-2-git-send-email-michal.kazior@tieto.com>
	 <1432897812.2104.7.camel@sipsolutions.net>
	 <CA+BoTQmkg8KBhFGqSsdt6Sks6JGUDGnM2oSzMSEWtCEz-abwzA@mail.gmail.com>
	 (sfid-20150529_133408_532814_43B8B10C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-05-29 at 13:34 +0200, Michal Kazior wrote:

> > I'm a bit undecided about this. Is this really the only place that
> > assumes use_4addr implies that it's a VLAN, in a context like this?
> 
> Hmm.. I guess TDLS could also have use_4addr and still be a
> IFTYPE_STATION, right? 

No, TDLS can neither get here (VLAN assignment) nor does it actually set
use_4addr. The only other thing that can set use_4addr is the station
interface itself, but then we also can't get here.

That wasn't really my point though - I was thinking more along the lines
of code in rx.c, tx.c that just checks use_4addr? Not really sure.

johannes


