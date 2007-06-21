Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:41374 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754045AbXFUNOn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 09:14:43 -0400
Date: Thu, 21 Jun 2007 15:14:41 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
Message-ID: <20070621151441.500d62d5@griffin.suse.cz>
In-Reply-To: <1182429920.21939.1.camel@johannes.berg>
References: <1182418939.10821.8.camel@johannes.berg>
	<20070621143558.68fc8e4a@griffin.suse.cz>
	<1182429920.21939.1.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 21 Jun 2007 14:45:19 +0200, Johannes Berg wrote:
> On Thu, 2007-06-21 at 14:35 +0200, Jiri Benc wrote:
> 
> > 1. I'm still not sure if using monitor interface for this purpose is a
> > good idea. Given the fact we want to switch to user space MLME, this
> > will mean that at least one monitor interface is always present. So we
> > got rid of management interface just to introduce another user visible
> > magic interface.
> 
> Well, that's not a bad point, but at least it's not created via magic
> ioctls etc.

That's true. Still, couldn't we find a better solution?

I know that netlink isn't designed for this kind of things. But if we
don't have any other idea, I'd still prefer that over a dedicated
network interface.

> Actually, I first thought that as well, but in fact the userspace MLME
> in wpa_supplicant doesn't even need to connect these events, it simply
> checks which auth sequence number it sent and then assumes that whatever
> it did was correct and adds the sta to the associated/auth list on the
> callback.

If some program needs to get frames it injected back with a status,
there should exist an easy way to determine which status corresponds
with which frame. If there is no need to determine this, what is the
reason for returning back injected frames in the first place?

 Jiri

-- 
Jiri Benc
SUSE Labs
