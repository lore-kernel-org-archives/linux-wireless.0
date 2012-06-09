Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55724 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2FIIZs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:25:48 -0400
Message-ID: <1339230344.4539.19.camel@jlt3.sipsolutions.net> (sfid-20120609_102555_460005_A217239A)
Subject: Re: [ANN] new wireless stack trees
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Date: Sat, 09 Jun 2012 10:25:44 +0200
In-Reply-To: <4FD06D56.5020506@broadcom.com>
References: <1338898271.4514.38.camel@jlt3.sipsolutions.net>
	 <4FD06D56.5020506@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 10:59 +0200, Arend van Spriel wrote:
> Although I can see the reason for maintaining the wireless stack
> separately from the wireless drivers, I would like to give my concerns
> about this idea.
> 
> While separating maintenance makes sense, moving to a separate
> repository impairs development in the wireless arena given the close
> relation between mac80211 stack and drivers and it will surely add
> latency. Integration between mac80211 and drivers will occur somewhat
> later and when issues are found in that area the fixes (at least
> mac80211 fixes) will add additional delay.

I'm not sure I share that concern much. We've always developed features
in mac80211 along with the driver, but once the mac80211 part is usable
it can be sent upstream without much concern for the driver. Even before
having my own trees we've always expected you to send patches for the
different components separately. The bigger change is that now John
could reject patches that don't apply because they're missing features,
so you may have to track mixed submissions more closely. I have a
feeling that's actually a good thing because the submitter can't just
fire & forget :-)

Technically of course you're right, there will be a little bit of a
delay between me deciding that I will apply your patch, applying it,
pushing it to John and then you sending your dependent patches. OTOH,
there always has been this delay because John always gave me plenty of
time to review mac80211 patches, so ultimately the delay might actually
go down if I merge quicker.

> > I won't maintain an integration tree like John's wireless-testing,
> > please continue to use his. If merge conflicts make it necessary, I'll
> > resolve them in separate branches etc. and work it out with John.
> 
> So mac80211-next repo will stay on last stable release and not be
> following the -rc releases?

No, it will follow wireless-next which is currently at 3.5-rc1. It will
probably stay there unless there's a reason to merge with something
else.

> > As a result, I ask you to not submit patch series that touch both your
> > driver and the stack, please submit them independently. John will have
> > to wait applying the patches to the driver until has has pulled in any
> > dependencies via my trees.
> 
> This can become a hornets nest as it means more maintenance work for
> John as the order of patches can change, eg. stack-dependent driver
> patch is overtaken by patch for bugfix.

If anything, it should mean more work for _you_, not John :-)
However, I don't see the problem here? This has always happened -- a new
stack-dependent driver feature will always be slower than a bugfix, by
the nature of the wireless/wireless-next trees.

johannes

