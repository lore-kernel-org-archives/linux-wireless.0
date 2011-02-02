Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([86.59.21.14]:52447 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab1BBL3a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 06:29:30 -0500
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: Fix short and long retry configuration
Date: Wed, 2 Feb 2011 12:29:27 +0100
Cc: sedat.dilek@gmail.com, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	nbd@openwrt.org
References: <20110128075211.26919.39228.stgit@localhost6.localdomain6> <AANLkTim2MBSMSDxyokEWWDC=bwzMCO92qd4_i3Cm0h29@mail.gmail.com> <20110202105254.GA15843@hash.localnet>
In-Reply-To: <20110202105254.GA15843@hash.localnet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201102021229.28104.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 February 2011 11:52:54 Bob Copeland wrote:
> On Wed, Feb 02, 2011 at 09:06:40AM +0100, Sedat Dilek wrote:
> > As I saw your patch in linux-next/wireless-next-2.6, I wanted to ask
> > what's up with Bob's
> > "mac80211-minstrel-honor-max-retry-counts-from-cfg80211.patch" (see
> > [1])?
> 
> I sort of dropped the ball on it.  I guess I need to test it to
> see if it actually works.  It may not properly handle reconfiguring
> the limits, e.g.  Once I can boot a recent kernel (i915 issues) I'll
> give it a spin and see.
> 
> > Is this patch obsolete, now?
> 
> Ath5k now uses the same values that my patch would have used in
> minstrel, so my patch wouldn't have any effect now, for ath5k.
> There still might be other drivers that would benefit from having
> the change in the rate controller.

My patch for ath5k is only one part of the story. It sets the retry limits in 
HW. Most of these values only affect after how many retries the contention 
window is reset to cw_min, not the actual number of retries (please check the 
register documentation in my patch). The total number of retries for a frame 
are the values we put into the TX descriptor - coming from the rate control 
module (minstrel).

In my point of view there are two things missing:

1) minstrel should respect the short/long retry configuration as well. This is 
what Bob's patch attempts to do (I never tested it).

2) I think minstrel does currently not use the max number of retries 
(short/long retries or hw->max_rate_tries) in a correct way. It looks like it 
uses the max number of retries for every single rate, whereas it should stay 
below the max retries in SUM of all different rates. E.g now I can see 
something like rate1: 6 retries, rate2: 3 retries, rate3: 3 retries, rate4: 3 
retries (or similar, i dont have the debugging output here, but it's easy to 
print the rates and tries before we setup the tx descriptor). This results in 
more total tries than have been setup in hw->max_rate_tries. One side effect 
is that this causes the contention window to be reset inbetween the retries 
(this is what Jonathan Guerin initially reported). Another effect is that we 
have WAY to many retries for a single frame. Also I think it does not make 
sense to have say 6 retries with the same rate, when we have other rates to 
try. I even wonder how the minstrel algorithm can work efficiently with this, 
but I didn't have the time to look closer into minstrel, and I won't be able 
to do that any time soon.

bruno
