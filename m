Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbXJKEBM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 00:01:12 -0400
Subject: Re: [PATCH] libertas: automatically re-associate
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <20071010165921.GG5962@tuxdriver.com>
References: <200710091404.31491.hs4233@mail.mn-solutions.de>
	 <200710091713.35595.hs4233@mail.mn-solutions.de>
	 <1191944257.20014.3.camel@localhost.localdomain>
	 <200710100943.33106.hs4233@mail.mn-solutions.de>
	 <1192028338.9739.28.camel@localhost.localdomain>
	 <20071010165921.GG5962@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 11 Oct 2007 00:00:44 -0400
Message-Id: <1192075245.31110.9.camel@localhost.localdomain> (sfid-20071011_050121_621559_90BE627B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-10-10 at 12:59 -0400, John W. Linville wrote:
> On Wed, Oct 10, 2007 at 10:58:58AM -0400, Dan Williams wrote:
> 
> > I won't throw a hissy fit over the reassociation patch as long as it
> > only tries this in open & WEP situations where a supplicant is not
> > necessary.  That means you cannot simply requeue an association in
> > libertas_mac_event_disconnected(), but you should check the association
> > request and not requeue if:
> > 
> > 1) the assoc request's mode is ad-hoc (is there a point to retrying
> > assoc in adhoc?)
> 
> I'm not sure I see why ad-hoc is a special case?

A STA can't ever get disassociation management frames in an IBSS, right?
I don't believe the firmware will ever disconnect you once you've
started an IBSS, but there may be a difference between the start-adhoc
and join-adhoc commands that get sent to firmware.  However, it's not
like loss of becaons in IBSS mode will cause a disconnection, because it
just looks like the network split and you are the only member of it, and
then your STA takes up beaconing responsibility by itself until the
world ends.  AFAIK.

Dan


