Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab3CRTEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 15:04:02 -0400
Message-ID: <1363633436.8260.4.camel@jlt4.sipsolutions.net> (sfid-20130318_200405_921207_FF6E4B24)
Subject: Re: [PATCH 3.9] mac80211: always synchronize_net() during station
 removal
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Mon, 18 Mar 2013 20:03:56 +0100
In-Reply-To: <CAB=NE6VTCdBzsQ7j7VgpbERUqYDuE-=9B=eoRa0rdSE7AiE7ew@mail.gmail.com> (sfid-20130315_192241_156682_BADF0063)
References: <1362608366-10771-1-git-send-email-johannes@sipsolutions.net>
	 <1362651722.8694.25.camel@jlt4.sipsolutions.net>
	 <CAB=NE6VTCdBzsQ7j7VgpbERUqYDuE-=9B=eoRa0rdSE7AiE7ew@mail.gmail.com>
	 (sfid-20130315_192241_156682_BADF0063)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-15 at 11:22 -0700, Luis R. Rodriguez wrote:
> On Thu, Mar 7, 2013 at 2:22 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2013-03-06 at 23:19 +0100, Johannes Berg wrote:
> >> From: Johannes Berg <johannes.berg@intel.com>
> >>
> >> If there are keys left during station removal, then a
> >> synchronize_net() will be done (for each key, I have a
> >> patch to address this for 3.10), otherwise it won't be
> >> done at all which causes issues because the station
> >> could be used for TX while it's being removed from the
> >> driver -- that might confuse the driver.
> >>
> >> Fix this by always doing synchronize_net() if no key
> >> was present any more.
> >
> > Applied.
> 
> This applies to v3.8 as well, do you want it there too?

Dunno, I don't know of a bug that was triggered by this, I only know our
new driver might trigger bugs without this.

johannes

