Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58946
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbYAZNrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 08:47:06 -0500
Date: Sat, 26 Jan 2008 05:47:20 -0800 (PST)
Message-Id: <20080126.054720.158242838.davem@davemloft.net> (sfid-20080126_134723_411091_B717C0BC)
To: torvalds@linux-foundation.org
Cc: linville@tuxdriver.com, mb@bu3sch.de, dcbw@redhat.com,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0801251354350.5056@hp.linux-foundation.org>
References: <20080125195037.GE14687@tuxdriver.com>
	<20080125211815.GF14687@tuxdriver.com>
	<alpine.LFD.1.00.0801251354350.5056@hp.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Jan 2008 13:56:15 -0800 (PST)

> 
> 
> On Fri, 25 Jan 2008, John W. Linville wrote:
> > 
> > Anyway, this is mostly just so we can scope the driver change required
> > in absence of a firmware change.  Persumably the changes required if
> > we were to put such code in mac80211 would be similar.
> 
> Make this conditional on archictures that need it, please.
> 
> And why is it suddenly smart to do this in three drivers rather than one 
> upper layer?
> 

Grep the ethernet drivers Linus, we've been doing this since
the Donald Becker era.

The ones that cannot provide the necessary alignment copy on
platforms that cannot handle it without traps.
