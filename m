Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab1KGRGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 12:06:46 -0500
Subject: Re: [PATCH v4 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB8051D.5010704@candelatech.com>
References: <1320437440-6463-1-git-send-email-greearb@candelatech.com>
	 <1320437440-6463-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111104_211114_679516_4CC16ABF) <1320657208.3993.29.camel@jlt3.sipsolutions.net>
	 <4EB8051D.5010704@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 18:06:43 +0100
Message-ID: <1320685603.3993.51.camel@jlt3.sipsolutions.net> (sfid-20111107_180649_634247_5CB7DAAD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-07 at 08:19 -0800, Ben Greear wrote:

> > Why is this not just a static const that you fill manually? There's
> > nothing that's not constant here. So e.g.
> >
> > static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
> > 	.ampdu_params_info = IEEE80211_HT_AMPDU_PARM_FACTOR |
> > 			     IEEE80211_HT_AMPDU_PARM_DENSITY,
> > 	.mcs = {
> > 		.rx_mask = { 0xff, 0xff, 0xff, 0xff, 0xff,
> > 			     0xff, 0xff, 0xff, 0xff, 0xff, },
> > 	},
> > 	/* etc */
> > };
> 
> Well, you suggested a pointer in the wiphy struct that was null
> for non mac80211 interfaces.  I'm not sure how to distinguish between
> mac80211 and other wiphys when reporting the capabilities if I use
> this global static.  I also like that the non-static logic lets
> us tweak this for individual drivers if that becomes an issue.

Right. So if you assign this pointer in alloc_hw() then the driver can
still override it before register_hw(). I don't see at all why it needs
to be dynamically allocated.

johannes

