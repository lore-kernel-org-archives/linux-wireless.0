Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab2KZKuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 05:50:19 -0500
Message-ID: <1353927043.9488.24.camel@jlt4.sipsolutions.net> (sfid-20121126_115029_283563_4EDB20A5)
Subject: Re: [PATCH v4 6/6] mac80211: add ap channel switch command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kgiori@qca.qualcomm.com" <kgiori@qca.qualcomm.com>,
	"mcgrof@frijolero.org" <mcgrof@frijolero.org>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"adrian.chadd@gmail.com" <adrian.chadd@gmail.com>,
	"j@w1.fi" <j@w1.fi>, "coelho@ti.com" <coelho@ti.com>,
	"igalc@ti.com" <igalc@ti.com>,
	"adrian@freebsd.org" <adrian@freebsd.org>,
	"nbd@nbd.name" <nbd@nbd.name>,
	"simon.wunderlich@s2003.tu-chemnitz.de"
	<simon.wunderlich@s2003.tu-chemnitz.de>, victorgld@gmail.com
Date: Mon, 26 Nov 2012 11:50:43 +0100
In-Reply-To: <50AB9E9D.2090801@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	      <1350226137-13704-7-git-send-email-victorg@ti.com>
	     <1350414472.10177.17.camel@jlt4.sipsolutions.net>
	    <50842563.4010201@ti.com>
	  <1350910599.10166.4.camel@jlt4.sipsolutions.net>
	    <50922AA9.4030509@ti.com>
	  <1352128994.9466.19.camel@jlt4.sipsolutions.net>
	  <50A2617B.3060807@ti.com>
	  <1352892233.9510.26.camel@jlt4.sipsolutions.net>
	 <50A38C3A.20908@tieto.com> <1352896680.9510.28.camel@jlt4.sipsolutions.net>
	 <50AB9E9D.2090801@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 17:15 +0200, Victor Goldenshtein wrote:
> On 14/11/2012 14:38, Johannes Berg wrote:
> > On Wed, 2012-11-14 at 13:19 +0100, Michal Kazior wrote:
> >
> >>> However, then I realised that that still doesn't work -- once initial
> >>> radar detection is done, it needs to continue while the AP is active. If
> >>> the channel context was going to be relinquished, or even just the
> >>> channel changed for a few seconds, it would be unsafe. So as a result,
> >>> the radar detect operation has to somehow be coupled to the start AP
> >>> operation and prohibit channel changes and additional channel contexts
> >>> during the entire operation time.
> >>
> >> Hmm.. cfg80211 doesn't really know about channel contexts.
> >>
> >> The problem I see is that cfg80211 may be in a combination with
> >> `num_different_channels = 1` and mac80211 can have 2 channel contexts
> >> due to channel type incompatibilities.
> >
> > Yes, this is a concern, we need to fix that anyway though, otherwise it
> > may assume that some operations are possible when they really aren't
> > (e.g. starting an HT40+ and HT40- AP on the same channel, which
> > shouldn't be done anyway, but still)
> >
> 
> not sure how it can happen if have this check:
> 
> if ((cac_type != NL80211_CHAN_HT20) && (cac_type != NL80211_CHAN_NO_HT))
> 		return -EOPNOTSUPP;
> 
> in both start_radar_detection() & enable_tx() ?

The discussion between Michal and me above was unrelated to DFS :-)

johannes

