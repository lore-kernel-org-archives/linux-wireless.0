Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51579 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1KCIIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 04:08:06 -0400
Subject: Re: mac80211: UAPSD - EOSP bit seems to be not set when send qos
 null frame
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAFED-j=sP7PSD8yv1U4RA9-NGnjJ9CE5C6qWOQxZ=rzGMdt+2w@mail.gmail.com> (sfid-20111103_090606_495560_51D06706)
References: <CAFED-jkVtVFBJfDc-18a+RogAFoTVudS9_POjZHFZ=AtBu1p0g@mail.gmail.com>
	 <1320306440.3950.0.camel@jlt3.sipsolutions.net>
	 <CAFED-j=sP7PSD8yv1U4RA9-NGnjJ9CE5C6qWOQxZ=rzGMdt+2w@mail.gmail.com>
	 (sfid-20111103_090606_495560_51D06706)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 09:08:03 +0100
Message-ID: <1320307683.3950.2.camel@jlt3.sipsolutions.net> (sfid-20111103_090811_283339_BC65CFF7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-03 at 09:05 +0100, Janusz Dziedzic wrote:
> 2011/11/3 Johannes Berg <johannes@sipsolutions.net>:
> > On Thu, 2011-11-03 at 08:36 +0100, Janusz Dziedzic wrote:
> >> Hello,
> >>
> >> I have a question connected with UAPSD implementation.
> >> Seems, mac80211 always clear EOSP bit in ieee80211_set_qos_hdr() fuction.
> >> Is that a problem in mac80211 or this should be handled in different place/way?
> >
> > It should be set:
> >
> >        if (qos) {
> >                nullfunc->qos_ctrl = cpu_to_le16(tid);
> >
> >                if (reason == IEEE80211_FRAME_RELEASE_UAPSD)
> >                        nullfunc->qos_ctrl |=
> >                                cpu_to_le16(IEEE80211_QOS_CTL_EOSP);
> >        }
> >
> 
> Yes, I see this is set correctly before we call ieee80211_set_qos_hdr().
> Next ieee80211_set_qos_hdr() fuction seems not care about EOSP bit and
> we have this bit cleared before ieee80211_tx() call.

Oh, WTH. Somebody had posted a patch that fixed that, I thought that
went in but in my testing this didn't show up since my device always
sets/clears it according to what I told it.

johannes

