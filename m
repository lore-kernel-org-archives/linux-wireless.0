Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2ABOoe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 09:44:34 -0500
Subject: Re: [PATCH v2 3/3] mac80211: add sta_state callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEfQ87gAPPAf4TO6LRbFtBh3YBRR5DO-oM=YB_BPczyCUA@mail.gmail.com> (sfid-20120102_153902_674527_64295749)
References: <1325162501-7996-1-git-send-email-eliad@wizery.com>
	 <1325162501-7996-4-git-send-email-eliad@wizery.com>
	 <1325501581.3643.8.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfQ87gAPPAf4TO6LRbFtBh3YBRR5DO-oM=YB_BPczyCUA@mail.gmail.com>
	 (sfid-20120102_153902_674527_64295749)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jan 2012 15:44:31 +0100
Message-ID: <1325515471.3643.15.camel@jlt3.sipsolutions.net> (sfid-20120102_154438_080894_F342DC49)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-02 at 16:38 +0200, Eliad Peller wrote:

> > I have a more fundamental issue/thought though, but it's hard to put
> > into words... let me start from what I thought we might want.
> >
> > I think with the auth/assoc rework I'm planning, we will want to add the
> > station to the driver before auth, in NONE state. To implement that with
> > the current state, that means changing all drivers that want the station
> > in assoc state only.
> >
> > So to solve this more cleanly, I thought we could hijack the station
> > state callback (this patchset) and call sta_state even when the station
> > isn't uploaded yet.

> does it really make sense to notify the driver about state transitions
> of station it doesn't know?

Well, no, but the station transition would let it know in a way. It
would go from not existing to NONE state.

> > Basically my idea was that new drivers that use the station state
> > callback can add/remove stations based on the state callback.
> >
> > The mac80211 backward compatibility implementation would take the state
> > call and call sta_add() if the station goes into ASSOC state (this
> > actually depends on the interface type, but that's easy to do.)
> >
> > This means we need better error handling for state transitions in a lot
> > of cases, but I think that's doable.

> i guess we should always delete the station on error? otherwise, the
> station state becomes unclear.

In most cases we would, yes.

> if sta_state will be allowed to return an error, instead of adding a
> new backward compatibility implementation to mac80211 we can just
> change all the current drivers to register for sta_state(), and
> operate on auth->assoc and assoc->auth transitions instead of
> sta_add/sta_remove.

Right, that's the alternative, but it would be easier to add the code in
mac80211 I think? And if we add a "NOT_EXIST" state we can completely
make sta_add/sta_remove be only there for drivers that don't need more
advanced state?

johannes

