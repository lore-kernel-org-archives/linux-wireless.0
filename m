Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2LMXJZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 18:09:25 -0500
Message-ID: <1355440186.9463.36.camel@jlt4.sipsolutions.net> (sfid-20121214_000928_312565_7B8D87D3)
Subject: Re: [PATCH 1/2] cfg80211: allow drivers to selectively disable
 80/160 MHz
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 14 Dec 2012 00:09:46 +0100
In-Reply-To: <CAB=NE6Wudb52Wurot4j_+9JSjrcKHrfwgKmr_PVVftjLtfxY5A@mail.gmail.com> (sfid-20121213_234445_071561_AB20E3B3)
References: <1355337296-5815-1-git-send-email-johannes@sipsolutions.net>
	 <1355337296-5815-2-git-send-email-johannes@sipsolutions.net>
	 <CAB=NE6Wudb52Wurot4j_+9JSjrcKHrfwgKmr_PVVftjLtfxY5A@mail.gmail.com>
	 (sfid-20121213_234445_071561_AB20E3B3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 14:44 -0800, Luis R. Rodriguez wrote:
> On Wed, Dec 12, 2012 at 10:34 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Some drivers might support 80 or 160 MHz only on some
> > channels for whatever reason, so allow them to disable
> > these channel widths. Also maintain the new flags when
> > regulatory bandwidth limitations would disable these
> > wide channels.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> We need something to spell out VHT80 and VHT160 as a capability for
> debugging on ht_print_chan().

Well, not sure. I don't have VHT80 bits like HT40+/-, I only have "can
do 80 MHz on this channel", and the next patch advertises it to nl80211
anyway so we can use iw to dump it.

>  This patch also seems to depend on a
> patch posted as RFC, not PATCH.

Yeah that's probably true.

johannes

