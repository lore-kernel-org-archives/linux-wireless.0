Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44395 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaAWI0v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 03:26:51 -0500
Message-ID: <1390465607.4142.7.camel@jlt4.sipsolutions.net> (sfid-20140123_092658_532006_E12498FA)
Subject: Re: [PATCH 3/3] cfg80211: implement multi-interface CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 23 Jan 2014 09:26:47 +0100
In-Reply-To: <1390458525.4189.46.camel@porter.coelho.fi>
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
	 <1390226968-18928-4-git-send-email-michal.kazior@tieto.com>
	 <1390458525.4189.46.camel@porter.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 08:28 +0200, Luca Coelho wrote:

> Why is this necessary? I think it's easier to treat the CSA's
> separately.  When wpa_supplicant decides to switch channel in one
> interface, it asks cfg80211 to do so.  Then, if that interface change is
> "approved" (ie. there's no internal reason why it would fail), cfg80211
> sends a notification to userspace that the interface will switch.  Then
> wpa_s decides whether any other interfaces need switching as well (ie.
> if it's in the same channel context).

I don't think that makes sense. If userspace requested the CSA
operation, the fact that it will happen should be known as soon as the
request returns 0. No need for a notification (other than when the mlme
code in mac80211 decided to switch by itself). You're mixing the cases
of GO-follow-client-interface and switch-multiple-AP-BSSes, which I'm
not sure is right.

The problem with using the approach you're suggesting to switch multiple
AP interfaces is that when you do that, you open the system up to races
much more than when requesting multiple interfaces at once. Also, I
still think we need to enforce that the interface switch at the same
time, which would practically be impossible with multiple switch
commands.

> > This makes it possible for userspace to request a
> > multi-interface channel switch while allowing
> > sanity checks wrt target interface/channel
> > combination.
> 
> Okay, the sanity checks are an interesting issue.  But if the
> combination is not good, the whole command will fail and none of the
> interfaces will switch.  If wpa_s does this interface-by-interface,
> separately, the triggering interface (ie. the one that decided to switch
> in the first place) may succeed while the subsequent requests may fail
> (eg. if the interface combination is not allowed in the new channel).
> If the second one fails, wpa_s may make another decision, for instance
> trying to switch the second interface to a *different* channel instead,
> or not switch at all.

That makes no sense. You're talking about completely different
scenarios, see above.

johannes

