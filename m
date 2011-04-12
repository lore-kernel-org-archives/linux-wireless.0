Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab1DLJ6r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 05:58:47 -0400
Subject: Re: [RFC v2] mac80211: consolidate MIC failure report handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <201104111816.22932.chunkeey@googlemail.com>
References: <201104091234.27305.chunkeey@googlemail.com>
	 <1302529173.6487.8.camel@jlt3.sipsolutions.net>
	 <201104111816.22932.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 11:58:45 +0200
Message-ID: <1302602325.3639.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-11 at 18:16 +0200, Christian Lamparter wrote:

> > > +	if (!ieee80211_has_protected(hdr->frame_control) ||
> > > +	    !ieee80211_is_data_present(hdr->frame_control)) {
> > > +		return RX_CONTINUE;
> > > +	}
> > 
> > But is this check correct? What if the driver _completely_ pretends that the
> > frame wasn't encrypted? Do we strictly require that it leaves the protected
> > bit set?
> 
> OnT: It looks like this patch might also help to relieve ath9k & ath9k_htc of
> some workarounds. see: 56363ddeeed "ath9k: fix spurious MIC failure reports".
> (ath5k seems to be fine though?!)

Yeah, it looks like if we do it in the TKIP path we could revert that.

> BTW: what to do about this?
> -       if (rx->sdata->vif.type == NL80211_IFTYPE_AP && keyidx) {
> -               /*
> -                * APs with pairwise keys should never receive Michael MIC
> -                * errors for non-zero keyidx because these are reserved for
> -                * group keys and only the AP is sending real multicast
> -                * frames in the BSS.
> -                */
> -               return; [Drop Unusable]
> -       }
> for now, I've kept the code. But I'm not quite sure why, at least
> I couldn't find the passage in the spec that says "GTK MIC failures in AP mode
> can be ignored" [Although, 8.5.1 (see "196 hole")& 8.3.2.3 (last sentence)
> hint in this direction]?

Well, hmm? APs never receive anything with a key that has a non-zero at
all, since pairwise keys have key index 0 and group keys are never used
for RX.


Also, I think we should run some actual TKIP testing :-)

johannes

