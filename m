Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933189AbXCHTeK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 14:34:10 -0500
Subject: Re: cfg/nl80211 primitives
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jkm@devicescape.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1173380977.3248.55.camel@johannes.berg>
References: <1173219649.3503.50.camel@johannes.berg>
	 <20070308004940.GC31388@devicescape.com>
	 <1173380977.3248.55.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 14:36:39 -0500
Message-Id: <1173382599.3020.34.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-03-08 at 20:09 +0100, Johannes Berg wrote:
> On Wed, 2007-03-07 at 16:49 -0800, Jouni Malinen wrote:
> 
> > And where would
> >    (5) change some parameters within this association without triggering
> >        new authentication/association
> > fit in?
> 
> For that case it's just a new configure command I suppose.
> 
> > > However, I don't see why we shouldn't go to a model where we give the
> > > kernel all information it needs to do an operation when we want it to do
> > > it, like the procedure
> > >  (1) tell the kernel to do X
> > >    - using parameter A=B
> > >    - using parameter C=D
> > >    - ...
> > >  (2) tell the kernel to do Y
> > 
> > Would this be all parameters as in _no_ other parameters could be set
> > before or after the command? As an example, how would one set
> > fragmentation threshold and then change that value after having
> > associated?
> 
> Actually, things like the fragmentation threshold or say rx sensitivity
> (where it can be set) don't really influence the association so for
> those I'd think they are out of scope for the MLME SAP primitives.
> 
> > MLME SAP primitives may be okay for many cases, but we cannot limit
> > ourselves to just the parameters defined there. Number of parameters do
> > not go through MLME SAP interface and some of the options may require
> > getting used to (e.g., power management options would use their own
> > primitive, not MLME-ASSOCIATE, etc.).
> 
> Right.
> 
> > MLME SAP interface is between MLME and SME, but when we have some parts
> > of MLME in user space and some in kernel, things can get bit confusing
> > since the interface between MLME and SME is not the same as interface
> > between kernel and user space.
> 
> True.
> 
> I think what I should have said when I wrote this email is that I
> dislike having this "transaction layer" in the kernel where you set a
> bunch of settings and then "commit" them by saying "please associate now
> with whatever settings I told you to use".

So when wpa_supplicant or whatever has to do rekeying, or if I want to
change some parameter but not completely re-associate, how does that
work?

> What I'd like to see instead is that you give the MLME (whether it's in
> the kernel or in userspace[1]) all the parameters it needs to do one
> action when telling it to do that action.

I'd basically expected that this was the model we'd be using anyway.  A
user tool wouldn't have to:

set ssid
set key
set authmode
associate

but instead bundle all those up into one message to netlink with the
"associate" command or something.  I wasn't expecting each setting to be
broken down into a separate message and then have a final "commit"
command like with WEXT right now.  That sucks and makes command ordering
ambiguous.

I'd much rather conceptually have the following (in python-esque), which
is what I thought it would be more like...

err = associate(ssid="foo", key=0x435223, auth="shared")
<rekey>
err = set(key=0x235326563)

Dan

> I'm not saying that we should limit ourselves to the parameters outlined
> in the MLME SAP interface nor that we should really follow it closely.
> 
> johannes
> 
> [1] since we said we'd want the userspace mlme to be controlled by
> nl80211 through the kernel

