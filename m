Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbXIUVn1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 17:43:27 -0400
Subject: Re: [PATCH 0/5] Add central regulatory domain agent - Patchset I
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Drake <dsd@gentoo.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20070921204606.GD31768@pogo>
References: <20070921204606.GD31768@pogo>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 17:39:56 -0400
Message-Id: <1190410796.14368.17.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-09-21 at 16:46 -0400, Luis R. Rodriguez wrote:
> Patchset I - Add central regulatory domain agent
> 
> This is patchset I of II which adds a central regulatory domain
> agent onto the wireless subsystem. I've split it into two patchsets in order
> to introduce the agent before affecting mac80211 drivers. This allows work
> to continue on the central reg agent independant of mac80211
> advancements.
> 
> Patch series I adds the central regulatory domain agent and
> integrates it with cfg80211. The central reg agent consists of 2
> main modules:
> 
> * ISO3166-1
> * Regdomains

Also, if you could make sure this stuff is completely separate
conceptually and architecturally from mac80211 itself, but have mac80211
_rely_ on it, then we can rip the bits out of the fullmac drivers that
do regdomain stuff and plug them into this framework too.  I think
that's a real win.  There's not a pile of code in the fullmac drivers
for this, but there's enough that it sucks having to have these defines
all over the place.

Also having somewhere that has standard functions that map channels to
frequencies and back would rock (if you do, please use u32 here for
frequencies not floats of course, like 2412000 and such unless you think
u64 would work better to specify down to the single Hz level).

Dan

> Additionally, changing regulatory domains can be acomplished through
> the use of a new configfs module which will be introduced for
> the wireless subsystem.
> 
> Patch series II will add support for the centreal reglatory agent
> onto mac80211, remove mac80211's simple regulatory control and and 
> replace each driver's own regulatory domain implementation with the
> central one.
> 
>   Luis

