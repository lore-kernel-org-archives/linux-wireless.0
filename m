Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4465 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab2FGI7O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 04:59:14 -0400
Message-ID: <4FD06D56.5020506@broadcom.com> (sfid-20120607_105924_254147_E4ED4D5D)
Date: Thu, 7 Jun 2012 10:59:02 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [ANN] new wireless stack trees
References: <1338898271.4514.38.camel@jlt3.sipsolutions.net>
In-Reply-To: <1338898271.4514.38.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2012 02:11 PM, Johannes Berg wrote:
> Hi,
> 
> Given the amount of work going on in the various wireless stack
> components, I've decided that I'll reflect my maintainer role also in
> git trees. I've created new trees and will pick patches for
>  * mac80211
>  * cfg80211
>  * rfkill (if needed)
> 
> into the new trees
>  * http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211.git;a=summary
>  * http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211-next.git;a=summary
> 
> Yes, I've called them "mac80211", but I will also pick up the other
> components into them. Calling them "wireless" would have been too
> confusing.
> 
> These trees feed John's wireless and wireless-next trees respectively.

Hi Johannes,

Although I can see the reason for maintaining the wireless stack
separately from the wireless drivers, I would like to give my concerns
about this idea.

While separating maintenance makes sense, moving to a separate
repository impairs development in the wireless arena given the close
relation between mac80211 stack and drivers and it will surely add
latency. Integration between mac80211 and drivers will occur somewhat
later and when issues are found in that area the fixes (at least
mac80211 fixes) will add additional delay.

> I won't maintain an integration tree like John's wireless-testing,
> please continue to use his. If merge conflicts make it necessary, I'll
> resolve them in separate branches etc. and work it out with John.

So mac80211-next repo will stay on last stable release and not be
following the -rc releases?

> As a result, I ask you to not submit patch series that touch both your
> driver and the stack, please submit them independently. John will have
> to wait applying the patches to the driver until has has pulled in any
> dependencies via my trees.

This can become a hornets nest as it means more maintenance work for
John as the order of patches can change, eg. stack-dependent driver
patch is overtaken by patch for bugfix.

> If you maintain your own driver trees you're free to merge these trees
> if you need their contents, but please don't send my contents to John
> yourself, wait with your merge requests and nag me if you need me to
> push to John :-)

Although it may appeal to merge the trees, nagging for a upstream push
makes more sense.

> A word of caution though: I've not done this before, so while I think I
> know what I'm signing up for I'm sure I'll make mistakes. If you pull my
> tree in and I have to rebase due to those mistakes then would have to
> rebase as well, so maybe don't pull it tomorrow but give me some time to
> adjust to the workflow.

As stated I have some concerns, but let us see how it goes.

> Of course I'll continue to post my own patches to the mailing list well
> before I applying them.

Great plan ;-)

Gr. AvS

