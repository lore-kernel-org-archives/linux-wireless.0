Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45281 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125Ab2F1Jas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 05:30:48 -0400
Message-ID: <1340875844.4491.26.camel@jlt3.sipsolutions.net> (sfid-20120628_113051_794910_0B091AE1)
Subject: Re: [PATCH] mac80211: allow Rx in reconfig only after removing BA
 sessions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 28 Jun 2012 11:30:44 +0200
In-Reply-To: <CA+XVXfdKLeaHpLmqsXROH9VojHkB4EP-BpcFDLb8ZCtjb_XCbQ@mail.gmail.com> (sfid-20120628_103758_593069_FB3D8FF9)
References: <1340821557-27009-1-git-send-email-arik@wizery.com>
	 <1340871433.4491.20.camel@jlt3.sipsolutions.net>
	 <CA+XVXfdKLeaHpLmqsXROH9VojHkB4EP-BpcFDLb8ZCtjb_XCbQ@mail.gmail.com>
	 (sfid-20120628_103758_593069_FB3D8FF9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 11:37 +0300, Arik Nemtsov wrote:
> On Thu, Jun 28, 2012 at 11:17 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2012-06-27 at 21:25 +0300, Arik Nemtsov wrote:
> >> Previously, a connected STA/AP could send us some AMPDUs right after
> >> recovery, without the driver knowing anything about it.
> >
> > Huh, that description doesn't make a lot of sense? The STA/AP can send
> > us AMPDUs anyway without the driver knowing anything about it since it
> > has no idea we're restarting ...
> 
> Well the point is to drop them early in the Rx path. Should I change
> the description or you don't like the patch in general?

I don't mind the patch, I just don't quite understand it still.

The driver is receiving the AMPDUs anyway, and if it's passing them up
why do we need to drop them?

johannes

