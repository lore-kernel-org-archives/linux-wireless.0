Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47389 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167AbYLJVnM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 16:43:12 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC] b43: rework rfkill code
Date: Wed, 10 Dec 2008 22:42:33 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <20081210150935.GA10927@srcf.ucam.org> <1228930083.15837.44.camel@johannes.berg> <20081210213334.GA7589@khazad-dum.debian.net>
In-Reply-To: <20081210213334.GA7589@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812102242.35995.mb@bu3sch.de> (sfid-20081210_224317_559890_F8AD6D74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 December 2008 22:33:34 Henrique de Moraes Holschuh wrote:
> On Wed, 10 Dec 2008, Johannes Berg wrote:
> > On Wed, 2008-12-10 at 18:23 +0100, Johannes Berg wrote:
> > > Then there's user_claim_unsupported which is set by all drivers but
> > > rt2x00, probably because they have hardware kill switches and thus they
> > > have to set it even if it's not strictly true, because of the lacking
> > > separation between these things (that I pointed out)
> > 
> > IOW, correct me if I'm wrong, it seems to me that user_claim_unsupported
> > really is a wrong name for "has hw kill", which could be avoided if sw
> 
> I never understood what user_claim_unsupported is for.  I left it alone
> because of that, but it looks like some artifact of the old rfkill that did
> horrible things to the input layer.

No, as I just explained. It comes from a time when we didn't have all that input stuff at all.
It was a workaround. rfkill basically had a facility to change the hardware rfkill state from
userspace. As b43 does not support that, I introduced the flag.
Today we have three states (which is still broken, but you saw the rest of the thread...), so I guess
we can remove it again.
We cannot change the hardware state. That's what the flag is (was) for.

-- 
Greetings, Michael.
