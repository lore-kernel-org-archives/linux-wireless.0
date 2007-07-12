Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbXGLDaW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 23:30:22 -0400
Subject: Re: [PATCH 2.6] libertas : fix a few wext abuses...
From: Dan Williams <dcbw@redhat.com>
To: jt@hpl.hp.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070712004634.GA12148@bougret.hpl.hp.com>
References: <20070710213706.GA7929@bougret.hpl.hp.com>
	 <1184188789.28850.4.camel@localhost.localdomain>
	 <20070712004634.GA12148@bougret.hpl.hp.com>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 23:28:12 -0400
Message-Id: <1184210893.18797.16.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-07-11 at 17:46 -0700, Jean Tourrilhes wrote:
> On Wed, Jul 11, 2007 at 05:19:48PM -0400, Dan Williams wrote:
> > On Tue, 2007-07-10 at 14:37 -0700, Jean Tourrilhes wrote:
> > > 	Hi guys,
> > > 
> > > 	I have no clue to who is the official libertas maintainer, so
> > > please tell me where to send this patch.
> > 
> > Me, actually :)  Thanks for the patch.
> > 
> > Dan
> 
> 	By the way, from my glancing at the driver, the Libertas
> driver do select CONFIG_IEEE80211, and then doesn't use it ? It seems
> to force loading a modules that is not needed.

It does for ieee80211_escape_essid, actually.  Sucks to have to load in
the whole module just for that, but it's only 50k and eventually we'll
still need to load to lib80211 which should eventually have this sort of
thing.

Dan


