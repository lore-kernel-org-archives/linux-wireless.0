Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60937 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933308AbZD3PxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 11:53:20 -0400
Date: Thu, 30 Apr 2009 12:53:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC v6] rfkill: rewrite
Message-ID: <20090430155316.GF28027@khazad-dum.debian.net>
References: <1238349195.24972.5.camel@johannes.local> <1239745712.4205.17.camel@johannes.local> <1239750483.4205.28.camel@johannes.local> <20090430031903.GD18827@khazad-dum.debian.net> <1241104014.29878.12.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1241104014.29878.12.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 30 Apr 2009, Johannes Berg wrote:
> > The return values for rfkill_alloc() are not the same on the stub and
> > real functions.  The stub function uses ERR_PTR, while the real
> > function uses NULL for any errors.   Please make them do the same
> > thing, and it is probably a damn good idea to document in the
> > kerneldoc what kind of return values one should expect when you return
> > a pointer and the function can fail (i.e. NULL or ERR_PTR).
> 
> Actually, I was going to clean this up, and then I noticed you're
> wrong. :) Returning ERR_PTR(-ENODEV) is intentional, in the non-RFKILL
> case. Imagine a driver like this:

Well, that's confusing as all heck... document it, please?  I still think in
that case, we'd be better off if rfkill_alloc always uses the ERR_PTR
convention.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
