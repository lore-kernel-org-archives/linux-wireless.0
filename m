Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2FFIsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:48:43 -0400
Message-ID: <1338972522.4513.21.camel@jlt3.sipsolutions.net> (sfid-20120606_104846_580441_3864AC39)
Subject: Re: [PATCH] mac80211: clear ifmgd->bssid only after building DELBA
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:48:42 +0200
In-Reply-To: <CAB3XZEfTLN65kVDbfL58t7PaAhMGbnN++DgjwbSELg3NmiGqFg@mail.gmail.com> (sfid-20120601_104035_157923_97B2E5DE)
References: <1338538443-23172-1-git-send-email-eliad@wizery.com>
	 <1338538911.4884.10.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfTLN65kVDbfL58t7PaAhMGbnN++DgjwbSELg3NmiGqFg@mail.gmail.com>
	 (sfid-20120601_104035_157923_97B2E5DE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-01 at 11:40 +0300, Eliad Peller wrote:
> On Fri, Jun 1, 2012 at 11:21 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2012-06-01 at 11:14 +0300, Eliad Peller wrote:
> >> ieee80211_set_disassoc() clears ifmgd->bssid before
> >> building DELBA frames, resulting in frames with invalid
> >> bssid ("00:00:00:00:00:00").
> >>
> >> Fix it by clearing ifmgd->bssid only after building
> >> all the needed frames.
> >>
> >> After this change, we no longer need to save the
> >> bssid (before clearing it), so remove the local array.
> >
> > I'm not convinced clearing the BSSID this late is correct, there's a lot
> > of code using it, for example comparing it on RX, that we may not want
> > to have it at this point any more.
> >
> > It may well be that this is no longer a concern, but I wouldn't dismiss
> > it right away.
> >
> i can't really spot any significant difference between these 2 locations.
> i only deferred it latter in the same function (after stopping the
> queues, setting carrier off, and sending DELBA + deauth). do you see
> anything that might go wrong?

I took another look, and I guess I don't see anything now either. Let's
try this patch :-)

One side effect from clearing the BSSID early was also that we sometimes
(if there was pending traffic while disassociating) got the message
"dropped from to unauthorized port 00:00:00:00:00:00" or so ... so that
should go away too.

johannes

