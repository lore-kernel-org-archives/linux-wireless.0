Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:39574 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3ABNhB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 08:37:01 -0500
Received: by mail-we0-f175.google.com with SMTP id z53so6820810wey.34
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 05:37:00 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] nl80211: allow ad-hoc to set WMM parameters from outside
Date: Wed, 2 Jan 2013 14:36:54 +0100
Cc: Adrian Chadd <adrian@freebsd.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de> <CAJ-Vmok_UDVykup4xHCigrBbzErOhUQOZMATJ+=qkBFOHQS+Bg@mail.gmail.com> <1357131499.9839.19.camel@jlt4.sipsolutions.net>
In-Reply-To: <1357131499.9839.19.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201301021436.55010.chunkeey@googlemail.com> (sfid-20130102_143706_247021_B425D827)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 January 2013 13:58:19 Johannes Berg wrote:
> On Tue, 2013-01-01 at 15:46 -0800, Adrian Chadd wrote:
> > I've been looking at WME parameter handling for FreeBSD's net80211
> > stack (with and without 802.11n support.)
> > 
> > Yes, the problem is figuring out what the actual BSS configuration
> > _should_ be. You could potentially hear a variety of different WMM
> > parameters from a variety of different nodes in the BSS (depending
> > upon how buggy their WMM IE handling in adhoc mode is, I guess) so you
> > can't just simply update the WMM parameters based on what you hear
> > from peers.
> > 
> > What I have thus far:
> > 
> > * When creating a BSS, used the stored values;
> > * When joining a BSS, use the configuration from the BSS node you've
> > initially decided to "join" against, and hope they're actually
> > "correct";
> > * When doing a BSS merge, use the configuration from the BSS node that
> > you're joining to;
> > * If a different BSS configuration is heard from the node you joined
> > against, update your local configuration;
> > * .. and set a timer that enforces you don't change your configuration
> > for another 'n' ms (for n > 1000?) even if the joined/merged BSS ID
> > changes its config.
> > 
> > STA mode operation has the STA listening to changes in the BSS. It
> > only hears these frames from the active AP so you don't have churn if
> > you hear different WMM IEs from different APs (in the same SSID.)
> > adhoc is slightly crazier there.
> > 
> > My only concern is having oscillating BSS updates propagate across the
> > network in a rather silly looking fashion. Hence the BGP 'route
> > dampening' style timer to try and ensure that doesn't occur.
> > 
> > It'd be nice if we could come up with a unified way of doing this and
> > have it interoperate between FreeBSD/Linux (and any other vendor
> > adhoc+wmm implementations out there.)
> 
> Makes sense to me, but I'm not really into IBSS.
> 
> Overall, that speaks for having the parameters given as part of the
> "IBSS join" command rather than being updated on the fly though.
> 
How does MESH handle these pesky WMM parameters?

I can't find anything useful in the 802.11-2012 spec either. There's
something vague in 4.7 "Difference between ESS and IBSS LANs" on page 80:
"The services that apply to an IBSS are the SSs [Station ServiceS]. [...].
The parameters that  control differentiation of the delivery of MSDUs with
different priority using EDCA are >FIXED<. [...]".

But what does this mean? Does it translate into: "Every peer of an IBSS
truly independent of each other when it comes to the WMM parameters.
Each peer can advertise (in beacons, probes, ...) and have its own set
of fixed parameters and no one needs to sync those from anyone else"?

Or does "fixed" just mean that everyone has to go with the default WMM
parameters from 8-105 [i.e.: no one can change them at all]?

Regards,
	Christian
