Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58542 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3HBLZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 07:25:57 -0400
Message-ID: <1375442751.18144.7.camel@jlt4.sipsolutions.net> (sfid-20130802_132600_789604_97FFD65F)
Subject: Re: [RFC 1/3] nl/cfg80211: add chan_time for scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Fri, 02 Aug 2013 13:25:51 +0200
In-Reply-To: <CA+BoTQm+rWRRpp6XQ_-YHMBfH0Q4ecZ3z-6TV3cvFZ=8uXWsQA@mail.gmail.com> (sfid-20130801_111410_156661_E1ABADDA)
References: <1375087158-22077-1-git-send-email-michal.kazior@tieto.com>
	 <1375087158-22077-2-git-send-email-michal.kazior@tieto.com>
	 <1375342845.8608.8.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+rWRRpp6XQ_-YHMBfH0Q4ecZ3z-6TV3cvFZ=8uXWsQA@mail.gmail.com>
	 (sfid-20130801_111410_156661_E1ABADDA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-01 at 11:14 +0200, Michal Kazior wrote:

> > This seems a bit iffy - you don't differentiate between active/passive
> > scans?
> 
> Is there a reason this should be differentiated?

Well they don't usually have the same timing, passive channel dwell time
usually needs to be longer than on active channels.

> > This also interferes a bit with some other scan optimisations that could
> > be done at a low firmware level, so I think we should be careful and
> > actually say that this is really more intended for measurement use cases
> > and not for normal scans?
> >
> > Or maybe we should have a separate measurement command with similar
> > semantics? This all doesn't seem very clear to me yet :)
> 
> Motivation behind this patchset is to simplify ACS implementation and
> depend on scan. This also allows easier fallback from survey-based ACS
> to BSS-based one.

Sure, I understand.

> Other use cases are a side-effect so perhaps clarifying the intent in
> the docs is enough.

I'm just saying that this is a fundamentally different usage than actual
scanning. Let's say for the sake of the argument I find a way to scan
channels quicker and implement that in my device (hw_scan). I don't
think this is too far-fetched, imagine I have an 80MHz capable device
and can send probe request 4x transmissions on all the subchannels, if
somehow I manage to separate the receive then I could scan 4x as
quickly. I don't think this particular thing is possible but I could
imagine scan optimisations like it.

Now this comes along - and suddenly the API requires that you stay on
each specified channel for the given period of time. Any such
"non-traditional" scan optimisations would have to be given up, so in a
sense this fundamentally alters the semantics of the scan primitive,
where before it was "give me the list of networks (with these SSIDs) on
these channels" it now becomes "go to each channel, stay there for this
amount of time and ..."

That's what I'm worried about - the implicit semantic change here.

johannes

